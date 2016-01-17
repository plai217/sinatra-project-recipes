class RecipesController < ApplicationController

  get '/recipes' do
    @recipes = Recipe.all
    if logged_in?
      @user = User.find(session[:id])
      erb :recipes
    else
      redirect '/users/login'
    end
  end

  get '/recipes/new' do
    erb :'recipes/new'
  end

  post '/recipes' do
    if params[:recipe].all?{|x| x == nil}
      redirect '/recipes/new'
    else
      @recipe = Recipe.create(recipe_name: params[:name], user_id: current_user.id)
      params[:recipe].each do |k,v| 
        @recipe.ingredients << Ingredient.find_or_create_by(ingredient_name: v) unless v == ""
      end
      redirect '/recipes'
    end
  end

  get '/recipes/:id' do
    @recipe = Recipe.find(params[:id])
    if logged_in?
      erb :'recipes/show'
    else
      redirect '/users/login'
    end
  end 

  get '/recipes/:id/edit' do
    if logged_in?
      @recipe = Recipe.find(params[:id])
      erb :'recipes/edit'
    else 
      redirect '/users/login'
    end
  end

  post '/recipes/:id' do
    @recipe = Recipe.find(params[:id])
    if logged_in?
      if params[:name] != ""
        @recipe.recipe_name = params[:name]
        @recipe.save
        redirect '/recipes'
      else 
        redirect "/recipes/#{@recipe.id}/edit"
      end
    else
      redirect "/login?error=You have to be logged in to do that"
    end
  end

  post '/recipes/:id/delete' do
    @recipe = Recipe.find(params[:id])
    if logged_in?
      @recipe.delete
      redirect '/recipes'
    else
      redirect '/users/login'
    end
  end

end