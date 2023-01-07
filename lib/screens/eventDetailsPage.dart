// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/events.dart';

class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({
    Key? key,
    required this.event,
  }) : super(key: key);
  final Events event;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          // appBar: SliverAppBar(),
          body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    const SliverAppBar(
                      floating: true,
                    )
                  ],
              body: Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, bottom: 54, top: 8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 8, bottom: 16),
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(240, 221, 245, 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            event.eventLabel,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(30, 29, 29, 0.8)),
                          ),
                        ),
                      ),
                      Text(
                        event.eventTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 28,
                            color: Color.fromARGB(255, 30, 29, 29)),
                      ),
                      //start
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                                backgroundImage:
                                    NetworkImage(event.senderProfilePic)),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: event.senderRole,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: " @${event.senderName}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w400),
                                      )
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.watch_later_outlined,
                                      size: 16,
                                    ),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                    Text(timeago.format(event.dateOfcreation)),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Hero(
                        tag: Key(event.eventId.toString()),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            child: CachedNetworkImage(
                              imageUrl: event.imageUrl,
                              placeholder: (context, url) {
                                return Image.asset(
                                  "assets/images/placeholder.png",
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                      if (event.registrationFee.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "Registration Fee: ${event.registrationFee}",
                            textScaleFactor: 1.1,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      SizedBox(
                        height: 16,
                      ),
                      if (event.attachmentUrl.isNotEmpty)
                        AnyLinkPreview.isValidLink(event.attachmentUrl)
                            ? AnyLinkPreview.builder(
                                link: event.attachmentUrl,
                                itemBuilder:
                                    (context, metadata, imageProvider) =>
                                        Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: Container(
                                        color: const Color.fromRGBO(
                                            242, 243, 245, 1),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16, horizontal: 24),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.insert_drive_file,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            if (metadata.title != null)
                                              Text(
                                                metadata.title!,
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: Color.fromRGBO(
                                                        27, 96, 173, 1),
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          event.eventDesc,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),

                      if (event.registrationLink.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.black)),
                                clipBehavior: Clip.hardEdge,
                                child: const Text(
                                  "Register Now!",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  final url = Uri.parse(event.registrationLink);
                                  if (!await launchUrl(url)) {
                                    throw 'Could not launch $url';
                                  }
                                },
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ))),
    );
  }
}
