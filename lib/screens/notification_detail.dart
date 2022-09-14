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
          child: Column(
            children: [
              Hero(
                tag: Key(item.messageId.toString()),
                child: Card(child: Image.network(item.imageUrl)),
              ),
              Expanded(child: Container())
            ],
          ),
        ));
  }
}
