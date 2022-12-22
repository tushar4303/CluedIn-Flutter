// ignore_for_file: use_build_context_synchronously
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../notificationService/local_notification_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String fcmToken = "firebase token";

  @override
  void initState() {
    print("le token");
    getToken();
    super.initState();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print(message);
      print("FirebaseMessaging.instance.getInitialMessage");
    });

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data11 ${message.data}");
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );
    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.notification!.title);
          print(message.notification!.body);
          print("message.data22 ${message.data['_id']}");
        }
      },
    );
  }

  getToken() async {
    String? token = await _firebaseMessaging.getToken();
    fcmToken = token!;
    print("fcm token : $fcmToken");
  }

  requestingNotificationPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("user granted provisional authorization");
    } else {
      print("user declined or has not accepted permisiion");
    }
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  String name = "";
  bool changeButton = false;

  final _formKey = GlobalKey<FormState>();

  moveToHome(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        changeButton = true;
      });

      await Future.delayed((Duration(seconds: 1)));
      // await Navigator.pushNamed(context, MyRoutes.notificationRoute);
      setState(() {
        changeButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 30.0,
                ),
                Image.asset(
                  "assets/images/welcome_cats.png",
                  fit: BoxFit.cover,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Welcome $name",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                            hintText: "Enter Username", labelText: "UserName"),
                        validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "Username cannot be empty";
                          //   }

                          //   return null;
                          // },
                          if (value != "Tushar4303") {
                            return "User doesn't exist";
                          } else if (value!.isEmpty) {
                            return "Please enter your UserName";
                          }

                          return null;
                        },
                        onChanged: (value) {
                          name = value;
                          setState(() {});
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            hintText: "Enter Password", labelText: "Password"),
                        validator: (value) {
                          //   if (value!.isEmpty) {
                          //     return "Password cannot be empty";
                          //   } else if (value.length < 6) {
                          //     return "Password length should be atleast 6";
                          //   }

                          //   return null;
                          // },
                          if (value != "admin123") {
                            return "Incorrect UserName or Password";
                          } else if (value!.isEmpty) {
                            return "Please enter your Password";
                          }

                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40.0,
                      ),
                      Material(
                        color: Colors.deepPurple,
                        borderRadius:
                            BorderRadius.circular(changeButton ? 50 : 8),
                        child: InkWell(
                          onTap: () => moveToHome(context),
                          child: AnimatedContainer(
                            duration: Duration(seconds: 1),
                            width: changeButton ? 50 : 150,
                            height: 50,
                            alignment: Alignment.center,
                            child: changeButton
                                ? Icon(
                                    Icons.done,
                                    color: Colors.white,
                                  )
                                : Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

// ignore_for_file: prefer_const_constructors