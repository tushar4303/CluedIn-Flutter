// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:cluedin_app/models/notification.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

class NotificationDetailsPage extends StatelessWidget {
  const NotificationDetailsPage({
    Key? key,
    required this.notification,
  }) : super(key: key);
  final Notifications notification;

  final String _errorImage =
      "https://i.ytimg.com/vi/z8wrRRR7_qU/maxresdefault.jpg";

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
                            notification.notificationLabel,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(30, 29, 29, 0.8)),
                          ),
                        ),
                      ),
                      Text(
                        notification.notificationTitle,
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
                                    notification.senderProfilePic)),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: notification.senderRole,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: " @${notification.senderName}",
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
                                    Text(timeago
                                        .format(notification.dateOfcreation)),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      if (notification.imageUrl.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16)),
                            child: CachedNetworkImage(
                              imageUrl: notification.imageUrl,
                              placeholder: (context, url) {
                                return Image.asset(
                                  "assets/images/placeholder_landscape.png",
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          notification.notificationMessage,
                          textAlign: TextAlign.left,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      if (notification.attachmentUrl.isNotEmpty)
                        AnyLinkPreview.isValidLink(notification.attachmentUrl)
                            ? AnyLinkPreview.builder(
                                link: notification.attachmentUrl,
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
                                            final url = Uri.parse(
                                                notification.attachmentUrl);
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
                    ],
                  ),
                ),
              ))),
    );
  }
}
