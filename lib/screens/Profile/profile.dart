import 'dart:async';
import 'package:cluedin_app/screens/Profile/profileDetails.dart';
import 'package:cluedin_app/widgets/customDivider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:cluedin_app/models/profile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/webView/webview.dart';
import 'package:share_plus/share_plus.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late Future openbox;

  void shareApp() {
    final String text =
        "Check out CluedIn app! Stay up-to-date with all the latest updates and events. Download now: [https://github.com/tushar4303/CluedIn-Flutter/]";

    Share.share(text);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    openBox("UserBox");
  }

  @override
  void initState() {
    super.initState();

    openbox = openBox("UserBox");
  }

  Future<Box<dynamic>> openBox(String boxName) async {
    final box = await Hive.openBox(boxName);
    return box;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          toolbarHeight: MediaQuery.of(context).size.height * 0.096,
          elevation: 0.3,
          title: Transform(
            transform: Matrix4.translationValues(8.0, -5.6, 0),
            child: const Text(
              "Profile",
              textAlign: TextAlign.left,
              textScaleFactor: 1.3,
              style: TextStyle(color: Color.fromARGB(255, 30, 29, 29)),
            ),
          )),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(
            height: 90,
            child: Center(
                child: FutureBuilder(
              future: openbox,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  var firstname = Hive.box('userBox').get("fname");
                  var lastname = Hive.box('userBox').get("lname");
                  var profilepic = Hive.box('userBox').get("profilePic");
                  final details = UserDetails(
                      userid: Hive.box('userBox').get("userid"),
                      fname: firstname,
                      lname: lastname,
                      mobno: Hive.box('userBox').get("mobno"),
                      email: Hive.box('userBox').get("email"),
                      branchName: Hive.box('userBox').get("branchName"),
                      profilePic: profilepic,
                      token: Hive.box('userBox').get("token"));

                  final username = firstname + " " + lastname;
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => ProfileDetails(
                                    userDetails: details,
                                  ))).then((_) {
                        setState(() {});
                      });
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(profilepic),
                      radius: 36,
                    ),
                    title:
                        Text("$username", style: const TextStyle(fontSize: 18)),
                    subtitle: const Text("Show profile",
                        style: TextStyle(fontSize: 15)),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 20),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )),
          ),
          const CustomDivider(),
          Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 16, left: 16, right: 16),
            child: Card(
              elevation: 1.2,
              surfaceTintColor: Colors.transparent,
              child: Center(
                child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WebViewApp(
                                    webViewTitle: "CluedIn Feedback form",
                                    webViewLink:
                                        'https://docs.google.com/forms/d/e/1FAIpQLSfSKWO1hU-WhnOd0MBH32VOrlfnirZebrjN5-PXl0v42VRHCw/viewform?usp=sf_link',
                                  )));
                    },
                    title: const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Text("Leave us a Feedback!"),
                    ),
                    subtitle: const Text(
                        "Your feedback helps us to improve the product"),
                    trailing: const Icon(
                      Icons.store_mall_directory,
                      size: 32,
                    )),
              ),
            ),
          ),
          Column(
            children: [
              const CustomDivider(),
              ListTile(
                // horizontalTitleGap: 0,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                onTap: () {
                  shareApp();
                },
                leading: const Icon(Icons.share),
                title: const Text("Spread the word"),
                subtitle: const Text("Share the App with your friends"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              ),
              const CustomDivider(),
              ListTile(
                // horizontalTitleGap: 0,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                onTap: () {},
                leading: const Icon(Icons.star_border_outlined),
                title: const Text("Rate Us"),
                subtitle: const Text("Tell us what you think"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              ),
              const CustomDivider(),
              ListTile(
                // horizontalTitleGap: 0,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                onTap: () async {
                  final url = Uri.parse(
                    "https://github.com/tushar4303/CluedIn-Flutter",
                  );
                  if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
                    throw 'Could not launch $url';
                  }
                },
                leading: const Icon(Icons.info_outline),
                title: const Text("About CluedIn"),
                subtitle: const Text("Know more about us"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              ),
              const CustomDivider(),
            ],
          ),
          const SizedBox(
            height: 28,
          ),
          RichText(
            text: const TextSpan(
              text: 'Crafted with ',
              style: TextStyle(fontSize: 14, color: Colors.black87),
              children: <TextSpan>[
                TextSpan(
                    text: "💜 ",
                    style: TextStyle(fontSize: 12, color: Colors.black87)),
                TextSpan(
                    text: "by ",
                    style: TextStyle(fontSize: 14, color: Colors.black87)),
                TextSpan(
                    text: "CSI DBIT",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  final url = Uri.parse(
                    "https://github.com/tushar4303/CluedIn-Flutter",
                  );
                  if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text(
                  "Changelogs",
                  style:
                      TextStyle(fontSize: 13, color: Colors.deepPurpleAccent),
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              const Text(
                "|",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(
                width: 6,
              ),
              GestureDetector(
                onTap: () async {
                  final url = Uri.parse(
                    "https://github.com/tushar4303/CluedIn-Flutter/blob/main/PRIVACY_POLICY.md",
                  );
                  if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
                    throw 'Could not launch $url';
                  }
                },
                child: const Text(
                  "Privacy policy",
                  style:
                      TextStyle(fontSize: 13, color: Colors.deepPurpleAccent),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("Version 1.10.0"),
          const SizedBox(
            height: 28,
          ),
        ]),
      ),
    );
  }
}
