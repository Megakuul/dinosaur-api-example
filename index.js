"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
const express = require("express");
const port = process.env.PORT;
const app = express();
app.use(express.json());
app.get("/dinosaurs", (req, res) => {
    res.json();
});
app.listen(port, () => {
    console.log("server exposed on port: " + port);
});
//# sourceMappingURL=index.js.map