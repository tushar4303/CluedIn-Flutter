// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:cluedin_app/models/notification.dart';

class NotificationDetailsPage extends StatelessWidget {
  const NotificationDetailsPage({
    Key? key,
    required this.item,
  }) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Stay Updated"),
        ),
        body: SafeArea(
          child: Card(
            child: Column(
              children: [
                Hero(
                  tag: Key(item.messageId.toString()),
                  child: Card(child: Image.network(item.imageUrl)),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        item.userRole,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(" @${item.userName}",
                          style: const TextStyle(fontWeight: FontWeight.w400))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item.messageTitle,
                    textScaleFactor: 1.5,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    item.userMessage,
                    textAlign: TextAlign.justify,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
