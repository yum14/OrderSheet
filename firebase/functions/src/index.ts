import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { firestore } from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript

// npm run build
// firebase emulators:start
// firebase deploy --only functions:[method]

export const helloWorld = functions.region('asia-northeast1').https.onRequest((request, response) => {
    functions.logger.info("Hello logs!", { structuredData: true });
    response.send("Hello from Firebase!");
});

export const sendOrderNotification = functions.region('asia-northeast1').firestore.document('notifications/{id}')
    .onCreate(async (snap, context) => {
        const triggerData = snap.data() as Notification;
        functions.logger.info("notification: ", triggerData.user_id);

        try {
            const usersSnapshot = await db.collection('users').where(firestore.FieldPath.documentId(), 'in', triggerData.member_ids).get();

            var tokens: [string?] = [];

            usersSnapshot.forEach(doc => {
                const user = doc.data() as User;
                tokens.push(user.notification_token);
            });

            const deviceTokens: [string] = tokens.filter(Boolean) as [string]

            if (deviceTokens.length > 0) {

                const payload = {
                    notification: {
                        title: triggerData.title,
                        body: triggerData.body,
                        icon: triggerData.icon
                    }
                };

                const response = await admin.messaging().sendToDevice(deviceTokens, payload);

                response.results.forEach((result, index) => {
                    const error = result.error;
                    if (error) {
                        functions.logger.error(
                            'Failure sending notification to',
                            deviceTokens[index],
                            error
                        );
                    }
                });
            } else {
                functions.logger.error('no notification token. user_id: ', triggerData.user_id);
            }

            // データ削除
            return snap.ref.delete()
                .catch(error => {
                    functions.logger.error('delete failed. user_id: ', triggerData.user_id);
                    functions.logger.error('error: ', error);
                });

        } catch (error) {
            functions.logger.error('no users. user_id: ', triggerData.user_id);
            functions.logger.error('error: ', error);
        }

    });

interface Notification {
    user_id: string;
    member_ids: [string];
    title: string;
    body: string;
    icon: string;
}

interface User {
    id: string;
    notification_token: string;
}