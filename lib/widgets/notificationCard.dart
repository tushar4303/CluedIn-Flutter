import 'package:flutter/material.dart';
import 'package:cluedin_app/models/notification.dart';
import 'package:intl/intl.dart';

import '../screens/notification_detail.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({super.key, required this.notification});
  final Notifications notification;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: Key(notification.notificationId.toString()),
      child: SizedBox(
        width: double.infinity,
        // height: MediaQuery.of(context).size.height * 0.1155,
        child: Card(
          // color: Colors.amberAccent,
          elevation: 0.0,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          NotificationDetailsPage(notification: notification)));
            },
            leading: CircleAvatar(
                backgroundImage: NetworkImage(notification.senderProfilePic),
                child: const Text('DP')),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    text: notification.senderRole,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: " @${notification.senderName}",
                        style: const TextStyle(fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Text(notification.notificationTitle,
                    textScaleFactor: 0.9,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    notification.notificationMessage,
                    textScaleFactor: 0.9,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            trailing: Text(
              DateFormat('MMM d, ' 'yy').format(notification.dateOfcreation),
              textAlign: TextAlign.end,
              textScaleFactor: 0.8,
            ),
          ),
        ),
      ),
    );
  }
}
