require 'pry'


SCHEDULER.every '10s', :first_in => 0 do |job|

  current_project = File.read('./assets/current_project.txt').gsub("\n",'')
  outcomes = File.read("./assets/data/#{current_project}_outcomes.rb").gsub(/\s+/, "")
  #puts outcomes
  outcomeArray = outcomes.split(",")
  colours = []
  #puts "oa = #{outcomeArray}"
  outcomeArray.each do |current_outcome|
  if current_outcome == "G"|| current_outcome == "g"
     colours.push('green')
  elsif current_outcome ==  "B"|| current_outcome == "b"
     colours.push('orange')
   elsif current_outcome == "D"|| current_outcome == "d"
     colours.push('red')
  else
    colours.push('grey')
  end
  #puts current_outcome
end

days = ['Tuesday', 'Thursday', 'Tuesday', 'Friday']

statuses = days.zip(colours).map{|k, v| {day: k, colour: v}}
  #  puts "****************************"
  #  puts statuses

  send_event('outcomes', { items: statuses})
end
