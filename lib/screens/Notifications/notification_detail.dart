// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:io';
import 'package:cluedin_app/screens/pdfView.dart';
import 'package:cluedin_app/utils/globals.dart';
import 'package:cluedin_app/utils/links.dart';
import 'package:cluedin_app/widgets/ShimmerForAttachment.dart';
import 'package:cluedin_app/widgets/homescreen/youtubeVideoCard.dart';
import 'package:cluedin_app/widgets/showFileShareBottomsheet.dart';
import 'package:cluedin_app/widgets/webView/webview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:retry/retry.dart';
import 'package:cluedin_app/screens/Notifications/notification_page.dart';
import 'package:cluedin_app/models/notification.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mime/mime.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/linkMetaData.dart';

class NotificationDetailsPage extends StatefulWidget {
  const NotificationDetailsPage({
    super.key,
    required this.notification,
  });
  final Notifications notification;

  @override
  State<NotificationDetailsPage> createState() =>
      _NotificationDetailsPageState();
}

class _NotificationDetailsPageState extends State<NotificationDetailsPage> {
  String remotePDFpath = "";
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

  Future hasRead() async {
    print("inside has read");
    final uri = Uri.parse(notifReadStatus);
    var hasRead = widget.notification.isRead;
    var userId = Hive.box('userBox').get("userid") as int;
    var nmId = widget.notification.notificationId;
    print(hasRead);
    print(userId);
    print(nmId);

    const r = RetryOptions(maxAttempts: 3);
    final response = await r.retry(
      // Make a GET request
      () => http.post(uri, body: {
        'user_id': userId.toString(),
        'nm_id': nmId.toString(),
        'isRead': "1"
      }).timeout(const Duration(seconds: 2)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    try {
      if (response.statusCode == 200) {
        print("status sent successfully");
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.notification.isRead == 0) {
      hasRead();
    }
    createFileOfPdfUrl(
            "$baseServerUrl${widget.notification.attachmentUrl}", context)
        .then((f) {
      setState(() {
        remotePDFpath = f.path;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NotificationPage()),
        );
        return true; // Return true to allow the back navigation, false to prevent it
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white, // Set status bar color here
          statusBarIconBrightness:
              Brightness.dark, // Set status bar icons brightness
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            // appBar: SliverAppBar(),
            body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                const SliverAppBar(
                  floating: true,
                  backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                            widget.notification.notificationLabel,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(30, 29, 29, 0.8)),
                          ),
                        ),
                      ),
                      Text(
                        widget.notification.notificationTitle,
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
                              backgroundImage: NetworkImage(
                                  "$baseServerUrl${widget.notification.senderProfilePic}"),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: widget.notification.senderRole,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            " @${widget.notification.sender_fname} ${widget.notification.sender_lname}",
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
                                    Text(timeago.format(
                                        widget.notification.dateOfcreation)),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      if (widget.notification.imageUrl.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: InkWell(
                            onLongPress: () {
                              showFileOptionsBottomSheet(context,
                                  "$baseServerUrl${widget.notification.imageUrl}",
                                  shareText:
                                      widget.notification.notificationMessage);
                            },
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16)),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "$baseServerUrl${widget.notification.imageUrl}",
                                placeholder: (context, url) {
                                  return Image.asset(
                                    "assets/images/placeholder_landscape.png",
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      // Display only the first YouTube link
                      if (extractYouTubeLinks(
                              widget.notification.notificationMessage)
                          .isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: YoutubeCard(
                            youtubeLink: extractYouTubeLinks(
                                widget.notification.notificationMessage)[0],
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
                            widget.notification.notificationMessage,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      if (widget.notification.attachmentUrl.isNotEmpty)
                        FutureBuilder<LinkMetadata>(
                          future: fetchLinkMetadata(
                              "$baseServerUrl${widget.notification.attachmentUrl}"),
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
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => PDFScreen(
                                                  path: remotePDFpath,
                                                ),
                                              ),
                                            );
                                          },
                                          onLongPress: () async {
                                            showFileOptionsBottomSheet(context,
                                                "$baseServerUrl${widget.notification.attachmentUrl}",
                                                shareText: widget.notification
                                                    .notificationMessage);
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
                                                  const SizedBox(width: 8),
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
                      if (widget.notification.nm_registration_url.isNotEmpty)
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
                                  "Registration link",
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  if (widget.notification.nm_registration_url
                                          .contains('google.com/forms') ||
                                      widget.notification.nm_registration_url
                                          .contains('tinyurl.com')) {
                                    await _launchUrl(widget
                                        .notification.nm_registration_url);
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => WebViewApp(
                                          webViewTitle: "Registration link",
                                          webViewLink: widget
                                              .notification.nm_registration_url,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
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

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
