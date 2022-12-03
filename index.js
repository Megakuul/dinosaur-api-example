const express = require("express");

const app = express();

const port = parseInt(process.env.PORT) || 8080;

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
});