#!/usr/bin/env ruby
#This job is designed to display the number of open issues for the current sprint

require 'rest-client'
require 'json'
require 'date'

git_token = ENV["GIT_TOKEN"]
git_owner = ENV["GIT_OWNER"]
git_project = ENV["GIT_PROJECT"]
#git_issue_label = "03.Proposal"

## Change this if you want to run more than one set of issue widgets
event_name = "open_iss"

## the endpoint we'll be hitting
uri = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=open&page=1&per_page=100&access_token=#{git_token}"

uri2 = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=open&page=2&per_page=100&access_token=#{git_token}"
#add the following after state=open if desired

uriClosed1 = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=closed&page=1&per_page=100&access_token=#{git_token}"

uriClosed2 = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=closed&page=2&per_page=100&access_token=#{git_token}"
#&labels=#{git_issue_label}



SCHEDULER.every '1m', :first_in => 0 do |job|
    firstResponse = RestClient.get uri
    secondResponse = RestClient.get uri2
    issuesPage1 = JSON.parse(firstResponse.body, symbolize_names: true)
    issuesPage2 = JSON.parse(secondResponse.body, symbolize_names: true)

    thirdResponse = RestClient.get uriClosed1
    fourthResponse = RestClient.get uriClosed2
    cIssuesPage1 = JSON.parse(thirdResponse.body, symbolize_names: true)
    cIssuesPage2 = JSON.parse(fourthResponse.body, symbolize_names: true)
    # puts "milestone: #{issuesPage1.url}"
    # puts cIssuesPage1
    open_issues = issuesPage1.length + issuesPage2.length

    currentMilestone = 7
    currentMileOpen = []

    issuesPage1.length.times do |i|
      if issuesPage1[i][:milestone] != nil
        if issuesPage1[i][:milestone][:number] == currentMilestone
            currentMileOpen << 1
        end
      end
    end

    issuesPage2.length.times do |x|
      if issuesPage2[x][:milestone] != nil
        if issuesPage2[x][:milestone][:number] == currentMilestone
            currentMileOpen << 1
        end
      end
    end



    send_event(event_name, {
            text: currentMileOpen.count
        })

end # SCHEDULER
