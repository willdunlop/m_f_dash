
SCHEDULER.every '10s' do

  current_project = File.read('./assets/current_project.txt').gsub("\n",'')
  #puts "CURRENT PROJECT #{current_project}"
  sprintarray = File.read("./assets/data/#{current_project}_sprint_goals.rb").split(',')
  #puts "SPRINT ARRAY #{sprintarray}"
  checks = File.read("./assets/data/#{current_project}_values.rb").split(',')
  checksarray = []
  checks.each do |ea|
    if ea == " " || ea == ""
      checksarray.push("")
    else
      checksarray.push("✓")
    end
end
colour_sprintgoals = {colour: "sprintgoals"}
sprintgoals = sprintarray.zip(checksarray).map{|s, c| {label: s, value: c}}
#puts sprintgoals
send_event('sprintgoals', { items: sprintgoals, colour: colour_sprintgoals })
end
