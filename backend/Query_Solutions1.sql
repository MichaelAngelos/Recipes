#Query 3.2

#Chefs who specialized in Nation for certain years
SELECT * FROM Cooks where List_of_Specializations_in_Nations like '%American%' and Years_of_Experience = 25;

#Also Went on Episodes
SELECT * FROM Cooks where List_of_Specializations_in_Nations like '%American%'
	and Years_of_Experience = 25 and chef_id IN (SELECT chef_id FROM episode_list);

	#SELECT * FROM episode_cooks

#Query 3.3

SELECT cooks.*,COUNT(rec_id) as Number_of_Recipes FROM cooks inner join cooks_in_recipe using (chef_id)
		where age < 30 GROUP BY chef_id ORDER BY Number_of_Recipes DESC LIMIT 3;
    
#Query 3.4

SELECT * FROM Cooks where chef_id NOT IN (Select chef_id from episode_judges);

#Query 3.7

#This is the highest count of appearences
SELECT Count(chef_id) as Appearences from episode_list group by chef_id ORDER BY Appearences DESC LIMIT 1;

#These are the chefs that have appeared 3 times less than the highest.Cannot do 5 because of current dummy data
SELECT chef_id,Count(chef_id) as Appearences  FROM episode_list group by chef_id
		HAVING Appearences < (SELECT Count(chef_id) as Appearences from episode_list group by chef_id ORDER BY Appearences DESC LIMIT 1) - 4 order by appearences desc;
        
        
#Query 3.1

SELECT chef_id,cuisine,AVG((Rating_1 + Rating_2 + Rating_3) /3) as Average_Rating FROM episode_list INNER JOIN ratings using (episode_id,chef_id) GROUP BY chef_id,cuisine