#Query 3.9
#List of average values of weights of carbohydrates per years
select _year, avg(carbohydrates) from 
                 (Recipe_Nutrition_per_Portion natural join Episode_list natural join Episodes) group by _year;

#Query 3.12
#Most demanding episode per year
select _year, _order 
from (Episodes natural join Episode_list) 
where (Episode_list.rec_id==Recipe.id and ) 
group by _year;

#Query 3.13
#Episode with least experienced contestants and judges

#Query 3.14
#Most times appeared theme
select theme_name, count (theme_name) as themes 
from Theme natural join Recipe_misc natural join Episode_list group by theme_name order by themes desc limit 1;

#Query 3.15
#Ingredient groups never appeared in the contest
select group_name 
from Ingredient_group 
where group_name not in (select distinct group_name from Episode_list natural join Ingredient_group natural join Ingredients_in_Recipes);