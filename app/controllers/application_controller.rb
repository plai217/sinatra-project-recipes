require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, 'recipes'
  end

  get '/' do
    erb :index
  end

  helpers do
    def redirect_if_not_logged_in
      unless logged_in?
        redirect "/users/login?error=You have to be logged in to do that"
        @error_message = params[:error]
      end
    end

    def logged_in?
      !!session[:id] 
    end

    def current_user
      User.find(session[:id])
    end
  end

end
