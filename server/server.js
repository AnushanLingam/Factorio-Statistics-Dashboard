const path = require('path');
const fs = require('fs');
const socketio = require("socket.io");
const express = require("express");
const http = require("http");

// Grab platform dependent mod output directory
let appDirectory = process.env.APPDATA || (process.platform == 'darwin' ? process.env.HOME + 'Library/Application Support' : process.env.HOME);
let statsDashboardData = path.join(appDirectory, "Factorio", "script-output", "statsDashboard");

/*
    output.json and input.json file structure
    [itemOutputs, fluidOutputs] || [itemInputs, fluidInputs] 
*/

let outputStats;
let inputStats

if (fs.existsSync(path.join(statsDashboardData, "output.json")) && path.join(statsDashboardData, "input.json")) {
    outputStats = JSON.parse(fs.readFileSync(path.join(statsDashboardData, "output.json")));
    inputStats = JSON.parse(fs.readFileSync(path.join(statsDashboardData, "input.json")));
}

let stats = {
    output: {
        itemOutputs: outputStats !== undefined ? outputStats[0] : [],
        fluidOutputs: outputStats !== undefined ? outputStats[1] : []
    },
    inputs: {
        itemInputs: inputStats !== undefined ? inputStats[0] : [],
        fluidInputs: inputStats !== undefined ? inputStats[1] : []
    }
}

const port = process.env.PORT || 5000;
const app = express();
const publicPath = path.join(__dirname, "..", "dist");
var server = http.createServer(app);
var io = socketio(server);

io.on("connection", (socket) => {
    socket.emit("initialData", stats);
});

app.use(express.static(publicPath));

app.get("*", (req, res) => {
    res.sendFile(path.join(publicPath, "index.html"));
});

server.listen(port, () => {
    console.log("Server Running!", port);
});
