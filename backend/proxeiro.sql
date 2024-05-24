SELECT * FROM Recipe;

INSERT INTO cooks_in_recipe (chef_id,rec_id) VALUES (1,1);

SELECT cooks.chef_id,_name,Count(rec_id) as total_recipes FROM cooks INNER JOIN cooks_in_recipe using (chef_id) WHERE cooks.age < 30 group by chef_id ORDER BY total_recipes DESC LIMIT 10;

select * from recipe;

select * from cooks;

SELECT nation,count(nation) from Recipe group by nation;

SELECT chef_id,episode_id,_name FROM cooks inner join ratings using (chef_id) inner join episodes using (episode_id);

#Fetch All episode data
SELECT * FROM
(
SELECT * FROM cooks inner join ratings using (chef_id) inner join episodes using (episode_id) where List_of_3_cook_judges NOT LIKE '%' || chef_id || '%'
)	
WHERE List_of_10_cooks like '%' || chef_id || '%';

SELECT * FROM (
	SELECT episode_id,chef_id_of_winner,group_concat(chef_id) as list_of_cooks FROM episodes
	inner join episode_cooks using (episode_id) GROUP BY episode_id
) as temp inner join (
	SELECT episode_id,group_concat(cuisine) as list_cuisines from episode_cuisines group by episode_id
) as temp2 using (episode_id) inner join (
	SELECT episode_id,group_concat(chef_id) as list_judges FROM episode_judges group by episode_id
) as temp3 using (episode_id) inner join (
	SELECT episode_id,group_concat(rec_id) as list_recipes FROM episode_recipes group by episode_id
) as temp4 using (episode_id);

SELECT * FROM Cooks where List_of_Specializations_in_Nations like '%American%' and Years_of_Experience = 25;

SELECT * FROM recipe inner join meal_types_of_recipes ON id = rec_id inner join meal_type using (meal_id);

SELECT GROUP_CONCAT(eq_id,'---',amount) FROM equipment GROUP BY rec_id;

SELECT * FROM recipe inner join meal_types_of_recipes ON id = rec_id inner join meal_type using (meal_id)
INNER JOIN(
	SELECT rec_id,GROUP_CONCAT(eq_name,'---',amount SEPARATOR '___') AS equipment_used FROM equipment_in_recipes inner join equipment using (eq_id) GROUP BY rec_id
) as a using (rec_id);

SELECT *,GROUP_CONCAT(eq_name,'---',amount SEPARATOR '___') AS equipment_used
FROM recipe
inner join meal_types_of_recipes ON id = rec_id
inner join meal_type using (meal_id)
inner join equipment_in_recipes using (rec_id)
inner join equipment using (eq_id)
GROUP BY id;


SELECT * FROM recipe inner join meal_types_of_recipes ON id = rec_id inner join meal_type using (meal_id)
INNER JOIN(
	SELECT rec_id,GROUP_CONCAT(eq_name,'---',amount SEPARATOR '___') AS equipment_used FROM equipment_in_recipes inner join equipment using (eq_id) GROUP BY rec_id
) as a using (rec_id);

SELECT Recipe.*,meal_type,GROUP_CONCAT(eq_name,'---',equipment_in_recipes.amount SEPARATOR '___') AS equipment_used,b.ingredients_used
FROM recipe
inner join meal_types_of_recipes ON id = rec_id
inner join meal_type using (meal_id)
inner join equipment_in_recipes using (rec_id)
inner join equipment using (eq_id)
inner join (
 SELECT *,GROUP_CONCAT(ing_name,'---',amount SEPARATOR '___') as ingredients_used FROM recipe inner join ingredients_in_recipes on id = rec_id inner join ingredients using (ing_id) group by rec_id
) as b using (rec_id)
GROUP BY rec_id;

SELECT recipe.*,GROUP_CONCAT(ing_name,'---',amount SEPARATOR '___') FROM Recipe inner join ingredients_in_recipes on id = rec_id inner join ingredients using (ing_id) group by rec_id;

SELECT * FROM recipe inner join ingredients_in_recipes on id = rec_id inner join ingredients using (ing_id) order by id;

