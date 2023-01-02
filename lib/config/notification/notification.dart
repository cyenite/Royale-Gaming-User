import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  showNotification(AppNotification.fromMap(message.data));
}

Future<void> showNotification(AppNotification notification) async {}

class AppNotification {
  final String? title;
  final String? body;
  AppNotification({required this.title, required this.body});
  factory AppNotification.fromMap(Map data) {
    return AppNotification(body: data['body'], title: data['title']);
  }
}

Future firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint(
      "Handling a background message : ${message.notification!.title}");
}
