import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http ;
import 'dart:convert';
final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

Future sendAndRetrieveMessage(String token , String message, String title , {String imgUrl , String screen}) async {
  print(" In Send Notification");
  print(" Screen is $screen");
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
          'status': 'done',
          'screen' : screen,
          'x' : 'MsgBox()',
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


String calculateTime(time) {
  var now = DateTime.now();
  var difference = now.difference(time);
  var diffInDay = difference.inDays;
  String headerText = '';
  if (diffInDay == 0 && difference.inHours == 0) {
    headerText = 'just now';
  } else if (diffInDay == 0 && difference.inHours > 0) {
    if (difference.inHours > 1)
      headerText = '${difference.inHours} hrs ago';
    else
      headerText = '${difference.inHours} hr ago';
  } else if (diffInDay > 0 && diffInDay <= now.day) {
    if (diffInDay < 2)
      headerText = '$diffInDay day ago';
    else
      headerText = '$diffInDay days ago';
  } else if (diffInDay >= 7 && diffInDay <= now.day) {
    headerText = '1 week ago';
  } else if (diffInDay >= 14 && diffInDay <= now.day) {
    headerText = '2 weeks ago';
  } else if (diffInDay >= 21 && diffInDay <= now.day) {
    headerText = '3 weeks ago';
  } else if (diffInDay >= 28 && diffInDay <= now.day) {
    headerText = '4 weeks ago';
  } else if (diffInDay >= 30 && time.year == now.year || diffInDay < 365) {
    if (now.month < time.month) {
      int diff = (now.month + 12) - time.month;
      headerText = '$diff months ago';
    } else {
      int diff = now.month - time.month;
      headerText = '$diff months ago';
    }
  } else {
    headerText = 'year Ago';
  }
  return headerText;
}