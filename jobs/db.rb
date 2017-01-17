require 'pg'

db = PG.connect(dbname: 'dash')
#db.exec("CREATE DATABASE dash;")
#db.exec("USE dash;")
# db.exec("CREATE TABLE card_data(ProjectName varchar (50), GitRepo varchar (50), TenkProj varchar (50));")
# db.prepare('statement1', 'insert into test (t_id, testname) values ($1, $2)')
# db.exec_prepared('statement1', [ 1, 'testWill' ])
proj_nameArr = []
proj_gitArr = []
proj_tenkArr = []
puts "db.cd = #{dash.card_data}"
db.exec("SELECT * FROM card_data") do |res|
  # puts "results for db query: #{res.inspect}"
  @theData = res.map do |row|
    proj_nameArr << row['projectname']
    proj_gitArr << row['gitrepo']
    proj_tenkArr << row['tenkproj']
  end
end

# puts "projArr: #{proj_nameArr}"
# puts "projGit: #{proj_gitArr}"
# puts "projTenk: #{proj_tenkArr}"

name = proj_nameArr[0]

@data = db.exec("SELECT * FROM card_data")

send_event('home_data', {text: proj_nameArr})
