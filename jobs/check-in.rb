require 'pry'


SCHEDULER.every '10s', :first_in => 0 do |job|
  outcomes = File.read('./assets/outcomes.rb').gsub(/\s+/, "")
  puts outcomes
  outcomeArray = outcomes.split(",")
  colours = []
  puts "oa = #{outcomeArray}"
  outcomeArray.each do |current_outcome|
  if current_outcome == "G"|| current_outcome == "g"
     colours.push('green')
  elsif current_outcome ==  "B"|| current_outcome == "b"
     colours.push('orange')
   elsif current_outcome == "D"|| current_outcome == "g"
     colours.push('red')
  else
    colours.push('grey')
  end
  puts current_outcome
end

days = ['Tuesday', 'Thursday', 'Tuesday', 'Friday']

statuses = days.zip(colours).map{|k, v| {day: k, colour: v}}
    puts "****************************"
    puts statuses

  send_event('outcomes', { items: statuses})
end


#   outcomeArray.each do |current_outcome|
#     if current_outcome == "G"
#       statuses[current_outcome] = 'green'
#     elsif current_outcome =="B"
#       statuses[current_outcome] = 'red'
#     else
#       statuses[current_outcome] = 'grey'
#   end
# end

# outcomeArray.length.times do |each|
#   if outcomeArray[each] == "G"
#     @color = 'red'
#   end
#   colors.push(:color => @color)
# end
# end
#   # puts statuses
#   # puts statuses.values
#   send_event('outcomes', { items: colors})
