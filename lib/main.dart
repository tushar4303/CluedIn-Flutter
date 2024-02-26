// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: camel_case_types
import 'package:cluedin_app/screens/resetPasswordScreen.dart';
import 'package:cluedin_app/screens/signUpPasswordScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:async';
import 'package:calendar_view/calendar_view.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:cluedin_app/screens/Events/Explore.dart';
import 'package:cluedin_app/screens/HomeScreen/homescreen.dart';
import 'package:cluedin_app/screens/login_page.dart';
import 'package:cluedin_app/screens/Notifications/notification_page.dart';
import 'package:cluedin_app/screens/Profile/profile.dart';
import 'package:cluedin_app/widgets/themes.dart';
import 'package:uni_links/uni_links.dart';
import 'firebase_options.dart';
import 'utils/globals.dart';

Future<void> backgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    // Show a notification and handle tap events
    print("handling a background notification");
  }
}

// FlutterLocalNotificationsPlugin notificationsPlugin =
//     FlutterLocalNotificationsPlugin();
// Define a global key for the navigator
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "CluedIn",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox('userBox');

  bool isLoggedIn =
      await Hive.box('userBox').get('isLoggedIn', defaultValue: false);

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  initUniLinks();
  runApp(myApp(isLoggedIn: isLoggedIn));
}

void initUniLinks() async {
  // Handle initial URI when the app launches
  try {
    Uri? initialUri = await getInitialUri();
    if (initialUri != null) {
      handleDeepLink(initialUri);
    }
  } on PlatformException {
    // Handle exception if getInitialUri() fails
  }

  // Listen for URI links when the app is already running
  uriLinkStream.listen((Uri? uri) {
    if (uri != null) {
      handleDeepLink(uri);
    }
  });
}

void handleDeepLink(Uri uri) {
  if (uri.pathSegments.length >= 3 &&
      uri.pathSegments[0] == 'api' &&
      uri.pathSegments[1] == 'app') {
    if (uri.pathSegments[2] == 'request-signup' &&
        uri.pathSegments.length >= 4) {
      // Reset password link
      String userIdString = uri.pathSegments[3];
      int? userId = int.tryParse(userIdString); // Convert to number

      String token = uri.pathSegments.length >= 5 ? uri.pathSegments[4] : '';

      if (userId != null) {
        navigateToSignUpPasswordScreen(userId, token);
      } else {
        print('Invalid user ID format');
      }
    } else if (uri.pathSegments[2] == 'request-reset-password' &&
        uri.pathSegments.length >= 4) {
      // Sign-up password link
      String userIdString = uri.pathSegments[3];
      int? userId = int.tryParse(userIdString); // Convert to number

      String token = uri.pathSegments.length >= 5 ? uri.pathSegments[4] : '';

      if (userId != null) {
        navigateToResetPasswordScreen(userId, token);
      } else {
        print('Invalid user ID format');
      }
    } else {
      print('Unknown deep link type');
    }
  } else {
    print('Invalid deep link format');
  }
}

void navigateToResetPasswordScreen(int userId, String token) {
  navigatorKey.currentState?.push(
    CupertinoPageRoute(
      builder: (context) => ResetPasswordPage(
        userId: userId,
        token: token,
      ),
    ),
  );

  print(token);
  print("Navigating to ResetPasswordPage");
  print(userId);
}

void navigateToSignUpPasswordScreen(int userId, String token) {
  navigatorKey.currentState?.push(
    CupertinoPageRoute(
      builder: (context) => SignUpPasswordPage(
        userId: userId,
        token: token,
      ),
    ),
  );

  print(token);
  print("Navigating to SignUpPasswordPage");
  print(userId);
}

class myApp extends StatelessWidget {
  final bool isLoggedIn;
  const myApp({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
      controller: EventController(),
      child: MaterialApp(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: snackbarKey,
        themeMode: ThemeMode.light,
        debugShowCheckedModeBanner: false,
        theme: MyTheme.lightTheme(context),
        darkTheme: MyTheme.darkTheme(context),
        home: isLoggedIn ? HomePage() : LoginPage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  // List<NavbarItem> items = [
  //   NavbarItem(
  //     Icons.home_outlined, 'Home',
  //     // backgroundColor: mediumPurple,
  //   ),
  //   NavbarItem(
  //     Icons.notifications_none_outlined, 'Notifications',
  //     // backgroundColor: mediumPurple,
  //   ),
  //   NavbarItem(
  //     Icons.explore_outlined, 'Explore',
  //     // backgroundColor: Colors.orange,
  //   ),
  //   NavbarItem(
  //     Icons.person_outline, 'Profile',
  //     // backgroundColor: Colors.teal,
  //   ),
  // ];

  List<NavbarItem> items = [
    NavbarItem(Icons.home_outlined, 'Home',
        // backgroundColor: mediumPurple,
        selectedIcon: Icon(
          Icons.home,
          size: 26,
        )),
    NavbarItem(Icons.notifications_none_outlined, 'Notifications',
        // backgroundColor: mediumPurple,
        selectedIcon: Icon(
          Icons.notifications,
          size: 26,
        )),
    NavbarItem(Icons.explore_outlined, 'Explore',
        // backgroundColor: Colors.orange,
        selectedIcon: Icon(
          Icons.explore,
          size: 26,
        )),
    NavbarItem(Icons.person_outline, 'Profile',
        // backgroundColor: Colors.teal,
        selectedIcon: Icon(
          Icons.person,
          size: 26,
        )),
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

  DateTime oldTime = DateTime.now();
  DateTime newTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return NavbarRouter(
      // type: NavbarType.material3,
      // destinationAnimationCurve: Curves.fastOutSlowIn,
      // destinationAnimationDuration: 300,
      errorBuilder: (context) {
        return Text('Error 404');
      },
      onBackButtonPressed: (isExitingApp) {
        if (isExitingApp) {
          newTime = DateTime.now();
          // time difference between consecutive taps
          int difference = newTime.difference(oldTime).inMilliseconds;
          oldTime = newTime;
          if (difference < 1000) {
            NavbarNotifier.hideSnackBar(context);
            return isExitingApp;
          } else {
            final state = Scaffold.of(context);
            NavbarNotifier.showSnackBar(
              context,
              "Tap back button again to exit",
              bottom: state.hasFloatingActionButton ? 0 : kNavbarHeight,
            );
            return false;
          }
        } else {
          return isExitingApp;
        }
      },
      decoration: NavbarDecoration(
          borderRadius: BorderRadius.circular(16),
          // indicatorColor: Color.fromRGBO(138, 138, 138, 0.3),
          showSelectedLabels: false,
          isExtended: true,
          showUnselectedLabels: false,
          // height: 72,
          backgroundColor: const Color.fromRGBO(251, 251, 252, 1),
          selectedIconTheme: const IconThemeData(color: Colors.black),
          unselectedIconTheme:
              const IconThemeData(color: Color.fromRGBO(138, 138, 138, 1)),
          navbarType: BottomNavigationBarType.fixed,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          // elevation: 18,
          // selectedLabelTextStyle: const TextStyle(color: Colors.black),
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
            // initialRoute: _routes[i]!.keys.first,
          ),
      ],
    );
  }
}


  

// ignore_for_file: prefer_const_constructors
