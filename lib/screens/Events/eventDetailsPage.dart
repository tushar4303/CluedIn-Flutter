// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'package:cluedin_app/widgets/ShimmerForAttachment.dart';
import 'package:cluedin_app/widgets/showFileShareBottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/events.dart';
import '../../widgets/webView/webview.dart';
import '../../models/linkMetaData.dart';

class EventDetailsPage extends StatefulWidget {
  const EventDetailsPage({
    Key? key,
    required this.event,
  }) : super(key: key);
  final Events event;

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  RichText get timerDisplay {
    Duration duration = widget.event.dateOfcreation.difference(DateTime.now());
    var sentAt = DateFormat('MMM d, ' 'yy').format(widget.event.dateOfcreation);
    if (duration.isNegative) {
      return RichText(
        text: TextSpan(
          children: [
            const TextSpan(
                text: 'ENDED ', style: TextStyle(color: Colors.black)),
            TextSpan(text: '|', style: TextStyle(color: Colors.grey[400])),
            TextSpan(
                text: ' $sentAt', style: const TextStyle(color: Colors.black)),
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
                text: ' $sentAt',
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
              text: ' $sentAt',
              style: const TextStyle(color: Colors.black, fontSize: 18)),
        ],
      ),
    );
  }

  Future<LinkMetadata> fetchLinkMetadata(String link) async {
    try {
      // Extract filename using a regular expression
      final RegExp regex = RegExp(r"nm-\d+-(.*)$");
      final Match? match = regex.firstMatch(link);
      final filename = match?.group(1) ?? "Unknown";

      final response = await http.head(Uri.parse(link));
      if (response.statusCode == 200) {
        // Extract size from the 'content-length' header
        final contentLength = response.headers['content-length'];
        final size = contentLength != null
            ? '${(int.parse(contentLength) / (1024 * 1024)).toStringAsFixed(2)} MB'
            : '';

        // Determine the MIME type of the document
        final mimeType = lookupMimeType(link) ?? "";

        return LinkMetadata(title: filename, size: size, mimeType: mimeType);
      } else {
        throw Exception('Failed to load link metadata');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load link metadata');
    }
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
                            widget.event.eventLabel,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(30, 29, 29, 0.8)),
                          ),
                        ),
                      ),
                      Text(
                        widget.event.eventTitle,
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 32,
                            color: Color.fromARGB(255, 30, 29, 29)),
                      ),
                      timerDisplay,
                      Hero(
                        tag: Key(widget.event.eventId.toString()),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: InkWell(
                            onLongPress: () {
                              showFileOptionsBottomSheet(
                                  context, widget.event.imageUrl);
                            },
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                              child: CachedNetworkImage(
                                imageUrl: widget.event.imageUrl,
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
                      ),
                      if (widget.event.registrationFee.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            "Registration Fee: ${widget.event.registrationFee}",
                            textScaler: const TextScaler.linear(1.1),
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      GestureDetector(
                        onTap: () {
                          // Clear the text selection when tapping outside the SelectableText region
                          if (FocusScope.of(context).hasPrimaryFocus) {
                            FocusScope.of(context).unfocus();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: SelectableText(
                            widget.event.eventDesc,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (widget.event.attachmentUrl.isNotEmpty)
                        FutureBuilder<LinkMetadata>(
                          future: fetchLinkMetadata(
                              "http://cluedin.creast.in:5000/${widget.event.attachmentUrl}"),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              if (snapshot.hasData) {
                                final metadata = snapshot.data!;

                                // Display filename with ellipsis if it's too long
                                final displayFilename =
                                    metadata.title.length > 20
                                        ? '${metadata.title.substring(0, 15)}..'
                                        : metadata.title;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      child: Material(
                                        color: const Color.fromRGBO(
                                            242, 243, 245, 1),
                                        child: InkWell(
                                          onTap: () async {
                                            final url = Uri.parse(
                                              "http://cluedin.creast.in:5000/${widget.event.attachmentUrl}",
                                            );
                                            if (!await launchUrl(url,
                                                mode: LaunchMode
                                                    .platformDefault)) {
                                              throw 'Could not launch $url';
                                            }
                                          },
                                          onLongPress: () async {
                                            showFileOptionsBottomSheet(context,
                                                "http://cluedin.creast.in:5000/${widget.event.attachmentUrl}");
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 22,
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8, right: 8),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  // Dynamically display icon based on MIME type
                                                  Icon(
                                                    getIconForMimeType(
                                                        metadata.mimeType),
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  Text(
                                                    displayFilename,
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                      color: Color.fromRGBO(
                                                          27, 96, 173, 1),
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 16),
                                                  // Add code to display document size
                                                  Text(
                                                    'Size: ${metadata.size}', // Use the actual document size from metadata
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                // Handle the case when metadata is not available
                                return Container();
                              }
                            } else {
                              // Handle loading state
                              return const ShimmerForAttachment();
                            }
                          },
                        ),
                      if (widget.event.registrationLink.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 16, bottom: 12), // Increased bottom padding
                          child: Center(
                            child: SizedBox(
                              height: 50, // Adjust the height as needed
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.black),
                                ),
                                clipBehavior: Clip.hardEdge,
                                child: const Text(
                                  "Register Now!",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WebViewApp(
                                        webViewTitle: "Register now!",
                                        webViewLink:
                                            "http://cluedin.creast.in:5000/${widget.event.registrationLink}",
                                      ),
                                    ),
                                  );
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
                                  "http://cluedin.creast.in:5000/${widget.event.senderProfilePic}"),
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
                                      text: widget.event.senderRole,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text:
                                              " @${widget.event.sender_fname} ${widget.event.sender_lname}",
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
                                    widget.event.organizedBy,
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

  // Function to get the icon based on MIME type
  IconData getIconForMimeType(String? mimeType) {
    // Add mappings for various MIME types to corresponding icons
    if (mimeType != null) {
      if (mimeType.startsWith('application/pdf')) {
        return Icons.picture_as_pdf;
      } else if (mimeType.startsWith('application/msword') ||
          mimeType.startsWith(
              'application/vnd.openxmlformats-officedocument.wordprocessingml.document')) {
        return Icons.description;
      } else if (mimeType.startsWith('application/vnd.ms-excel') ||
          mimeType.startsWith(
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')) {
        return Icons.insert_drive_file;
      }
      // Add more MIME type checks as needed
    }
    // Default icon
    return Icons.insert_drive_file;
  }
}
