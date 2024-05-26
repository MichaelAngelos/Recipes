#Query 3.1
SELECT chef_id,cuisine,AVG((Rating_1 + Rating_2 + Rating_3) /3) as Average_Rating FROM episode_list INNER JOIN ratings using (episode_id,chef_id) GROUP BY chef_id,cuisine

#Query 3.2

#Chefs who specialized in Nation for certain years
SELECT * FROM Cooks where List_of_Specializations_in_Nations like '%American%' and Years_of_Experience = 25;

#Also Went on Episodes
SELECT * FROM Cooks where List_of_Specializations_in_Nations like '%American%'
	and Years_of_Experience = 25 and chef_id IN (SELECT chef_id FROM episode_cooks);

	#SELECT * FROM episode_cooks

#Query 3.3

SELECT cooks.*,COUNT(rec_id) as Number_of_Recipes FROM cooks inner join cooks_in_recipe using (chef_id)
		where age < 30 GROUP BY chef_id ORDER BY Number_of_Recipes DESC LIMIT 3;

#Query 3.4

SELECT * FROM Cooks where chef_id NOT IN (Select chef_id from episode_judges);

# fifth query
select s.ci as chef_id from (SELECT * FROM episode_judges as ej JOIN (select e.episode_id as ei, e._year, ej.chef_id as ci, COUNT(ej.episode_id) total from episodes e join episode_judges ej ON e.episode_id = ej.episode_id GROUP BY ej.chef_id, e._year HAVING COUNT(ej.episode_id) > 3) as t ON t.ci = ej.chef_id and t.ei = ej.episode_id GROUP BY t.total HAVING count(*) >=2) as f JOIN (select e.episode_id as ei, e._year, ej.chef_id as ci, COUNT(ej.episode_id) total from episodes e join episode_judges ej ON e.episode_id = ej.episode_id GROUP BY ej.chef_id, e._year HAVING COUNT(ej.episode_id) > 3) AS s ON s.total = f.total; 
----------> needs to be more effiecient


#Query 3.7

#This is the highest count of appearences
SELECT Count(chef_id) as Appearences from episode_list group by chef_id ORDER BY Appearences DESC LIMIT 1;

#These are the chefs that have appeared 3 times less than the highest.Cannot do 5 because of current dummy data
SELECT chef_id,Count(chef_id) as Appearences  FROM episode_list group by chef_id
		HAVING Appearences < (SELECT Count(chef_id) as Appearences from episode_list group by chef_id ORDER BY Appearences DESC LIMIT 1) - 2;
        

# 8 query
SET profiling = 1;

SELECT t.episode_id, t.rec_name, t.rec_id, MAX(t.total) as max_total 
	from 
		(SELECT el.episode_id as episode_id, r.recipe_name as rec_name, r.id as rec_id, eir.eq_id, COUNT(eir.eq_id) as total 
			from 
				episode_list el
			join 
				recipe r 
			join 
				equipment_in_recipes eir 
			ON 
				el.rec_id = r.id AND r.id = eir.rec_id 
			GROUP BY el.episode_id 
            ORDER BY el.episode_id) as t;
            
SHOW PROFILE FOR QUERY 6;

SET profiling = 1;

SELECT t.episode_id, t.rec_name, t.rec_id, MAX(t.total) as max_total 
	from 
		(SELECT el.episode_id as episode_id, r.recipe_name as rec_name, r.id as rec_id, eir.eq_id, COUNT(eir.eq_id) as total 
			from 
				episode_list el
         		force INDEX (episode_id)
			join 
				recipe r 
			join 
				equipment_in_recipes eir 
			ON 
				el.rec_id = r.id AND r.id = eir.rec_id 
			GROUP BY el.episode_id 
            ORDER BY el.episode_id) as t;
            
SHOW PROFILE FOR QUERY 35;

# 9 query
select 
	t.ep_id, 
    AVG(t.total_carb) 
