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