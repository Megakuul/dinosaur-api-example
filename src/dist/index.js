"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const client_1 = require("@prisma/client");
const prisma = new client_1.PrismaClient();
const express = require("express");
const port = process.env.PORT;
const app = express();
app.use(express.json());
app.get("/dinosaurs", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const dinosaurs = yield prisma.dinosaur.findMany();
    res.json(dinosaurs);
}));
app.get("/dinosaur", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const dinosaurname = req.query.name;
    const dinosaur = yield prisma.dinosaur.findMany({
        where: {
            name: dinosaurname
        }
    });
    res.json(dinosaur);
}));
app.post("/dinosaur", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const newdinosaur = req.body;
    const dinosaur = yield prisma.dinosaur.create({
        data: {
            name: newdinosaur.name,
            description: newdinosaur.description
        }
    });
    res.json({ dinosaur });
}));
app.delete("/dinosaur", (req, res) => __awaiter(void 0, void 0, void 0, function* () {
    const dinosaurname = req.query.name;
    const dinosaur = yield prisma.dinosaur.deleteMany({
        where: {
            name: dinosaurname
        }
    });
    res.json({ dinosaur });
}));
app.listen(port, () => {
    console.log("server exposed on port: " + port);
});
//# sourceMappingURL=index.js.map