import 'dart:convert';
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

import '../notificationService/local_notification_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String fcmToken = "firebase token";
  int currentPage = 0;
  late Future<List<StudentChapters>?> myfuture;
  final url =
      "https://gist.githubusercontent.com/tushar4303/f7dc4c7e9463f9e93d62da331a71a754/raw/aac4370dc27e48649a87ff3321b5505963414194/homepage.json";

  DateTime today = DateTime.now();

  void _onDaySelected(DateTime day, focusedDay) {
    setState(() {
      today = day;
    });
  }

  Future<List<StudentChapters>?> loadHomePage() async {
    const r = RetryOptions(maxAttempts: 3);
    final response = await r.retry(
      // Make a GET request
      () => http.get(Uri.parse(url)).timeout(const Duration(seconds: 2)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    try {
      if (response.statusCode == 200) {
        final HomePageJson = response.body;

        final decodedData = jsonDecode(HomePageJson);
        var studentChapters = decodedData["student_chapters"];

        HomeModel.studentChapters = List.from(studentChapters)
            .map<StudentChapters>((chapter) => StudentChapters.fromMap(chapter))
            .toList();
        print(HomeModel.studentChapters!.length);

        return HomeModel.studentChapters;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  void initState() {
    print("le token");
    getToken();
    super.initState();
    myfuture = loadHomePage();
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      print(message);
      print("FirebaseMessaging.instance.getInitialMessage");
    });

    // 2. This method only call when App in forground it mean app must be opened
    FirebaseMessaging.onMessage.listen(
      (message) {
        print(message);
        print("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          print(message.data);
          LocalNotificationService.createanddisplaynotification(message);
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => NotificationDetailsPage()));
        }
      },
    );
    // 3. This method only call when App in background and not terminated(not closed)
    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        print("FirebaseMessaging.onMessageOpenedApp.listen");
        if (message.notification != null) {
          print(message.data);
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

  @override
  void dispose() {
    super.dispose();
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
                    PageView.builder(
                      itemBuilder: (context, index) {
                        return CarouselCard(
                          car: cars[index],
                        );
                      },
                      itemCount: cars.length,
                      controller:
                          PageController(initialPage: 0, viewportFraction: 1),
                      onPageChanged: (index) {
                        setState(() {
                          currentPage = index;
                        });
                      },
                    ),
                    Positioned(bottom: 0.0, child: updateIndicators()),
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
                                    chapter: HomeModel.studentChapters![index]);
                              },
                              padEnds: false,
                              itemCount: HomeModel.studentChapters!.length,
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

  Widget updateIndicators() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: cars.map(
          (car) {
            var index = cars.indexOf(car);
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
        ).toList(),
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
      padding: EdgeInsets.only(top: 16, left: 24),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
        color: const Color.fromRGBO(250, 250, 250, 1),
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
                      color: Color.fromARGB(75, 158, 158, 158).withOpacity(0.2),
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
                  Positioned.fill(
                      child: Image.asset(
                    "assets/images/csi.png",
                    fit: BoxFit.cover,
                  )),
                  // CachedNetworkImage(
                  //   imageUrl: chapter.logo,
                  //   placeholder: (context, url) {
                  //     return Image.asset(
                  //       "assets/images/placeholder.png",
                  //       fit: BoxFit.cover,
                  //     );
                  //   },
                  // ),
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
                              Color.fromARGB(179, 179, 178, 178)
                                  .withOpacity(0.25),
                              Color.fromARGB(138, 230, 227, 227)
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
  CarouselCard({super.key, required this.car});

  TeslaCar car;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
      ),
      child: GestureDetector(
        onTap: () {},
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: CachedNetworkImage(
            imageUrl: car.image,
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

class TeslaCar {
  TeslaCar(
      {required this.model, required this.image, required this.description});

  String model;
  String image;
  String description;
}

var cars = [
  TeslaCar(
      model: 'Roadster',
      image:
          'https://www.itcluster.ck.ua/wp-content/uploads/2019/03/661821a9442a8dbd824e89bd18c0fd2e_XL.jpg',
      description:
          'As an all-electric supercar, Roadster maximizes the potential of aerodynamic engineering—with record-setting performance and efficiency.'),
  TeslaCar(
      model: 'Model S',
      image:
          'https://ictframe.com/wp-content/uploads/Digital-Ocean-Summit-Nepal-2020.jpg',
      description:
          "Model S sets an industry standard for performance and safety. Tesla’s all-electric powertrain delivers unparalleled performance in all weather conditions."),
  TeslaCar(
      model: 'Model 3',
      image:
          'https://stuff.co.za/wp-content/uploads/2021/04/ces-2021-anchor-desk3.jpg_ext-scaled.jpg',
      description:
          "Model 3 comes with the option of dual motor all-wheel drive, 20” Performance Wheels and Brakes and lowered suspension for total control, in all weather conditions."),
  TeslaCar(
      model: 'Model X',
      image:
          'https://www.iottechexpo.com/wp-content/uploads/2018/04/IoT-Tech-Expo-1-777x518.jpg',
      description:
          "Tesla’s all-electric powertrain delivers Dual Motor All-Wheel Drive, adaptive air suspension and the quickest acceleration of any SUV on the road—from zero to 60 mph in 2.6 seconds."),
  TeslaCar(
      model: 'Model Y',
      image:
          'https://www.techtalkthai.com/wp-content/uploads/2016/10/google_DevFest-Hackathon-PR.png',
      description:
          "Tesla All-Wheel Drive has two ultra-responsive, independent electric motors that digitally control torque to the front and rear wheels—for far better handling, traction and stability."),
];
