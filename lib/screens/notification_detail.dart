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
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Academics",
                        style: TextStyle(
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
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      """Lorem ipsum dolor sit amet consectetur adipiscing elit nullam pulvinar viverra, iaculis habitant montes vehicula tellus massa quam facilisi mollis, eu metus sapien vivamus venenatis laoreet proin fermentum taciti. Turpis odio dignissim tortor ultrices cras nam in torquent sollicitudin erat ornare, facilisi enim rutrum convallis molestie lacus commodo vestibulum aliquam sociis condimentum, iaculis sagittis mollis ac penatibus nunc dictumst vehicula sociosqu nostra. Dictumst aliquam eleifend sit maecenas hendrerit mauris, semper nec duis ac est netus varius, neque facilisis laoreet in euismod. 

Nunc tincidunt senectus class duis amet suspendisse nisl in litora nullam curae, luctus ultricies facilisis ut himenaeos viverra facilisi posuere sem. Scelerisque vitae dolor proin ante neque facilisi vulputate, magnis erat habitasse lobortis himenaeos sagittis, auctor vel eu metus maecenas ut. Vel facilisi nibh accumsan nascetur est habitant convallis nisl, consectetur nulla netus sagittis auctor at quam, pulvinar montes pharetra vulputate consequat vivamus vestibulum. 

Dis sit semper et varius ligula duis lectus accumsan mollis quis litora, mi imperdiet interdum porttitor facilisi purus magna hac sapien. Porta litora suscipit montes mollis id ornare nullam, leo sapien habitant porttitor nascetur sociis ridiculus dis, posuere lacus odio potenti convallis habitasse. Porttitor quis scelerisque mi facilisi tellus ultricies vestibulum aptent arcu facilisis, sollicitudin risus vehicula mattis sociis metus duis ligula amet, nulla inceptos urna nisi interdum tempor taciti elementum vitae.

""",
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
