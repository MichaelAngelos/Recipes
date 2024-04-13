DROP SCHEMA IF EXISTS Recipes;
CREATE SCHEMA IF NOT EXISTS Recipes;
use Recipes;
#SHOW CREATE DATABASE Recipes;

CREATE TABLE Recipe(
	id integer(10) NOT NULL,
    CookingorConfectionary bool NOT NULL,
	Nation Varchar(32) NOT NULL,
    Difficulty_level integer(1) NOT NULL,
    recipe_name varchar(64) NOT NULL,
    description_ varchar(255) NOT NULL,
    prep_time integer(10) NOT NULL,
    cook_time integer(10) NOT NULL,
    portions integer(2) NOT NULL,
    basic_ingredient varchar(64) NOT NULL,
    PRIMARY KEY(id)
);

CREATE TABLE Recipe_tips(
	tip_id integer(10) NOT NULL,
    rec_id integer(10) NOT NULL,
	tip varchar(255) NOT NULL,
    FOREIGN KEY (rec_id) REFERENCES Recipe(id),
    PRIMARY KEY(tip_id,rec_id)
);

CREATE TABLE Recipe_Tags(
	tag_id integer(10) NOT NULL,
    rec_id integer(10) NOT NULL,
	tag varchar(64) NOT NULL,
    FOREIGN KEY (rec_id) REFERENCES Recipe(id),
    PRIMARY KEY(tag_id,rec_id)
);

CREATE TABLE Recipe_Steps(
	step_id integer(10) NOT NULL,
    rec_id integer(10) NOT NULL,
	_order integer(2) NOT NULL,
    step_details varchar(255) NOT NULL,
    FOREIGN KEY (rec_id) REFERENCES Recipe(id),
    PRIMARY KEY(step_id,rec_id)
);

CREATE TABLE Recipe_Nutrition_per_Portion(
    rec_id integer(10) NOT NULL,
    fat Decimal(5,2) NOT NULL,
    protein Decimal(5,2) NOT NULL,
    carbohydrates Decimal(5,2) NOT NULL,
    calories Decimal(5,2) NOT NULL,
    FOREIGN KEY (rec_id) REFERENCES Recipe(id),
    PRIMARY KEY(rec_id)
);

CREATE TABLE Meal_Type(
	meal_id integer(10) NOT NULL,
    meal_type varchar(32) NOT NULL,
    PRIMARY KEY(meal_id)
);

CREATE TABLE Meal_Types_of_Recipes(
	meal_id integer(10) NOT NULL,
    rec_id integer(10) NOT NULL,
    FOREIGN KEY (meal_id) REFERENCES Meal_Type(meal_id),
    FOREIGN KEY (rec_id) REFERENCES Recipe(id),
    PRIMARY KEY(meal_id,rec_id)
);

CREATE TABLE Equipment(
	eq_id integer(10) NOT NULL,
    eq_name varchar(64) NOT NULL,
    instructions varchar(255) NOT NULL,
    PRIMARY KEY(eq_id)
);

CREATE TABLE Equipment_in_Recipes(
	eq_id integer(10) NOT NULL,
    rec_id integer(10) NOT NULL,
    amount integer(2) NOT NULL,
    FOREIGN KEY (eq_id) REFERENCES Equipment(eq_id),
    FOREIGN KEY (rec_id) REFERENCES Recipe(id),
    PRIMARY KEY(eq_id,rec_id)
);

CREATE TABLE Ingredients(
	ing_id integer(10) NOT NULL,
    ing_name varchar(64) NOT NULL,
    fat_per_100_gr_or_ml Decimal(5,2) NOT NULL,
    protein_per_100_gr_or_ml Decimal(5,2) NOT NULL,
    carbohydrates_per_100_gr_or_ml Decimal(5,2) NOT NULL,
    calories_per_100_gr_or_ml Decimal(5,2) NOT NULL,
    PRIMARY KEY(ing_id)
);

CREATE TABLE Ingredients_in_Recipes(
	ing_id integer(10) NOT NULL,
    rec_id integer(10) NOT NULL,
    amount varchar(255) NOT NULL,
    FOREIGN KEY (ing_id) REFERENCES Ingredients(ing_id),
    FOREIGN KEY (rec_id) REFERENCES Recipe(id),
    PRIMARY KEY(ing_id,rec_id)
);

CREATE TABLE Ingredient_group(
	group_id integer(10) NOT NULL,
    group_name varchar(64) NOT NULL,
    PRIMARY KEY(group_id)
);

CREATE TABLE Ingredient_Belongs_in_Group(
	group_id integer(10) NOT NULL,
    ing_id integer(10) NOT NULL,
    FOREIGN KEY (group_id) REFERENCES Ingredient_group(group_id),
    FOREIGN KEY (ing_id) REFERENCES Ingredients(ing_id),
    PRIMARY KEY(group_id,ing_id)
);

CREATE TABLE Categories(
	cat_id integer(10) NOT NULL,
    cat_name varchar(64) NOT NULL,
    PRIMARY KEY(cat_id)
);

CREATE TABLE Theme(
	theme_id integer(10) NOT NULL,
    theme_name varchar(64) NOT NULL,
    theme_desc varchar(255) NOT NULL,
    PRIMARY KEY(theme_id)
);

CREATE TABLE Recipe_misc(
	rec_id integer(10) NOT NULL,
    cat_id integer(10) NOT NULL,
    theme_id integer(10) NOT NULL,
    FOREIGN KEY (rec_id) REFERENCES Recipe(id),
    FOREIGN KEY (cat_id) REFERENCES Categories(cat_id),
    FOREIGN KEY (theme_id) REFERENCES Theme(theme_id),
    PRIMARY KEY(rec_id)
);

CREATE TABLE Cooks(
	chef_id integer(10) NOT NULL,
    _name varchar(64) NOT NULL,
	Phone_number integer(10) NOT NULL,
    birth_yr integer(4) NOT NULL,
    Age integer(2) NOT NULL,
    Years_of_Experience integer(2) NOT NULL,
    List_of_Specializations_in_Nations varchar(255) NOT NULL,
    Chef_title varchar(32) NOT NULL,
    PRIMARY KEY(chef_id)
);

CREATE TABLE Cooks_in_Recipe(
	chef_id integer(10) NOT NULL,
    rec_id integer(10) NOT NULL,
    FOREIGN KEY (rec_id) REFERENCES Recipe(id),
    FOREIGN KEY (chef_id) REFERENCES Cooks(chef_id),
    PRIMARY KEY(chef_id,rec_id)
);

CREATE TABLE Episodes(
	episode_id integer(10) NOT NULL,
    List_of_10_cuisines varchar(255) NOT NULL,
	List_of_10_cooks varchar(255) NOT NULL,
    List_of_3_cook_judges varchar(255) NOT NULL,
    List_of_recipe_for_each_cook varchar(255) NOT NULL,
    chef_id_of_winner integer(10) NOT NULL,
    FOREIGN KEY(chef_id_of_winner) REFERENCES Cooks(chef_id),
    PRIMARY KEY(episode_id)
);

CREATE TABLE Ratings(
	chef_id integer(10) NOT NULL,
    episode_id integer(10) NOT NULL,
    FOREIGN KEY (episode_id) REFERENCES Episodes(episode_id),
    FOREIGN KEY (chef_id) REFERENCES Cooks(chef_id),
	All_3_Ratings integer(6) NOT NULL,
    PRIMARY KEY(chef_id,episode_id)
);

SHOW TABLES;