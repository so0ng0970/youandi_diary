const functions = require("firebase-functions");
const admin = require("./admin");

const createCustomToken = functions.https.onRequest(
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

module.exports = { createCustomToken };
