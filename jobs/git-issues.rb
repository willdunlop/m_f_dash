#!/usr/bin/env ruby
require 'rest-client'
require 'json'
require 'date'

git_token = "blocked"
git_owner = "blocked"
git_project = "blocked"
#git_issue_label = "03.Proposal"

## Change this if you want to run more than one set of issue widgets
event_name = "git_issues_labeled_defects"

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

    puts "\e[31m+++MILESTONE+++\e[0m: #{issuesPage1[0][:milestone][:number]}"


    # sprint5iss = []
    mileNo5Open = []
    mileNo5Closed = []

    issuesPage1.length.times do |i|
      if issuesPage1[i][:milestone] != nil
        puts issuesPage1[i][:milestone][:number]
        if issuesPage1[i][:milestone][:number] == 5
            mileNo5Open << 1
        end
      end
    end

    issuesPage2.length.times do |x|
      if issuesPage2[x][:milestone] != nil
        puts issuesPage2[x][:milestone][:number]
        if issuesPage2[x][:milestone][:number] == 5
            mileNo5Open << 1
        end
      end
    end

    cIssuesPage1.length.times do |a|
      if cIssuesPage1[a][:milestone] != nil
        if cIssuesPage1[a][:milestone][:number] == 5
            mileNo5Closed << 1
        end
      end
    end
    cIssuesPage2.length.times do |b|
      if cIssuesPage2[b][:milestone] != nil
        if cIssuesPage2[b][:milestone][:number] == 5
            mileNo5Closed << 1
        end
      end
    end

    open_issues = mileNo5Open.count
    closed_issues = mileNo5Closed.count
    all_issues = open_issues + closed_issues

    puts "\e[31mmileNo5: #{mileNo5.count} \e[0m"

    optimal_issues = all_issues / 14

    def points_array(all, optimal)
      @points = []
      until all < 0
        all = all - optimal
        points << all
      end
      puts points
    end


    points_array(all_issues , optimal_issues)

    ## Drop the first point value and increment x by 1
    graph_points.shift
    last_x -= 1

    ## Push the most recent point value
    graph_points << { x: 14, y: points }

    send_event(event_name, {
            text: open_issues, points: @points
        })

end # SCHEDULER
