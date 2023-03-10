import 'dart:convert';

import 'package:cluedin_app/models/notification.dart';
import 'package:cluedin_app/screens/notification_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:navbar_router/navbar_router.dart';

import '../main.dart';
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

    _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: (details) async {
        String? payload = details.payload;

        if (payload == "notification") {
          print("reached here here");
          // add this line
          await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomePage(),
            ),
            (route) => false,
          );
          NavbarNotifier.index = 1;
        }
      },
      onDidReceiveNotificationResponse: (details) async {
        String? payload = details.payload;

        if (payload == "notification") {
          print("reached here");
          // add this line
          await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomePage(),
            ),
            (route) => false,
          );
          NavbarNotifier.index = 1;
        }
      },
    );
  }

  void createanddisplaynotification(
      BuildContext context, RemoteMessage message) async {
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
        payload: "notification",
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
