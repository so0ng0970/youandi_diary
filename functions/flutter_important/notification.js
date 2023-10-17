const functions = require("firebase-functions");
const admin = require("./admin");

const addMessage = functions.https.onRequest((req, res) => {
  const message = {
    notification: {
      title: "Title", // 제목
      body: "Content", //내용
    },
    topic: "Topic",
  };

  admin
    .messaging()
    .send(message)
    .then((response) => {
      console.log("Successfully sent message:", response);
      res.status(200).send("Success!"); 
    })
    .catch((error) => {
      console.log("Error sending message:", error);
      res.status(500).send(error);
    });
});

module.exports = { addMessage };
