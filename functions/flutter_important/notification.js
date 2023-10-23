const functions = require("firebase-functions");
const admin = require("./admin");

const db = admin.firestore();

const addMessage = functions.firestore
  .document("/diary/{diaryId}/post/{postId}/comment/{commentId}")
  .onCreate(async (snap, context) => {
    const newValue = snap.data();
    const postDoc = await db
      .doc(`diary/${context.params.diaryId}/post/${context.params.postId}`)
      .get();
    const postOwnerData = postDoc.data();

    if (postOwnerData && newValue.userId !== postOwnerData.userId) {
      const userDoc = await db.doc(`user/${postOwnerData.userId}`).get();
      const userData = userDoc.data();

      if (userData) {
        var tokens = userData.pushToken;

        var message = {
          notification: {
            title: `${postDoc.diaryTittle}`,
            body: `${newValue.userName}님이 댓글을 남겼습니다`,
          },
          data: {
            // Add this
            title: `${postDoc.diaryTittle}}`,
            body: `${newValue.userName}님이 댓글을 남겼습니다`,
          },
          token: tokens,
        };
        admin
          .messaging()
          .send(message)
          .then((response) => {
            console.log("Successfully sent message:", response);
          })
          .catch((error) => {
            console.log("Error sending message:", error);
          });
      }
    }
  });

module.exports = { addMessage };
