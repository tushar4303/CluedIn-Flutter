import 'dart:convert';
import 'dart:math';
import 'package:cluedin_app/screens/notification_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cluedin_app/models/home.dart';
import 'package:cluedin_app/screens/studentChapterPage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:retry/retry.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:io';
import '../main.dart';
import '../models/notification.dart';
import '../notificationService/local_notification_service.dart';
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
  late final CarouselModel carousel;

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

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          toolbarHeight: MediaQuery.of(context).size.height * 0.076,
          // elevation: 0.3,
          title: Transform(
            transform: Matrix4.translationValues(8.0, 3.0, 0),
            child: const Text(
              "Home",
              textAlign: TextAlign.left,
              textScaleFactor: 1.3,
              style: TextStyle(color: Color.fromARGB(255, 30, 29, 29)),
            ),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 56),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.20,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Stack(alignment: Alignment.center, children: <Widget>[
                    FutureBuilder(
                      future: myfuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            final carousel = snapshot.data!.carousel;

                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                PageView.builder(
                                  controller: _pageController,
                                  itemCount: carousel!.slides.length,
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
                            );
                          } else if (snapshot.hasError) {
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Error: ${snapshot.error.toString()}",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
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
                  ]),
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: FutureBuilder(
                      future: myfuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return PageView.builder(
                              itemBuilder: (context, index) {
                                return ChapterCard(
                                    chapter:
                                        snapshot.data!.studentChapters![index]);
                              },
                              padEnds: false,
                              itemCount: snapshot.data!.studentChapters!.length,
                              controller: PageController(
                                  initialPage: 0, viewportFraction: 0.425),
                              onPageChanged: (index) {},
                            );
                          } else if (snapshot.hasError) {
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  "Error: ${snapshot.error.toString()}",
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            );
                          }
                        }
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.black,
                          ),
                        );
                      },
                    )),
              ),
              const SizedBox(
                height: 24,
              ),
              const titlebar(title: "What's new?"),
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: TableCalendar(
                  firstDay: DateTime.utc(2010, 10, 16),
                  lastDay: DateTime.utc(2030, 3, 14),
                  focusedDay: today,
                  selectedDayPredicate: (day) => isSameDay(day, today),
                  headerStyle: const HeaderStyle(
                      formatButtonVisible: false, titleCentered: true),
                  onDaySelected: _onDaySelected,
                ),
              ),
              const SizedBox(
                height: 24,
              )
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

class titlebar extends StatelessWidget {
  const titlebar({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 24),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class utilityBar extends StatelessWidget {
  const utilityBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 3,
              offset: const Offset(0.0, 0.75))
        ],
        color: const Color.fromRGBO(251, 251, 252, 1),
        borderRadius: BorderRadius.circular(
          16.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.black12, //color of border
                        width: 0.15, //width of border
                      ),
                      color: const Color.fromRGBO(242, 242, 242, 1)),
                  child: Column(
                    children: [
                      IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.calendar_today),
                        color: Colors.black.withOpacity(0.8),
                        // tooltip: 'Increase volume by 10',
                        onPressed: () async {
                          final url = Uri.parse(
                              'https://drive.google.com/file/d/1ZWAwmTozuTU_Zm3HBZ9jdTse25ryMEIV/view?usp=share_link');
                          if (!await launchUrl(url)) {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  "Timetable",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                )
              ],
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.black12, //color of border
                        width: 0.15, //width of border
                      ),
                      color: const Color.fromRGBO(242, 242, 242, 1)),
                  child: Column(
                    children: [
                      IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.train),
                        color: Colors.black.withOpacity(0.8),
                        // tooltip: 'Increase volume by 10',
                        onPressed: () async {
                          final url = Uri.parse(
                              'https://drive.google.com/file/d/1ZWAwmTozuTU_Zm3HBZ9jdTse25ryMEIV/view?usp=share_link');
                          if (!await launchUrl(url)) {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  "Concession",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                )
              ],
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.black12, //color of border
                        width: 0.15, //width of border
                      ),
                      color: const Color.fromRGBO(242, 242, 242, 1)),
                  child: Column(
                    children: [
                      IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.library_books),
                        color: Colors.black.withOpacity(0.8),
                        // tooltip: 'Increase volume by 10',
                        onPressed: () async {
                          final url = Uri.parse(
                              'https://drive.google.com/file/d/1ZWAwmTozuTU_Zm3HBZ9jdTse25ryMEIV/view?usp=share_link');
                          if (!await launchUrl(url)) {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  "Moodle-Elearn",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                )
              ],
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.black12, //color of border
                        width: 0.15, //width of border
                      ),
                      color: const Color.fromRGBO(242, 242, 242, 1)),
                  child: Column(
                    children: [
                      IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.web),
                        color: Colors.black.withOpacity(0.8),
                        // tooltip: 'Increase volume by 10',
                        onPressed: () async {
                          final url = Uri.parse(
                              'https://drive.google.com/file/d/1ZWAwmTozuTU_Zm3HBZ9jdTse25ryMEIV/view?usp=share_link');
                          if (!await launchUrl(url)) {
                            throw 'Could not launch $url';
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  "Website",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChapterCard extends StatelessWidget {
  ChapterCard({super.key, required this.chapter});

  StudentChapters chapter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StudentChapterPage(
                        chapter: chapter,
                      )));
        },
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: const Color.fromARGB(75, 158, 158, 158)
                          .withOpacity(0.2),
                      blurRadius: 0.65,
                      offset: const Offset(0.25, 0.35))
                ],
                color: const Color.fromRGBO(250, 250, 250, 1),
                borderRadius: BorderRadius.circular(
                  16.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                child: Stack(children: <Widget>[
                  // Positioned.fill(
                  //     child: Image.asset(
                  //   "assets/images/csi.png",
                  //   fit: BoxFit.cover,
                  // )),
                  Positioned.fill(
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: chapter.logo,
                      placeholder: (context, url) {
                        return Image.asset(
                          "assets/images/placeholder.png",
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  Positioned(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 60,
                        // margin: EdgeInsets.only(bottom: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            end: const Alignment(0.0, -1),
                            begin: const Alignment(0.0, 0.9),
                            colors: <Color>[
                              const Color.fromARGB(179, 179, 178, 178)
                                  .withOpacity(0.25),
                              const Color.fromARGB(138, 230, 227, 227)
                                  .withOpacity(0.0)
                            ],
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12, bottom: 8, right: 10),
                            child: Text(
                              textScaleFactor: 0.9,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              chapter.title,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CarouselCard extends StatelessWidget {
  const CarouselCard({Key? key, required this.slide}) : super(key: key);

  final CarouselSlide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
      ),
      child: GestureDetector(
        onTap: () async {
          final url = Uri.parse(slide.redirectUrl);
          if (!await launchUrl(url)) {
            throw 'Could not launch $url';
          }
        },
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: CachedNetworkImage(
            imageUrl: "http://cluedin.creast.in:5000/${slide.photoUrl}",
            fit: BoxFit.cover,
            placeholder: (context, url) {
              return Image.asset(
                "assets/images/placeholder_landscape.png",
                fit: BoxFit.cover,
              );
            },
          ),
        ),
      ),
    );
  }
}
