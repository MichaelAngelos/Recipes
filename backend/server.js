const mysql=require("mysql2")
const express = require('express')
const app = express()
const PORT = 5000;

const startURL="";
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

app.listen(PORT, () => {console.log('Server started on port 5000')})