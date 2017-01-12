


SCHEDULER.every '20s' do
  sprintarray = File.read('./assets/sprint_goals.rb').split(',')
  checks = File.read('./assets/tickboxes.rb').split(',')
  checksarray = []
  checks.each do |ea|
    if ea == " "
      checksarray.push("")
    else
      checksarray.push("✓")
    end
end
sprintgoals = sprintarray.zip(checksarray).map{|s, c| {label: s, value: c}}
puts sprintgoals
send_event('sprintgoals', { items: sprintgoals })
end








#   buzzwords = buzzstring.split(",")
#   # buzzwords1 = list.split(",")
#   # buzzwords2 = ['Paradigm shift', 'Leverage', 'Pivoting', 'Turn-key', 'Streamlininess', 'Exit strategy', 'Synergy', 'Enterprise', 'Web 2.0']
#   puts buzzwords
#   buzzword_counts = Hash.new({ value: 0 })
#   random_buzzword = buzzwords.sample
#   buzzword_counts[random_buzzword] = { label: random_buzzword, value: (buzzword_counts[random_buzzword][:value] + 1) % 30 }
#   # puts buzzword_counts.values
#   send_event('buzzwords', { items: buzzword_counts.values })
# end

