// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:cluedin_app/screens/Events/exploreDetailsPage.dart';
// import 'package:cluedin_app/utils/links.dart';
// import 'package:cluedin_app/widgets/ErrorView.dart';
// import 'package:cluedin_app/widgets/connectivityTest.dart';
// import 'package:cluedin_app/widgets/networkErrorHandling.dart';
// import 'package:cluedin_app/widgets/noResultsFound.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:hive_flutter/hive_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'package:cluedin_app/models/events.dart';
// import 'package:flutter/material.dart';
// import 'package:calendar_view/calendar_view.dart';
// import 'package:retry/retry.dart';
// import 'package:shimmer/shimmer.dart';

// class MonthViewWidget extends StatefulWidget {
//   const MonthViewWidget({super.key});

//   @override
//   _MonthViewWidgetState createState() => _MonthViewWidgetState();
// }

// class _MonthViewWidgetState extends State<MonthViewWidget>
//     with SingleTickerProviderStateMixin {
//   late EventController eventController;
//   late TabController _tabController;
//   late Future<List<CalendarEventData>?> myfuture;
//   StreamSubscription? internetconnection;
//   bool isoffline = false;
//   bool showFrom = false;
//   late ConnectivityHelper connectivityHelper;
//   Future<List<CalendarEventData>> fetchEvents() async {
//     var token = Hive.box('userBox').get("token");
//     const r = RetryOptions(maxAttempts: 3);

//     try {
//       final response = await r.retry(
//         // Make a GET request
//         () => http.get(
//           Uri.parse(calendarApiUrl),
//           headers: {
//             'Authorization': 'Bearer $token',
//           },
//         ).timeout(const Duration(seconds: 2)),
//         // Retry on SocketException or TimeoutException
//         retryIf: (e) => e is SocketException || e is TimeoutException,
//       );

//       if (response.statusCode == 200) {
//         final eventsJson = response.body;
//         final decodedData = jsonDecode(eventsJson);
//         var eventsData = decodedData["events"];
//         var acadCalendarData = decodedData["calendarEvents"];
//         EventModel.labels = List.from(decodedData["labels"]);
//         EventModel.organizers = List.from(decodedData["organizers"]);

//         EventModel.events = List.from(eventsData)
//             .map<Events>((event) => Events.fromMap(event))
//             .toList();

//         // print(EventModel.events);

//         EventModel.calendarEvents = List.from(acadCalendarData)
//             .map<AcademicEvent>(
//                 (academicEvent) => AcademicEvent.fromMap(academicEvent))
//             .toList();

//         // print(EventModel.calendarEvents);

//         final calendarEvents = <CalendarEventData>[];

//         if (EventModel.events != null) {
//           calendarEvents.addAll(EventModel.events!.map((event) {
//             return CalendarEventData(
//                 date: event.dateOfEvent,
//                 title: event.eventTitle,
//                 description: event.eventDesc,
//                 startTime: event.dateOfEvent,
//                 endDate: event.dateOfExpiration,
//                 color: Colors.lightGreen
//                 // Add other properties as needed
//                 );
//           }));
//         }

//         if (EventModel.calendarEvents != null) {
//           calendarEvents.addAll(EventModel.calendarEvents!.map((event) {
//             return CalendarEventData(
//                 date: event.dateOfEvent,
//                 title: event.eventName,
//                 description: "Academic Calendar Event",
//                 startTime: event.dateOfEvent,
//                 endDate: event.dateOfExpiry,
//                 color: Colors.lightBlue
//                 // Add other properties as needed
//                 );
//           }));
//         }

//         if (calendarEvents.isNotEmpty) {
//           eventController.addAll(calendarEvents);
//         }

//         return calendarEvents;
//       } else {
//         throw Exception("Failed to load events");
//       }
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }

//   @override
//   void initState() {
//     _tabController = TabController(length: 1, vsync: this);
//     connectivityHelper = ConnectivityHelper(
//       onConnectivityChanged: (bool isConnected) {
//         setState(() {
//           isoffline = !isConnected;
//         });
//         if (isConnected) {
//           // If connected, reload data
//           setState(() {
//             myfuture = fetchEvents();
//           });
//         }
//       },
//     );
//     super.initState();

//     eventController = EventController();
//     selectedDate = DateTime.now();
//     myfuture = fetchEvents();
//   }

