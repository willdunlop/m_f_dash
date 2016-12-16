#!/bin/env ruby
# encoding: utf-8

require 'net/http'
require 'uri'
require 'json'

# TODO replace with a real production host
server = "https://localhost"

SCHEDULER.every '30s', :first_in => 0 do |job|

  url = URI.parse("#{server}/api/content/dashboard?token=FawTP0fJgSagS1aYcM2a5Bx-MaJI8Y975NwYWP12B0E")
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = (url.scheme == 'https')
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  response = http.request(Net::HTTP::Get.new(url.request_uri))

  # Convert to JSON
  j = JSON[response.body]

  # Send the joke to the text widget
  review_content = {}
  review_content['en'] = { label: 'English', value: j['en']['news_article']['needs_review'] }
  review_content['mi'] = { label: 'Māori', value: j['mi']['news_article']['needs_review'] }
  send_event("goalslist", { items: review_content.values })
end
