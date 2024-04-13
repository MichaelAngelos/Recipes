create database IF NOT EXISTS Recipes;
SHOW CREATE DATABASE Recipes;

CREATE TABLE Recipe(
	id integer(10) NOT NULL,
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