import 'dart:convert';

import 'package:cluedin_app/models/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../screens/notification_detail.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    AndroidInitializationSettings androidSettings =
        const AndroidInitializationSettings("@mipmap/ic_launcher");

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
        Notifications notification = Notifications.fromMap(jsonDecode(payload));

        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NotificationDetailsPage(
              notification: notification,
            ),
          ),
        );
      }
    });
  }

  static void createanddisplaynotification(RemoteMessage message) async {
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
          category: AndroidNotificationCategory("notifications"),
        ),
      );

      await _notificationsPlugin.show(
        message.messageId.hashCode,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
        payload: json.encode(message.data),
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}
