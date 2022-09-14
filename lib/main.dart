// ignore_for_file: camel_case_types

import 'package:cluedin_app/screens/notification_page.dart';
import 'package:cluedin_app/screens/login_page.dart';
import 'package:cluedin_app/utils/routes.dart';
import 'package:cluedin_app/widgets/themes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.darkTheme(context),
      initialRoute: MyRoutes.notificationRoute,
      routes: {
        "/": (context) => LoginPage(),
        MyRoutes.notificationRoute: (context) => NotificationPage(),
        MyRoutes.loginRoute: (context) => LoginPage(),
      },
    );
  }
}

// ignore_for_file: prefer_const_constructors