class UsersController < ApplicationController

  get '/users/signup' do
    if logged_in?
      redirect '/recipes'
    else
      erb :'users/signup'
    end
  end

  get '/users/login' do
    if logged_in?
      redirect '/recipes'
    else
      erb :'users/login'
    end
  end

  post '/users/signup' do
    if params.values.include?("")
      redirect '/users/signup'
    else
      @user = User.create(params)
      session[:user_id] = @user.id
      redirect '/recipes'
    end
  end
end