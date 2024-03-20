// ignore_for_file: unused_import, unused_element

import 'dart:convert';
import 'dart:math';
import 'package:cluedin_app/widgets/connectivityTest.dart';
import 'package:cluedin_app/widgets/ErrorView.dart';
import 'package:cluedin_app/widgets/homescreen/sectionDivider.dart';
import 'package:cluedin_app/widgets/homescreen/videoCard.dart';
import 'package:cluedin_app/widgets/homescreen/youtubeVideoCard.dart';
import 'package:cluedin_app/widgets/networkErrorHandling.dart';
import 'package:cluedin_app/widgets/offline.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:cluedin_app/models/home.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:retry/retry.dart';
import 'package:http/http.dart' as http;
import 'package:upgrader/upgrader.dart';
import 'dart:async';
import 'dart:io';
import '../../notificationService/local_notification_service.dart';
import '../../widgets/homescreen/carouselCard.dart';
import '../../widgets/homescreen/chapterCard.dart';
import '../../widgets/homescreen/titleBar.dart';
import '../../widgets/homescreen/utilityBar.dart';
import '../login_page.dart';
import '../../utils/links.dart';

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
  late String videoLink;

  late Future<HomeModel?> myfuture;

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
        Uri.parse(homeApiUrl),
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
        final studentClubsJson = decodedData["student_clubs"];
        videoLink = decodedData["featured_video"];
        final studentChapters = List.from(studentChaptersJson)
            .map<StudentChapters>((chapter) => StudentChapters.fromMap(chapter))
            .toList();
        final studentClubs = List.from(studentClubsJson)
            .map<StudentClubs>((chapter) => StudentClubs.fromMap(chapter))
            .toList();
        studentChapters.shuffle(Random());
        studentClubs.shuffle(Random());
        // print(studentChapters.length);

        // Load carousel

        final homeModel = HomeModel(
          studentChapters: studentChapters,
          studentClubs: studentClubs,
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
    requestingNotificationPermission();
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

            print(message.data);
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
      print("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("User granted provisional authorization");
    } else {
      print("User declined or has not accepted permission");

      // Show a dialog or snackbar to inform the user about missing important updates
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Notification Permission Required'),
            content: const Text(
                'Allowing notifications ensures you receive important updates and information. Would you like to enable notifications?'),
            actions: <Widget>[
              TextButton(
                child: const Text('No, Thanks'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: const Text('Enable Notifications'),
                onPressed: () {
                  // Open app settings to allow the user to enable notifications manually
                  openAppSettings();
                },
              ),
            ],
          );
        },
      );
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
        toolbarHeight: MediaQuery.of(context).size.height * 0.076,
        title: Transform(
          transform: Matrix4.translationValues(8.0, 3.0, 0),
          child: const Text(
            "Home",
            textAlign: TextAlign.left,
            textScaler: TextScaler.linear(1.3),
            style: TextStyle(color: Color.fromARGB(255, 30, 29, 29)),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            myfuture = loadHomePageData();
          });
        },
        child: SingleChildScrollView(
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
                              height: MediaQuery.of(context).size.height * 0.22,
                              width: double.infinity,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
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
                            const Padding(
                                padding: EdgeInsets.only(top: 16),
                                child: SectionDivider(text: 'EXPLORE')),
                            DefaultTabController(
                              length: 2, // Number of tabs
                              child: Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 16),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: TabBar(
                                        padding: EdgeInsets.only(left: 32),
                                        splashFactory: NoSplash.splashFactory,
                                        isScrollable: true,
                                        tabAlignment: TabAlignment.start,
                                        indicator: null,
                                        tabs: [
                                          Tab(
                                            text: 'Chapters',
                                          ),
                                          Tab(
                                            text: 'Clubs',
                                          ),
                                        ],
                                        dividerHeight: 0,
                                        indicatorPadding: EdgeInsets.zero,
                                        indicatorColor: Colors.black,
                                        labelColor: Colors
                                            .black, // Text color of the active tab
                                        unselectedLabelColor: Color.fromRGBO(
                                            125,
                                            125,
                                            125,
                                            0.8), // Text color of inactive tabs
                                        labelStyle: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight
                                                .w500), // Style of the active tab text
                                        unselectedLabelStyle: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight
                                                .w500), // Style of inactive tab text
                                        labelPadding:
                                            EdgeInsets.only(right: 16),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.225,
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: TabBarView(
                                        children: [
                                          // Tab 1: Chapters

                                          // Tab 1: Chapters
                                          PageView.builder(
                                            itemBuilder: (context, index) {
                                              return ChapterCard(
                                                chapter: snapshot.data!
                                                    .studentChapters![index],
                                              );
                                            },
                                            padEnds: false,
                                            itemCount: snapshot
                                                .data!.studentChapters!.length,
                                            controller: PageController(
                                              initialPage: 0,
                                              viewportFraction: 0.425,
                                            ),
                                            onPageChanged: (index) {},
                                          ),

                                          // Tab 2: Clubs
                                          PageView.builder(
                                            itemBuilder: (context, index) {
                                              return ChapterCard(
                                                chapter: snapshot
                                                        .data!.studentClubs![
                                                    index], // Assuming studentClubs is a List<StudentChapters>
                                              );
                                            },
                                            padEnds: false,
                                            itemCount: snapshot
                                                .data!.studentClubs!.length,
                                            controller: PageController(
                                              initialPage: 0,
                                              viewportFraction: 0.425,
                                            ),
                                            onPageChanged: (index) {},
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: SectionDivider(text: "WHAT'S NEW?"),
                            ),
                            const SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 24, right: 24, bottom: 56),
                              child: VideoCard(videoUrl: videoLink),
                            ),
                          ],
                        );
                      }
                      if (snapshot.hasError) {
                        return ErrorHandlingWidget(
                          error: snapshot.error,
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
