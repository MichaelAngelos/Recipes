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
