#!/usr/bin/env ruby
#
#
################
### LOGO JOB ###
################
#
require 'rest-client'
require 'json'

tenk_token = ENV["TENK_TOKEN"]
project = "PrimeX Connect"

uriProjects = "https://api.10000ft.com/api/v1/projects?filter_field=project_state=active&per_page=100&auth=#{tenk_token}
"
SCHEDULER.every '10s', :first_in => 0 do |job|

  tenResponse = RestClient.get uriProjects
  projectPage = JSON.parse(tenResponse.body, symbolize_names: true)

  #puts "\e[31m10k data extraction: #{projectPage[:data][2][:client]}\e[0m"

  #projectPage[:data].length.times do |i|
    if projectPage[:data][0][:client] = project
      #puts "\e[31m#{projectPage[:data][0][:thumbnail]}\e[0m"
      @image = projectPage[:data][0][:thumbnail]
    end
#  end

  send_event("logo", url: @image)


end #SCHEDULER
