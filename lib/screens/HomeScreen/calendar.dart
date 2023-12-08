import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cluedin_app/screens/Events/eventDetailsPage.dart';
import 'package:cluedin_app/widgets/ErrorView.dart';
import 'package:cluedin_app/widgets/connectivityTest.dart';
import 'package:cluedin_app/widgets/networkErrorHandling.dart';
import 'package:cluedin_app/widgets/noResultsFound.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:cluedin_app/models/events.dart';
import 'package:cluedin_app/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:retry/retry.dart';
import 'package:shimmer/shimmer.dart';

class MonthViewWidget extends StatefulWidget {
  const MonthViewWidget({Key? key}) : super(key: key);

  @override
  _MonthViewWidgetState createState() => _MonthViewWidgetState();
}

class _MonthViewWidgetState extends State<MonthViewWidget> {
  late EventController eventController;
  late Future<List<CalendarEventData>?> myfuture;
  final url = "http://128.199.23.207:5000/api/app/appEvent";
  StreamSubscription? internetconnection;
  bool isoffline = false;
  bool showFrom = false;
  late ConnectivityHelper connectivityHelper;
  Future<List<CalendarEventData>> fetchEvents() async {
    var token = Hive.box('userBox').get("token");
    const r = RetryOptions(maxAttempts: 3);

    try {
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

      if (response.statusCode == 200) {
        final eventsJson = response.body;
        final decodedData = jsonDecode(eventsJson);
        var eventsData = decodedData["events"];

        EventModel.labels = List.from(decodedData["labels"]);
        EventModel.organizers = List.from(decodedData["organizers"]);

        EventModel.events = List.from(eventsData)
            .map<Events>((event) => Events.fromMap(event))
            .toList();

        final calendarEvents = EventModel.events?.map((event) {
          return CalendarEventData(
            date: event.dateOfcreation,
            title: event.eventTitle,
            description: event.eventDesc,
            startTime: event.dateOfcreation,
            endDate: event.dateOfexpiration,
            // Add other properties as needed
          );
        }).toList();
        if (calendarEvents != null) {
          eventController.addAll(calendarEvents);
        }

        return calendarEvents ?? [];
      } else {
        throw Exception("Failed to load events");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // Future<List<Events>?> loadEvents() async {
  //   var token = Hive.box('userBox').get("token");
  //   const r = RetryOptions(maxAttempts: 3);
  //   final response = await r.retry(
  //     // Make a GET request
  //     () => http.get(
  //       Uri.parse(url),
  //       headers: {
  //         'Authorization': 'Bearer $token',
  //       },
  //     ).timeout(const Duration(seconds: 2)),
  //     // Retry on SocketException or TimeoutException
  //     retryIf: (e) => e is SocketException || e is TimeoutException,
  //   );
  //   try {
  //     if (response.statusCode == 200) {
  //       final EventsJson = response.body;
  //       final decodedData = jsonDecode(EventsJson);
  //       // print(decodedData);
  //       var eventsData = decodedData["events"];
  //       print(eventsData);
  //       var labelsData = decodedData["labels"];
  //       var organizersData = decodedData["organizers"];

  //       EventModel.labels = List.from(labelsData);
  //       EventModel.organizers = List.from(organizersData);

  //       EventModel.events = List.from(eventsData)
  //           .map<Events>((event) => Events.fromMap(event))
  //           .toList();

  //       print(EventModel.events);

  //       return EventModel.events;
  //     } else if (response.statusCode == 401 || response.statusCode == 403) {
  //       var errorJson = json.decode(response.body);
  //       var error = '';
  //       if (errorJson['msg'] != null && errorJson['msg'].isNotEmpty) {
  //         error = errorJson['msg'];
  //         NavbarNotifier.hideBottomNavBar = true;
  //         Navigator.of(context).pushAndRemoveUntil(
  //             MaterialPageRoute(builder: (c) => const LoginPage()),
  //             (r) => false);
  //         final box = await Hive.openBox("UserBox");
  //         await box.clear();
  //       }
  //       Fluttertoast.showToast(
  //         msg: error,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //       );
  //     } else {
  //       final error = response.body;
  //       final decodedData = jsonDecode(error);
  //       // print(decodedData);
  //       var message = decodedData["msg"];
  //       Fluttertoast.showToast(
  //         msg: message,
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 3,
  //       );
  //     }
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  //   return null;
  // }

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
            myfuture = fetchEvents();
          });
        }
      },
    );
    super.initState();

    eventController = EventController();
    selectedDate = DateTime.now();
    myfuture = fetchEvents();

    // // Add events for the 8th of December 2023
    // final event1 = CalendarEventData(
    //   title: "Event 1",
    //   date: DateTime(2023, 12, 8),
    //   startTime: DateTime(2023, 12, 8, 10, 0),
    //   endTime: DateTime(2023, 12, 8, 12, 0),
    //   event: "Event 1",
    // );

    // final event2 = CalendarEventData(
    //   title: "Colo",
    //   date: DateTime(2023, 12, 8),
    //   startTime: DateTime(2023, 12, 8, 14, 0),
    //   endTime: DateTime(2023, 12, 8, 16, 0),
    //   event: "Colo",
    // );

    // final event3 = CalendarEventData(
    //   title: "Hysteria",
    //   date: DateTime(2023, 12, 8),
    //   startTime: DateTime(2023, 12, 8, 18, 0),
    //   endTime: DateTime(2023, 12, 8, 20, 0),
    //   event: "Hysteria",
    // );

    // final event4 = CalendarEventData(
    //   title: "Nightout",
    //   date: DateTime(2023, 12, 8),
    //   startTime: DateTime(2023, 12, 9, 15, 0),
    //   endTime: DateTime(2023, 12, 9, 21, 0),
    //   event: "Nightout",
    // );

    // // Use Future.delayed to ensure the widget is fully initialized
    // Future.delayed(Duration.zero, () {
    //   // Add events to the controller
    //   eventController.addAll([event1, event2, event3, event4]);
    // });
  }

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.076,
        elevation: 0.3,
        title: const Text(
          "Academic calendar",
          textScaler: TextScaler.linear(1.3),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24),
        child: FutureBuilder(
          future: myfuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<CalendarEventData<Object?>>?> snapshot) {
            if (isoffline) {
              return ErrorView(
                onRetry: () {
                  setState(() {
                    myfuture = fetchEvents();
                  });
                },
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                if (snapshot.data!.isEmpty) {
                  return NoResultsFound(
                    onResetFiltersPressed: () {
                      // Handle resetting filters
                      setState(() {
                        myfuture = fetchEvents();
                      });
                    },
                  );
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    fetchEvents();
                  },
                  child: MonthView(
                    headerStyle: const HeaderStyle(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      headerTextStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),

                    headerStringBuilder: (date, {secondaryDate}) {
                      final monthAbbreviation =
                          _getMonthAbbreviation(date.month);
                      final year = date.year;

                      return '$monthAbbreviation $year';
                    },
                    controller: eventController,
                    showBorder: false,
                    // cellBuilder: (date, events, isToday, isInMonth) {
                    //   return GestureDetector(
                    //     onTap: () {
                    //       setState(() {
                    //         selectedDate = date;
                    //       });
                    //     },
                    //     child: Container(
                    //       alignment: Alignment.center,
                    //       margin: EdgeInsets.all(8.0),
                    //       height: 70.0,
                    //       decoration: BoxDecoration(
                    //         color: isToday
                    //             ? Colors.black
                    //             : selectedDate == date
                    //                 ? Colors.black.withOpacity(.80)
                    //                 : Colors.white,
                    //         borderRadius: BorderRadius.circular(35.0),
                    //         boxShadow: [
                    //           BoxShadow(
                    //             color: isToday
                    //                 ? Colors.black.withOpacity(0.5)
                    //                 : Colors.transparent,
                    //             spreadRadius: 2,
                    //             blurRadius: 4,
                    //             offset: Offset(0, 2),
                    //           ),
                    //         ],
                    //       ),
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           Text(
                    //             '${date.day}',
                    //             style: TextStyle(
                    //               fontSize: 16.0,
                    //               fontWeight: FontWeight.w500,
                    //               color: isToday
                    //                   ? Colors.white
                    //                   : selectedDate == date
                    //                       ? Colors.white
                    //                       : Colors.black.withOpacity(.80),
                    //             ),
                    //           ),
                    //           if (events.isNotEmpty)
                    //             Row(
                    //               mainAxisAlignment: MainAxisAlignment.center,
                    //               children: List.generate(
                    //                 events.length > 3 ? 3 : events.length,
                    //                 (index) => Container(
                    //                   margin: EdgeInsets.only(right: 3, bottom: 3),
                    //                   height: 4.5,
                    //                   width: 4.5,
                    //                   decoration: BoxDecoration(
                    //                     color: isToday
                    //                         ? Colors.white
                    //                         : selectedDate == date
                    //                             ? Colors.white
                    //                             : Colors.black.withOpacity(.95),
                    //                     shape: BoxShape.circle,
                    //                   ),
                    //                 ),
                    //               ),
                    //             ),
                    //           Expanded(
                    //             child: selectedDate != null
                    //                 ? _buildEventList(selectedDate!)
                    //                 : Container(),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   );
                    // },
                    minMonth: DateTime(2023),
                    maxMonth: DateTime(2050),
                    initialMonth: DateTime.now(),
                    useAvailableVerticalSpace: true,
                    // cellAspectRatio: 1,
                    onPageChange: (date, pageIndex) =>
                        print("$date, $pageIndex"),
                    onCellTap: (events, date) {
                      print('Events for ${date.day}: ${events.length}');
                    },

                    startDay: WeekDays.sunday,
                    onEventTap: (eventData, date) {
                      // Find the corresponding Event in EventModel
                      final selectedEvent =
                          EventModel.events?.firstWhere((event) {
                        return event.dateOfcreation == eventData.date &&
                            event.eventTitle == eventData.title &&
                            event.eventDesc == eventData.description &&
                            event.dateOfexpiration == eventData.endDate;
                      });

                      if (selectedEvent != null) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                EventDetailsPage(event: selectedEvent),
                          ),
                        ).then((_) {
                          setState(() {});
                        });
                      }
                    },

                    onDateLongPress: (date) => print(date),
                  ),
                );
              } else if (snapshot.hasError) {
                return ErrorHandlingWidget(
                  error: snapshot.error,
                  onRetry: () {
                    setState(() {
                      myfuture = fetchEvents();
                    });
                  },
                );
              }
            }
            // Show shimmer while waiting for data
            return ShimmerCalendarLayout();
          },
        ),
      ),
    );
  }

  _getMonthAbbreviation(int month) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return months[month - 1];
  }

  Widget _buildEventList(DateTime? selectedDate) {
    if (selectedDate == null) {
      return Container(); // Return an empty container if selectedDate is null
    }

    print('Selected Date: $selectedDate');

    // Filter events for the selected date
    final selectedEvents = eventController.events
        .where((event) =>
            event.date.year == selectedDate.year &&
            event.date.month == selectedDate.month &&
            event.date.day == selectedDate.day)
        .toList();

    print('Selected Events: $selectedEvents');

    return ListView.builder(
      itemCount: selectedEvents.length,
      itemBuilder: (context, index) {
        final event = selectedEvents[index];
        return _buildEventCard(event);
      },
    );
  }

  Widget _buildEventCard(CalendarEventData event) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 2.0,
      child: ListTile(
        title: Text(event.title),
        subtitle: Text(
          'Start: ${_formatTime(event.startTime) ?? 'N/A'}\n'
          'End: ${_formatTime(event.endTime) ?? 'N/A'}',
        ),
      ),
    );
  }

  String? _formatTime(DateTime? time) {
    if (time == null) {
      return null; // or return a default value like 'N/A'
    }
    return "${time.hour}:${time.minute}";
  }
}

Widget ShimmerCalendarLayout() {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shimmer effect for the month header
          Container(
            height: 24.0,
            width: 80.0, // Adjust the width as needed
            color: Colors.grey,
            margin: const EdgeInsets.only(bottom: 8.0),
          ),

          // Shimmer effect for the day headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              7,
              (index) => Container(
                height: 16.0,
                width: 16.0, // Adjust the width as needed
                color: Colors.grey,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
              ),
            ),
          ),

          // Shimmer effect for the date placeholders
          Column(
            children: List.generate(
              5,
              (index) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(
                  7,
                  (index) => Container(
                    height: 24.0,
                    width: 24.0, // Adjust the width as needed
                    color: Colors.grey,
                    margin: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 2.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
