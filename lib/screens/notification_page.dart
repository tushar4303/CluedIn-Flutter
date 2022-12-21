// ignore_for_file: non_constant_identifier_names

import 'package:cluedin_app/models/notification.dart';
import 'package:flutter/material.dart';
import 'package:cluedin_app/widgets/item_widget.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final url =
      "https://gist.githubusercontent.com/tushar4303/0ababbdad3073acd8ab2580b5deb084b/raw/ed49b00d346e21c199e896c77186cc636437b4c4/notifications.json";

  final _filters = [];
  final List<Item> _filteredNotifications = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future loadData() async {
    await Future.delayed(Duration(seconds: 2));

    final response = await http.get(Uri.parse(url));

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
    print(NotificationModel.items);

    setState(() {
      _filteredNotifications.clear();
      _filteredNotifications.addAll(NotificationModel.items!);
    });
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
          transform: Matrix4.translationValues(8.0, 10.0, 0),
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
                height: 8,
              ),
              RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(Duration(milliseconds: 1500));
                  loadData();
                },
                child: (NotificationModel.labels != null &&
                        NotificationModel.labels!.isNotEmpty)
                    ? SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
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
                      )
                    : Center(
                        child: CircularProgressIndicator(
                        color: Colors.white,
                      )),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: (NotificationModel.items != null &&
                      NotificationModel.items!.isNotEmpty)
                  ? RefreshIndicator(
                      onRefresh: () async {
                        await Future.delayed(Duration(milliseconds: 1500));
                        loadData();
                      },
                      child: ListView.builder(
                          itemCount: _filteredNotifications.length,
                          itemBuilder: (context, index) {
                            return NotificationWidget(
                              item: _filteredNotifications[index],
                            );
                          }),
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
      // ignore: prefer_const_literals_to_create_immutables
    );
  }
}

// ignore_for_file: prefer_const_constructors
