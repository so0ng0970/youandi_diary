const logger = require("firebase-functions/logger");
const admin = require("firebase-admin");
const functions = require("firebase-functions");

var serviceAccount = require("./youandi-5b3cd-firebase-adminsdk-wbrno-c791a170d1.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});
// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

exports.createCustomToken = functions.https.onRequest(
  async (request, response) => {
    const user = request.body;

    const uid = `kakao:${user.uid}`;
    const updateParams = {
      email: user.email,
      photoURL: user.photoURL,
      displayName: user.displayName,
    };

    try {
        // 기존 유저 
      await admin.auth().updateUser(uid, updateParams);
    } catch (e) {
        // 새 유저 
      updateParams["uid"] = uid;
      await admin.auth().createUser(updateParams);
    }

    const token = await admin.auth().createCustomToken(uid);

    response.send(token);
  }
);
