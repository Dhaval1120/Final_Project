import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http ;
import 'dart:convert';
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

Future sendAndRetrieveMessage(String token , String message, String title , [String imgUrl]) async {
  print(" In Send Notification");
  await firebaseMessaging.requestNotificationPermissions(
    const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: false),
  );
  String serverKey = 'AAAATXUm-B4:APA91bFAEMSBqEFllpXLMIyFuz7oBLjCT6CJTGyH_v3904i9YS8IC7IXO_cJUDduHdPDg5f4kgY8lyCebm4JWNMTEHFyC6VfVPhpVIubozRQKcuzt7En8X3J0aQ5I4P-vWEFQSheudpf';
  return await http.post(
    'https://fcm.googleapis.com/fcm/send',
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{
          'body': message,
          'title': title,
        },
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': token,
        'apns' : {
          "payload": {
            "aps": {
              "mutable-content": 1
            }
          },
          "fcm_options": {
            "image": imgUrl
          }
        }
      },
    ),
  ).catchError((e){
    print(" Error is $e");
  });
}