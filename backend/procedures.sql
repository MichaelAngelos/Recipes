DELIMITER //

CREATE PROCEDURE BackupDatabase()
BEGIN
    SET @dbBackup := CONCAT('mysqldump -u root -p  recipes > /path/to/backup/', DATE_FORMAT(NOW(), '%Y%m%d%H%i%s'), '_your_database_name.sql');
    PREPARE stmt FROM @dbBackup;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE RestoreDatabase(IN backupFilePath VARCHAR(255))
BEGIN
    SET @dbRestore := CONCAT('mysql -u your_username -pyour_password your_database_name < ', backupFilePath);
    PREPARE stmt FROM @dbRestore;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE InsertRecipeWithChef(
    IN p_CookingorConfectionary INT,
    IN p_Nation VARCHAR(255),
    IN p_Difficulty_Level INT,
    IN p_recipe_name VARCHAR(255),
    IN p_description_ TEXT,
    IN p_prep_time INT,
    IN p_cook_time INT,
    IN p_portions INT,
    IN p_basic_ingredient_id INT,
    IN p_meal_type VARCHAR(255),
    IN p_chef_id INT
)
BEGIN
    DECLARE exit handler for sqlexception, sqlwarning
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
	
    START TRANSACTION;
	
    -- Execute your SQL statements
    INSERT INTO recipe (CookingorConfectionary, Nation, Difficulty_Level, recipe_name, description_, prep_time, cook_time, portions, basic_ingredient_id, meal_type)
    VALUES (p_CookingorConfectionary, p_Nation, p_Difficulty_Level, p_recipe_name, p_description_, p_prep_time, p_cook_time, p_portions, p_basic_ingredient_id, p_meal_type);

    -- If no errors, continue with the second insert
    INSERT INTO cooks_in_recipe (chef_id, rec_id) VALUES (p_chef_id, LAST_INSERT_ID());
    
    SELECT last_insert_id() as new_recipe_id;

    -- If everything is successful, commit the transaction
    COMMIT;
END //

DELIMITER ;