require 'dashing'

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

run Sinatra::Application
