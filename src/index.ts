import { Prisma, PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

const express = require("express");
const cors = require('cors');

const port = process.env.PORT;

const app = express();

app.use(cors());
 
app.use(express.json());


app.get("/", async (req: any, res: any) => {
    res.redirect(301, "https://view.gehege.ch");
});

app.get("/dinosaurs", async (req: any, res: any) => {
    const test = req.body.name;

    try {
        const dinosaurs = await prisma.dinosaur.findMany();
        res.json(dinosaurs);
    } catch (error) {
        console.log(error);
        res.json(error + "cannot connect to database");
    }
});
 
app.get("/dinosaur", async (req: any, res: any) => {
    const dinosaurname = req.query.name;

    try {
        const dinosaur = await prisma.dinosaur.findMany({
            where: {
                name: {
                    contains: dinosaurname
                }
            }
        });
        
        res.json(dinosaur);
    } catch (error) {
        console.log(error);
        res.json(error + "cannot connect to database");
    }
});

app.post("/dinosaur", async (req: any, res: any) => {
    const newdinosaur = req.body;
    try {
        const dinosaur = await prisma.dinosaur.create({
            data: {
                name: newdinosaur.name,
                description: newdinosaur.description,
                creator: newdinosaur.creator
            }
        });
        res.json({dinosaur});
    } catch (error) {
        console.log(error);
        res.json(error + "cannot connect to database");
    }
});

app.delete("/dinosaur", async (req: any, res: any) => {
    const dinosaurname = req.query.name;
    try {
        const dinosaur = await prisma.dinosaur.deleteMany({
            where: {
                name: dinosaurname
            }
        })
        res.json({dinosaur});
    } catch (error) {
        console.log(error);
        res.json(error + "cannot connect to database");
    }
});

app.listen(port, () => {
    console.log("server exposed on port: " + port);
});