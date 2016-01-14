require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "recipes"
  end

  get '/' do
    erb :index
  end

  get '/recipes' do
    @recipes = Recipe.all
    if logged_in?
      @user = User.find(session[:user_id])
      erb :recipes
    else
      redirect "/login"
    end
  end

  helpers do
    def redirect_if_not_logged_in
      if !logged_in?
        redirect "/login?error=You have to be logged in to do that"
      end
    end

    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

  end

end
