// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:cluedin_app/models/notification.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:cluedin_app/widgets/item_widget.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import '../widgets/offline.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  StreamSubscription? internetconnection;
  bool isoffline = false;
  //set variable for Connectivity subscription listiner
  final url =
      "https://gist.githubusercontent.com/tushar4303/0ababbdad3073acd8ab2580b5deb084b/raw/ed49b00d346e21c199e896c77186cc636437b4c4/notifications.json";

  final _filters = [];
  final List<Item> _filteredNotifications = [];
  late Future<List<Item>?> myfuture;

  @override
  void initState() {
    internetconnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // whenevery connection status is changed.
      if (result == ConnectivityResult.none) {
        //there is no any connection
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        //connection is mobile data network
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        //connection is from wifi
        setState(() {
          isoffline = false;
        });
      }
    }); // using this listiner, you can get the medium of connection as well.
    super.initState();
    myfuture = loadData();
  }

  Future<List<Item>?> loadData() async {
    final response = await retry(
      // Make a GET request
      () => http.get(Uri.parse(url)).timeout(Duration(seconds: 3)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    print("inside future");
    try {
      if (response.statusCode == 200) {
        final NotificationsJson = response.body;

        final decodedData = jsonDecode(NotificationsJson);
        var notificationsData = decodedData["notifications"];
        var labelsData = decodedData["labels"];
        var senderRolesData = decodedData["senderRoles"];

        NotificationModel.labels = List.from(labelsData);
        NotificationModel.senderRoles = List.from(senderRolesData);

        NotificationModel.items = List.from(notificationsData)
            .map<Item>((item) => Item.fromMap(item))
            .toList();

        setState(() {
          _filteredNotifications.clear();
          _filteredNotifications.addAll(NotificationModel.items!);
        });

        return NotificationModel.items;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: MediaQuery.of(context).size.height * 0.125,
        elevation: 0.3,
        // title: Text("Notifications"),
        title: Transform(
          transform: Matrix4.translationValues(8.0, 16.0, 0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Notifications",
                textAlign: TextAlign.left,
                textScaleFactor: 1.3,
                style: TextStyle(color: Color.fromARGB(255, 30, 29, 29)),
              ),
              SizedBox(
                height: 4,
              ),
              (NotificationModel.labels != null &&
                      NotificationModel.labels!.isNotEmpty)
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Transform(
                              transform: Matrix4.translationValues(0, -4, 0),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: ActionChip(
                                  onPressed: () {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(25.0),
                                          ),
                                        ),
                                        context: context,
                                        builder: (builder) {
                                          return SizedBox(
                                            height: 350.0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft: const Radius
                                                              .circular(20.0),
                                                          topRight: const Radius
                                                              .circular(20.0))),
                                              //content starts
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    right: 5.0,
                                                    left: 5.0,
                                                    top: 10.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    // rounded rectangle grey handle
                                                    Container(
                                                      width: 40.0,
                                                      height: 5.0,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                  },
                                  label: Text("From"),
                                  avatar: Icon(Icons.account_circle),
                                  visualDensity: VisualDensity(vertical: -1.5),
                                  side: BorderSide(
                                      width: 1,
                                      color: Color.fromARGB(66, 75, 74, 74)),
                                  // surfaceTintColor: Colors.black,

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children:
                                  (NotificationModel.labels!.map((filterType) {
                                return Transform(
                                    transform: Matrix4.identity()..scale(0.85),
                                    child: FilterChip(
                                        checkmarkColor: Colors.black,
                                        label: Text(
                                          filterType,
                                          textScaleFactor: 1.1,
                                        ),
                                        // labelPadding: EdgeInsets.symmetric(
                                        //     horizontal: 4, vertical: 0),
                                        selected: _filters.contains(filterType),
                                        side: BorderSide(
                                            width: 1,
                                            color:
                                                Color.fromARGB(66, 75, 74, 74)),
                                        // surfaceTintColor: Colors.black,

                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        selectedColor:
                                            Color.fromARGB(180, 224, 220, 220),
                                        onSelected: ((value) {
                                          setState(() {
                                            if (value) {
                                              _filters.add(filterType);
                                              print(filterType);
                                            } else {
                                              _filters.removeWhere((name) {
                                                return name == filterType;
                                              });
                                            }
                                            _filteredNotifications.clear();
                                            if (_filters.isEmpty) {
                                              _filteredNotifications.addAll(
                                                  NotificationModel.items!);
                                            } else {
                                              _filteredNotifications.addAll(
                                                  NotificationModel.items!.where(
                                                      (notification) => _filters
                                                          .contains(notification
                                                              .messageLabel)));
                                            }
                                          });
                                        })));
                              }).toList()),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(
                      color: Colors.white,
                    )),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            child: errmsg("No Internet Connection Available", isoffline),
            //to show internet connection message on isoffline = true.
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: FutureBuilder(
                    future: myfuture,
                    builder: ((context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return RefreshIndicator(
                            onRefresh: () async {
                              loadData();
                            },
                            child: ListView.builder(
                                itemCount: _filteredNotifications.length,
                                itemBuilder: (context, index) {
                                  return NotificationWidget(
                                    item: _filteredNotifications[index],
                                  );
                                }),
                          );
                        } else if (snapshot.hasData) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.035,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 0),
                                child: SvgPicture.asset(
                                  "assets/images/offline.svg",
                                  height:
                                      MediaQuery.of(context).size.height * 0.45,
                                ),
                              ),
                              Text(
                                'Well this is awkward!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 30, 29, 29)),
                              ),
                              Text(
                                'We dont seem to be connected...',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 30, 29, 29)),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      visualDensity: VisualDensity.comfortable,
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              Colors.black)),
                                  clipBehavior: Clip.hardEdge,
                                  child: Text(
                                    "Try again",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      myfuture = loadData();
                                    });
                                  },
                                ),
                              )
                            ],
                          );
                        }
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      );
                    }))),
          ),
        ],
      ),
      // ignore: prefer_const_literals_to_create_immutables
    );
  }
}



// ignore_for_file: prefer_const_constructors
