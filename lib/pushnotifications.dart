import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Localnotificationservice {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static void initilize() {
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings('@mipmap/launcher_icon'));

    _plugin.initialize(initializationSettings);
  }

  static void displaymassage(RemoteMessage message) async {
    // print(message.notification?.title);
    // print('ccccccccccccccccccccccccccccccccccccccccc');
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            'easyaproach', 'easyaproach channel',
            importance: Importance.max, priority: Priority.high),
      );
      await _plugin.show(id, message.notification?.title,
          message.notification?.title, notificationDetails);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
