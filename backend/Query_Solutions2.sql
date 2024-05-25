#Query 3.9
#List of average values of weights of carbohydrates per years
select _year, avg(carbohydrates) from 
                 (Recipe_Nutrition_per_Portion natural join Episode_list natural join Episodes) group by _year;

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