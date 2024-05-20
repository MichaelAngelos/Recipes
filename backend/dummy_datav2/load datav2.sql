DELETE FROM Ratings;
DELETE FROM Episode_Judges;
DELETE FROM Episode_list;
DELETE FROM Episodes;
DELETE FROM Cooks_in_Recipe;
DELETE FROM Cooks;
DELETE FROM Recipe_misc;
DELETE FROM Theme;
DELETE FROM Categories;
DELETE FROM Ingredient_Belongs_in_Group;
DELETE FROM Ingredient_group;
DELETE FROM Ingredients_in_Recipes;
DELETE FROM Equipment_in_Recipes;
DELETE FROM Equipment;
DELETE FROM Meal_Types_of_Recipes;
DELETE FROM Meal_Type;
DELETE FROM Recipe_Nutrition_per_Portion;
DELETE FROM Recipe_Steps;
DELETE FROM Recipe_Tags;
DELETE FROM Recipe;
DELETE FROM Ingredients;
DELETE FROM Users;

LOAD DATA INFILE 'users.tsv'
INTO TABLE Users
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM Users;

LOAD DATA INFILE 'ingredients.tsv'
INTO TABLE ingredients
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM ingredients;

LOAD DATA INFILE 'recipes.tsv'
INTO TABLE Recipe
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM Recipe;

LOAD DATA INFILE 'recipe_tags.tsv'
INTO TABLE recipe_tags
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM recipe_tags;

LOAD DATA INFILE 'recipe_steps.tsv'
INTO TABLE recipe_steps
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM recipe_steps;

LOAD DATA INFILE 'meal_type.tsv'
INTO TABLE meal_type
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM meal_type;

LOAD DATA INFILE 'meal_type_of_recipes.tsv'
INTO TABLE meal_types_of_recipes
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM meal_types_of_recipes;

LOAD DATA INFILE 'equipment.tsv'
INTO TABLE equipment
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM equipment;

LOAD DATA INFILE 'equipment_in_recipes.tsv'
INTO TABLE equipment_in_recipes
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM equipment_in_recipes;

LOAD DATA INFILE 'ingredients_in_recipes.tsv'
INTO TABLE ingredients_in_recipes
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM ingredients_in_recipes;

LOAD DATA INFILE 'ingredient_group.tsv'
INTO TABLE ingredient_group
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM ingredient_group;

LOAD DATA INFILE 'ingredient_belongs_in_group.tsv'
INTO TABLE ingredient_belongs_in_group
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM ingredient_belongs_in_group;

LOAD DATA INFILE 'theme.tsv'
INTO TABLE theme
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM theme;

LOAD DATA INFILE 'cooks.tsv'
INTO TABLE cooks
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM cooks;

LOAD DATA INFILE 'cooks_in_recipe.tsv'
INTO TABLE cooks_in_recipe
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM cooks_in_recipe;

LOAD DATA INFILE 'episodes.tsv'
INTO TABLE episodes
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM episodes;

LOAD DATA INFILE 'episode_list.tsv'
INTO TABLE episode_list
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM episode_list;

LOAD DATA INFILE 'episode_judges.tsv'
INTO TABLE episode_judges
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM episode_judges;

LOAD DATA INFILE 'ratings.tsv'
INTO TABLE ratings
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM ratings;