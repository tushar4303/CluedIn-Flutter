import 'package:cluedin_app/models/events.dart';
import 'package:cluedin_app/utils/links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../screens/Events/exploreDetailsPage.dart';

class EventsWidget extends StatefulWidget {
  const EventsWidget({Key? key, required this.event}) : super(key: key);
  final Events event;

  @override
  State<EventsWidget> createState() => _EventsWidgetState();
}

class _EventsWidgetState extends State<EventsWidget> {
  Color getStatusColor() {
    // Get the current date
    DateTime currentDate = DateTime.now();
    // Check if the event is ongoing, upcoming, or expired
    if (widget.event.dateOfEvent.isBefore(currentDate) &&
        widget.event.dateOfExpiration!.isAfter(currentDate)) {
      // Event is ongoing
      return Colors.green;
    } else if (widget.event.dateOfEvent.isAfter(currentDate)) {
      // Event is upcoming
      return Colors.blue;
    } else {
      // Event is expired
      return Colors.red;
    }
  }

  String getStatusText() {
    // Get the current date
    DateTime currentDate = DateTime.now();
    // Check if the event is ongoing, upcoming, or expired
    if (widget.event.dateOfEvent.isBefore(currentDate) &&
        widget.event.dateOfExpiration!.isAfter(currentDate)) {
      // Event is ongoing
      return 'Ongoing';
    } else if (widget.event.dateOfEvent.isAfter(currentDate)) {
      // Event is upcoming
      return 'Upcoming';
    } else {
      // Event is expired
      return 'Expired';
    }
  }

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
        child: Stack(
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 260,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: "$baseServerUrl${widget.event.imageUrl}",
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
                              padding:
                                  const EdgeInsets.only(left: 12, right: 12),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.watch_later_outlined,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    DateFormat('MMM d, ' 'yy')
                                        .format(widget.event.dateOfCreation),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const Spacer(), // Add Spacer here
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: getStatusColor(),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    getStatusText(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.event.eventTitle,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            // Badge Widget
          ],
        ),
      ),
    );
  }
}
