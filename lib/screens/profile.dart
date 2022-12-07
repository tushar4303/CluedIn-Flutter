import 'package:cluedin_app/screens/phone.dart';
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
          toolbarHeight: 96,
          elevation: 0.3,
          title: Transform(
            transform: Matrix4.translationValues(8.0, 10.0, 0),
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
                onTap: () {},
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://avatars.githubusercontent.com/u/88235295?s=400&u=2c6acf95bc514b8ca6115a6ff24822154a10ee7b&v=4'),
                  radius: 36,
                ),
                title: Transform(
                  transform: Matrix4.translationValues(-10, 1.0, 0.0),
                  child: const Text("Tushar", style: TextStyle(fontSize: 18)),
                ),
                subtitle: Transform(
                  transform: Matrix4.translationValues(-10, -1.0, 0.0),
                  child: const Text("Show profile",
                      style: TextStyle(fontSize: 15)),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              ),
            ),
          ),
          Divider(
            thickness: 2,
            indent: 24,
            endIndent: 24,
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 8, bottom: 16, left: 16, right: 16),
            child: Card(
              elevation: 1.2,
              surfaceTintColor: Colors.transparent,
              child: Center(
                child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    onTap: () {},
                    title: Text("Leave us a Feedback!"),
                    subtitle:
                        Text("Your feedback helps us to improve the product"),
                    trailing: Icon(
                      Icons.store_mall_directory,
                      size: 32,
                    )),
              ),
            ),
          ),
          Column(
            children: [
              Divider(
                thickness: 2,
                indent: 24,
                endIndent: 24,
                height: 0,
              ),
              ListTile(
                horizontalTitleGap: 0,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                onTap: () {},
                leading: Icon(Icons.share),
                title: Text("Spread the word"),
                subtitle: Text("Share the App with your friends"),
                trailing: Icon(Icons.arrow_forward_ios, size: 20),
              ),
              Divider(
                thickness: 2,
                indent: 24,
                endIndent: 24,
                height: 0,
              ),
              ListTile(
                horizontalTitleGap: 0,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                onTap: () {},
                leading: Icon(Icons.star_border_outlined),
                title: Text("Rate Us"),
                subtitle: Text("Tell us what you think"),
                trailing: Icon(Icons.arrow_forward_ios, size: 20),
              ),
              Divider(
                thickness: 2,
                indent: 24,
                endIndent: 24,
                height: 0,
              ),
              ListTile(
                horizontalTitleGap: 0,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                onTap: () {},
                leading: Icon(Icons.info_outline),
                title: Text("About CluedIn"),
                subtitle: Text("V 1.0.0"),
                trailing: Icon(Icons.arrow_forward_ios, size: 20),
              ),
              Divider(
                thickness: 2,
                indent: 24,
                endIndent: 24,
                height: 0,
              ),
              ListTile(
                horizontalTitleGap: 0,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (c) => MyPhone()),
                      (r) => false);
                },
                leading: Icon(Icons.logout_outlined),
                title: Text(
                  "Logout",
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(""),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: Colors.black,
                ),
              ),
              Divider(
                thickness: 2,
                indent: 24,
                endIndent: 24,
                height: 0,
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
