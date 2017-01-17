require 'dashing'

require 'pg'

require 'json'
require 'rest-client'

configure do
  set :auth_token, 'NEW_TOKEN'

  helpers do
    def protected!
      # Put any authentication code you want in here.
      # This method is run before accessing any resource.
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

get '/sample' do
    erb :sprint_goals_edit
end

get '/sampletv' do
    request.path_info
end

get '/sampletv/:ea_p' do

end

post '/sample' do

  goal1 = params[:goal1]
  goal2 = params[:goal2]
  goal3 = params[:goal3]
  goal4 = params[:goal4]
  goal5 = params[:goal5]

  ch1 = params[:ch1]
  ch2 = params[:ch2]
  ch3 = params[:ch3]
  ch4 = params[:ch4]
  ch5 = params[:ch5]

  tuesday = params[:Tuesday]
  thursday = params[:Thursday]
  tuesday2 = params[:Tuesday2]
  friday = params[:Friday]

  ch1 = params[:ch1]
  ch2 = params[:ch2]
  ch3 = params[:ch3]
  ch4 = params[:ch4]
  ch5 = params[:ch5]



  outcomes = "#{tuesday}, #{thursday}, #{tuesday2}, #{friday}"
  sprints = "#{goal1}, #{goal2}, #{goal3}, #{goal4}, #{goal5}"
  values = "#{ch1}, #{ch2}, #{ch3}, #{ch4}, #{ch5}"
  File.open('./assets/sprint_goals.rb', 'w') { |file| file.write(sprints) }
  File.open('./assets/values.rb', 'w') { |file| file.write(values)}
  File.open('./assets/outcomes.rb', 'w') { |file| file.write(outcomes) }
  File.open('./assets/tickboxes.rb', 'w') { |file| file.write(values) }

erb :sample
end

get '/projects' do
  proj_nameArr = []
  proj_gitArr = []
  proj_tenkArr = []
  db = PG.connect(dbname: 'dash')
  db.exec("SELECT * FROM card_data") do |res|
    res.map do |row|
      proj_nameArr << row['projectname']
      proj_gitArr << row['gitrepo']
      proj_tenkArr << row['tenkproj']
    end
  end
  @value = "A Value"
  # puts "Proj Name: #{proj_nameArr}"
  erb :projects
end

post '/projects' do
  #params come through for each form
  #format them into hash array thing
  #write it to file

  #recieve params
  # card_id = ":id => #{params[:proj_name].upcase}_ID"
  proj_name = params[:proj_name]
  proj_git = params[:proj_git]
  proj_tenk = params[:proj_tenk]
  @value = "A Value"

  db = PG.connect(dbname: 'dash') # Connect to DB
  db.exec("CREATE TABLE #{proj_name}(P_ID int NOT NULL UNIQUE, ProjectName varchar (50), GitRepo varchar (50), TenkProj varchar (50));")
  db.prepare('add_card', 'insert into card_data (ProjectName, GitRepo, TenkProj) values ($1, $2, $3)') #prepare db for data exec
  db.exec_prepared('add_card', [ proj_name, proj_git, proj_tenk ]) #send prepared data to the db

  # database = "./data/project_setup.rb"
  # opendb = open(database, "a")
  # opendb.write("{#{card_id}, :card => {name: #{proj_name}, git: #{proj_git}, tenk: #{proj_tenk}}},")
  #
  # opendb.close

  erb :projects

end

#Database preperation
db = PG.connect(dbname: 'dash') # Connect to DB

proj_nameArr = []
proj_gitArr = []
proj_tenkArr = []
db.exec("SELECT * FROM card_data") do |res|
  res.map do |row|
    proj_nameArr << row['projectname']
    proj_gitArr << row['gitrepo']
    proj_tenkArr << row['tenkproj']
  end
end

Sinatra::Application::DATA = proj_nameArr

run Sinatra::Application
