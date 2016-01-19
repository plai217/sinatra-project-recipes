class RecipesController < ApplicationController

  get '/recipes' do
    redirect_if_not_logged_in
    @recipes = Recipe.all
    @user = User.find(session[:id])
    erb :'recipes/recipes'
  end

  get '/recipes/new' do
    redirect_if_not_logged_in
    erb :'recipes/new'
  end

  post '/recipes' do
    if params[:recipe].all? { |x, ing| ing == "" }
      redirect "/recipes/new?error=You need at least one ingredient"
    elsif params[:name] == ''
      redirect "/recipes/new?error=Recipe needs a name"
    else
      @recipe = Recipe.create(recipe_name: params[:name], user_id: current_user.id)
      params[:recipe].each do |_k, v|
        @recipe.ingredients << Ingredient.find_or_create_by(ingredient_name: v) unless v == ""
      end
      redirect '/recipes'
    end
  end

  get '/recipes/:id' do
    redirect_if_not_logged_in
    @recipe = Recipe.find(params[:id])
    erb :'recipes/show'
  end

  get '/recipes/:id/edit' do
    redirect_if_not_logged_in
    @recipe = Recipe.find(params[:id])
    if current_user == User.find(@recipe.user_id)
      erb :'recipes/edit'
    else
      redirect "/recipes/#{@recipe.id}?error=Cannot edit other's recipes"
    end
  end

  post '/recipes/:id' do
    @recipe = Recipe.find(params[:id])
    if params[:ingredient] == nil && params[:recipe].all? { |x, ing| ing == '' }
      redirect "/recipes/#{@recipe.id}/edit?error=You need at least one ingredient"  
    elsif params[:name] != ''
      @recipe.recipe_name = params[:name]
      @recipe.ingredients.clear
      params[:recipe].each do |_k, ing| 
        unless ing == ''
          @recipe.ingredients << Ingredient.find_or_create_by(ingredient_name: ing)
        end
      end
      if params[:ingredient] != nil
        params[:ingredient].each do |ing, _on|
          @recipe.ingredients << Ingredient.find_or_create_by(ingredient_name: ing)
        end
      end
      @recipe.save
      redirect '/recipes'
    else
      redirect "/recipes/#{@recipe.id}/edit?error=Recipe needs a name"
    end
  end

  get '/recipes/:id/delete' do
    redirect_if_not_logged_in
    @recipe = Recipe.find(params[:id])
    if current_user != User.find(@recipe.user_id)
      redirect "/recipes/#{@recipe.id}?error=Cannot delete other's recipes"
    else
      erb :'recipes/delete'
    end
  end

  post '/recipes/:id/delete' do
    @recipe = Recipe.find(params[:id])
    @recipe.delete
    redirect '/recipes'
  end

end