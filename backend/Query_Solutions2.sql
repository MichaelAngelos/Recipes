#Query 3.9
#List of average values of weights of carbohydrates per years
select _year, avg(carbohydrates) from 
                 (Recipe_Nutrition_per_Portion natural join Episode_list natural join Episodes) group by _year;

#Query 3.12
#Most demanding episode per year
SELECT _year, _order
FROM (
    SELECT _year, _order, SUM(Difficulty_level) AS total_difficulty
    FROM Episodes
    WHERE Episodes.id==Episode_list.id AND Episode_list.rec_id==Recipe.id
    GROUP BY _year, _order
) AS episode_difficulty
WHERE (episode_difficulty._year, episode_difficulty.total_difficulty) IN (
    SELECT _year, MAX(total_difficulty)
    FROM (
        SELECT _year, _order, SUM(Difficulty_level) AS total_difficulty
        FROM Episodes
        WHERE Episodes.id==Episode_list.id AND Episode_list.rec_id==Recipe.id
        GROUP BY _year, _order
    ) AS yearly_difficulty
    GROUP BY _year
)
ORDER BY _year;

#Query 3.13
#Episode with least experienced contestants and judges
select _year, _order, sum(chef_title_as_num) as title_sum
from(
    (select *,
    CASE
        WHEN chef_title = 'Chef' THEN 5
        WHEN chef_title = 'Assistant Chef' THEN 4
        WHEN chef_title = '1st Cook' THEN 3
        WHEN chef_title = '2nd Cook' THEN 2
        WHEN chef_title = '3rd Cook' THEN 1
    END AS chef_title_as_num
    from Cooks natural join Episodes natural join Episode_list
    )
    union
    (select *,
    CASE
        WHEN chef_title = 'Chef' THEN 5
        WHEN chef_title = 'Assistant Chef' THEN 4
        WHEN chef_title = '1st Cook' THEN 3
        WHEN chef_title = '2nd Cook' THEN 2
        WHEN chef_title = '3rd Cook' THEN 1
    END AS chef_title_as_num
    from Cooks natural join Episodes natural join Episode_judges
    )
)
order by title_sum asc limit 1;

#Query 3.14
#Most times appeared theme
select theme_name, count (theme_name) as themes 
from Theme natural join Recipe_misc natural join Episode_list group by theme_name order by themes desc limit 1;

#Query 3.15
#Ingredient groups never appeared in the contest
select group_name 
from Ingredient_group 
where group_name not in (select distinct group_name from Episode_list natural join Ingredient_group natural join Ingredients_in_Recipes);