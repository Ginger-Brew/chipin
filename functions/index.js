const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.updateDiscountCodes = functions.https.onCall(async (data, context) => {
  try {
    const currentTime = new Date();
    const userEmail = context.auth.token.email || null;
    const documentId = data.documentId; // Get the documentId from the argument

    // Reference to the Firestore collection
    const discountCodeCollection = admin.firestore().collection("DiscountCode");
    const earnListCollection =
    admin.firestore().collection(`Restaurant/${userEmail}/EarnList`);

    // Retrieve the document using the provided documentId
    const doc = await discountCodeCollection.doc(documentId).get();

    if (doc.exists) {
      const expirationDate = doc.data().expirationDate.toDate();

      // Check if the expiration date has passed
      if (currentTime > expirationDate) {
        // Update isValid to false
        await discountCodeCollection.doc(documentId).update({isValid: false});

        // Create a new document in the user's EarnList
        const earnPoint = {
          currentTime: currentTime,
          reservationPrice: doc.data().reservationPrice,
        };

        await earnListCollection.add(earnPoint);
      }
    } else {
      console.log(`Document with ID ${documentId} does not exist.`);
    }

    return null;
  } catch (e) {
    console.error("Error updating discount codes: ", e);
    throw new functions.https.HttpsError("internal",
        "An error occurred while updating discount codes.");
  }
});
