// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'dart:async';
import 'dart:io';
import 'package:cluedin_app/widgets/connectivityTest.dart';
import 'package:cluedin_app/widgets/ErrorView.dart';
import 'package:cluedin_app/models/notification.dart';
import 'package:cluedin_app/widgets/networkErrorHandling.dart';
import 'package:cluedin_app/widgets/noResultsFound.dart';
import 'package:cluedin_app/widgets/notificationPage/NotificationShimmer.dart';
import 'package:flutter/material.dart';
import 'package:cluedin_app/widgets/notificationPage/notificationCard.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:navbar_router/navbar_router.dart';
import 'package:retry/retry.dart';
import '../../widgets/offline.dart';
import '../login_page.dart';
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
            (senders.isEmpty || senders.contains(notification.senderRole)) &&
            (_startDate == null ||
                notification.dateOfcreation.isAfter(_startDate!)) &&
            (_endDate == null ||
                notification.dateOfcreation.isBefore(_endDate!)) &&
            (!showUnread ||
                notification.isRead ==
                    0)) // Added condition for filtering unread notifications
        .toList();
  }

  StreamSubscription? internetconnection;
  bool isoffline = false;
  bool showFrom = false;

  late ConnectivityHelper connectivityHelper;

  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  DateTime? _startDate;
  DateTime? _endDate;
  bool showUnread = false;

  final _filters = [];
  final _senders = [];
  final List<Notifications> _filteredNotifications = [];
  late Future<List<Notifications>?> myfuture;

  @override
  void initState() {
    super.initState();
    connectivityHelper = ConnectivityHelper(
      onConnectivityChanged: (bool isConnected) {
        setState(() {
          isoffline = !isConnected;
        });
        if (isConnected) {
          // If connected, reload data
          setState(() {
            myfuture = loadNotifications();
          });
        }
      },
    );
    connectivityHelper.initConnectivityListener();
    myfuture = loadNotifications();
  }

  void clearDateRange() {
    setState(() {
      _startDate = null;
      _endDate = null;
      updateFilteredNotifications();
    });
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        automaticallyImplyLeading: false,
        toolbarHeight: MediaQuery.of(context).size.height * 0.125,
        elevation: 0.3,
        title: Transform(
          transform: Matrix4.translationValues(8.0, 16.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Notifications",
                    textAlign: TextAlign.left,
                    textScaler: TextScaler.linear(1.3),
                    style: TextStyle(color: Color.fromARGB(255, 30, 29, 29)),
                  ),
                  Transform.translate(
                    offset: const Offset(0.0, -4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: showUnread
                            ? const Color.fromRGBO(233, 228, 230, 0.8)
                            : null,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        visualDensity: VisualDensity.comfortable,
                        icon: Icon(
                          showUnread
                              ? Icons.mark_unread_chat_alt_rounded
                              : Icons.mark_unread_chat_alt_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            // Toggle the state when the icon button is tapped
                            showUnread = !showUnread;
                            // Filter notifications based on 'showUnread' state
                            updateFilteredNotifications();
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
              (NotificationModel.labels != null &&
                      NotificationModel.labels!.isNotEmpty)
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16, left: 0),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Use DateTime.now() for both start and end dates
                                setState(() {
                                  _startDate = DateTime.now();
                                  _endDate = DateTime.now();
                                  updateFilteredNotifications();
                                });
                              },
                              onDoubleTap: () {
                                // Handle double tap to automatically choose today's date
                                setState(() {
                                  _startDate = DateTime.now()
                                      .subtract(const Duration(days: 1));
                                  _endDate = DateTime.now();
                                  updateFilteredNotifications();
                                });
                              },
                              onLongPress: () {
                                // Handle long press to clear the date range
                                clearDateRange();
                              },
                              child: _startDate != null && _endDate != null
                                  ? Transform.translate(
                                      offset: const Offset(0.0, -4.0),
                                      child: ActionChip(
                                        visualDensity:
                                            const VisualDensity(vertical: -1.5),
                                        side: const BorderSide(
                                            width: 1,
                                            color:
                                                Color.fromARGB(66, 75, 74, 74)),
                                        shape: const StadiumBorder(),
                                        avatar: const Icon(
                                          Icons.event_busy,
                                          color: Colors.black,
                                        ),
                                        label: const Text('Date'),
                                        onPressed: () {
                                          // Handle clear date range
                                          clearDateRange();
                                        },
                                      ),
                                    )
                                  : Transform.translate(
                                      offset: const Offset(0.0, -4.0),
                                      child: ActionChip(
                                        visualDensity:
                                            const VisualDensity(vertical: -1.5),
                                        side: const BorderSide(
                                            width: 1,
                                            color:
                                                Color.fromARGB(66, 75, 74, 74)),
                                        shape: const StadiumBorder(),
                                        avatar: const Icon(
                                          Icons.calendar_today,
                                          color: Colors.black,
                                        ),
                                        label: const Text('Date'),
                                        onPressed: () async {
                                          final picked =
                                              await showDateRangePicker(
                                            context: context,
                                            firstDate: DateTime(2022),
                                            lastDate: DateTime(2030),
                                            initialDateRange:
                                                _startDate != null &&
                                                        _endDate != null
                                                    ? DateTimeRange(
                                                        start: _startDate!,
                                                        end: _endDate!)
                                                    : null,
                                          );

                                          if (picked != null &&
                                              picked.start != null &&
                                              picked.end != null) {
                                            setState(() {
                                              _startDate = picked.start;
                                              _endDate = picked.end;
                                              updateFilteredNotifications();
                                            });
                                          }
                                        },
                                      ),
                                    ),
                            ),
                            const SizedBox(
                              width: 14,
                            ),
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
                                          textScaler:
                                              const TextScaler.linear(1.1),
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
          ),
          Expanded(
            child: FutureBuilder(
              future: Future.wait([myfuture, _simulateDelay()]),
              builder: (context, snapshot) {
                if (isoffline) {
                  return ErrorView(
                    onRetry: () {
                      setState(() {
                        myfuture = loadNotifications();
                      });
                    },
                  );
                }
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    if (_filteredNotifications.isEmpty) {
                      return NoResultsFound(
                        onResetFiltersPressed: () {
                          // Handle resetting filters
                          setState(() {
                            _filters.clear();
                            _senders.clear();
                            showFrom = false;
                            _startDate = null;
                            _endDate = null;
                            _filteredNotifications.clear();
                            myfuture = loadNotifications();
                          });
                        },
                      );
                    }

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
                    return ErrorHandlingWidget(
                      error: snapshot.error,
                      onRetry: () {
                        setState(() {
                          myfuture = loadNotifications();
                        });
                      },
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
                      return const ListTileShimmer(); // Create a ListTileShimmer widget for shimmer effect
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

  const SenderRolesBottomSheet({
    super.key,
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
        decoration: const BoxDecoration(
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