#All Recipe meal_type,equipment and ingredients
SELECT Recipe.*,meal_type,GROUP_CONCAT(eq_name,'---',equipment_in_recipes.amount SEPARATOR '___') AS equipment_used,b.ingredients_used
FROM recipe
inner join meal_types_of_recipes ON id = rec_id
inner join meal_type using (meal_id)
inner join equipment_in_recipes using (rec_id)
inner join equipment using (eq_id)
inner join (
 SELECT *,GROUP_CONCAT(ing_name,'---',amount SEPARATOR '___') as ingredients_used FROM recipe inner join ingredients_in_recipes on id = rec_id inner join ingredients using (ing_id) group by rec_id
) as b using (rec_id)
GROUP BY rec_id;

SELECT Recipe.*,meal_type,GROUP_CONCAT(eq_name,'---',equipment_in_recipes.amount SEPARATOR '___') AS equipment_used,
ing_table.ingredients_used,steps.ordered_steps,GROUP_CONCAT(tag SEPARATOR '___')
FROM recipe
left join meal_types_of_recipes ON recipe.id = rec_id
left join meal_type using (meal_id)
left join equipment_in_recipes using (rec_id)
left join equipment using (eq_id)
left join (
 SELECT *,GROUP_CONCAT(ing_name,'---',amount SEPARATOR '___') as ingredients_used FROM recipe inner join ingredients_in_recipes on id = rec_id inner join ingredients using (ing_id) group by rec_id
) as ing_table using (rec_id)
left join (
	SELECT recipe.*,GROUP_CONCAT(step_details SEPARATOR '___') as ordered_steps FROM recipe left join sorted_steps on id = rec_id group by recipe.id
) as steps on recipe.id = steps.id
GROUP BY rec_id;

SELECT Recipe.*,meal_type,GROUP_CONCAT(eq_name,'---',equipment_in_recipes.amount SEPARATOR '___') AS equipment_used,
ing_table.ingredients_used,steps.ordered_steps,tags_fetch.tag_list
FROM recipe
left join meal_types_of_recipes ON recipe.id = rec_id
left join meal_type using (meal_id)
left join equipment_in_recipes using (rec_id)
left join equipment using (eq_id)
left join (
 SELECT *,GROUP_CONCAT(ing_name,'---',amount SEPARATOR '___') as ingredients_used FROM recipe inner join ingredients_in_recipes on id = rec_id inner join ingredients using (ing_id) group by rec_id
) as ing_table using (rec_id)
left join (
	SELECT recipe.*,GROUP_CONCAT(step_details SEPARATOR '___') as ordered_steps FROM recipe left join sorted_steps on id = rec_id group by recipe.id
) as steps on recipe.id = steps.id
left join (
	SELECT *,GROUP_CONCAT(tag SEPARATOR '___') as tag_list FROM RECIPE left join recipe_tags on id = rec_id group by id
) as tags_fetch on recipe.id = tags_fetch.rec_id
GROUP BY id;

SELECT * FROM recipe left join recipe_steps on id = rec_id order by id,_order;

SELECT recipe.*,GROUP_CONCAT(step_details SEPARATOR '___') FROM recipe left join recipe_steps on id = rec_id group by rec_id;

select *,GROUP_CONCAT(step_details SEPARATOR '___') from sorted_steps group by rec_id;

SELECT *,GROUP_CONCAT(tag SEPARATOR '___') FROM RECIPE left join recipe_tags on id = rec_id group by id;

SELECT Recipe.*,meal_type,GROUP_CONCAT(eq_name,'---',equipment_in_recipes.amount SEPARATOR '___') AS equipment_used,
ing_table.ingredients_used,steps.ordered_steps,tags_fetch.tag_list,theme.theme_name,theme.theme_desc,categories.cat_name,cook_list
FROM recipe
left join meal_types_of_recipes ON recipe.id = rec_id
left join meal_type using (meal_id)
left join equipment_in_recipes using (rec_id)
left join equipment using (eq_id)
left join (
 SELECT *,GROUP_CONCAT(ing_name,'---',amount SEPARATOR '___') as ingredients_used FROM recipe inner join ingredients_in_recipes on id = rec_id inner join ingredients using (ing_id) group by rec_id
) as ing_table using (rec_id)
left join (
	SELECT recipe.*,GROUP_CONCAT(step_details SEPARATOR '___') as ordered_steps FROM recipe left join sorted_steps on id = rec_id group by recipe.id
) as steps on recipe.id = steps.id
left join (
	SELECT *,GROUP_CONCAT(tag SEPARATOR '___') as tag_list FROM RECIPE left join recipe_tags on id = rec_id group by id
) as tags_fetch on recipe.id = tags_fetch.rec_id
left join recipe_misc on recipe.id = recipe_misc.rec_id
left join theme using (theme_id)
left join categories using (cat_id)
GROUP BY id;

