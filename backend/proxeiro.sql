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

SELECT Recipe.*,meal_type,GROUP_CONCAT(eq_name,'---',equipment_in_recipes.amount SEPARATOR '___') AS equipment_used,b.ingredients_used
FROM recipe
left join meal_types_of_recipes ON id = rec_id
left join meal_type using (meal_id)
left join equipment_in_recipes using (rec_id)
left join equipment using (eq_id)
left join (
 SELECT *,GROUP_CONCAT(ing_name,'---',amount SEPARATOR '___') as ingredients_used FROM recipe inner join ingredients_in_recipes on id = rec_id inner join ingredients using (ing_id) group by rec_id
) as b using (rec_id)
GROUP BY rec_id;

SELECT * FROM recipe left join recipe_steps on id = rec_id order by id,_order;

SELECT recipe.*,GROUP_CONCAT(step_details SEPARATOR '___') FROM recipe left join recipe_steps on id = rec_id group by rec_id order by id,_order;