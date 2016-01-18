class UsersController < ApplicationController

  get '/users/signup' do
    session.clear 
    erb :'users/signup'
  end

  post '/users/signup' do
    if params.values.include?("")
      redirect '/users/signup'
    else
      @user = User.create(params)
      redirect '/users/login'
    end
  end

  get '/users/login' do
    session.clear
    erb :'users/login'#, locals: {message: "Incorrect Login or password"}
  end

  post '/users/login' do
    @user = User.find_by(:username => params[:username])
    if @user && @user.authenticate(params[:password])
      session[:id] = @user.id 
      redirect '/recipes'
    else 
      redirect '/users/login'
    end
  end

  get '/users/logout' do
    if logged_in?
      session.clear 
    end
    redirect '/'
  end

  get '/users/:slug' do
    redirect_if_not_logged_in
    @user = User.find_by_slug(params[:slug])
    erb :'/users/showall'
  end

end