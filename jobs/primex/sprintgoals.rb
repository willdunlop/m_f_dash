
SCHEDULER.every '20s' do

  current_project = File.read('./assets/current_project.txt').gsub("\n",'')
  #puts "CURRENT PROJECT #{current_project}"
  sprintarray = File.read("./assets/#{current_project}_sprint_goals.rb").split(',')
  #puts "SPRINT ARRAY #{sprintarray}"
  checks = File.read("./assets/#{current_project}_values.rb").split(',')
  checksarray = []
  checks.each do |ea|
    if ea == " "
      checksarray.push("")
    else
      checksarray.push("✓")
    end
end
sprintgoals = sprintarray.zip(checksarray).map{|s, c| {label: s, value: c}}
#puts sprintgoals
send_event('sprintgoals', { items: sprintgoals })
end
