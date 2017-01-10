#!/usr/bin/env ruby
require 'rest-client'
require 'json'
require 'date'

now = DateTime.now
git_token = ENV["GIT_TOKEN"]
git_owner = ENV["GIT_OWNER"]
git_project = ENV["GIT_PROJECT"]
#git_issue_label = "03.Proposal"

## Change this if you want to run more than one set of issue widgets

## the endpoint we'll be hitting
uri = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=open&page=1&per_page=100&access_token=#{git_token}"

uri2 = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=open&page=2&per_page=100&access_token=#{git_token}"
#add the following after state=open if desired

uriClosed1 = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=closed&page=1&per_page=100&access_token=#{git_token}"

uriClosed2 = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=closed&page=2&per_page=100&access_token=#{git_token}"
#&labels=#{git_issue_label}

uriMilestone = "https://api.github.com/repos/#{git_owner}/#{git_project}/milestones?page=1&per_page=100&access_token=#{git_token}"

refCount = 0

SCHEDULER.every '10s', :first_in => 0 do |job|
    puts "\e[34mGetting #{uri} and #{uri2}\e[0m"
    firstResponse = RestClient.get uri
    secondResponse = RestClient.get uri2
    issuesPage1 = JSON.parse(firstResponse.body, symbolize_names: true)
    issuesPage2 = JSON.parse(secondResponse.body, symbolize_names: true)

    puts "\e[34mGetting #{uriClosed1} and #{uriClosed2}\e[0m"
    thirdResponse = RestClient.get uriClosed1
    fourthResponse = RestClient.get uriClosed2
    cIssuesPage1 = JSON.parse(thirdResponse.body, symbolize_names: true)
    cIssuesPage2 = JSON.parse(fourthResponse.body, symbolize_names: true)

    puts "\e[34mGetting #{uriMilestone}\e[0m"
    mileResponse = RestClient.get uriMilestone
    mileData = JSON.parse(mileResponse.body, symbolize_names: true)


    currentMilestone = 7
    currentMileOpen = []
    currentMileClosed = []
    refCount = refCount + 1
    puts "\e[38;5;182mMENTALLY FRIENDLY PROJECT DASHBOARD\e[0m"
    puts "\e[94mRefresh for #{git_project} count: \e[32m#{refCount}\e[0m"
    puts "\e[94mCurrent Milstone: \e[32m#{currentMilestone}\e[0m"
    puts "\e[34mCalculating sprint date range\e[0m"
    puts "\e[94mToday: #{now}\e[0m"
    mileData.length.times do |num|
      if mileData[num][:number] == currentMilestone
        puts "\e[94mMilestone Due: #{mileData[num][:due_on]}\e[0m"
        @mileDueStr = mileData[num][:due_on]
      end
    end

    issuesPage1.length.times do |i|
      if issuesPage1[i][:milestone] != nil
        if issuesPage1[i][:milestone][:number] == currentMilestone
            currentMileOpen << 1
        end
      end
    end
    puts "\e[34mRetreiving Open Issues from page 1\e[0m"


    issuesPage2.length.times do |x|
      if issuesPage2[x][:milestone] != nil
        if issuesPage2[x][:milestone][:number] == currentMilestone
            currentMileOpen << 1
        end
      end
    end
    puts "\e[34mRetreiving Open Issues from page 2\e[0m"

    issClosedDate = []

    cIssuesPage1.length.times do |a|
      if cIssuesPage1[a][:milestone] != nil
        if cIssuesPage1[a][:milestone][:number] == currentMilestone
            currentMileClosed << 1
            puts "Issue: #{cIssuesPage1[a][:number]} Closed at: #{cIssuesPage1[a][:closed_at]}"
            closedDateStr = cIssuesPage1[a][:closed_at]
            closedDate = Date.parse closedDateStr
            issClosedDate << closedDate.to_s
        end
      end
    end
    puts "\e[34mRetreiving Closed Issues from page 1\e[0m"

    cIssuesPage2.length.times do |b|
      if cIssuesPage2[b][:milestone] != nil
        if cIssuesPage2[b][:milestone][:number] == currentMilestone
            currentMileClosed << 1
        end
      end
    end
    puts "\e[34mRetreiving Closed Issues from page 2\e[0m"


    open_issues = currentMileOpen.count
    closed_issues = currentMileClosed.count
    all_issues = open_issues + closed_issues


    ## Drop the first point value and increment x by 1
    graph_points = []
    expected = [
      {x: 0, y: all_issues},
      {x: 14, y: 0}
    ]
    actual = [
      {x: 1, y: 5},
      {x: 2, y: 5},
      {x: 3, y: 1},
      {x: 7, y: 4},
      {x: 11, y: 3},
      {x: 14, y: 2},
    ]
### Chart.js chart ##

  #points need to be an array of y axis values

  mileDue = Date.parse @mileDueStr

  puts "\e[94mStart of sprint #{currentMilestone}: #{mileDue - 11}\e[0m"
  puts "\e[94mEnd of Sprint #{currentMilestone}: #{mileDue}\e[0m"

  optimal_issues = all_issues.to_f / 14
  def points_array(all, optimal)
      @expect = []
      until all < 0
        all = all - optimal
        @expect << all
      end
      #puts expect
    end
    points_array(all_issues , optimal_issues)


   dateRange = []
   eaDay = 0
   until eaDay == 12
     mileDueStr = mileDue - eaDay
     dateRange << mileDueStr.to_s
     eaDay = eaDay + 1
   end
   puts "Closed date arr: #{issClosedDate}"
   #for each date in issClosedDate find it's position in dateRange
   issClosedDate.length.times do |eaClosed|
     dateRange.length.times do |eaDate|
      if issClosedDate[eaClosed] == dateRange[eaDate]
        puts "Its positiong is: #{dateRange[eaDate].index}"
      end
    end
  end

   puts "DATES ARE: #{dateRange}"
   puts "I must know: #{Array.new(dateRange.length) { rand(40..80) }}"

    data = [
        {
          label: 'Expected',
          data: @expect,
          backgroundColor: [ 'rgba(255, 99, 132, 0.2)' ] * dateRange.length,
          borderColor: [ 'rgba(255, 99, 132, 1)' ] * dateRange.length,
          borderWidth: 1,
        }, {
          label: 'Second dataset',

          backgroundColor: [ 'rgba(255, 206, 86, 0.2)' ] * dateRange.length,
          borderColor: [ 'rgba(255, 206, 86, 1)' ] * dateRange.length,
          borderWidth: 1,
        }
      ]


    ## Push the most recent point value

    send_event('burn', { labels: dateRange, datasets: data })

    #send_event("burn", points: [expected, actual])

    # series = [
    #   {
    #     name: "Expected",
    #     data: straight_data,
    #     renderer: 'line'
    #   },
    #   {
    #     name: "Actual",
    #     data: test_data,
    #     renderer: 'line'
    #   }
    # ]
    #
    # send_event(event_name, series: series)

end # SCHEDULER
