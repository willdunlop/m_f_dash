require 'dashing'
require 'pg'

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

post '/sample' do
  goal1 = params[:goal1]
  goal2 = params[:goal2]
  goal3 = params[:goal3]
  goal4 = params[:goal4]
  goal5 = params[:goal5]

erb :sample, :locals => {'goal1' => goal1, 'goal2' => goal2, 'goal3' => goal3, 'goal4' => goal4, 'goal5' => goal5}
end

get '/projects' do
  @data = db.exec("SELECT * FROM card_data")
  erb :projects
end

post '/projects' do
  #params come through for each form
  #format them into hash array thing
  #write it to file

  #recieve params
  # card_id = ":id => #{params[:proj_name].upcase}_ID"
  @proj_name = params[:proj_name]
  @proj_git = params[:proj_git]
  @proj_tenk = params[:proj_tenk]

  module ProjectParams
    PN = params[:proj_name]
    PG = params[:proj_git]
    PTK = params[:proj_tenk]
  end




  db = PG.connect(dbname: 'dash') # Connect to DB
  db.prepare('add_card', 'insert into card_data (ProjectName, GitRepo, TenkProj) values ($1, $2, $3)') #prepare db for data exec
  db.exec_prepared('add_card', [ proj_name, proj_git, proj_tenk ]) #send prepared data to the db



  # database = "./data/project_setup.rb"
  # opendb = open(database, "a")
  # opendb.write("{#{card_id}, :card => {name: #{proj_name}, git: #{proj_git}, tenk: #{proj_tenk}}},")
  #
  # opendb.close

end

run Sinatra::Application
