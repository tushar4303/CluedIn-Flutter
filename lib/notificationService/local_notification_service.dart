import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:navbar_router/navbar_router.dart';

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
          NavbarNotifier.index = 1;
          // await Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (BuildContext context) => const NotificationPage(),
          //   ),
          // );
        }
      },
      onDidReceiveNotificationResponse: (details) async {
        String? payload = details.payload;

        if (payload == "notification") {
          print("reached here");
          NavbarNotifier.index = 1;
          // add this line
          // await Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(
          //     builder: (BuildContext context) => const NotificationPage(),
          //   ),
          // );
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
          category: AndroidNotificationCategory.social,
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
