import 'dart:async';
import 'dart:io';
import 'package:cluedin_app/models/notification.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:cluedin_app/widgets/notificationCard.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  List<Notifications> filter(
      List<Notifications> notifications, laBels, senders) {
    if (!_filters.contains("Academics")) {
      _senders.clear();
    }
    return notifications
        .where((notification) =>
            (laBels.isEmpty ||
                laBels.contains(notification.notificationLabel)) &&
            (senders.isEmpty || senders.contains(notification.senderRole)))
        .toList();
  }

  StreamSubscription? internetconnection;
  bool isoffline = false;
  bool showFrom = false;
  //set variable for Connectivity subscription listiner

  final _filters = [];
  final _senders = [];
  final List<Notifications> _filteredNotifications = [];
  late Future<List<Notifications>?> myfuture;

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
    myfuture = loadNotifications();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Notifications>?> loadNotifications() async {
    final uri = Uri.http('cluedin.creast.in:5000', '/api/app/appNotif');
    var userid = Hive.box('userBox').get("userid") as int;

    const r = RetryOptions(maxAttempts: 3);
    final response = await r.retry(
      () => http.post(uri, body: {'user_id': userid.toString()}).timeout(
          const Duration(seconds: 2)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    try {
      if (response.statusCode == 200) {
        final NotificationsJson = response.body;

        final decodedData = jsonDecode(NotificationsJson);
        var notificationsData = decodedData["notifications"];
        var labelsData = decodedData["labels"];
        var senderRolesData = decodedData["senderRoles"];

        NotificationModel.labels = List.from(labelsData);
        NotificationModel.senderRoles = List.from(senderRolesData);

        NotificationModel.notifications = List.from(notificationsData)
            .map<Notifications>(
                (notification) => Notifications.fromMap(notification))
            .toList();

        print(NotificationModel.notifications);

        setState(() {
          _filters.clear();
          _senders.clear();
          showFrom = false;
          _filteredNotifications.clear();

          _filteredNotifications.addAll(
              filter(NotificationModel.notifications!, _filters, _senders));
        });

        return NotificationModel.notifications;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
              const Text(
                "Notifications",
                textAlign: TextAlign.left,
                textScaleFactor: 1.3,
                style: TextStyle(color: Color.fromARGB(255, 30, 29, 29)),
              ),
              const SizedBox(
                height: 4,
              ),
              (NotificationModel.labels != null &&
                      NotificationModel.labels!.isNotEmpty)
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Transform(
                              transform: Matrix4.translationValues(0, -4, 0),
                              child: Visibility(
                                visible: showFrom,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: ActionChip(
                                    onPressed: () async {
                                      await showModalBottomSheet(
                                          isScrollControlled: true,
                                          isDismissible: true,
                                          useRootNavigator: true,
                                          backgroundColor: Colors.transparent,
                                          context: context,
                                          builder: (context) =>
                                              DraggableScrollableSheet(
                                                  expand: false,
                                                  key: UniqueKey(),
                                                  initialChildSize: 0.4,
                                                  maxChildSize: 0.6,
                                                  builder:
                                                      (context, controller) =>
                                                          Container(
                                                            decoration: const BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                borderRadius: BorderRadius.only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            20.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            20.0))),
                                                            child: Column(
                                                              children: [
                                                                Container(
                                                                  margin: const EdgeInsets
                                                                          .only(
                                                                      top: 8,
                                                                      bottom:
                                                                          8),
                                                                  width: 40.0,
                                                                  height: 5.0,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10.0),
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: ListView
                                                                      .builder(
                                                                    itemCount: NotificationModel
                                                                        .senderRoles!
                                                                        .length,
                                                                    controller:
                                                                        controller,
                                                                    itemBuilder:
                                                                        (BuildContext
                                                                                context,
                                                                            int index) {
                                                                      return Column(
                                                                        children: [
                                                                          ListTile(
                                                                            visualDensity:
                                                                                const VisualDensity(vertical: -2.5),
                                                                            title:
                                                                                Text(NotificationModel.senderRoles![index]),
                                                                            selected:
                                                                                _senders.contains(NotificationModel.senderRoles![index]),
                                                                            selectedColor:
                                                                                Colors.blueAccent,
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                if (!_senders.contains(NotificationModel.senderRoles![index])) {
                                                                                  _senders.add(NotificationModel.senderRoles![index]);
                                                                                } else {
                                                                                  _senders.removeWhere((name) {
                                                                                    return name == NotificationModel.senderRoles![index];
                                                                                  });
                                                                                }
                                                                                _filteredNotifications.clear();
                                                                                _filteredNotifications.addAll(filter(NotificationModel.notifications!, _filters, _senders));
                                                                              });
                                                                            },
                                                                          ),
                                                                          Divider(
                                                                            thickness:
                                                                                0.5,
                                                                            color:
                                                                                Colors.grey.withOpacity(0.3),
                                                                          )
                                                                        ],
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          )));
                                    },
                                    label: const Text("From"),
                                    avatar: const Icon(
                                      Icons.account_circle,
                                      color: Colors.black,
                                    ),
                                    visualDensity:
                                        const VisualDensity(vertical: -1.5),
                                    side: const BorderSide(
                                        width: 1,
                                        color: Color.fromARGB(66, 75, 74, 74)),
                                    // surfaceTintColor: Colors.black,

                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
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
                                        selected: _filters.contains(filterType),
                                        side: const BorderSide(
                                            width: 1,
                                            color:
                                                Color.fromARGB(66, 75, 74, 74)),
                                        // surfaceTintColor: Colors.black,

                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        selectedColor: const Color.fromARGB(
                                            180, 224, 220, 220),
                                        onSelected: ((value) {
                                          setState(() {
                                            if (value) {
                                              _filters.clear();
                                              _filters.add(filterType);
                                            } else {
                                              _filters.removeWhere((name) {
                                                return name == filterType;
                                              });
                                            }
                                            print(_filters);

                                            showFrom =
                                                _filters.contains("Academics");

                                            _filteredNotifications.clear();
                                            _filteredNotifications.addAll(
                                                filter(
                                                    NotificationModel
                                                        .notifications!,
                                                    _filters,
                                                    _senders));
                                          });
                                        })));
                              }).toList()),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Center(
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
                        if (snapshot.hasData) {
                          return RefreshIndicator(
                            onRefresh: () async {
                              loadNotifications();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 54),
                              child: ListView.builder(
                                  itemCount: _filteredNotifications.length,
                                  itemBuilder: (context, index) {
                                    return NotificationWidget(
                                      notification:
                                          _filteredNotifications[index],
                                    );
                                  }),
                            ),
                          );
                        } else if (snapshot.hasError) {
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
                              const Text(
                                'Well this is awkward!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 30, 29, 29)),
                              ),
                              const Text(
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
                                  child: const Text(
                                    "Try again",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      myfuture = loadNotifications();
                                    });
                                  },
                                ),
                              )
                            ],
                          );
                        }
                      }
                      return const Center(
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
