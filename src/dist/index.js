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
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (g && (g = 0, op[0] && (_ = 0)), _) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
exports.__esModule = true;
var client_1 = require("@prisma/client");
var prisma = new client_1.PrismaClient();
var express = require("express");
var cors = require('cors');
var port = process.env.PORT;
var app = express();
app.use(cors());
app.use(express.json());
app.get("/dinosaurs", function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    var test, dinosaurs, error_1;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                test = req.body.name;
                _a.label = 1;
            case 1:
                _a.trys.push([1, 3, , 4]);
                return [4 /*yield*/, prisma.dinosaur.findMany()];
            case 2:
                dinosaurs = _a.sent();
                res.json(dinosaurs);
                return [3 /*break*/, 4];
            case 3:
                error_1 = _a.sent();
                console.log(error_1);
                res.json(error_1 + "cannot connect to database");
                return [3 /*break*/, 4];
            case 4: return [2 /*return*/];
        }
    });
}); });
app.get("/dinosaur", function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    var dinosaurname, dinosaur, error_2;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                dinosaurname = req.query.name;
                _a.label = 1;
            case 1:
                _a.trys.push([1, 3, , 4]);
                return [4 /*yield*/, prisma.dinosaur.findMany({
                        where: {
                            name: {
                                contains: dinosaurname
                            }
                        }
                    })];
            case 2:
                dinosaur = _a.sent();
                res.json(dinosaur);
                return [3 /*break*/, 4];
            case 3:
                error_2 = _a.sent();
                console.log(error_2);
                res.json(error_2 + "cannot connect to database");
                return [3 /*break*/, 4];
            case 4: return [2 /*return*/];
        }
    });
}); });
app.post("/dinosaur", function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    var newdinosaur, dinosaur, error_3;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                newdinosaur = req.body;
                _a.label = 1;
            case 1:
                _a.trys.push([1, 3, , 4]);
                return [4 /*yield*/, prisma.dinosaur.create({
                        data: {
                            name: newdinosaur.name,
                            description: newdinosaur.description,
                            creator: newdinosaur.creator
                        }
                    })];
            case 2:
                dinosaur = _a.sent();
                res.json({ dinosaur: dinosaur });
                return [3 /*break*/, 4];
            case 3:
                error_3 = _a.sent();
                console.log(error_3);
                res.json(error_3 + "cannot connect to database");
                return [3 /*break*/, 4];
            case 4: return [2 /*return*/];
        }
    });
}); });
app["delete"]("/dinosaur", function (req, res) { return __awaiter(void 0, void 0, void 0, function () {
    var dinosaurname, dinosaur, error_4;
    return __generator(this, function (_a) {
        switch (_a.label) {
            case 0:
                dinosaurname = req.query.name;
                _a.label = 1;
            case 1:
                _a.trys.push([1, 3, , 4]);
                return [4 /*yield*/, prisma.dinosaur.deleteMany({
                        where: {
                            name: dinosaurname
                        }
                    })];
            case 2:
                dinosaur = _a.sent();
                res.json({ dinosaur: dinosaur });
                return [3 /*break*/, 4];
            case 3:
                error_4 = _a.sent();
                console.log(error_4);
                res.json(error_4 + "cannot connect to database");
                return [3 /*break*/, 4];
            case 4: return [2 /*return*/];
        }
    });
}); });
app.listen(port, function () {
    console.log("server exposed on port: " + port);
});
//# sourceMappingURL=index.js.map