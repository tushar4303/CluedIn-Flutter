import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cluedin_app/screens/Events/exploreDetailsPage.dart';
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

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.076,
        elevation: 0.3,
        title: const Text(
          "Term Plan",
          textScaler: TextScaler.linear(1.3),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Monthly'),
            Tab(text: 'Weekly'),
            Tab(text: 'Daily'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
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
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      MonthView(
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
                        // cellAspectRatio: 1,
                        onPageChange: (date, pageIndex) =>
                            print("$date, $pageIndex"),
                        onCellTap: (events, date) {
                          print('Events for ${date.day}: ${events.length}');
                        },

                        startDay: WeekDays.sunday,
                        onEventTap: (eventData, date) {
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
                      WeekView(
                        controller: eventController,
                        // eventTileBuilder: (date, events, boundry, start, end) {
                        //   // Return your widget to display as event tile.
                        //   return Container();
                        // },
                        // fullDayEventBuilder: (events, date) {
                        //   // Return your widget to display full day event view.
                        //   return Container();
                        // },
                        // showLiveTimeLineInAllDays:
                        //     true, // To display live time line in all pages in week view.

                        minDay: DateTime(1990),
                        maxDay: DateTime(2050),
                        initialDay: DateTime.now(),
                        // heightPerMinute:
                        //     1, // height occupied by 1 minute time span.
                        // eventArranger:
                        //     const SideEventArranger(), // To define how simultaneous events will be arranged.
                        // onEventTap: (events, date) => print(events),
                        // onDateLongPress: (date) => print(date),
                        // startDay: WeekDays
                        //     .sunday, // To change the first day of the week.
                      ),
                      DayView(
                        controller: eventController,
                        eventTileBuilder: (date, events, boundry, start, end) {
                          // Return your widget to display as event tile.
                          return Container();
                        },
                        fullDayEventBuilder: (events, date) {
                          // Return your widget to display full day event view.
                          return Container();
                        },
                        showVerticalLine:
                            true, // To display live time line in day view.
                        showLiveTimeLineInAllDays:
                            true, // To display live time line in all pages in day view.
                        minDay: DateTime(2020),
                        maxDay: DateTime(2050),
                        initialDay: DateTime.now(),
                        heightPerMinute:
                            1, // height occupied by 1 minute time span.
                        eventArranger:
                            const SideEventArranger(), // To define how simultaneous events will be arranged.
                        onEventTap: (events, date) => print(events),
                        onDateLongPress: (date) => print(date),
                      )
                    ],
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
