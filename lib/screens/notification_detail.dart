// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:cluedin_app/models/notification.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationDetailsPage extends StatelessWidget {
  const NotificationDetailsPage({
    Key? key,
    required this.item,
  }) : super(key: key);
  final Item item;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 16),
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(240, 221, 245, 1),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        item.messageLabel,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(30, 29, 29, 0.8)),
                      ),
                    ),
                  ),
                  Text(
                    item.messageTitle,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 28,
                        color: Color.fromARGB(255, 30, 29, 29)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                            backgroundImage: NetworkImage(item.imageUrl)),
                        const SizedBox(
                          width: 8,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: item.userRole,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: " @${item.userName}",
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
                                Text(timeago.format(item.dateOfcreation)),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Hero(
                    tag: Key(item.messageId.toString()),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16)),
                        child: Image.network(item.imageUrl),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      item.userMessage,
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
