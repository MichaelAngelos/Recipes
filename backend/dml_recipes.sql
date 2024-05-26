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

DELIMITER //

CREATE TRIGGER after_recipe_insert
AFTER INSERT ON ingredients_in_recipes
FOR EACH ROW
BEGIN
    DECLARE existing_log_id INT;
    DECLARE ing_fat DECIMAL(10,2);
    DECLARE ing_protein DECIMAL(10,2);
    DECLARE ing_carbs DECIMAL(10,2);
    DECLARE ing_cal DECIMAL(10,2);

    -- Check if a log entry for this rec_id already exists
    SELECT rec_id INTO existing_log_id
    FROM recipe_nutrition_per_portion
    WHERE rec_id = NEW.rec_id
    LIMIT 1;

    -- Get the nutrition values from ingredients table
    SELECT fat_per_100_gr_or_ml, protein_per_100_gr_or_ml, carbohydrates_per_100_gr_or_ml, calories_per_100_gr_or_ml 
    INTO ing_fat, ing_protein, ing_carbs, ing_cal
    FROM ingredients
    WHERE ing_id = NEW.ing_id;

    -- If it exists, update the log entry
    IF existing_log_id IS NOT NULL THEN
        UPDATE recipe_nutrition_per_portion
        SET fat = fat + (ing_fat * NEW.amount) / 100,
            protein = protein + (ing_protein * NEW.amount) / 100,
            carbohydrates = carbohydrates + (ing_carbs * NEW.amount) / 100,
            calories = calories + (ing_cal * NEW.amount) / 100
        WHERE rec_id = NEW.rec_id;
    ELSE
        -- If it doesn't exist, insert a new log entry
        INSERT INTO recipe_nutrition_per_portion (rec_id, fat, protein, carbohydrates, calories)
        VALUES (NEW.rec_id, (ing_fat * NEW.amount) / 100, (ing_protein * NEW.amount) / 100, (ing_carbs * NEW.amount) / 100, (ing_cal * NEW.amount) / 100);
    END IF;
END //

DELIMITER ;