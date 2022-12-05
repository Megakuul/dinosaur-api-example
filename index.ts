import { PrismaClient } from '@prisma/client'
const prisma = new PrismaClient()

const express = require("express");

const port = process.env.PORT;

const app = express();
 
app.use(express.json());


app.get("/dinosaurs", (req: any, res: any) => {
    res.json();
});

app.listen(port, () => {
    console.log("server exposed on port: " + port);
});