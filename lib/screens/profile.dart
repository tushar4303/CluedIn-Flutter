import 'package:cluedin_app/screens/phone.dart';
import 'package:cluedin_app/screens/profileDetails.dart';
import 'package:cluedin_app/widgets/customDivider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

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
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => ProfileDetails()));
                },
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://avatars.githubusercontent.com/u/88235295?s=400&u=2c6acf95bc514b8ca6115a6ff24822154a10ee7b&v=4'),
                  radius: 36,
                ),
                title: Transform(
                  transform: Matrix4.translationValues(-10, 0.0, 0.0),
                  child: const Text("Tushar", style: TextStyle(fontSize: 18)),
                ),
                subtitle: Transform(
                  transform: Matrix4.translationValues(-10, -0.8, 0.0),
                  child: const Text("Show profile",
                      style: TextStyle(fontSize: 15)),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              ),
            ),
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
                    onTap: () {},
                    title: const Text("Leave us a Feedback!"),
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
                horizontalTitleGap: 0,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                onTap: () {},
                leading: const Icon(Icons.share),
                title: const Text("Spread the word"),
                subtitle: const Text("Share the App with your friends"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              ),
              const CustomDivider(),
              ListTile(
                horizontalTitleGap: 0,
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
                horizontalTitleGap: 0,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                onTap: () {},
                leading: const Icon(Icons.info_outline),
                title: const Text("About CluedIn"),
                subtitle: const Text("Know more about us"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              ),
              const CustomDivider(),
              ListTile(
                horizontalTitleGap: 0,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (c) => const MyPhone()),
                      (r) => false);
                },
                leading: const Icon(Icons.logout_outlined),
                title: const Text(
                  "Logout",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.black,
                ),
              ),
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
                onTap: () {},
                child: const Text(
                  "About app",
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
                onTap: () {},
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
