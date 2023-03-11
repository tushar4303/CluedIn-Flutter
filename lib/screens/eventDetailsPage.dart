// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/events.dart';

class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({
    Key? key,
    required this.event,
  }) : super(key: key);
  final Events event;

  RichText get timerDisplay {
    Duration duration = event.dateOfcreation.difference(DateTime.now());
    var sent_at = DateFormat('MMM d, ' 'yy').format(event.dateOfcreation);
    if (duration.isNegative) {
      return RichText(
        text: TextSpan(
          children: [
            const TextSpan(
                text: 'ENDED ', style: TextStyle(color: Colors.black)),
            TextSpan(text: '|', style: TextStyle(color: Colors.grey[400])),
            TextSpan(
                text: ' $sent_at', style: const TextStyle(color: Colors.black)),
          ],
        ),
      );
    }
    if (duration.inHours > 24) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(
                text: 'Ends in ${duration.inDays}D ',
                style: const TextStyle(color: Colors.black, fontSize: 18)),
            TextSpan(
                text: '|',
                style: TextStyle(color: Colors.grey[600], fontSize: 18)),
            TextSpan(
                text: ' $sent_at',
                style: const TextStyle(color: Colors.black, fontSize: 18)),
          ],
        ),
      );
    }

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text:
                'Ends in ${duration.inDays}D ${duration.inHours.remainder(24)}H ${twoDigitMinutes}M ${twoDigitSeconds}S ',
            style: const TextStyle(color: Colors.black, fontSize: 18),
          ),
          TextSpan(
            text: '|',
            style: TextStyle(color: Colors.grey[400], fontSize: 18),
          ),
          TextSpan(
              text: ' $sent_at',
              style: const TextStyle(color: Colors.black, fontSize: 18)),
        ],
      ),
    );
  }

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
                            fontSize: 32,
                            color: Color.fromARGB(255, 30, 29, 29)),
                      ),
                      timerDisplay,
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
                      const SizedBox(
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
                                      child: Material(
                                        color: const Color.fromRGBO(
                                            242, 243, 245, 1),
                                        child: InkWell(
                                          onTap: () async {
                                            final url =
                                                Uri.parse(event.attachmentUrl);
                                            if (!await launchUrl(url,
                                                mode: LaunchMode
                                                    .platformDefault)) {
                                              throw 'Could not launch $url';
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 16, horizontal: 24),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.insert_drive_file,
                                                  color: Colors.black
                                                      .withOpacity(0.5),
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
                          padding: const EdgeInsets.only(
                              top: 16, left: 16, right: 16, bottom: 8),
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
                        ),
                      const SizedBox(
                        height: 24,
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Colors.grey[400]!.withOpacity(0.5),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                  "http://cluedin.creast.in:5000/${event.senderProfilePic}"),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: event.senderRole,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              " @${event.sender_fname} ${event.sender_lname}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    event.organizedBy,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Colors.grey[400]!.withOpacity(0.5),
                      ),
                      const SizedBox(
                        height: 48,
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }
}
