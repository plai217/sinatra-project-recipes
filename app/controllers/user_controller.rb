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
      session[:id] = @user.id
      redirect '/recipes'
    end
  end

  get '/users/login' do
    if logged_in?
      redirect '/recipes'
    else
      erb :'users/login'#, locals: {message: "Incorrect Login or password"}
    end
  end


  post '/users/login' do
    if params[:username] == nil || params[:password == nil]
      redirect "/users/login"
    else 
      @user = User.find_by(:username => params[:username])
      if @user && @user.authenticate(params[:password])
        session[:id] = @user.id 
        redirect "/recipes"
      else 
        redirect "/users/login"
      end
    end
  end

  get '/users/logout' do
    if logged_in?
      session.clear 
    end
    redirect '/'
  end

  get '/users/:slug' do
    if logged_in?
      @user = User.find_by_slug(params[:slug])
      erb :'/users/showall'
    else
      redirect "/users/login"
    end
  end

end