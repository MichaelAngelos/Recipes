const mysql=require("mysql2")
const express = require('express')
const bodyParser = require('body-parser');
const { exec } = require('child_process');
const app = express()
const PORT = 5000;

const startURL="/recipes";

app.use(bodyParser.json());

function separate_into_list_cooks(stringToSeparate) {
    let input=stringToSeparate.split(", ")
    return input
}

function separate_into_list(stringToSeparate) {
    let input=stringToSeparate.split("___")
    //console.log(stringToSeparate)
    for (let i=0;i<input.length;i++) {
        input[i]=input[i].split('---')
    }
    return input
}

function separate_result_column_from_list(result,column_name) {
    for(let j = 0;j< result.length;j++){
        if (result[j][column_name] != null)
        return separate_into_list(result[j][column_name]);
    }
}

function separate_result_column(result_column) {
    //console.log(result_column)
    if (result_column != null) {
        return separate_into_list(result_column);
    }
}

const connection_string={
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'recipes',
}

const recipes = mysql.createPool(connection_string)

recipes.getConnection((err,connection) => {
    if (err){
        console.log(err)
        console.log({
            "status":"failed",
            "dataconnection":connection_string
        })
    }
    else{
        console.log("Connected!\n")
        console.log({
            "status":"OK",
            "dataconnection":connection_string
        })
    }
    connection.release()
})

app.get("/hello-world", (req,res) => {
    res.status(200).send("Hello World!")
})

app.get("/test", (req,res) => {
    recipes.getConnection((err,connection) => {
        if (err) {
            console.log("error connecting to db")
            res.status(500).send()
            connection.release()
            throw err
        }
        console.log("Connected on /test endpoint")
        sql = `
        SELECT * FROM Recipe
        `
        recipes.query(sql,(err,result) => {
            if (err){
                console.log(err)
                res.status(500).send()
                return connection.release()
            }

            if (result.length === 0){
                console.log("Got Empty response from Database\nPropably no dummy data available for request")
                res.status(204).send()
                return connection.release()
            }
            else {
                //The query returns an array of JSON objects,but i only have 1 result.
                //So,i access that first
                //result=result[0]

                res.setHeader('Content-Type', 'application/json')
                res.send(JSON.stringify(result,null,2));
                //res.send(result)
                connection.release()
            }
            console.log("The result of the query is:")
            console.log(result)
        })
    })
})

app.get("/3-3", (req,res) => {
    recipes.getConnection((err,connection) => {
        if (err) {
            console.log("error connecting to db")
            res.status(500).send()
            connection.release()
            throw err
        }
        console.log("Connected on /test endpoint")
        sql = `
        SELECT cooks.chef_id,_name,Count(rec_id) as total_recipes
        FROM cooks 
        INNER JOIN cooks_in_recipe using (chef_id)
        WHERE cooks.age < 30 group by chef_id
        ORDER BY total_recipes
        DESC LIMIT 10;
        `
        recipes.query(sql,(err,result) => {
            if (err){
                console.log(err)
                res.status(500).send()
                return connection.release()
            }

            if (result.length === 0){
                console.log("Got Empty response from Database\nPropably no dummy data available for request")
                res.status(204).send()
                return connection.release()
            }
            else {
                //The query returns an array of JSON objects,but i only have 1 result.
                //So,i access that first
                //result=result[0]

                res.setHeader('Content-Type', 'application/json')
                res.send(JSON.stringify(result,null,2));
                //res.send(result)
                connection.release()
            }
            console.log("The result of the query is:")
            console.log(result)
        })
    })
})

app.get("/cookdata", (req,res) => {
    recipes.getConnection((err,connection) => {
        if (err) {
            console.log("error connecting to db")
            res.status(500).send()
            connection.release()
            throw err
        }
        console.log("Connected on /test endpoint")
        sql = `
        SELECT * FROM cooks;
        `
        recipes.query(sql,(err,result) => {
            if (err){
                console.log(err)
                res.status(500).send()
                return connection.release()
            }

            if (result.length === 0){
                console.log("Got Empty response from Database\nPropably no dummy data available for request")
                res.status(204).send()
                return connection.release()
            }
            else {
                //The query returns an array of JSON objects
                
                for(let j = 0;j< result.length;j++){
                    console.log(result[j])
                    console.log(result[j]["List_of_Specializations_in_Nations"].split(","))
                    if (result[j]["List_of_Specializations_in_Nations"] != null)
                    result[j]["List_of_Specializations_in_Nations"] = separate_into_list(result[j]["List_of_Specializations_in_Nations"]);
                }
               

                res.setHeader('Content-Type', 'application/json')
                res.send(JSON.stringify(result,null,2));
                //res.send(result)
                connection.release()
            }
            console.log("The result of the query is:")
            console.log(result)
        })
    })
})

