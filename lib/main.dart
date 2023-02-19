// ignore_for_file: camel_case_types
import 'package:cluedin_app/screens/events.dart';
import 'package:cluedin_app/screens/homescreen.dart';
import 'package:cluedin_app/screens/notification_page.dart';
import 'package:cluedin_app/screens/phone.dart';
import 'package:cluedin_app/screens/profile.dart';
import 'package:cluedin_app/widgets/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'firebase_options.dart';
import 'utils/globals.dart';
import 'package:navbar_router/navbar_router.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

// FlutterLocalNotificationsPlugin notificationsPlugin =
//     FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "CluedIn",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(myApp());
}

class myApp extends StatelessWidget {
  const myApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: snackbarKey,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      theme: MyTheme.lightTheme(context),
      darkTheme: MyTheme.darkTheme(context),
      home: HomePage(),
      // home: MyPhone(),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  List<NavbarItem> items = [
    NavbarItem(
      Icons.home,
      'Home',
    ),
    NavbarItem(
      Icons.notifications,
      'Notifications',
    ),
    NavbarItem(Icons.explore, 'Explore'),
    NavbarItem(Icons.person, 'Profile'),
  ];

  final Map<int, Map<String, Widget>> _routes = {
    0: {
      '/': HomeScreen(),
    },
    1: {
      '/': NotificationPage(),
    },
    2: {
      '/': MyEvents(),
    },
    3: {
      '/': MyProfile(),
    },
  };

  @override
  Widget build(BuildContext context) {
    return NavbarRouter(
      errorBuilder: (context) {
        return const Center(child: Text('Error 404'));
      },
      onBackButtonPressed: (isExiting) {
        return isExiting;
      },
      destinationAnimationCurve: Curves.fastOutSlowIn,
      destinationAnimationDuration: 700,
      decoration: NavbarDecoration(
          backgroundColor: const Color.fromRGBO(251, 251, 252, 1),
          selectedIconTheme: const IconThemeData(color: Colors.black),
          navbarType: BottomNavigationBarType.fixed,
          elevation: 18,
          selectedLabelTextStyle: const TextStyle(color: Colors.black),
          enableFeedback: true),
      destinations: [
        for (int i = 0; i < items.length; i++)
          DestinationRouter(
            navbarItem: items[i],
            destinations: [
              for (int j = 0; j < _routes[i]!.keys.length; j++)
                Destination(
                  route: _routes[i]!.keys.elementAt(j),
                  widget: _routes[i]!.values.elementAt(j),
                ),
            ],
            initialRoute: _routes[i]!.keys.first,
          ),
      ],
    );
  }
}

// ignore_for_file: prefer_const_constructors