SELECT * FROM recipe left join recipe_misc on id=rec_id left join theme using (theme_id) left join categories using (cat_id);

SELECT * FROM theme;

SELECT Recipe.*,meal_type,GROUP_CONCAT(eq_name,'---',equipment_in_recipes.amount SEPARATOR '___') AS equipment_used,
ing_table.ingredients_used,steps.ordered_steps,tags_fetch.tag_list,theme_name,theme_desc,cat_name,fat,protein,carbohydrates,calories,cook_list
FROM recipe
left join meal_types_of_recipes ON recipe.id = rec_id
left join meal_type using (meal_id)
left join equipment_in_recipes using (rec_id)
left join equipment using (eq_id)
left join (
 SELECT *,GROUP_CONCAT(ing_name,'---',amount SEPARATOR '___') as ingredients_used FROM recipe inner join ingredients_in_recipes on id = rec_id inner join ingredients using (ing_id) group by rec_id
) as ing_table using (rec_id)
left join (
	SELECT recipe.*,GROUP_CONCAT(step_details SEPARATOR '___') as ordered_steps FROM recipe left join sorted_steps on id = rec_id group by recipe.id
) as steps on recipe.id = steps.id
left join (
	SELECT *,GROUP_CONCAT(tag SEPARATOR '___') as tag_list FROM RECIPE left join recipe_tags on id = rec_id group by id
) as tags_fetch on recipe.id = tags_fetch.rec_id
left join recipe_misc on recipe.id = recipe_misc.rec_id
left join theme using (theme_id)
left join categories using (cat_id)
left join recipe_nutrition_per_portion on recipe.id = recipe_nutrition_per_portion.rec_id
left join (
	SELECT rec_id,GROUP_CONCAT(chef_id SEPARATOR '___') as cook_list FROM cooks_in_recipe GROUP BY rec_id
) as cooks_list on recipe.id = cooks_list.rec_id
GROUP BY id;

select * from cooks_in_recipe order by rec_id;

SELECT episode_id,chef_id,SUM(chef_title_as_num) as title_sum
from (
	select *,
	CASE
		WHEN chef_title = 'Chef' THEN 1
		WHEN chef_title = 'Assistant Chef' THEN 2
		WHEN chef_title = '1st Cook' THEN 3
		WHEN chef_title = '2nd Cook' THEN 4
		WHEN chef_title = '3rd Cook' THEN 5
	END AS chef_title_as_num
	from cooks
	left join episode_list using (chef_id)
) as temp group by episode_id order by title_sum desc limit 10;

SELECT episode_id,cooks.* FROM episode_list inner join cooks using (chef_id)
UNION
SELECT episode_id,cooks.* FROM episode_judges inner join cooks using (chef_id);

SELECT * FROM meal_type;
SELECT * FROM Recipe;

SELECT id,CookingorConfectionary,Nation,Difficulty_level,recipe_name,description_,prep_time,cook_time,portions,basic_ingredient_id,meal_type.meal_type
FROM recipe inner join meal_types_of_recipes on id=rec_id inner join meal_type using (meal_id) order by id asc;

SELECT * FROM meal_types_of_recipes;

SELECT * FROM all_recipe_data;
SELECT * FROM recipe;
SELECT * FROM ingredients_in_recipes;

START TRANSACTION;

-- Execute your SQL statements
INSERT INTO recipe (CookingorConfectionary, Nation,Difficulty_Level,recipe_name,description_,prep_time,cook_time,portions,basic_ingredient_id,meal_type)
VALUES (0,"Greek",2,"Tzatziki","Delicious condiment",10,10,4,9,"asdasdasdsds");

-- Check for errors or conditions
-- If an error occurs, rollback the transaction
COMMIT;

SELECT * FROM recipe;
SELECT * FROM cooks_in_recipe;

CALL InsertRecipeWithChef(0, 'Greek', 2, 'Tzatziki', 'Delicious condiment', 10, 10, 4, 9, 'Side Dishes', 5);

SELECT _role FROM users where user_id = 4;

