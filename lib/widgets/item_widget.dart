import 'package:flutter/material.dart';
import 'package:cluedin_app/models/notification.dart';
import 'package:cluedin_app/screens/notification_detail.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key, required this.item});
  final Item item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.1155,
      child: Card(
        // color: Colors.amberAccent,
        elevation: 0.0,
        margin: const EdgeInsets.symmetric(vertical: 0),
        child: ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationDetailsPage(item: item)));
          },
          leading: Hero(
            tag: Key(item.messageId.toString()),
            child: CircleAvatar(
                backgroundImage: NetworkImage(item.imageUrl),
                child: const Text('DP')),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  text: item.userRole,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: " @${item.userName}",
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 1,
              ),
              Text(item.messageTitle,
                  textScaleFactor: 0.9,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  item.userMessage,
                  textScaleFactor: 0.9,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          trailing: Text(
            DateFormat('MMM d, ' 'yy').format(item.dateOfcreation),
            textAlign: TextAlign.end,
            textScaleFactor: 0.8,
          ),
        ),
      ),
    );
  }
}
