import 'package:cluedin_app/utils/links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cluedin_app/models/notification.dart';
import 'package:intl/intl.dart';

import '../../screens/Notifications/notification_detail.dart';

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({super.key, required this.notification});
  final Notifications notification;

  @override
  State<NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return DateFormat('MMM d, ' 'yy').format(dateTime);
    } else {
      return DateFormat.jm().format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: Key(widget.notification.notificationId.toString()),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        margin: const EdgeInsets.only(bottom: 0, top: 0, left: 4),
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    NotificationDetailsPage(notification: widget.notification),
              ),
            ).then((_) {
              setState(() {});
            });
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                "$baseServerUrl${widget.notification.senderProfilePic}"),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  text: widget.notification.senderRole,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 16,
                      height: 1.1),
                  children: <TextSpan>[
                    TextSpan(
                      text:
                          " @${widget.notification.sender_fname} ${widget.notification.sender_lname}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
              Text(widget.notification.notificationTitle,
                  textScaler: const TextScaler.linear(0.95),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, height: 1.2, fontSize: 16)),
              Text(
                widget.notification.notificationMessage.trim(),
                textScaler: const TextScaler.linear(1.05),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                // ignore: prefer_const_constructors
                style: TextStyle(height: 1.1, fontSize: 14),
              ),
            ],
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatDate(widget.notification.dateOfcreation),
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                  fontSize: 11,
                ),
              ),
              if (widget.notification.isRead == 0)
                Padding(
                  padding: const EdgeInsets.only(bottom: 24, right: 8),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
