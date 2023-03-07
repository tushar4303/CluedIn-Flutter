import 'dart:convert';

import 'package:cluedin_app/models/notification.dart';
import 'package:cluedin_app/screens/notification_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../screens/notification_detail.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    AndroidInitializationSettings androidSettings =
        const AndroidInitializationSettings("@mipmap/launcher_icon");

    DarwinInitializationSettings iosSettings =
        const DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestCriticalPermission: true,
            requestSoundPermission: true);

    InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    _notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) async {
      String? payload = details.payload;
      if (payload != null && payload.isNotEmpty) {
        // Notifications notification = Notifications.fromMap(jsonDecode(payload));

        // await Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => const NotificationPage(),
        //   ),
        // );
      }
    });
  }

  static void createanddisplaynotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    print(message);
    print("reached in show");
    try {
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "pushnotificationapp",
          "pushnotificationappchannel",
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          playSound: true,
          enableVibration: true,
          channelShowBadge: true,
          icon: "@mipmap/launcher_icon",
          category: AndroidNotificationCategory("notifications"),
        ),
      );

      await _notificationsPlugin.show(
        notification.hashCode,
        notification!.title,
        notification.body,
        notificationDetails,
        // payload: json.encode(message.data),
      );

      print("hua kya?");
    } on Exception catch (e) {
      print(e);
    }
  }
}
