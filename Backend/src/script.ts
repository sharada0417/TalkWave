import { WebSocketServer } from "ws";

const wss = new WebSocketServer({ port: 4000 });

console.log("server is running on port 4000");

wss.on("connection", (ws) => {
  console.log("New Client connected");

  ws.on("message", (message) => {
    console.log("Received a message from the client:", message.toString());

    // ✅ Send the message back to the same client
    ws.send(`Server reply: ${message}`);
  });

  ws.on("close", () => {
    console.log("Client disconnected");
  });

  ws.on("error", (err) => {
    console.error("Socket error:", err);
  });
});
