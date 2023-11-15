import 'dart:async';
import 'dart:io';
import 'package:cluedin_app/models/notification.dart';
import 'package:cluedin_app/widgets/notificationPage/NotificationShimmer.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:cluedin_app/widgets/notificationPage/notificationCard.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:navbar_router/navbar_router.dart';
import 'package:retry/retry.dart';
import '../widgets/offline.dart';
import 'login_page.dart';
import 'package:shimmer/shimmer.dart';

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

  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  final _filters = [];
  final _senders = [];
  final List<Notifications> _filteredNotifications = [];
  late Future<List<Notifications>?> myfuture;

  @override
  void initState() {
    internetconnection = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isoffline = true;
        });
      } else if (result == ConnectivityResult.mobile) {
        setState(() {
          isoffline = false;
        });
      } else if (result == ConnectivityResult.wifi) {
        setState(() {
          isoffline = false;
        });
      }
    });
    super.initState();
    myfuture = loadNotifications();
  }

  Future<List<Notifications>?> loadNotifications() async {
    final uri = Uri.http('cluedin.creast.in:5000', '/api/app/appNotif');
    var userid = Hive.box('userBox').get("userid") as int;
    var token = Hive.box('userBox').get("token");

    const r = RetryOptions(maxAttempts: 3);
    final response = await r.retry(
      () => http.post(uri, headers: {
        'Authorization': 'Bearer $token',
      }, body: {
        'user_id': userid.toString()
      }).timeout(const Duration(seconds: 2)),
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

        setState(() {
          _filters.clear();
          _senders.clear();
          showFrom = false;
          _filteredNotifications.clear();

          _filteredNotifications.addAll(
              filter(NotificationModel.notifications!, _filters, _senders));
        });

        return NotificationModel.notifications;
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        var errorJson = json.decode(response.body);
        var error = '';
        if (errorJson['msg'] != null && errorJson['msg'].isNotEmpty) {
          error = errorJson['msg'];
          NavbarNotifier.hideBottomNavBar = true;
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
    return null;
  }

  void updateFilteredNotifications() {
    setState(() {
      _filteredNotifications.clear();
      _filteredNotifications
          .addAll(filter(NotificationModel.notifications!, _filters, _senders));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: MediaQuery.of(context).size.height * 0.125,
        elevation: 0.3,
        title: Transform(
          transform: Matrix4.translationValues(8.0, 16.0, 0),
          child: Column(
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
                                      showModalBottomSheet(
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
                                          builder: (context, controller) =>
                                              SenderRolesBottomSheet(
                                            senderRoles:
                                                NotificationModel.senderRoles!,
                                            onSendersSelected: (senders) {
                                              setState(() {
                                                _senders.clear();
                                                _senders.addAll(senders);
                                                updateFilteredNotifications();
                                              });
                                            },
                                          ),
                                        ),
                                      );
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
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        selectedColor: const Color.fromARGB(
                                            180, 224, 220, 220),
                                        onSelected: (value) {
                                          setState(() {
                                            if (value) {
                                              _filters.clear();
                                              _filters.add(filterType);
                                            } else {
                                              _filters.removeWhere((name) {
                                                return name == filterType;
                                              });
                                            }

                                            showFrom =
                                                _filters.contains("Academics");

                                            if (showFrom) {
                                              _senders.clear();
                                            }

                                            updateFilteredNotifications();
                                          });
                                        }));
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
          ),
          Expanded(
            child: FutureBuilder(
              future: Future.wait([myfuture, _simulateDelay()]),
              builder: (context, snapshot) {
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
                              notification: _filteredNotifications[index],
                            );
                          },
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.035,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 0),
                          child: SvgPicture.asset(
                            "assets/images/offline.svg",
                            height: MediaQuery.of(context).size.height * 0.45,
                          ),
                        ),
                        const Text(
                          'Well, this is awkward!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 30, 29, 29),
                          ),
                        ),
                        const Text(
                          'We don\'t seem to be connected...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 30, 29, 29),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              visualDensity: VisualDensity.comfortable,
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black),
                            ),
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

                // If the data is still loading or no data has been retrieved yet, display shimmer effect
                return Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: ListView.builder(
                    itemCount:
                        10, // You can adjust this number based on your design
                    itemBuilder: (context, index) {
                      return ListTileShimmer(); // Create a ListTileShimmer widget for shimmer effect
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Extracted widget for the bottom sheet content
class SenderRolesBottomSheet extends StatefulWidget {
  final List<String> senderRoles;
  final Function(List<String>) onSendersSelected;

  SenderRolesBottomSheet({
    required this.senderRoles,
    required this.onSendersSelected,
  });

  @override
  _SenderRolesBottomSheetState createState() => _SenderRolesBottomSheetState();
}

class _SenderRolesBottomSheetState extends State<SenderRolesBottomSheet> {
  List<String> selectedSenders = [];

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.white, // Change the background color as needed
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              width: 40.0,
              height: 5.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.senderRoles.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    children: [
                      ListTile(
                        visualDensity: const VisualDensity(vertical: -2.5),
                        title: Text(widget.senderRoles[index]),
                        selected:
                            selectedSenders.contains(widget.senderRoles[index]),
                        selectedColor: Colors.blueAccent,
                        onTap: () {
                          setState(() {
                            if (!selectedSenders
                                .contains(widget.senderRoles[index])) {
                              selectedSenders.add(widget.senderRoles[index]);
                            } else {
                              selectedSenders.removeWhere((name) {
                                return name == widget.senderRoles[index];
                              });
                            }
                            widget.onSendersSelected(selectedSenders);
                          });
                        },
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Colors.grey.withOpacity(0.3),
                      )
                    ],
                  );
                },
              ),
            ),
          ],
        ));
  }
}
