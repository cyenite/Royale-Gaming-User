// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Future _notificationDetails() async {
//   return const NotificationDetails(
//       android: AndroidNotificationDetails('channel Id', 'channel Name',
//           channelDescription: 'silent channel description',
//           importance: Importance.max),
//       iOS: IOSNotificationDetails());
// }

// class ApiNotification {
//   static final _apiNotification = FlutterLocalNotificationsPlugin();
//   static Future showApiNotification({
//     int id = 0,
//     String? title,
//     String? body,
//     String? payload,
//   }) async =>
//       _apiNotification.show(
//         id,
//         title,
//         body,
//         await _notificationDetails(),
//         payload: payload,
//       );
// }
