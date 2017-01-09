# require 'wombat'
# require 'json'
# require 'rest-client'
#
# class HeadersScraper
#   include Wombat::Crawler
#
#   base_url "https://github.com/MentallyFriendly/gillhub"
#   path "/"
#   #
#   # headers "^[^k]+$", :headers
#   # projectBudget do
#   #   "xpath=//*[@id='mainCon']/div[1]/div/div/div[2]/div/div[2]/div[1]"
#   # end
# # *[@id='mainCon']//span
#   projectBudget "css=body"
# # "xpath=//*[@id='mainCon']/div[1]/div/div/div[2]/div/div[2]/div[1]/span"
#
# end
#
# SCHEDULER.every '1m', :first_in => 0 do |job|
# crawlData = HeadersScraper.new.crawl
# puts crawlData
# # data = crawlData.length
# # puts data
# send_event('headers', {text: crawlData})
# end

# div[@class="projectStatusStatisticText"
# /div[1]//div[1]/div/div/div[2]/div/div[2]/div[1]/span
