
#!/usr/bin/env ruby

#
#        Final Version
######################
### GIT ISSUES JOB ###
######################
#           11/01/2017
require 'rest-client'
require 'json'
require 'date'
require 'dashing'


#Environment variables for access the repo through API
git_token = ENV["GIT_TOKEN"]
git_owner = ENV["GIT_OWNER"]
git_project = ENV["GIT_PROJECT"]
@git_project = git_project

projectName = git_project.capitalize

## the endpoints for github open issues
uri = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=open&page=1&per_page=100&access_token=#{git_token}"
uri2 = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=open&page=2&per_page=100&access_token=#{git_token}"
## the endpoints for github closed issues
uriClosed1 = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=closed&page=1&per_page=100&access_token=#{git_token}"
uriClosed2 = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=closed&page=2&per_page=100&access_token=#{git_token}"
#the endpoint for github milestone data
uriMilestone = "https://api.github.com/repos/#{git_owner}/#{git_project}/milestones?page=1&per_page=100&access_token=#{git_token}"
#counter used for debugging
refCount = 0
###Variable for defining what sprint is shown##


puts "\e[38;5;182mMENTALLY FRIENDLY PROJECT DASHBOARD\e[0m"
puts "\e[94mToday: #{Date.today.to_s}\e[0m"

SCHEDULER.every '10s', :first_in => 0 do |job|

  #Environment variables for access the repo through API
  git_token = ENV["GIT_TOKEN"]
  git_owner = ENV["GIT_OWNER"]
  git_project = ENV["GIT_PROJECT"]
  @git_project = git_project

  projectName = git_project.capitalize

  ## the endpoints for github open issues
  uri = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=open&page=1&per_page=100&access_token=#{git_token}"
  uri2 = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=open&page=2&per_page=100&access_token=#{git_token}"
  ## the endpoints for github closed issues
  uriClosed1 = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=closed&page=1&per_page=100&access_token=#{git_token}"
  uriClosed2 = "https://api.github.com/repos/#{git_owner}/#{git_project}/issues?state=closed&page=2&per_page=100&access_token=#{git_token}"
  #the endpoint for github milestone data
  uriMilestone = "https://api.github.com/repos/#{git_owner}/#{git_project}/milestones?page=1&per_page=100&access_token=#{git_token}"


    refCount = refCount + 1
    puts "\e[90m=\e[0m" * 20
    puts "\e[36mSCHEDULAR: #{refCount} refreshes so far...\e[0m"
    #Retrieves data from API and formats it
    puts "\e[34mGetting page 1 and 2 for open issues\e[0m"
    firstResponse = RestClient.get uri
    secondResponse = RestClient.get uri2
    issuesPage1 = JSON.parse(firstResponse.body, symbolize_names: true)
    issuesPage2 = JSON.parse(secondResponse.body, symbolize_names: true)
    puts "\e[34mGetting page 1 and 2 for closed issues\e[0m"
    thirdResponse = RestClient.get uriClosed1
    fourthResponse = RestClient.get uriClosed2
    cIssuesPage1 = JSON.parse(thirdResponse.body, symbolize_names: true)
    cIssuesPage2 = JSON.parse(fourthResponse.body, symbolize_names: true)
    puts "\e[34mGetting milestone data\e[0m"
    mileResponse = RestClient.get uriMilestone
    mileData = JSON.parse(mileResponse.body, symbolize_names: true)
    #Stores open and closed issues respectively
    currentOpenIssues = 0
    currentClosedIssues = 0

    futureMiles = []
    mileData.each do |cm|
      dat = Date.parse cm[:due_on]
      if dat > Date.today
        futureMiles << dat
      end
    end

    mileData.each do |vm|
      dte = Date.parse vm[:due_on]
      if dte == futureMiles.min
        @currentMilestone = vm[:number]
        @currMSTitle = vm[:title]
      end
    end

    puts "\e[94mCurrent Milestone: #{@currentMilestone}\e[0m"

    mileData.length.times do |num|
      if mileData[num][:number] == @currentMilestone
        @mileDueStr = mileData[num][:due_on]
      end
    end

    issuesPage1.length.times do |i|
      if issuesPage1[i][:milestone] != nil
        if issuesPage1[i][:milestone][:number] == @currentMilestone
          currentOpenIssues = currentOpenIssues + 1
        end
      end
    end
    puts "\e[34mRetreiving Open Issues from page 1\e[0m"


    issuesPage2.length.times do |x|
      if issuesPage2[x][:milestone] != nil
        if issuesPage2[x][:milestone][:number] == @currentMilestone
          currentOpenIssues = currentOpenIssues + 1
        end
      end
    end
    puts "\e[34mRetreiving Open Issues from page 2\e[0m"

    issClosedDate = []

    cIssuesPage1.length.times do |a|
      if cIssuesPage1[a][:milestone] != nil
        if cIssuesPage1[a][:milestone][:number] == @currentMilestone
            currentClosedIssues = currentClosedIssues + 1
            closedDateStr = cIssuesPage1[a][:closed_at]
            closedDate = Date.parse closedDateStr
            issClosedDate << closedDate.to_s
        end
      end
    end
    puts "\e[34mRetreiving Closed Issues from page 1\e[0m"


    cIssuesPage2.length.times do |b|
      if cIssuesPage2[b][:milestone] != nil
        if cIssuesPage2[b][:milestone][:number] == @currentMilestone
            currentClosedIssues = currentClosedIssues + 1
            closedDateStr2 = cIssuesPage2[b][:closed_at]
            closedDate2 = Date.parse closedDateStr2
            issClosedDate << closedDate2.to_str
        end
      end
    end
    puts "\e[34mRetreiving Closed Issues from page 2\e[0m"


    all_issues = currentOpenIssues + currentClosedIssues


  ### Chart configuration ##
  #points need to be an array of y axis values

  mileDue = Date.parse @mileDueStr

  puts "\e[94mStart of Sprint #{@currentMilestone}: #{mileDue - 11}\e[0m"
  puts "\e[94mEnd of Sprint #{@currentMilestone}: #{mileDue}\e[0m"

  # Used for calculating the expected amount (Diagonal straight line)
  optimal_issues = all_issues.to_f / 11
  def points_array(all, optimal)
      @expect = [all]
      until all < 0
        all = all - optimal
        @expect << all
      end
  end
  points_array(all_issues , optimal_issues)

  #Generates an array containing each day of the sprint
   dateRangeRev = []
   eaDay = 0
   until eaDay == 12
     mileDueStr = mileDue - eaDay
     dateRangeRev << mileDueStr.to_s
     eaDay = eaDay + 1
   end
   dateRange = dateRangeRev.reverse