//   DateTime? selectedDate;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         toolbarHeight: MediaQuery.of(context).size.height * 0.076,
//         elevation: 0.3,
//         title: const Text(
//           "Term Plan",
//           textScaler: TextScaler.linear(1.3),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(left: 16, right: 16),
//         child: FutureBuilder(
//           future: myfuture,
//           builder: (BuildContext context,
//               AsyncSnapshot<List<CalendarEventData<Object?>>?> snapshot) {
//             if (isoffline) {
//               return ErrorView(
//                 lottieJson: 'assets/lottiefiles/noInternet.json',
//                 onRetry: () {
//                   setState(() {
//                     myfuture = fetchEvents();
//                   });
//                 },
//               );
//             }
//             if (snapshot.connectionState == ConnectionState.done) {
//               if (snapshot.hasData) {
//                 if (snapshot.data!.isEmpty) {
//                   return NoResultsFound(
//                     onResetFiltersPressed: () {
//                       // Handle resetting filters
//                       setState(() {
//                         myfuture = fetchEvents();
//                       });
//                     },
//                   );
//                 }
//                 if (EventModel.events != null) {
//                   return RefreshIndicator(
//                     onRefresh: () async {
//                       fetchEvents();
//                     },
//                     child: MonthView(
//                       headerStyle: const HeaderStyle(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                         ),
//                         headerTextStyle: TextStyle(
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.w500,
//                           color: Colors.black87,
//                         ),
//                       ),
//                       headerStringBuilder: (date, {secondaryDate}) {
//                         final monthAbbreviation =
//                             _getMonthAbbreviation(date.month);
//                         final year = date.year;

//                         return '$monthAbbreviation $year';
//                       },
//                       controller: eventController,
//                       showBorder: false,
//                       minMonth: DateTime(2023),
//                       maxMonth: DateTime(2050),
//                       initialMonth: DateTime.now(),
//                       useAvailableVerticalSpace: true,
//                       onPageChange: (date, pageIndex) =>
//                           print("$date, $pageIndex"),
//                       onCellTap: (events, date) {
//                         print('Events for ${date.day}: ${events.length}');
//                       },
//                       startDay: WeekDays.sunday,
//                       onEventTap: (eventData, date) {
//                         final selectedEvent =
//                             EventModel.events?.firstWhere((event) {
//                           return event.dateOfEvent == eventData.date &&
//                               event.eventTitle == eventData.title &&
//                               event.eventDesc == eventData.description &&
//                               event.dateOfExpiration == eventData.endDate;
//                         });

//                         if (selectedEvent != null) {
//                           Navigator.push(
//                             context,
//                             CupertinoPageRoute(
//                               builder: (context) =>
//                                   EventDetailsPage(event: selectedEvent),
//                             ),
//                           ).then((_) {
//                             setState(() {});
//                           });
//                         }
//                       },
//                       onDateLongPress: (date) => print(date),
//                     ),
//                   );
//                 } else {
//                   return ErrorHandlingWidget(
//                     error: "Event data is null",
//                     onRetry: () {
//                       setState(() {
//                         myfuture = fetchEvents();
//                       });
//                     },
//                   );
//                 }
//               } else if (snapshot.hasError) {
//                 print(snapshot.error.toString());
//                 return ErrorHandlingWidget(
//                   error: snapshot.error,
//                   onRetry: () {
//                     setState(() {
//                       myfuture = fetchEvents();
//                     });
//                   },
//                 );
//               }
//             }