app.get(startURL+"/signin",(req,res) => {
    let user_username = ""
    let user_password = ""
    error_proper_syntax_string='Input data is incorrect.Try with proper query parameters "username" and "password'
    if ((!req.query.username)||(!req.query.password)){
        console.log(error_proper_syntax_string)
        return res.status(400).send(error_proper_syntax_string)
    }
    else {
        user_username = req.query.username.toString()
        user_password = req.query.password.toString()
        if ((user_username == "")||(user_password == "")){
            console.log(error_proper_syntax_string)
            return res.status(400).send(error_proper_syntax_string)
        }
    }

    recipes.getConnection((err,connection) => {
        if (err){
            console.log("error connecting to db")
            res.status(500).send()
            connection.release()
            throw err
        }
        console.log("Connected!\n")
        sql=`
        SELECT user_id from users where username = ? and _password = ?
        `
        recipes.query(sql,[user_username,user_password],(err,result) => {
            if (err){
                console.log(err)
                res.status(500).send()
                return connection.release()
            }

            if (result.length === 0){
                console.log("Credentials failed to authenticate")
                res.status(401).send("Credentials failed to authenticate")
                return connection.release()
            }
            else {
                //Separate into list of lists where it is required
                result=result[0]

                console.log("user's id: " + result["user_id"])
                res.status(200).send(result["user_id"].toString());
                connection.release()
            }
            console.log("This user exists in the database and their credentials have been validated")
        })
    })
})

app.post(startURL+"/signup",(req,res) => {
    let new_username = ""
    let new_password = ""
    let role = ""
    error_proper_syntax_string='Input data is incorrect.Try with proper http body syntax'
    if ((req.body.role === undefined)||(!req.body.username)||(!req.body.password)||((req.body.role != 1)&&(req.body.role != 0))){
        console.log("test")
        console.log(error_proper_syntax_string)
        return res.status(400).send(error_proper_syntax_string)
    }
    else {
        console.log("test")
        new_username = req.body.username.toString()
        new_password = req.body.password.toString()
        role = req.body.role.toString()
        if ((new_username == "")||(new_password == "")){
            console.log(error_proper_syntax_string)
            return res.status(400).send(error_proper_syntax_string)
        }
    }

    recipes.getConnection((err,connection) => {
        if (err){
            console.log("error connecting to db")
            res.status(500).send()
            connection.release()
            throw err
        }
        console.log("Connected!\n")
        sql=`
        INSERT INTO users (username,_password,_role) VALUES (?,?,?);
        `
        recipes.query(sql,[new_username,new_password,role],(err,result) => {
            if (err){
                console.log(err)
                //Send specific error message if trying to sign up with existing username
                if (err.code === "ER_DUP_ENTRY"){
                    res.status(400).send("Username already exists")
                    return connection.release()
                }
                res.status(500).send()
                return connection.release()
            }

            if (result.length === 0){
                console.log("Got Empty response from Database\nPropably no dummy data available for request")
                res.status(204).send()
                return connection.release()
            }
            else {
                //Separate into list of lists where it is required
                res.send("A new account has been created with the information you have given!");
                connection.release()
            }
            console.log("A new account has been created with the information you have given!")
        })
    })
})

app.get(startURL+"/fetchrecipe",(req,res) => {
    let recipe_id;
    error_proper_syntax_string='Input data is incorrect.Send recipe id in query parameters'
    if ((req.query.recipe_id === undefined)||(req.query.recipe_id == "")){
        console.log(error_proper_syntax_string)
        return res.status(400).send(error_proper_syntax_string)
    }
    else {
        recipe_id = parseInt(req.query.recipe_id)
    }

    recipes.getConnection((err,connection) => {
        if (err){
            console.log("error connecting to db")
            res.status(500).send()
            connection.release()
            throw err
        }
        console.log("Connected!\n")
        sql=
        `
        select * from all_recipe_data where id = ?;
        `
        recipes.query(sql,[recipe_id],(err,result) => {
            if (err){
                console.log(err)
                res.status(500).send()
                return connection.release()
            }

            if (result.length === 0){
                console.log("Got Empty response from Database\nPropably no dummy data available for request")
                res.status(204).send()
                return connection.release()
            }
            else {
                //Separate into list of lists where it is required
                result = result[0]

                result["equipment_used"] = separate_result_column(result["equipment_used"])
                result["ingredients_used"] = separate_result_column(result["ingredients_used"])
                result["ordered_steps"] = separate_result_column(result["ordered_steps"])
                result["tag_list"] = separate_result_column(result["tag_list"])
                result["cook_list"] = separate_result_column(result["cook_list"])

                res.send(result);
                connection.release()
            }
            console.log("Successfully fetched recipe:")
            console.log(result)
        })
    })
})

