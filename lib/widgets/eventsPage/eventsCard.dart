import 'package:cluedin_app/models/events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../screens/Events/eventDetailsPage.dart';

class EventsWidget extends StatefulWidget {
  const EventsWidget({super.key, required this.event});
  final Events event;

  @override
  State<EventsWidget> createState() => _EventsWidgetState();
}

class _EventsWidgetState extends State<EventsWidget> {
  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: Key(widget.event.eventId.toString()),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => EventDetailsPage(event: widget.event),
              ),
            ).then((_) {
              setState(() {});
            });
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
                        imageUrl: widget.event.imageUrl,
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
                                            " ${DateFormat('MMM d, ' 'yy').format(widget.event.dateOfcreation)}",
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
                child: Text(widget.event.eventTitle,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ));
  }
}