//             // Show shimmer while waiting for data
//             return ShimmerCalendarLayout();
//           },
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   _getMonthAbbreviation(int month) {
//     final months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec'
//     ];

//     return months[month - 1];
//   }

//   String? _formatTime(DateTime? time) {
//     if (time == null) {
//       return null; // or return a default value like 'N/A'
//     }
//     return "${time.hour}:${time.minute}";
//   }
// }

// Widget ShimmerCalendarLayout() {
//   return Shimmer.fromColors(
//     baseColor: Colors.grey[300]!,
//     highlightColor: Colors.grey[100]!,
//     child: Container(
//       margin: const EdgeInsets.only(bottom: 12.0),
//       padding: const EdgeInsets.all(16.0),
//       decoration: BoxDecoration(
//         color: Colors.grey,
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Shimmer effect for the month header
//           Container(
//             height: 24.0,
//             width: 80.0, // Adjust the width as needed
//             color: Colors.grey,
//             margin: const EdgeInsets.only(bottom: 8.0),
//           ),

//           // Shimmer effect for the day headers
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: List.generate(
//               7,
//               (index) => Container(
//                 height: 16.0,
//                 width: 16.0, // Adjust the width as needed
//                 color: Colors.grey,
//                 margin: const EdgeInsets.symmetric(horizontal: 4.0),
//               ),
//             ),
//           ),

//           // Shimmer effect for the date placeholders
//           Column(
//             children: List.generate(
//               5,
//               (index) => Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: List.generate(
//                   7,
//                   (index) => Container(
//                     height: 24.0,
//                     width: 24.0, // Adjust the width as needed
//                     color: Colors.grey,
//                     margin: const EdgeInsets.symmetric(
//                         vertical: 4.0, horizontal: 2.0),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     ),
//   );
// }
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cluedin_app/screens/Events/exploreDetailsPage.dart';
import 'package:cluedin_app/utils/links.dart';
import 'package:cluedin_app/widgets/ErrorView.dart';
import 'package:cluedin_app/widgets/connectivityTest.dart';
import 'package:cluedin_app/widgets/networkErrorHandling.dart';
import 'package:cluedin_app/widgets/noResultsFound.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:cluedin_app/models/events.dart';
import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:retry/retry.dart';
import 'package:shimmer/shimmer.dart';

class MonthViewWidget extends StatefulWidget {
  const MonthViewWidget({super.key});

  @override
  _MonthViewWidgetState createState() => _MonthViewWidgetState();
}

class _MonthViewWidgetState extends State<MonthViewWidget>
    with SingleTickerProviderStateMixin {
  late EventController eventController;
  late TabController _tabController;
  late Future<List<CalendarEventData>?> myfuture;
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
          Uri.parse(calendarApiUrl),
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
        var acadCalendarData = decodedData["calendarEvents"];
        EventModel.labels = List.from(decodedData["labels"]);
        EventModel.organizers = List.from(decodedData["organizers"]);

        EventModel.events = List.from(eventsData)
            .map<Events>((event) => Events.fromMap(event))
            .toList();

        // print(EventModel.events);

        EventModel.calendarEvents = List.from(acadCalendarData)
            .map<AcademicEvent>(
                (academicEvent) => AcademicEvent.fromMap(academicEvent))
            .toList();

        // print(EventModel.calendarEvents);

        final calendarEvents = <CalendarEventData>[];

        if (EventModel.events != null) {
          calendarEvents.addAll(EventModel.events!.map((event) {
            return CalendarEventData(
              date: event.dateOfEvent,
              title: event.eventTitle,
              description: event.eventDesc,
              startTime: event.dateOfEvent,
              endDate: event.dateOfExpiration,
              color: _getColorForEventCategory(
                  "Non-Academic-Page"), // Default color
              // Add other properties as needed
            );
          }));
        }

        if (EventModel.calendarEvents != null) {
          calendarEvents.addAll(EventModel.calendarEvents!.map((event) {
            Color color = _getColorForEventCategory(event.eventCategory);
            return CalendarEventData(
              date: event.dateOfEvent,
              title: event.eventName,
              description: event.eventCategory,
              startTime: event.dateOfEvent,
              endDate: event.dateOfExpiry,
              color: color,
              // Add other properties as needed
            );
          }));
        }

        if (calendarEvents.isNotEmpty) {
          eventController.addAll(calendarEvents);
        }

        return calendarEvents;
      } else {
        throw Exception("Failed to load events");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Color _getColorForEventCategory(String eventCategory) {
    switch (eventCategory) {
      case "Academic":
        return Colors.blue; // Use Google Calendar color for Academic events
      case "Non-Academic":
        return Colors
            .lightGreen; // Use Google Calendar color for Non-Academic events
      case "Non-Academic-Page":
        return Colors.green;
      case "Holiday":
        return Colors.red; // Use Google Calendar color for Holiday events
      default:
        return Colors.grey; // Use a default color for Other events
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this);
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
  }

  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    // Define a list of legend items with corresponding colors
    List<Map<String, dynamic>> legendItems = [
      {"category": "Academic", "color": Colors.blue},
      {"category": "Non-Academic", "color": Colors.lightGreen},
      {"category": "Non-Academic", "color": Colors.green},
      {"category": "Holiday", "color": Colors.red},
      {"category": "Other", "color": Colors.grey},
    ];

// Add a method to handle the legend button tap
    void showLegendMenu(BuildContext context) {
      final RenderBox appBarRenderBox = context.findRenderObject() as RenderBox;
      final Offset offset = appBarRenderBox.localToGlobal(Offset.zero);

      // Calculate the position of the context menu
      final double menuWidth = MediaQuery.of(context).size.width * 0.5;
      const double iconSize = 24.0;
      const double menuItemHeight = 48.0;
      final double menuHeight = legendItems.length * menuItemHeight;
      final double screenHeight = MediaQuery.of(context).size.height;
      final double screenWidth = MediaQuery.of(context).size.width;
      double dx = offset.dx + appBarRenderBox.size.width - iconSize;
      double dy = offset.dy + kToolbarHeight + (iconSize * 1.35);

      // Adjust the position if the menu goes out of the screen
      if (dx + menuWidth > screenWidth) {
        dx = screenWidth - menuWidth;
      }
      if (dy + menuHeight > screenHeight) {
        dy = offset.dy - menuHeight;
      }

      // Show the context menu with legend items
      showMenu(
        context: context,
        position:
            RelativeRect.fromLTRB(dx, dy, dx + menuWidth, dy + menuHeight),
        items: legendItems.map((item) {
          return PopupMenuItem(
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item['color'] as Color,
                  ),
                  margin: const EdgeInsets.only(right: 8),
                ),
                Text(item['category'] as String),
              ],
            ),
          );
        }).toList(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.076,
        elevation: 0.3,
        title: const Text(
          "Term Plan",
          textScaler: TextScaler.linear(1.3),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              // Call the method to show the legend context menu
              showLegendMenu(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
        child: FutureBuilder(
          future: myfuture,
          builder: (BuildContext context,
              AsyncSnapshot<List<CalendarEventData<Object?>>?> snapshot) {
            if (isoffline) {
              return ErrorView(
                lottieJson: 'assets/lottiefiles/noInternet.json',
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
                if (EventModel.events != null) {
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
                      minMonth: DateTime(2023),
                      maxMonth: DateTime(2050),
                      initialMonth: DateTime.now(),
                      useAvailableVerticalSpace: true,
                      onPageChange: (date, pageIndex) =>
                          print("$date, $pageIndex"),
                      onCellTap: (events, date) {
                        // Filter events that include the selected date
                        List<CalendarEventData> eventsForSelectedDate =
                            events.where((event) {
                          return event.date.isBefore(
                                  date.add(const Duration(days: 1))) &&
                              event.endDate.isAfter(
                                  date.subtract(const Duration(days: 1)));
                        }).toList();

                        // Show bottom sheet with the list of events for the selected date
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'Events on ${DateFormat('MMMM d, yyyy').format(date)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: eventsForSelectedDate.isEmpty
                                      ? Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                Lottie.asset(
                                                    'assets/lottiefiles/noResults.json'),
                                                const Text(
                                                  'No Results Found',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : ListView.separated(
                                          itemCount:
                                              eventsForSelectedDate.length,
                                          separatorBuilder: (context, index) =>
                                              const Divider(),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            CalendarEventData eventData =
                                                eventsForSelectedDate[index];
                                            Color dotColor = eventData.color;

                                            return ListTile(
                                              title: Row(
                                                children: [
                                                  Container(
                                                    width: 8,
                                                    height: 8,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: dotColor,
                                                    ),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                  ),
                                                  Text(
                                                    eventData.title,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              subtitle: eventData.color ==
                                                      Colors.green
                                                  ? const Text(
                                                      'Tap for more info')
                                                  : Text(
                                                      eventData.description),
                                              onTap: () {
                                                // Handle tap logic here
                                                final selectedEvent = EventModel
                                                    .events
                                                    ?.firstWhere((event) {
                                                  return event.dateOfEvent ==
                                                          eventData.date &&
                                                      event.eventTitle ==
                                                          eventData.title &&
                                                      event.eventDesc ==
                                                          eventData
                                                              .description &&
                                                      event.dateOfExpiration ==
                                                          eventData.endDate;
                                                });

                                                if (selectedEvent != null) {
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder: (context) =>
                                                          EventDetailsPage(
                                                              event:
                                                                  selectedEvent),
                                                    ),
                                                  ).then((_) {
                                                    setState(() {});
                                                  });
                                                }
                                              },
                                            );
                                          },
                                        ),
                                ),
                              ],
                            );
                          },
                        );
                      },

                      startDay: WeekDays.sunday,
                      // onEventTap: (eventData, date) {
                      //   final selectedEvent =
                      //       EventModel.events?.firstWhere((event) {
                      //     return event.dateOfEvent == eventData.date &&
                      //         event.eventTitle == eventData.title &&
                      //         event.eventDesc == eventData.description &&
                      //         event.dateOfExpiration == eventData.endDate;
                      //   });

                      //   if (selectedEvent != null) {
                      //     Navigator.push(
                      //       context,
                      //       CupertinoPageRoute(
                      //         builder: (context) =>
                      //             EventDetailsPage(event: selectedEvent),
                      //       ),
                      //     ).then((_) {
                      //       setState(() {});
                      //     });
                      //   }
                      // },
                      onDateLongPress: (date) => print(date),
                    ),
                  );
                } else {
                  return ErrorHandlingWidget(
                    error: "Event data is null",
                    onRetry: () {
                      setState(() {
                        myfuture = fetchEvents();
                      });
                    },
                  );
                }
              } else if (snapshot.hasError) {
                print(snapshot.error.toString());
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