app.post(startURL + "/newepisode", (req, res) => {
    const { year, order } = req.body;

    if (year === undefined || order === undefined || order > 10) {
        return res.status(400).send('Required fields (year or order) wrong or missing');
    }

    recipes.getConnection((err, connection) => {
        if (err) {
            console.log("Error connecting to db");
            res.status(500).send();
            if (connection) connection.release();
            throw err;
        }

        const sql = `
            SELECT COUNT(*) AS count 
            FROM Episodes 
            WHERE _year = ? AND _order = ?;
        `;

        connection.query(sql, [_year, _order], async (err, result) => {
            if (err) {
                console.log(err);
                res.status(500).send();
                connection.release();
                return;
            }

            if (result[0].count > 0) {
                res.status(400).send("Episode already exists, try again");
                connection.release();
                return;
            }

            try {
                await new Promise((resolve, reject) => {
                    connection.beginTransaction(err => {
                        if (err) reject(err);
                        else resolve();
                    });
                });

                const recentEpisodesSql = `
                    SELECT episode_id FROM episodes ORDER BY _year DESC, _order DESC LIMIT 3;
                `;
                const recentEpisodes = await new Promise((resolve, reject) => {
                    connection.query(recentEpisodesSql, (err, results) => {
                        if (err) reject(err);
                        else resolve(results.map(row => row.episode_id));
                    });
                });

                /*const getCandidates = async (table, idField) => {
                    const recentSelectionsSql = `
                        SELECT ${idField}, COUNT(${idField}) AS count
                        FROM (
                            SELECT episode_id, chef_id FROM episode_list WHERE episode_id IN (?)
                            UNION ALL
                            SELECT episode_id, chef_id FROM episode_Judges WHERE episode_id IN (?)
                        ) AS recent_selections
                        GROUP BY ${idField}
                        HAVING count >= 3;
                    `;
                    const recentSelections = await new Promise((resolve, reject) => {
                        connection.query(recentSelectionsSql, [recentEpisodes, recentEpisodes], (err, results) => {
                            if (err) reject(err);
                            else resolve(results.map(row => row[idField]));
                        });
                    });

                    const candidatesSql = `
                        SELECT * FROM ${table} WHERE ${idField} NOT IN (?)
                        ORDER BY RAND() LIMIT 10;
                    `;
                    return await new Promise((resolve, reject) => {
                        connection.query(candidatesSql, [recentSelections.length ? recentSelections : [0]], (err, results) => {
                            if (err) reject(err);
                            else resolve(results);
                        });
                    });
                };*/

                //const getCandidateNations = async 
                const recentCookersSql = `
                    SELECT chef_id, COUNT(chef_id) AS count
                    FROM episode_list inner join cooks using (chef_id)
                    where episode_id in (?)
                    GROUP BY chef_id
                    HAVING count >= 3;
                `;
                const recentCookerSelections = await new Promise((resolve, reject) => {
                    connection.query(recentCookersSql, [recentEpisodes, recentEpisodes], (err, results) => {
                        if (err) reject(err);
                        else resolve(results.map(row => row[idField]));
                    });
                });
                const candidateCookersSql = `SELECT * FROM Cooks WHERE chef_id NOT IN (?) ORDER BY RAND() LIMIT 10`;
 
                const Cookers = await new Promise((resolve, reject) => {
                    connection.query(candidateCookersSql, [recentCookerSelections.length ? recentCookerSelections : [0]], (err, results) => {
                        if (err) reject(err);
                        else resolve(results);
                    });
                });
                
                /*const RecentNationsSql = `
                    SELECT Nation, COUNT(Nation) AS count
                    FROM episode_list inner join recipe on id = rec_id
                    where episode_id in (48,49,50)
                    GROUP BY Nation
                    HAVING count >= 3;                
                `;
                const RecentNationsSelection = await new Promise((resolve, reject) => {
                    connection.query(recentNationsSql, [recentEpisodes, recentEpisodes], (err, results) => {
                        if (err) reject(err);
                        else resolve(results.map(row => row[idField]));
                    });
                });

                const candidateNationsSql = `SELECT * FROM Recipes WHERE Nation NOT IN (?) ORDER BY RAND() LIMIT 10`;

                const */
                //const cuisines = await getCandidates('Recipe', 'Nation');
                //const cookers = await getCandidates('Cooks', 'chef_id');
   
                const recipesByCuisine = await Promise.all(
                    cuisines.map(cuisine => {
                        return new Promise((resolve, reject) => {
                            const fetchRecipeSql = `
                                SELECT * FROM recipes WHERE Nation = ? ORDER BY RAND() LIMIT 10;
                            `;
                            connection.query(fetchRecipeSql, [cuisine.id], (err, results) => {
                                if (err) reject(err);
                                else resolve(results[0]);
                            });
                        });
                    })
                );

                const assignments = cuisines.map((cuisine, index) => ({
                    cuisine: cuisine.id,
                    cooker: cookers[index].id,
                    recipe: recipesByCuisine[index].id,
                }));
                
                const recentJudgesSql = `
                    SELECT chef_id, COUNT(chef_id) AS count
                    FROM episode_judges inner join Cooks using (chef_id)
                    WHERE episode_id IN (?)
                    GROUP BY chef_id
                    HAVING count >= 1;
                `;
                const recentJudgeSelections = await new Promise((resolve, reject) => {
                    connection.query(recentJudgesSql, [recentEpisodes, recentEpisodes], (err, results) => {
                        if (err) reject(err);
                        else resolve(results.map(row => row[idField]));
                    });
                });

                const candidateJudgesSql = `SELECT * FROM Cooks WHERE chef_id NOT IN (?) ORDER BY RAND() LIMIT 3`;

                const Judges = await new Promise((resolve, reject) => {
                    connection.query(candidateJudgesSql, [recentJudgeSelections.length ? recentJudgeSelections : [0]], (err, results) => {
                        if (err) reject(err);
                        else resolve(results);
                    });
                });
            

                //const judges = await getCandidates('Cooks', 'chef_id'); 

                const insertEpisodeSql = `
                    INSERT INTO episodes (_year, _order) VALUES (?, ?);
                `;
                const { insertId: episodeId } = await new Promise((resolve, reject) => {
                    connection.query(insertEpisodeSql, [_year, _order], (err, result) => {
                        if (err) reject(err);
                        else resolve(result);
                    });
                });

                const insertAssignmentsSql = `
                    INSERT INTO episode_list (episode_id, cuisine, chef_id, rec_id) VALUES ?
                `;
                const assignmentsValues = assignments.map(a => [episodeId, a.cuisine, a.cooker, a.recipe]);
                await new Promise((resolve, reject) => {
                    connection.query(insertAssignmentsSql, [assignmentsValues], (err) => {
                        if (err) reject(err);
                        else resolve();
                    });
                });

                const insertJudgesSql = `
                    INSERT INTO episode_judges (episode_id, chef_id) VALUES ?
                `;
                const judgesValues = judges.map(judge => [episodeId, judge.id]);
                await new Promise((resolve, reject) => {
                    connection.query(insertJudgesSql, [judgesValues], (err) => {
                        if (err) reject(err);
                        else resolve();
                    });
                });

                await new Promise((resolve, reject) => {
                    connection.commit(err => {
                        if (err) reject(err);
                        else resolve();
                    });
                });

                // Generate random scores and insert them into the database
                const generateRandomScore = () => Math.floor(Math.random() * 5) + 1;
                const scorePromises = assignments.map(assignment => {
                    return judges.map(judge => {
                        const score = generateRandomScore();
                        const insertScoreSql = `
                            INSERT INTO episode_scores (episode_id, chef_id,  score) VALUES (?, ?,  ?);
                        `;
                        return new Promise((resolve, reject) => {
                            connection.query(insertScoreSql, [episodeId, assignment.cooker, judge.id, score], (err) => {
                                if (err) reject(err);
                                else resolve();
                            });
                        });
                    });
                });

                await Promise.all(scorePromises.flat());

                // Fetch scores and determine the winner
                const fetchScoresSql = `
                    SELECT chef_id, SUM(score) as total_score
                    FROM Ratings
                    WHERE episode_id = ?
                    GROUP BY chef_id
                    ORDER BY total_score DESC
                `;
                const scores = await new Promise((resolve, reject) => {
                    connection.query(fetchScoresSql, [episodeId], (err, results) => {
                        if (err) reject(err);
                        else resolve(results);
                    });
                });

                const highestScore = scores[0].total_score;
                const topScorers = scores.filter(score => score.total_score === highestScore);

                let winner;
                if (topScorers.length > 1) {
                    // Handle tie by professional training
                    const trainingLevels = { '3rd cooker': 1, '2nd cooker': 2, '1st cooker': 3, 'chef assistant': 4, 'chef': 5 };
                    const cookerTrainingLevelsSql = `
                        SELECT chef_id, Chef_title
                        FROM Cooks
                        WHERE chef_id IN (?)
                    `;
                    const topScorerIds = topScorers.map(scorer => scorer.cooker_id);
                    const topScorersWithTraining = await new Promise((resolve, reject) => {
                        connection.query(cookerTrainingLevelsSql, [topScorerIds], (err, results) => {
                            if (err) reject(err);
                            else resolve(results);
                        });
                    });

                    topScorersWithTraining.sort((a, b) => {
                        const trainingA = trainingLevels[a.professional_training];
                        const trainingB = trainingLevels[b.professional_training];
                        return trainingB - trainingA; // Higher training level first
                    });

                    const topTrainingLevel = trainingLevels[topScorersWithTraining[0].professional_training];
                    const topTrainers = topScorersWithTraining.filter(scorer => trainingLevels[scorer.professional_training] === topTrainingLevel);

                    if (topTrainers.length > 1) {
                        // Random selection in case of a tie in professional training
                        winner = topTrainers[Math.floor(Math.random() * topTrainers.length)];
                    } else {
                        winner = topTrainers[0];
                    }
                } else {
                    winner = topScorers[0];
                }

                res.send({ message: 'Episode created successfully', winner: winner.cooker_id });
            } catch (error) {
                console.log(error);

                await new Promise((resolve, reject) => {
                    connection.rollback(err => {
                        if (err) reject(err);
                        else resolve();
                    });
                });

                res.status(500).send({ message: 'Error creating episode' });
            } finally {
                connection.release();
            }
        });
    });
});

