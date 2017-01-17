


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
# puts sprintgoals
send_event('sprintgoals', { items: sprintgoals })
end


# require 'pg'
#
# SCHEDULER.every '15m', :first_in => 0 do |job|
#
#   # Postgres connection
#   db = PG.connect(:hostaddr => "192.168.1.1", :user => "dashing", :password => "SECRET", :port => 3306, :dbname => "users" )
#
#   # SQL query - simplified because lazy
#   sql = "SELECT * FROM users"
#
#   # Execute the query
#   db.exec(sql) do |results|
#
#     # Sending to List widget, so map to :label and :value
#     acctitems = results.map do |row|
#       row = {
#         :label => row['account'],
#         :value => row['count']
#       }
#     end
#
#     # Update the List widget
#     send_event('account_count', { items: acctitems } )
#   end
#
# end
