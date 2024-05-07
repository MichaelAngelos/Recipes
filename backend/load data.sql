DELETE FROM ratings;
DELETE FROM episodes;
DELETE FROM Cooks_in_Recipe;
DELETE FROM Cooks;
DELETE FROM Recipe;

LOAD DATA INFILE 'dummy_recipes.tsv'
INTO TABLE Recipe
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM Recipe;

#DELETE FROM Cooks;

LOAD DATA INFILE 'dummy_cooks.tsv'
INTO TABLE Cooks
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM Cooks;

#DELETE FROM Cooks_in_Recipe;

LOAD DATA INFILE 'dummy_cooks_in_recipes.tsv'
INTO TABLE cooks_in_recipe
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM cooks_in_recipe;

LOAD DATA INFILE 'dummy_episodes.tsv'
INTO TABLE episodes
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM episodes;

LOAD DATA INFILE 'dummy_ratings.tsv'
INTO TABLE ratings
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM ratings;

LOAD DATA INFILE 'dummy_episode_cooks.tsv'
INTO TABLE episode_cooks
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM ratings;

LOAD DATA INFILE 'dummy_episode_cuisines.tsv'
INTO TABLE episode_cuisines
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM ratings;

LOAD DATA INFILE 'dummy_episode_judges.tsv'
INTO TABLE episode_judges
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM ratings;

LOAD DATA INFILE 'dummy_episode_recipes.tsv'
INTO TABLE episode_recipes
FIELDS TERMINATED BY '	'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT * FROM ratings;