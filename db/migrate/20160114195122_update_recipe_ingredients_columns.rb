class UpdateRecipeIngredientsColumns < ActiveRecord::Migration
  def change
    rename_column :recipe_ingredients, :figure_id, :recipe_id
    rename_column :recipe_ingredients, :title_id, :ingredient_id
  end
end