app.post(startURL+"/newrecipe",(req,res) => {
    //Parameter Checkin
    error_proper_syntax_string=
    `Not all parameters are passed.Proper syntax is this:
    {
        "chef_id" : any chef_id,
        "CookingorConfectionary": 0 or 1,
        "Nation": any nation,
        "Difficulty_level": 1 to 5,
        "recipe_name": the name of recipe,
        "description_": recipe description,
        "prep_time": any positive number,
        "cook_time": any positive number,
        "portions": any positive number,
        "basic_ingredient_id": any existing ingredient id for ingredient group,
        "meal_type": type of meal
    }
    `
    //if lencth of parameters is different than expected.Naive parameter checking
    if (Object.keys(req.body).length != 11){
        console.log(error_proper_syntax_string)
        return res.status(400).send(error_proper_syntax_string)
    }

    recipes.getConnection((err,connection) => {
        if (err){
            console.log("error connecting to db")
            res.status(500).send()
            connection.release()
            throw err
        }
        console.log("Connected!\n")
        sql=
        `
        CALL InsertRecipeWithChef(?,?,?,?,?,?,?,?,?,?,?);
        `
        recipes.query(sql,
            [
                req.body.CookingorConfectionary,
                req.body.Nation,
                req.body.Difficulty_level,
                req.body.recipe_name,
                req.body.description_,
                req.body.prep_time,
                req.body.cook_time,
                req.body.portions,
                req.body.basic_ingredient_id,
                req.body.meal_type,
                req.body.chef_id,
            ],(err,result) => {
            if (err){
                console.log(err)
                res.status(500).send()
                return connection.release()
            }

            if (result.length === 0){
                console.log("Got Empty response from Database\nPropably no dummy data available for request")
                res.status(204).send()
                return connection.release()
            }
            else {
                result=result[0]
                created_recipe_id = result[0]["new_recipe_id"]

                res.send("A new recipe has been created with the recipe id: " + created_recipe_id 
                        +'\nAdd equipment,ingredients,steps,tags and tips separately!');
                connection.release()
            }
            console.log("Successfully fetched recipe:")
            console.log(result)
        })
    })
})

app.listen(PORT, () => {console.log('Server started on port 5000')})
