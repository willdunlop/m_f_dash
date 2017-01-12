require 'dashing'
require 'json'

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
puts ">>>>>>>>>>>>>>>>"
puts ch5
# puts params[:ch]
puts ">>>>>>>>>>>>>>>>"
# checked = "#{params[:ch]}"


  outcomes = "#{tuesday}, #{thursday}, #{tuesday2}, #{friday}"
  sprints = "#{goal1}, #{goal2}, #{goal3}, #{goal4}, #{goal5}"
  values = "#{ch1}, #{ch2}, #{ch3}, #{ch4}, #{ch5}"
  File.open('./assets/sprint_goals.rb', 'w') { |file| file.write(sprints) }
  File.open('./assets/values.rb', 'w') { |file| file.write(values)}
  File.open('./assets/outcomes.rb', 'w') { |file| file.write(outcomes) }
  File.open('./assets/tickboxes.rb', 'w') { |file| file.write(values) }

erb :sample, :locals => {'goal1' => goal1, 'goal2' => goal2, 'goal3' => goal3, 'goal4' => goal4, 'goal5' => goal5}
end

post '/projects' do
  #params come through for each form
  #format them into hash array thing
  #write it to file

  #recieve params
  card_id = ":id => #{params[:proj_name].upcase}_ID"
  proj_name = params[:proj_name]
  proj_git = params[:proj_git]
  proj_tenk = params[:proj_tenk]


  database = "./data/project_setup.rb"
  opendb = open(database, "a")
  opendb.write("{#{card_id}, :card => {name: #{proj_name}, git: #{proj_git}, tenk: #{proj_tenk}}},")

  opendb.close

end

run Sinatra::Application
