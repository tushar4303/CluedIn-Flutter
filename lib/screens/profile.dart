import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cluedin_app/screens/phone.dart';
import 'package:cluedin_app/screens/profileDetails.dart';
import 'package:cluedin_app/widgets/customDivider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:retry/retry.dart';
import 'package:http/http.dart' as http;
import 'package:cluedin_app/models/profile.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late Future _userDetailsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadUserDetails();
  }

  @override
  void initState() {
    super.initState();

    _userDetailsFuture = loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    final queryParameters = {
      'mobno': '8104951731',
    };

    final uri =
        Uri.http('cluedin.creast.in:5000', '/api/app/profile', queryParameters);

    const r = RetryOptions(maxAttempts: 3);
    final response = await r.retry(
      // Make a GET request
      () => http.get(uri).timeout(const Duration(seconds: 2)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    if (response.statusCode == 200) {
      final UserDetailsJson = response.body;

      final userBox = await Hive.openBox('userBox');

      final decodedData = jsonDecode(UserDetailsJson);
      var userDetails = decodedData["data"];

      userDetails = UserDetails.fromMap(userDetails);

      await userBox.put('fname', userDetails.fname);
      await userBox.put('lname', userDetails.lname);
      await userBox.put('mobno', userDetails.mobno);
      await userBox.put('email', userDetails.email);
      await userBox.put('branchName', userDetails.branchName);
      await userBox.put('profilePic',
          'http://cluedin.creast.in:5000/' + userDetails.profilePic);
    } else {
      throw Exception('Failed to load user details');
    }
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
              future: _userDetailsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final userBox = Hive.box('userBox');
                  final fname = userBox.get('fname');
                  final lname = userBox.get('lname');
                  final mobno = userBox.get('mobno');
                  final email = userBox.get('email');
                  final branchName = userBox.get('branchName');
                  final profilePic = userBox.get('profilePic');
                  final Details = UserDetails(
                      fname: fname,
                      lname: lname,
                      mobno: mobno,
                      email: email,
                      branchName: branchName,
                      profilePic: profilePic);

                  final username = fname + lname;
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => ProfileDetails(
                                    userDetails: Details,
                                  ))).then((_) {
                        setState(() {});
                      });
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(profilePic),
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
                  FirebaseAuth.instance.signOut();
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
