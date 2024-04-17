const express = require('express')
const app = express()
const PORT = 5000;

app.get("/hello-world", (req,res) => {
    res.status(200).send("Hello World!")
})

app.listen(PORT, () => {console.log('Server started on port 5000')})