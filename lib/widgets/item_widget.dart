import 'package:flutter/material.dart';
import 'package:cluedin_app/models/notification.dart';
import 'package:cluedin_app/screens/notification_detail.dart';
import 'package:intl/intl.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key, required this.item});
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.symmetric(vertical: 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
        ),
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
              Row(children: [
                Text(
                  item.userRole,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textScaleFactor: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Expanded(
                  child: Text(
                    " @${item.userName}",
                    textScaleFactor: 1,
                    style: const TextStyle(fontWeight: FontWeight.w400),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
              ]),
              const SizedBox(
                height: 1,
              ),
              Text(item.messageTitle,
                  textScaleFactor: 0.9,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              item.userMessage,
              textScaleFactor: 0.9,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
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
