// ignore_for_file: non_constant_identifier_names

import 'package:cluedin_app/models/notification.dart';
import 'package:flutter/material.dart';
import 'package:cluedin_app/widgets/item_widget.dart';
import 'dart:convert';
// import 'package:flutter/services.dart';
import '../widgets/drawer.dart';
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final url = "https://json.extendsclass.com/bin/ed83bbd71629";

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
    var notificationsData = decodedData["notification"];
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
      appBar: AppBar(
        title: Text("Notifications"),
        // backgroundColor: Colors.amber,
        bottom: PreferredSize(
            // ignore: sort_child_properties_last
            child: Padding(
                padding: const EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: ["Teacher", "Principal"].map((filterType) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: FilterChip(
                          label: Text(filterType),
                          selected: _filters.contains(filterType),
                          elevation: 1,
                          selectedColor: Color.fromARGB(153, 212, 207, 207),
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
                )),
            preferredSize: Size(double.infinity, kToolbarHeight)),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
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
              : Center(child: CircularProgressIndicator())),
      drawer: MyDrawer(),
    );
  }
}

// ignore_for_file: prefer_const_constructors