import 'package:cluedin_app/models/notification.dart';
import 'package:flutter/material.dart';
import 'package:cluedin_app/widgets/item_widget.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../widgets/drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    await Future.delayed(Duration(seconds: 2));
    final NotificationsJson =
        await rootBundle.loadString("assets/files/notifactions.json");
    final decodedData = jsonDecode(NotificationsJson);
    var notificationsData = decodedData["notification"];
    NotificationModel.items = List.from(notificationsData)
        .map<Item>((item) => Item.fromMap(item))
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CluedIn")),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: (NotificationModel.items != null &&
                  NotificationModel.items!.isNotEmpty)
              ? ListView.builder(
                  itemCount: NotificationModel.items!.length,
                  itemBuilder: (context, index) => NotificationWidget(
                    item: NotificationModel.items![index],
                  ),
                )
              : Center(child: CircularProgressIndicator())),
      drawer: MyDrawer(),
    );
  }
}

// ignore_for_file: prefer_const_constructors