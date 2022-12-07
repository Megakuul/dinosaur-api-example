import { PrismaClient } from '@prisma/client'
import { ALL } from 'dns';

const prisma = new PrismaClient()

const express = require("express");

const port = process.env.PORT;

const app = express();
 
app.use(express.json());


app.get("/dinosaurs", async (req: any, res: any) => {

    const dinosaurs = await prisma.dinosaur.findMany();
    res.json(dinosaurs);
});
 
app.get("/dinosaur", async (req: any, res: any) => {
    const dinosaurname = req.query.name;

    const dinosaur = await prisma.dinosaur.findMany({
        where: {
            name: dinosaurname
        }
    });

    res.json(dinosaur);
});

app.post("/dinosaur", async (req: any, res: any) => {
    const newdinosaur = req.body;

    const dinosaur = await prisma.dinosaur.create({
        data: {
            name: newdinosaur.name,
            description: newdinosaur.description
        }
    });

    res.json({dinosaur});
});

app.delete("/dinosaur", async (req: any, res: any) => {
    const dinosaurname = req.query.name;
    
    const dinosaur = await prisma.dinosaur.deleteMany({
        where: {
            name: dinosaurname
        }
    })

    res.json({dinosaur});
});

app.listen(port, () => {
    console.log("server exposed on port: " + port);
});