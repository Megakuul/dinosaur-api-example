const express = require("express");

const sql = require("mysql");

//Init Enviroment variables
const sqlhost = process.env.SQLHOST;

const sqluser = process.env.SQLUSER;

const sqlpassword = process.env.SQLPASSWORD;

const port = parseInt(process.env.PORT) || 8080;

const app = express();

const sql_con = sql.createConnection({
    host: sqlhost,
    user: sqluser,
    password: sqlpassword
});

app.use(express.json());

let dinosaursList = {
    dinosaurs: [
        {
            name: "Linosaurus Rex",
            height: 3.0,
            "body mass": 7,
            carnivore: true,
            family: "Linosaurs"
        },
        {
            name: "Stair dinosaur",
            height: 1.6,
            "body mass": 6,
            carnivore: false,
            family: "Stegosaurs"
        },
        {
            name: "Tyrannosaurus",
            height: 12.4,
            "body mass": 9.78,
            carnivore: true,
            family: "Tyrannosauroidea"
        }

    ]
}

app.get("/dinosaurs", (req, res) => {
    res.json(dinosaursList);
});

app.listen(port, () => {
    console.log("server started on port: " + port);
    sql_con.connect(function(err) {
        if (err) console.log(`cannot connect to database: ${sqlhost}`);
        else console.log(`successfully connected to database: ${sqlhost}`);
    });
});