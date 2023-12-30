// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, unnecessary_null_comparison

import 'dart:async';
import 'dart:io';
import 'package:cluedin_app/models/events.dart';
import 'package:cluedin_app/widgets/connectivityTest.dart';
import 'package:cluedin_app/widgets/ErrorView.dart';
import 'package:cluedin_app/widgets/networkErrorHandling.dart';
import 'package:cluedin_app/widgets/noResultsFound.dart';
import 'package:cluedin_app/widgets/notificationPage/EventShimmer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:navbar_router/navbar_router.dart';
import 'package:retry/retry.dart';
import '../../widgets/explorePage/eventsCard.dart';
import '../../widgets/offline.dart';
import '../login_page.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({super.key});

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  List<Events> filter(List<Events> events, laBels, senders) {
    if (!_filters.contains("Technical")) {
      _senders.clear();
    }
    return events
        .where((event) =>
            (laBels.isEmpty || laBels.contains(event.eventLabel)) &&
            (senders.isEmpty || senders.contains(event.organizedBy)) &&
            (_startDate == null || event.dateOfcreation.isAfter(_startDate!)) &&
            (_endDate == null || event.dateOfcreation.isBefore(_endDate!)))
        .toList();
  }

  StreamSubscription? internetconnection;
  bool isoffline = false;
  bool showFrom = false;
  //set variable for Connectivity subscription listiner

  final url = "http://128.199.23.207:5000/api/app/appEvent";
  // final url =
  //     "https://gist.githubusercontent.com/tushar4303/675432e0e112e258c971986dbca37156/raw/9352579f1a97a046a7a9917b2e9a596f4ddc4ee0/events.json";
  final _filters = [];
  final _senders = [];
  final List<Events> _filteredEvents = [];
  late Future<List<Events>?> myfuture;
  late ConnectivityHelper connectivityHelper;

  @override
  void initState() {
    connectivityHelper = ConnectivityHelper(
      onConnectivityChanged: (bool isConnected) {
        setState(() {
          isoffline = !isConnected;
        });
        if (isConnected) {
          // If connected, reload data
          setState(() {
            myfuture = loadEvents();
          });
        }
      },
    );
    connectivityHelper.initConnectivityListener();
    super.initState();
    myfuture = loadEvents();
  }

  DateTime? _startDate;
  DateTime? _endDate;

  void clearDateRange() {
    setState(() {
      _startDate = null;
      _endDate = null;
      updateFilteredEvents();
    });
  }

  Future<List<Events>?> loadEvents() async {
    var token = Hive.box('userBox').get("token");
    const r = RetryOptions(maxAttempts: 3);
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
        final EventsJson = response.body;
        final decodedData = jsonDecode(EventsJson);
        // print(decodedData);
        var eventsData = decodedData["events"];
        print(eventsData);
        var labelsData = decodedData["labels"];
        var organizersData = decodedData["organizers"];

        EventModel.labels = List.from(labelsData);
        EventModel.organizers = List.from(organizersData);

        EventModel.events = List.from(eventsData)
            .map<Events>((event) => Events.fromMap(event))
            .toList();

        print(EventModel.events);

        setState(() {
          _filters.clear();
          _senders.clear();
          showFrom = false;
          _filteredEvents.clear();

          _filteredEvents
              .addAll(filter(EventModel.events!, _filters, _senders));
        });

        return EventModel.events;
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
    return null;
  }

  void updateFilteredEvents() {
    setState(() {
      _filteredEvents.clear();
      _filteredEvents.addAll(filter(EventModel.events!, _filters, _senders));
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Events",
                    textAlign: TextAlign.left,
                    textScaler: TextScaler.linear(1.3),
                    style: TextStyle(color: Color.fromARGB(255, 30, 29, 29)),
                  ),
                  Transform.translate(
                    offset: const Offset(0.0, -4.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(233, 228, 230, 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        visualDensity: VisualDensity.comfortable,
                        icon: const Icon(
                          Icons.mark_unread_chat_alt_rounded,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            // Toggle the state when the icon button is tapped

                            // Filter notifications based on 'showUnread' state
                            updateFilteredEvents();
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
              (EventModel.labels != null && EventModel.labels!.isNotEmpty)
                  ? SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Use DateTime.now() for both start and end dates
                                setState(() {
                                  _startDate = DateTime.now();
                                  _endDate = DateTime.now();
                                  updateFilteredEvents();
                                });
                              },
                              onDoubleTap: () {
                                // Handle double tap to automatically choose today's date
                                setState(() {
                                  _startDate = DateTime.now()
                                      .subtract(const Duration(days: 1));
                                  _endDate = DateTime.now();
                                  updateFilteredEvents();
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
                                              updateFilteredEvents();
                                            });
                                          }
                                        },
                                      ),
                                    ),
                            ),
                            const SizedBox(
                              width: 8,
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
                                            senderRoles: EventModel.organizers!,
                                            onSendersSelected: (senders) {
                                              setState(() {
                                                _senders.clear();
                                                _senders.addAll(senders);
                                                updateFilteredEvents();
                                              });
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                    label: const Text("From"),
                                    avatar: const Icon(
                                      Icons.auto_awesome,
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
                              children: (EventModel.labels!.map((filterType) {
                                return Transform(
                                    transform: Matrix4.identity()..scale(0.85),
                                    child: FilterChip(
                                        checkmarkColor: Colors.black,
                                        label: Text(
                                          filterType,
                                          textScaler:
                                              const TextScaler.linear(1.1),
                                        ),
                                        // labelPadding: EdgeInsets.symmetric(
                                        //     horizontal: 4, vertical: 0),
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
                                                _filters.contains("Technical");

                                            _filteredEvents.clear();
                                            _filteredEvents.addAll(filter(
                                                EventModel.events!,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: FutureBuilder(
                  future: Future.delayed(
                      const Duration(seconds: 1), () => myfuture),
                  builder: (context, snapshot) {
                    if (isoffline) {
                      return ErrorView(
                        onRetry: () {
                          setState(() {
                            myfuture = loadEvents();
                          });
                        },
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        if (_filteredEvents.isEmpty) {
                          return NoResultsFound(
                            onResetFiltersPressed: () {
                              // Handle resetting filters
                              setState(() {
                                _filters.clear();
                                _senders.clear();
                                showFrom = false;
                                _startDate = null;
                                _endDate = null;
                                _filteredEvents.clear();
                                myfuture = loadEvents();
                              });
                            },
                          );
                        }
                        return RefreshIndicator(
                          onRefresh: () async {
                            loadEvents();
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 72, top: 4),
                            child: GridView.builder(
                              itemCount: _filteredEvents.length,
                              itemBuilder: (context, index) {
                                return EventsWidget(
                                  event: _filteredEvents[index],
                                );
                              },
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 16.0,
                                mainAxisSpacing: 0,
                                mainAxisExtent: 310.0,
                              ),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return ErrorHandlingWidget(
                          error: snapshot.error,
                          onRetry: () {
                            setState(() {
                              myfuture = loadEvents();
                            });
                          },
                        );
                      }
                    }
                    // Show shimmer while waiting for data
                    return GridView.builder(
                      itemCount:
                          6, // Number of shimmer widgets you want to show
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 0,
                        mainAxisExtent: 310.0,
                      ),
                      itemBuilder: (context, index) {
                        return const EventWidgetShimmer();
                      },
                    );
                  },
                )),
          ),
        ],
      ),
      // ignore: prefer_const_literals_to_create_immutables
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
