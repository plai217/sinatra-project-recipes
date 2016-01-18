class RecipesController < ApplicationController

  get '/recipes' do
    @recipes = Recipe.all
    redirect_if_not_logged_in
    @user = User.find(session[:id])
    erb :'recipes/recipes'
  end

  get '/recipes/new' do
    if logged_in?
      erb :'recipes/new'
    else
      redirect '/users/login'
    end
  end

  post '/recipes' do
    if params[:recipe].all?{|x| x == nil}
      redirect '/recipes/new' #need error needs at least 1 ingredient
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
    @recipe = Recipe.find(params[:id])
    if current_user == User.find(@recipe.user_id)
      erb :'recipes/edit'
    elsif logged_in?
      redirect "/recipes/#{@recipe.id}?error=Cannot edit other's recipes"
    else
      redirect '/users/login'
    end
  end

  post '/recipes/:id' do
    @recipe = Recipe.find(params[:id])
    if logged_in?
      if params[:name] != ""
        @recipe.recipe_name = params[:name]
        @recipe.ingredients.clear
        params[:recipe].each do |k,ing| 
          unless ing == ""
            @recipe.ingredients << Ingredient.find_or_create_by(ingredient_name: ing)
          end
        end
        params[:ingredient].each do |ing,checked|
          @recipe.ingredients << Ingredient.find_or_create_by(ingredient_name: ing)
        end
        @recipe.save
        redirect '/recipes'
      else 
        redirect "/recipes/#{@recipe.id}/edit"
      end
    else
      redirect "/login?error=You have to be logged in to do that"
    end
  end

  get '/recipes/:id/delete' do
    @recipe = Recipe.find(params[:id])
    if current_user == User.find(@recipe.user_id)
      erb :'recipes/delete'
    elsif logged_in?
      redirect "/recipes/#{@recipe.id}?error=Cannot delete other's recipes"
    else 
      redirect '/users/login'
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