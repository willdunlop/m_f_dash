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

uriProjects = "https://api.10000ft.com/api/v1/projects?filter_field=project_state=active&per_page=100&auth=#{tenk_token}
"
SCHEDULER.every '10s', :first_in => 0 do |job|
  tenResponse = RestClient.get uriProjects
  projectPage = JSON.parse(tenResponse.body, symbolize_names: true)



end #SCHEDULER