from 
	(select 
     	el.episode_id as ep_id, 
     	r.id as recipe_id, 
     	i.carbohydrates_per_100_gr_or_ml as carb_per_100_gr, 
     	sum(i.carbohydrates_per_100_gr_or_ml*(tamount/100)) as total_carb, 
     	count(el.episode_id) as count_carb 
     from 
     	episode_list as el 
     JOIN 
     	recipe as r 
     JOIN
     	(SELECT 
    *,
    CASE
        WHEN amount LIKE '900 grams' THEN 900
         WHEN amount LIKE '8 slices' THEN 10
        WHEN amount LIKE '6 large' THEN 420
        WHEN amount LIKE '6' THEN 420
         WHEN amount LIKE '500 grams' THEN 500
         WHEN amount LIKE '50 grams' THEN 50
         WHEN amount LIKE '5 grams' THEN 5
         WHEN amount like '400 grams' THEN 400
         WHEN amount LIKE '4 tablespoons' THEN 40
         WHEN amount LIKE '4 leaves' THEN 4
         WHEN amount LIKE '4 large' THEN 280
         WHEN amount LIKE '4 grams' THEN 4
         WHEN amount LIKE '4 cups' THEN 500
         WHEN amount like '4 cloves' THEN 5
         when amount like '4' then 300
         when amount like '300 grams' then 300
         when amount like '3/4 cup' then 300
         when amount like '3 tablespoons' THEN 30
         when amount like '3 medium' THEN 150
         when amount like '3 large' THEN 280
         when amount like '3 cloves' then 30
         when amount like '250 grams' then 250
         when amount like '200 ml' then 190
         when amount like '200 grams' then 200
         when amount like '20 grams' then 20
         when amount like '2 teaspoons' then 20
         when amount like '2 tablespoons' then 40
         when amount like '2 stalks' then 2
         when amount like '2 slices' then 15
         when amount like '2 ripe mangoes' then 500
         when amount like '2 ripe avocados' then 450
         when amount like '2 medium-sized' then 150
         when amount like '2 leaves' then 20
         when amount like '2 large' then 140
         when amount like '2 cups' then 600
         when amount like '2 1/4 teaspoons' then 23
         when amount like '2 1/2 teaspoons' then 25
         when amount like '2' then 200
         when amount like '150 grams' then 150
         when amount like '12' then 1000
         when amount like '100 grams' then 100
         when amount like '10 sheets' then 500
         when amount like '10 grams' then 10
         when amount like '10' then 500
         when amount like '1/4 teaspoon' then 3
         when amount like '1/4 cup (cubed)' then 200
         when amount like '1/4 cup' then 200 
         when amount like '1/3 cup' then 150
         when amount like '1/2 teaspoon' then 5
         when amount like '1/2 cup (grated)' then 150
         when amount like '1/2 cup' then 150
         when amount like '1/2 cucumber' then 200
         when amount like '1/2' then 100
         when amount like '1-inch piece' then 5
         when amount like '1 whole' then 100
         when amount like '1 teaspoon' then 10
         when amount like '1 tablespoon' then 15
         when amount like '1 stalk' then 5
         when amount like '1 sprig' then 5
         when amount like '1 small' then 5
         when amount like '1 slice' then 5
         when amount like '1 package' then 500
         when amount like '1 medium-sized' then 50
         when amount like '1 large' then 70
         when amount like '1 kg' then 1000
         when amount like '1 head' then 25
         when amount like '1 cup (shredded)' then 300
         when amount like '1 cup' then 300
         when amount like '1 clove' then 20
         when amount like '1 can (400 grams)' then 400
         when amount like '1 can' then 400
         when amount like '1 batch' then 25
         when amount like '1 1/2 cups' then 500
         when amount like '1 (9-inch)' then 50
         when amount like '1' then 250
    	ELSE 0
    END AS tamount
FROM ingredients_in_recipes
        ) as iir
     JOIN
     	ingredients as i
     ON 
     		el.rec_id = r.id 
     	AND 
     		iir.rec_id = r.id 
     	AND 
     		iir.ing_id = i.ing_id 
     GROUP BY 
     	i.ing_id) as t 
