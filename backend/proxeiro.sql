SELECT * FROM Recipe;

INSERT INTO cooks_in_recipe (chef_id,rec_id) VALUES (1,1);

SELECT cooks.chef_id,_name,Count(rec_id) as total_recipes FROM cooks INNER JOIN cooks_in_recipe using (chef_id) WHERE cooks.age < 30 group by chef_id ORDER BY total_recipes DESC LIMIT 10;

select * from recipe;

SELECT nation,count(nation) from Recipe group by nation;