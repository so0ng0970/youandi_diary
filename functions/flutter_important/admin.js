const admin = require("firebase-admin");
var serviceAccount = require("../youandi-5b3cd-firebase-adminsdk-wbrno-c791a170d1.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

module.exports = admin;
