// ignore_for_file: non_constant_identifier_names

import 'package:cluedin_app/models/notification.dart';
import 'package:flutter/material.dart';
import 'package:cluedin_app/widgets/item_widget.dart';
import 'dart:convert';
import '../widgets/drawer.dart';
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final url = "https://json.extendsclass.com/bin/595354b2a1bc";

  final _filters = [];
  final List<Item> _filteredNotifications = [];

  final int _selectedIndex = 1;
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
    NotificationModel.items = List.from(notificationsData)
        .map<Item>((item) => Item.fromMap(item))
        .toList();
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
          toolbarHeight: 96,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: ["Teacher", "Principal"].map((filterType) {
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
                              width: 1, color: Color.fromARGB(66, 75, 74, 74)),
                          // surfaceTintColor: Colors.black,

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          selectedColor: Color.fromARGB(180, 224, 220, 220),
                          onSelected: ((value) {
                            setState(() {
                              if (value) {
                                _filters.add(filterType);
                              } else {
                                _filters.removeWhere((name) {
                                  return name == filterType;
                                });
                              }
                              _filteredNotifications.clear();
                              if (_filters.isEmpty) {
                                _filteredNotifications
                                    .addAll(NotificationModel.items!);
                              } else {
                                _filteredNotifications.addAll(NotificationModel
                                    .items!
                                    .where((notification) => _filters
                                        .contains(notification.userRole)));
                              }
                            });
                          })),
                    );
                  }).toList(),
                ),
              ],
            ),
          )),
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
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.notifications), label: "Notifications"),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore), label: "Explore"),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle), label: "Settings"),
          ]),
      drawer: MyDrawer(),
    );
  }
}

// ignore_for_file: prefer_const_constructors