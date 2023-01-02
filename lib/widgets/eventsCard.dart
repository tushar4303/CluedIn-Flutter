import 'package:flutter/material.dart';
import 'package:cluedin_app/models/notification.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../screens/notification_detail.dart';

class EventsWidget extends StatelessWidget {
  const EventsWidget({super.key, required this.item});
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: Key(item.messageId.toString()),
        child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationDetailsPage(item: item)));
          },
          child: Column(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 260,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0)),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: item.imageUrl,
                        placeholder: (context, url) {
                          return Image.asset(
                            "assets/images/placeholder.png",
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    Positioned(
                      child: Container(
                        margin: const EdgeInsets.only(top: 236),
                        height: 24,
                        color: const Color.fromARGB(165, 0, 0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: RichText(
                              maxLines: 2,
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                  text: null,
                                  style: const TextStyle(
                                      fontSize: 12, color: Colors.black87),
                                  children: [
                                    const WidgetSpan(
                                      child: Icon(
                                        Icons.watch_later_outlined,
                                        size: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextSpan(
                                        text:
                                            " ${DateFormat('MMM d, ' 'yy').format(item.dateOfcreation)}",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(item.messageTitle,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: Text(
              //       item
              //           .messageLabel,
              //       maxLines: 2,
              //       textAlign: TextAlign.left,
              //       overflow: TextOverflow.ellipsis,
              //       style: const TextStyle(
              //         fontSize: 14,
              //       )),
              // ),
            ],
          ),
        ));
  }
}
