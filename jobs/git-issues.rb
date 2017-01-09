#!/usr/bin/env ruby
require 'rest-client'
require 'json'
require 'date'


git_token = ENV["GIT_TOKEN"]
git_owner = ENV["GIT_OWNER"]
git_project = ENV["GIT_PROJECT"]
#git_issue_label = "03.Proposal"

## Change this if you want to run more than one set of issue widgets
event_name = "git_issues_burndown"

## the endpoint we'll be hitting
uri = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=open&page=1&per_page=100&access_token=#{git_token}"

uri2 = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=open&page=2&per_page=100&access_token=#{git_token}"
#add the following after state=open if desired

uriClosed1 = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=closed&page=1&per_page=100&access_token=#{git_token}"

uriClosed2 = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=closed&page=2&per_page=100&access_token=#{git_token}"
#&labels=#{git_issue_label}

## Create an array to hold our data points


## One hours worth of data for, seed 60 empty points (rickshaw acts funny if you don't).
(0..60).each do |a|
  #points << { x: a, y: 0.01 }
end

## Grab the last x value
#last_x = points.last[:x]


SCHEDULER.every '1m', :first_in => 0 do |job|
    puts "WELCOME TO THE MENTALLY FRIENDLY PROJECT DASHBOARD"
    puts "Getting #{uri} and #{uri2}"
    firstResponse = RestClient.get uri
    secondResponse = RestClient.get uri2
    issuesPage1 = JSON.parse(firstResponse.body, symbolize_names: true)
    issuesPage2 = JSON.parse(secondResponse.body, symbolize_names: true)

    puts "Getting #{uriClosed1} and #{uriClosed2}"
    thirdResponse = RestClient.get uriClosed1
    fourthResponse = RestClient.get uriClosed2
    cIssuesPage1 = JSON.parse(thirdResponse.body, symbolize_names: true)
    cIssuesPage2 = JSON.parse(fourthResponse.body, symbolize_names: true)

    currentMilestone = 7
    currentMileOpen = []
    currentMileClosed = []
    puts "\e[31mCurrent Milstone: \e[32m#{currentMilestone}\e[0m"

    issuesPage1.length.times do |i|
      if issuesPage1[i][:milestone] != nil
        if issuesPage1[i][:milestone][:number] == currentMilestone
            currentMileOpen << 1
        end
      end
    end
    puts "\e[33mRetreiving Open Issues from page 1\e[0m"


    issuesPage2.length.times do |x|
      if issuesPage2[x][:milestone] != nil
        if issuesPage2[x][:milestone][:number] == currentMilestone
            currentMileOpen << 1
        end
      end
    end
    puts "\e[33mRetreiving Open Issues from page 2\e[0m"


    cIssuesPage1.length.times do |a|
      if cIssuesPage1[a][:milestone] != nil
        if cIssuesPage1[a][:milestone][:number] == currentMilestone
            currentMileClosed << 1
        end
      end
    end
    puts "\e[33mRetreiving Closed Issues from page 1\e[0m"

    cIssuesPage2.length.times do |b|
      if cIssuesPage2[b][:milestone] != nil
        if cIssuesPage2[b][:milestone][:number] == currentMilestone
            currentMileClosed << 1
        end
      end
    end
    puts "\e[33mRetreiving Closed Issues from page 2\e[0m"


    open_issues = currentMileOpen.count
    closed_issues = currentMileClosed.count
    all_issues = open_issues + closed_issues


    ## Drop the first point value and increment x by 1
    graph_points = []
    straight_data = [
      {x: 0, y: all_issues},
      {x: 14, y: 0}
    ]
    test_data = [
      {x: 1, y: 5},
      {x: 2, y: 5},
      {x: 3, y: 1},
      {x: 7, y: 4},
      {x: 11, y: 3},
      {x: 14, y: 2},
    ]


    ## Push the most recent point value


    # send_event(event_name, {
    #         text: open_issues, points: [straight_data, test_data]
    #     })

    series = [
      {
        name: "Expected",
        data: straight_data
      },
      {
        name: "Actual",
        data: test_data
      }
    ]

    send_event("The Burn", series: series)
    #system "curl -d '{ \"auth_token\": \"YOUR_AUTH_TOKEN\",\"points\": [ #{straight_data}, #{test_data}]}' http://localhost:3030/widgets/git_issues_burndown"

end # SCHEDULER
