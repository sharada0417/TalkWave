import express from 'express';
import http from 'http'
import cors from 'cors'
import dotenv from 'dotenv'
import { WebSocket , WebSocketServer } from "ws";

dotenv.config();
const app=express();
const server = http.createServer(app)
const wss = new WebSocketServer({ server });

app.use(cors());
app.use(express.json());

//create a new websocket connection
wss.on("connection",(ws:WebSocket)=>{
    console.log("New Client connected");

    ws.on("message",(data)=>{
        console.log("Recevied a message from the client: "+data);
        wss.clients.forEach((client)=>{
            if(client !== ws && client.readyState == WebSocket.OPEN){
                client.send(data);
            }
        });
    });

    ws.on("close",()=>{
        console.log("Client disconnected");
    })
})

const PORT = process.env.PORT;

server.listen(PORT,()=>{
    console.log(`server is running on port ${PORT}`);
})