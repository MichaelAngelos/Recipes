#Query 3.2

#Chefs who specialized in Nation for certain years
SELECT * FROM Cooks where List_of_Specializations_in_Nations like '%American%' and Years_of_Experience = 25;

#Also Went on Episodes
SELECT * FROM Cooks where List_of_Specializations_in_Nations like '%American%'
	and Years_of_Experience = 25 and chef_id IN (SELECT chef_id FROM episode_cooks);

	#SELECT * FROM episode_cooks
    
#Query 3.4

SELECT * FROM Cooks where chef_id NOT IN (Select chef_id from episode_judges);