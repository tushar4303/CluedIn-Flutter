// ignore_for_file: unused_import, unused_element

import 'dart:convert';
import 'dart:math';
import 'package:cluedin_app/widgets/connectivityTest.dart';
import 'package:cluedin_app/widgets/noInternet.dart';
import 'package:cluedin_app/widgets/offline.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cluedin_app/models/home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:retry/retry.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import '../notificationService/local_notification_service.dart';
import '../widgets/homescreen/carouselCard.dart';
import '../widgets/homescreen/chapterCard.dart';
import '../widgets/homescreen/titleBar.dart';
import '../widgets/homescreen/utilityBar.dart';
import 'login_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  int currentPage = 0;
  late PageController _pageController;
  late CarouselModel carousel;

  late Future<HomeModel?> myfuture;
  final url = "http://128.199.23.207:5000/api/app/homeapi";

  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, focusedDay) {
    setState(() {
      today = day;
    });
  }

  Future<HomeModel> loadHomePageData() async {
    const r = RetryOptions(maxAttempts: 3);
    var token = Hive.box('userBox').get("token");

    // var headers = {'authorization': token};

    final response = await r.retry(
      // Make a GET request
      () => http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 2)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    try {
      if (response.statusCode == 200) {
        final HomePageJson = response.body;
        final decodedData = jsonDecode(HomePageJson);

        // Load student chapters
        final List<dynamic> slidesList = decodedData["featured_carousel"];
        final carouselSlides =
            slidesList.map((slide) => CarouselSlide.fromJson(slide)).toList();
        carousel = CarouselModel(slides: carouselSlides);
        print(carousel.slides.length);

        final studentChaptersJson = decodedData["student_chapters"];
        final studentChapters = List.from(studentChaptersJson)
            .map<StudentChapters>((chapter) => StudentChapters.fromMap(chapter))
            .toList();
        studentChapters.shuffle(Random());
        // print(studentChapters.length);

        // Load carousel

        final homeModel = HomeModel(
          studentChapters: studentChapters,
          carousel: carousel,
        );

        return homeModel;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        var errorJson = json.decode(response.body);
        var error = '';
        if (errorJson['msg'] != null && errorJson['msg'].isNotEmpty) {
          error = errorJson['msg'];
          NavbarNotifier.hideBottomNavBar = true;
          // ignore: use_build_context_synchronously
          // Navigator.of(context, rootNavigator: true).pop();
          // ignore: use_build_context_synchronously
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (c) => const LoginPage()),
              (r) => false);
          final box = await Hive.openBox("UserBox");
          await box.clear();
        }
        Fluttertoast.showToast(
          msg: error,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } else {
        final error = response.body;
        final decodedData = jsonDecode(error);
        // print(decodedData);
        var message = decodedData["msg"];
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
        );
      }
    } catch (e) {
      throw Exception(e.toString());
    }

    throw Exception('Failed to load home page data');
  }

  final localNotificationService = LocalNotificationService();
  late ConnectivityHelper connectivityHelper;

  @override
  void initState() {
    super.initState();
    connectivityHelper = ConnectivityHelper(
      onConnectivityChanged: (bool isConnected) {
        setState(() {
          isOffline = !isConnected;
        });
        if (isConnected) {
          // If connected, reload data
          setState(() {
            myfuture = loadHomePageData();
          });
        }
      },
    );
    connectivityHelper.initConnectivityListener();
    myfuture = loadHomePageData();
    _pageController = PageController(initialPage: 0);
    Timer.periodic(const Duration(seconds: 4), (Timer timer) {
      if (_pageController.page == carousel.slides.length - 1) {
        // _pageController.jumpToPage(0);
        _pageController.animateToPage(0,
            duration: const Duration(milliseconds: 800), curve: Curves.ease);
      } else {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('Received message in foreground: $message');
        localNotificationService.createanddisplaynotification(context, message);
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          if (message.notification != null) {
            print('idhar: click hua idhar');
            // Notifications notification = Notifications.fromMap(message.data);
            print(message.data);
            // NavbarNotifier.index = 1;

            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (BuildContext context) => const NotificationPage(),
            //   ),
            // );
          }
        });
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('idhar: click hua');
        // Notifications notification = Notifications.fromMap(message.data);
        var screen = message.data;
        print(screen);

        NavbarNotifier.index = 1;

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (BuildContext context) => const NotificationPage(),
        //   ),
        // );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

  bool isOffline = false;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: MediaQuery.of(context).size.height * 0.076,
        title: Transform(
          transform: Matrix4.translationValues(8.0, 3.0, 0),
          child: const Text(
            "Home",
            textAlign: TextAlign.left,
            textScaleFactor: 1.3,
            style: TextStyle(color: Color.fromARGB(255, 30, 29, 29)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 56),
          child: Column(
            children: <Widget>[
              Container(
                child: errmsg(
                  "No Internet Connection Available",
                  isOffline,
                ),
                // Show internet connection message on isOffline = true.
              ),
              FutureBuilder(
                future: myfuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.20,
                            width: double.infinity,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Stack(
                                alignment: Alignment.center,
                                children: <Widget>[
                                  PageView.builder(
                                    controller: _pageController,
                                    itemCount: carousel.slides.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return CarouselCard(
                                        slide: carousel.slides[index],
                                      );
                                    },
                                    onPageChanged: (int index) {
                                      setState(() {
                                        currentPage = index;
                                      });
                                    },
                                  ),
                                  Positioned(
                                    bottom: 0.0,
                                    child: updateIndicators(
                                      carousel.slides.length,
                                      currentPage,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const utilityBar(),
                          const titlebar(
                            title: "Student Chapters",
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.225,
                            width: double.infinity,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: PageView.builder(
                                itemBuilder: (context, index) {
                                  return ChapterCard(
                                      chapter: snapshot
                                          .data!.studentChapters![index]);
                                },
                                padEnds: false,
                                itemCount:
                                    snapshot.data!.studentChapters!.length,
                                controller: PageController(
                                    initialPage: 0, viewportFraction: 0.425),
                                onPageChanged: (index) {},
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          const titlebar(title: "What's new?"),
                        ],
                      );
                    }
                    if (snapshot.hasError) {
                      print("Error: ${snapshot.error}");
                      return ErrorView(
                        onRetry: () {
                          setState(() {
                            myfuture = loadHomePageData();
                          });
                        },
                      );
                    }
                  }
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget updateIndicators(int length, int currentPage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          length,
          (index) {
            return Container(
              width: 5.0,
              height: 5.0,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.85), //color of border
                  width: 0.5, //width of border
                ),
                shape: BoxShape.circle,
                color: currentPage == index
                    ? const Color.fromARGB(233, 255, 255, 255)
                    : Colors.grey.withOpacity(0.5),
              ),
            );
          },
        ),
      ),
    );
  }
}
