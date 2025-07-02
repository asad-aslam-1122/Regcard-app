import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class PushNotification {
  static void sendNotification({
    String? fcmToken,
    String? title,
    String? body,
  }) async {
    var response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAAMmpcRNY:APA91bHH4FtCYFOM2yYMslIfq8vRYwyGcNrkgaDKxL8oMgGEClFp2vbdOLDSIcObKAXyqDtRHdFnF8Fq_GuWCL-SCsp6jgIKJMIJ54QC_Y8WgJixRK22sj2_ah71BvqBHJ2Ef0CztzQu'
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{'title': title, 'body': body},
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '5',
            'sound': 'default',
            'status': 'done',
          },
          'to': fcmToken
        },
      ),
    );
    log(response.body);
  }
}
