const functions = require("firebase-functions");
const admin = require("./admin");

const db = admin.firestore();

const addMessage = functions.firestore
  .document("/user/{userId}/diary/{diaryId}/post/{postId}/comment/{commentId}")
  .onCreate(async (snap, context) => {
    const newValue = snap.data();
    const postDoc = await db
      .doc(
        `user/${context.params.userId}/diary/${context.params.diaryId}/post/${context.params.postId}`
      )
      .get();
    const postOwnerData = postDoc.data();
    if (postOwnerData) {
      var tokens = postOwnerData.pushToken;

      var message = {
        notification: {
          title: `${newValue.title}`,
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
  });
module.exports = { addMessage };