JOIN 
     episodes 
ON 
     episodes.episode_id = t.ep_id 
GROUP BY 
     episodes._year;
	 

# 10 query
WITH participation_counts AS (
    SELECT r.nation, e._year, COUNT(*) as participation_count
    FROM recipe r
    JOIN episode_list el ON r.id = el.rec_id
    JOIN episodes e ON el.episode_id = e.episode_id
    GROUP BY r.nation, e._year
    HAVING COUNT(*) >= 3
)

SELECT pc1.nation, pc1._year, pc1.participation_count from 
	participation_counts as pc1
    JOIN
    participation_counts as pc2
    ON pc1.nation = pc2.nation AND pc1._year = pc2._year -1
    where pc1.participation_count = pc2.participation_count
    ORDER by pc1._year


#Query 3.12
#Most demanding episode per year
SELECT _year, _order
FROM (
    SELECT E._year, E._order, SUM(R.Difficulty_level) AS total_difficulty
    FROM Episodes E
    JOIN Episode_list EL ON E.episode_id = EL.episode_id
    JOIN Recipe R ON EL.rec_id = R.id
    GROUP BY E._year, E._order
) AS episode_difficulty
WHERE (episode_difficulty._year, episode_difficulty.total_difficulty) IN (
    SELECT _year, MAX(total_difficulty)
    FROM (
        SELECT E._year, E._order, SUM(R.Difficulty_level) AS total_difficulty
        FROM Episodes E
        JOIN Episode_list EL ON E.episode_id = EL.episode_id
        JOIN Recipe R ON EL.rec_id = R.id
        GROUP BY E._year, E._order
    ) AS yearly_difficulty
    GROUP BY _year
)
ORDER BY _year;


#Query 3.13
#Episode with least experienced contestants and judges
SELECT _year, _order, SUM(chef_title_as_num) AS title_sum 
FROM (
    SELECT E._year, E._order,
        CASE
            WHEN C.chef_title = 'Chef' THEN 5
            WHEN C.chef_title = 'Assistant Chef' THEN 4
            WHEN C.chef_title = '1st Cook' THEN 3
            WHEN C.chef_title = '2nd Cook' THEN 2
            WHEN C.chef_title = '3rd Cook' THEN 1
        END AS chef_title_as_num
    FROM Cooks C
    JOIN Episode_list EL ON C.chef_id = EL.chef_id
    JOIN Episodes E ON EL.episode_id = E.episode_id
    
    UNION ALL
    
    SELECT E._year, E._order,
        CASE
            WHEN C.chef_title = 'Chef' THEN 5
            WHEN C.chef_title = 'Assistant Chef' THEN 4
            WHEN C.chef_title = '1st Cook' THEN 3
            WHEN C.chef_title = '2nd Cook' THEN 2
            WHEN C.chef_title = '3rd Cook' THEN 1
        END AS chef_title_as_num
    FROM Cooks C
    JOIN Episode_Judges EJ ON C.chef_id = EJ.chef_id
    JOIN Episodes E ON EJ.episode_id = E.episode_id
) AS combined
GROUP BY _year, _order
ORDER BY title_sum ASC
LIMIT 1;

#Query 3.14
#Most times appeared theme
SELECT theme_name, COUNT(*) AS theme_count
FROM Theme
JOIN Recipe_misc ON Theme.theme_id = Recipe_misc.theme_id
GROUP BY theme_name
ORDER BY theme_count DESC
LIMIT 1;

#Query 3.15
#Ingredient groups never appeared in the contest
SELECT group_name 
FROM Ingredient_group 
WHERE group_id NOT IN (
    SELECT DISTINCT ig.group_id
    FROM Episode_list el
    JOIN Ingredients_in_Recipes ir ON el.rec_id = ir.rec_id
    JOIN Ingredients i ON ir.ing_id = i.ing_id
    JOIN Ingredient_Belongs_in_Group ibg ON i.ing_id = ibg.ing_id
    JOIN Ingredient_group ig ON ibg.group_id = ig.group_id
);