# Check Date of today and match it to array position in dateRange

  dateRange.length.times do |ed|
    if dateRange[ed] == Date.today.to_s
      @actual = Array.new(ed+1, all_issues)
    end
  end

  dataPos = []
   #array containing closed date data array positions
   puts "\e[31missClosedDate: #{issClosedDate}\e[0m"
   issClosedDate.length.times do |eaClosed|
     dateRange.length.times do |eaDate|
      if issClosedDate[eaClosed] == dateRange[eaDate]
        dataPos << eaDate
      end
    end
  end

puts "\e[31mActual before update: #{@actual}\e[0m"
puts "\e[31mdataPos: #{dataPos.sort}\e[0m"
dataPos = dataPos.sort.reverse
  #The following loop updates the burndown array data to match closed issues with dates respectively
  nt = @actual[0]
  dataPos.each do |eaPos|
    newTotal = nt - 1

    #replaces the old value with the new
    @actual.delete_at(eaPos.to_i)
    @actual.insert(eaPos.to_i, newTotal)
    puts "\e[32mActual after replace: #{@actual}\e[0m"

    newArr = []
    #Corrects the open amount and puts into a new array
    @actual[eaPos+1..@actual.length].each { |correction| newArr << correction - 1 }

    #removes each outdated element in array
    (eaPos+1..@actual.length).reverse_each { |rem| @actual.delete_at(rem) }
    #adds the updated amounts
    @actual.insert(eaPos+1, newArr)
    @actual = @actual.flatten
  end
  #
  #   actual.delete_at(11)
  #Debugging

  puts "\e[31mActual after: #{@actual}\e[0m"
   puts "\e[94mBurndown Point Data: #{@actual}\e[0m"

   # Formats data for sending
    data = [
        {
          label: 'Actual',
          data: @actual,
          backgroundColor: [ 'rgba(255, 206, 86, 0.2)' ] * dateRange.length,
          borderColor: [ 'rgba(255, 206, 86, 1)' ] * dateRange.length,
          borderWidth: 1,
          lineTension: 0

        }, {
          label: 'Expected',
          data: @expect,
          backgroundColor: [ 'rgba(255, 99, 132, 0.2)' ] * dateRange.length,
          borderColor: [ 'rgba(255, 99, 132, 1)' ] * dateRange.length,
          borderWidth: 2,
          lineTension: 0,
          pointRadius: 0

        }
      ]

    ## Push the most recent point value
    send_event('burn', { labels: dateRange, datasets: data })
    send_event('open_iss', {text: currentOpenIssues })
    send_event('closed_iss', {text: currentClosedIssues })
    send_event('title', {text:  @currMSTitle, title: projectName})


end # SCHEDULER
