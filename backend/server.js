const mysql=require("mysql2")
const express = require('express')
const bodyParser = require('body-parser');
const { exec } = require('child_process');
const path = require('path');
const fs = require('fs');
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

function generateBackupFileName() {
    const date = new Date();
    var d = new Date,
    dformat = [d.getFullYear(),d.getMonth()+1,d.getDate()].join('-')+'_'
            +[d.getHours(),d.getMinutes(),d.getSeconds()].join('-');
    const timestamp = dformat
    return `recipes_backup_${timestamp}.sql`;
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
    year = req.body.year;
    order = req.body.order;

    if (year === undefined || order === undefined || order > 10) {
        return res.status(400).send('Required fields (year or order) wrong or missing');
    }

    recipes.getConnection(async (err, connection) => {
        if (err) {
            console.log("Error connecting to db");
            res.status(500).send();
            if (connection) connection.release();
            throw err;
        }

        try {
            await new Promise((resolve, reject) => {
                connection.beginTransaction(err => {
                    if (err) reject(err);
                    else resolve();
                });
            });

            const episodeExistsSql = `
                SELECT COUNT(*) AS count 
                FROM Episodes 
                WHERE _year = ? AND _order = ?;
            `;

            const [episodeExistsResult] = await new Promise((resolve, reject) => {
                connection.query(episodeExistsSql, [year, order], (err, results) => {
                    if (err) reject(err);
                    else resolve(results);
                });
            });

            if (episodeExistsResult.count > 0) {
                res.status(400).send("Episode already exists, try again");
                connection.release();
                return;
            }

            // Fetching recent episodes
            const recentEpisodesSql = `
                SELECT episode_id FROM episodes ORDER BY _year DESC, _order DESC LIMIT 3;
            `;
            const recentEpisodes = await new Promise((resolve, reject) => {
                connection.query(recentEpisodesSql, (err, results) => {
                    if (err) reject(err);
                    else resolve(results.map(row => row.episode_id));
                });
            });
            
            // Fetching recent cookers
            const recentCookersSql = `
                SELECT chef_id, COUNT(chef_id) AS count
                FROM episode_list INNER JOIN cooks USING (chef_id)
                WHERE episode_id IN (?)
                GROUP BY chef_id
                HAVING count >= 3;
            `;
            const recentCookerSelections = await new Promise((resolve, reject) => {
                connection.query(recentCookersSql, [recentEpisodes.length ? recentEpisodes : [-1]], (err, results) => {
                    if (err) reject(err);
                    else resolve(results.map(row => row.chef_id));
                });
            });

            // Fetching candidate cookers
            const candidateCookersSql = `
                SELECT * FROM Cooks 
                WHERE chef_id NOT IN (?) 
                ORDER BY RAND() 
                LIMIT 10;
            `;
            const cookers = await new Promise((resolve, reject) => {
                connection.query(candidateCookersSql, [recentCookerSelections.length ? recentCookerSelections : [0]], (err, results) => {
                    if (err) reject(err);
                    else resolve(results);
                });
            });

            // Fetching recent nations
            const recentNationsSql = `
                SELECT Nation, COUNT(Nation) AS count
                FROM episode_list INNER JOIN recipe ON id = rec_id
                WHERE episode_id IN (?)
                GROUP BY Nation
                HAVING count >= 3;
            `;
            const recentNationsSelection = await new Promise((resolve, reject) => {
                connection.query(recentNationsSql, [recentEpisodes.length ? recentEpisodes : [-1]], (err, results) => {
                    if (err) reject(err);
                    else resolve(results.map(row => row.Nation));
                });
            });

            // Fetching candidate cuisines
            const candidateNationsSql = `
                SELECT * FROM Recipe 
                WHERE Nation NOT IN (?) 
                ORDER BY RAND() 
                LIMIT 10;
            `;
            const cuisines = await new Promise((resolve, reject) => {
                connection.query(candidateNationsSql, [recentNationsSelection.length ? recentNationsSelection : [``]], (err, results) => {
                    if (err) reject(err);
                    else resolve(results);
                });
            });

            // Fetching recipes by cuisine
            const recipesByCuisine = await Promise.all(
                cuisines.map(cuisine => {
                    return new Promise((resolve, reject) => {
                        const fetchRecipeSql = `
                            SELECT * FROM recipe 
                            WHERE Nation = ? 
                            ORDER BY RAND() 
                            LIMIT 10;
                        `;
                        connection.query(fetchRecipeSql, [cuisine.Nation], (err, results) => {
                            if (err) reject(err);
                            else resolve(results[0]);
                        });
                    });
                })
            );
            //console.log(cuisines);
            // Assigning cookers to cuisines and recipes
            const assignments = cuisines.map((cuisine, index) => ({
                cuisine: cuisine.id,
                cooker: cookers[index].chef_id,
                recipe: recipesByCuisine[index].id,
            }));

            // Fetching recent judges
            const recentJudgesSql = `
                SELECT chef_id, COUNT(chef_id) AS count
                FROM episode_judges INNER JOIN Cooks USING (chef_id)
                WHERE episode_id IN (?)
                GROUP BY chef_id
                HAVING count >= 1;
            `;
            const recentJudgeSelections = await new Promise((resolve, reject) => {
                connection.query(recentJudgesSql, [recentEpisodes.length ? recentEpisodes : [-1]], (err, results) => {
                    if (err) reject(err);
                    else resolve(results.map(row => row.chef_id));
                });
            });

            // Fetching candidate judges
            const candidateJudgesSql = `
                SELECT * FROM Cooks 
                WHERE chef_id NOT IN (?) 
                ORDER BY RAND() 
                LIMIT 3;
            `;
            const judges = await new Promise((resolve, reject) => {
                connection.query(candidateJudgesSql, [recentJudgeSelections.length ? recentJudgeSelections : [0]], (err, results) => {
                    if (err) reject(err);
                    else resolve(results);
                });
            });

            // Inserting the episode to get the episodeId
            const insertEpisodeSql = `
                INSERT INTO episodes (_year, _order, chef_id_of_winner) VALUES (?, ?, ?);
            `;
            const { insertId: episodeId } = await new Promise((resolve, reject) => {
                connection.query(insertEpisodeSql, [year, order, null], (err, result) => {
                    if (err) reject(err);
                    else resolve(result);
                });
            });
            
            // Inserting assignments
            const insertAssignmentsSql = `
                INSERT INTO episode_list (episode_id, cuisine, chef_id, rec_id) VALUES ?
            `;
            //console.log(assignments);
            const assignmentsValues = assignments.map(a => [episodeId, a.cuisine, a.cooker, a.recipe]);
            //console.log(assignmentsValues);
            await new Promise((resolve, reject) => {
                connection.query(insertAssignmentsSql, [assignmentsValues], (err) => {
                    if (err) reject(err);
                    else resolve();
                });
            });

            // Inserting judges
            const insertJudgesSql = `
                INSERT INTO episode_judges (episode_id, chef_id) VALUES ?
            `;
            const judgesValues = judges.map(judge => [episodeId, judge.chef_id]);
            await new Promise((resolve, reject) => {
                connection.query(insertJudgesSql, [judgesValues], (err) => {
                    if (err) reject(err);
                    else resolve();
                });
            });

            // Generating random scores and inserting them
            const generateRandomScore = () => Math.floor(Math.random() * 5) + 1;
            const scorePromises = assignments.map(assignment => {
                return judges.map(judge => {
                    const score_1 = generateRandomScore();
                    const score_2 = generateRandomScore();
                    const score_3 = generateRandomScore();
                    const insertScoreSql = `
                        INSERT INTO Ratings (episode_id, chef_id, rating_1, rating_2, rating_3) VALUES (?, ?, ?, ?, ?);
                    `;
                    return new Promise((resolve, reject) => {
                        connection.query(insertScoreSql, [episodeId, assignment.cooker, score_1, score_2, score_3], (err) => {
                            if (err) reject(err);
                            else resolve();
                        });
                    });
                });
            });

            await Promise.all(scorePromises.flat());

            // Fetching scores and determining the winner
            const fetchScoresSql = `
                SELECT chef_id, (Rating_1 + Rating_2 + rating_3) as total_score
                FROM ratings
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
                const topScorerIds = topScorers.map(scorer => scorer.chef_id);
                const topScorersWithTraining = await new Promise((resolve, reject) => {
                    connection.query(cookerTrainingLevelsSql, [topScorerIds], (err, results) => {
                        if (err) reject(err);
                        else resolve(results);
                    });
                });

                winner = topScorersWithTraining.reduce((best, current) => {
                    if (trainingLevels[current.Chef_title] > trainingLevels[best.Chef_title]) {
                        return current;
                    }
                    return best;
                });
            } else {
                winner = topScorers[0];
            }

            // Update the episode with the winner's chef_id
            const updateWinnerSql = `
                UPDATE episodes SET chef_id_of_winner = ? WHERE episode_id = ?
            `;
            await new Promise((resolve, reject) => {
                connection.query(updateWinnerSql, [winner.chef_id, episodeId], (err) => {
                    if (err) reject(err);
                    else resolve();
                });
            });

            // Commit transaction
            await new Promise((resolve, reject) => {
                connection.commit(err => {
                    if (err) {
                        connection.rollback(() => {
                            reject(err);
                        });
                    } else {
                        resolve();
                    }
                });
            });

            res.send({ message: 'Episode created successfully', winner: winner.chef_id });
        } catch (error) {
            await new Promise((resolve, reject) => {
                connection.rollback(() => {
                    resolve();
                });
            });
            console.log(error);
            res.status(500).send();
        } finally {
            connection.release();
        }
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

tables_of_db = [
    "cooks",
    "cooks_in_recipe",
    "episode_judges",
    "episode_list",
    "episodes",
    "equipment",
    "equipment_in_recipes",
    "ingredient_belongs_in_group",
    "ingredient_group",
    "ingredients",
    "ingredients_in_recipes",
    "ratings",
    "recipe",
    "recipe_misc",
    "recipe_nutrition_per_portion",
    "recipe_steps",
    "recipe_tags",
    "sorted_steps",
    "theme",
    "users",
]

/*
operations_of_tables = {
    "cooks" : {
        "add" : "INSERT INTO cooks (name,Phone_number,birth_yr,Age,Years_of_Experience,List_of_Specializations_in_Nations,Chef_title) VALUES (?,?,?,?,?,?,?)",
        "update" : "UPDATE cooks SET ? where chef_id = ?",
    },
    "cooks_in_recipe" : {
        "add" : "INSERT INTO cooks (chef_id,rec_id) VALUES (?,?)",
        "update" : "UPDATE cooks SET ? where chef_id = ?",
    }
}
*/

app.post(startURL+"/crud_admin",(req,res) => {
     //Parameter Checking
    if (req.body.user_id === undefined || req.body.user_id == ''){
        console.log("Didn't provide user id for admin operation")
        return res.status(400).send("Didn't provide user id for admin operation")
    }
    if (!tables_of_db.includes(req.body.table)){
        console.log("Table parameter is incorrect,provide the name of an existing table")
        return res.status(400).send("Table parameter is incorrect,provide the name of an existing table")
    }
    if ((req.body.operation != "add") && (req.body.operation !="remove") && (req.body.operation !="update") && (req.body.operation !="read")){
        console.log("Operation not defined properly.Must be either add,remove or update")
        return res.status(400).send("Operation not defined properly.Must be either add,remove or update")
    }
    if (req.body.operation != "read" && req.body.data === undefined) {
        console.log("No data parameter given")
        return res.status(400).send("No data parameter given")
    }
    
    operation_on_Table = req.body.operation
    table_to_operate_on =  req.body.table

    recipes.getConnection((err,connection) => {
        if (err){
            console.log("error connecting to db")
            res.status(500).send()
            connection.release()
            throw err
        }
        console.log("Connected!\n")

        let sql;
        if (operation_on_Table == "read") {
            sql = "SELECT * FROM " + table_to_operate_on
        }
        else if (operation_on_Table == "remove") {
            sql = "DELETE FROM " + table_to_operate_on + " WHERE " + req.body.data.condition
        }
        else if (operation_on_Table == "update") {
            sql = "UPDATE " + table_to_operate_on + " SET " + req.body.data.column_data + " WHERE " + req.body.data.condition
        }
        //for add operation
        else {
            sql = "INSERT INTO " + table_to_operate_on + " (" + req.body.data.column_set + ") Values (" + req.body.data.values +')'
        }

        /*
        sql_parameters = 
        (operation_on_Table == "add") ? req.body.data.entry_list
        : (operation_on_Table == "update") ? [req.body.data.column_set,req.body.data.row_id]
        : null
        */

        recipes.query("SELECT * FROM users where user_id =" + req.body.user_id,(err,result) => {
            if (err){
                console.log(err)
                res.status(400).send(err)
                return connection.release()
            }

            if (result.length === 0){
                console.log("Got Empty response from Database\nPropably no dummy data available for request")
                res.status(204).send()
                return connection.release()
            }
            else {
                result=result[0];

                if (result["_role"] != 1) {
                    console.log("Invalid user id given.User id provided is not of admin")
                    return res.status(400).send("Invalid user id given.User id provided is not of admin")
                }
                else {
                    recipes.query(sql,(err,result) => {
                        if (err){
                            console.log(err)
                            res.status(400).send(err)
                            return connection.release()
                        }
            
                        if (result.length === 0){
                            console.log("Got Empty response from Database\nPropably no dummy data available for request")
                            res.status(204).send()
                            return connection.release()
                        }
                        else {
                            res.send(result);
                            connection.release()
                        }
                        console.log("Successfully performed operation:")
                        console.log(result)
                    })
                }
            }
            console.log("Successfully performed operation:")
            console.log(result)
        })
    })
})

app.post(startURL+"/backup",(req,res) => {

    if (!req.query.operation) {
        console.log("No operation provided regarding backups.Must be either 'create' or 'restore'")
        return res.status(400).send("No operation provided regarding backups.Must be either 'create' or 'restore'")
    }

    if (req.query.operation == 'create'){
        if (!req.query.mysql_bin_dir) {
            console.log("No directory provided for the bin folder of mysql.It is crucial to run mysqldump command")
            return res.status(400).send("No directory provided for the bin folder of mysql.It is crucial to run mysqldump command")
        }
    
        bin_directory = req.query.mysql_bin_dir.replace(/\\/g,'\\');
    
    
        const backupDir = req.query.backup_path.replace(/\\/g,'\\') || 'D:\\backup_database_of_recipe';
        if (!fs.existsSync(backupDir)) {
          fs.mkdirSync(backupDir, { recursive: true });
        }
      
        const backupFileName = generateBackupFileName();
        const backupFilePath = path.join(backupDir, backupFileName);
        const mysqldumpCommand = bin_directory + `\\mysqldump -u root recipes > "${backupFilePath}"`;
      
        exec(mysqldumpCommand, (error, stdout, stderr) => {
          if (error) {
            console.error(`Error executing mysqldump: ${error.message}`);
            return;
          }
      
          if (stderr) {
            console.error(`mysqldump stderr: ${stderr}`);
            return;
          }
      
          console.log(`Database backup created successfully at ${backupFilePath}`);
          res.send(`Database backup created successfully at ${backupFilePath}`)
        });
    }
    else if (req.query.operation == 'restore'){

        if (!req.query.backup_file_path) {
            console.log("No backup file path given")
            return res.status(400).send("No backup file path given")
        }

        if (!req.query.mysql_bin_dir) {
            console.log("No directory provided for the bin folder of mysql.It is crucial to run mysqldump command")
            return res.status(400).send("No directory provided for the bin folder of mysql.It is crucial to run mysqldump command")
        }
    
        bin_directory = req.query.mysql_bin_dir.replace(/\\/g,'\\');
      
        const backupFilePath = req.query.backup_file_path;
        const mysqlCommand = bin_directory + `\\mysql -u root recipes < "${backupFilePath}"`;
      
        exec(mysqlCommand, (error, stdout, stderr) => {
          if (error) {
            console.error(`Error executing mysqldump: ${error.message}`);
            return;
          }
      
          if (stderr) {
            console.error(`mysqldump stderr: ${stderr}`);
            return;
          }
      
          console.log(`Database backup created successfully at ${backupFilePath}`);
          res.send(`Database backup created successfully at ${backupFilePath}`)
        });
    }
    else {
        console.log("Incorrect operation value.Must be either 'create' or 'restore'")
         res.status(400).send("Incorrect operation value.Must be either 'create' or 'restore'")
    }
})

app.listen(PORT, () => {console.log('Server started on port 5000')})
