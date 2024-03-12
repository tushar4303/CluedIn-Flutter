import 'dart:async';
import 'dart:io';
import 'package:cluedin_app/screens/ContactDirectory.dart';
import 'package:cluedin_app/screens/Profile/profileDetails.dart';
import 'package:cluedin_app/widgets/customDivider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:cluedin_app/models/profile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/webView/webview.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late Future openbox;
  late PackageInfo packageInfo;
  late String appVersion;

  bool _isSharing = false;
  bool _isRating = false;

  final InAppReview _inAppReview = InAppReview.instance;

  void rateUsDebounced() {
    _rateUsDebouncer.debounce(() => rateUs());
  }

  void rateUs() async {
    if (!_isRating) {
      _isRating = true;

      if (await _inAppReview.isAvailable()) {
        _inAppReview.requestReview();
      } else {
        // In-app review is not available, open the app store
        String appStoreUrl;
        if (Platform.isAndroid) {
          // Play Store URL
          appStoreUrl =
              'https://play.google.com/store/apps/details?id=in.dbit.cluedin_app';
        } else if (Platform.isIOS) {
          // App Store URL (replace <your_app_id> with your actual App Store ID)
          appStoreUrl = 'https://apps.apple.com/app/<your_app_id>';
        } else {
          throw 'Unsupported platform';
        }

        if (appStoreUrl.isNotEmpty) {
          if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
            await launchUrl(Uri.parse(appStoreUrl));
          } else {
            throw 'Could not launch $appStoreUrl';
          }
        } else {
          throw 'App store URL is not provided';
        }
      }

      // Reset the flag after function execution
      _isRating = false;
    }
  }

  void shareAppDebounced() {
    _shareDebouncer.debounce(() => shareApp());
  }

  final _shareDebouncer = Debouncer(milliseconds: 500);
  final Debouncer _rateUsDebouncer = Debouncer(milliseconds: 500);

  void shareApp() async {
    if (!_isSharing) {
      setState(() {
        _isSharing = true;
      });

      const String text =
          "Check out CluedIn app! Stay up-to-date with all the latest updates and events. Download now: [https://play.google.com/store/apps/details?id=in.dbit.cluedin_app]";

      try {
        // Show share dialog
        await Share.share(text);
      } catch (e) {
        print('Error sharing: $e');
      } finally {
        // Reset sharing flag
        setState(() {
          _isSharing = false;
        });
      }
    }
  }

  void initializePackageInfo() async {
    packageInfo = await PackageInfo.fromPlatform();
    appVersion = packageInfo.version;
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    openBox("UserBox");
    initializePackageInfo();
  }

  @override
  void initState() {
    super.initState();
    openbox = openBox("UserBox");
    initializePackageInfo();
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
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          automaticallyImplyLeading: false,
          toolbarHeight: MediaQuery.of(context).size.height * 0.096,
          elevation: 0.3,
          title: Transform(
            transform: Matrix4.translationValues(8.0, -5.6, 0),
            child: const Text(
              "Profile",
              textAlign: TextAlign.left,
              textScaler: TextScaler.linear(1.3),
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
                    semester: Hive.box('userBox').get("semester"),
                    bsdId: Hive.box('userBox').get("bsdId"),
                    department: Hive.box('userBox').get("department"),
                    classValue: Hive.box('userBox').get("classValue"),
                    division: Hive.box('userBox').get("division"),
                    token: Hive.box('userBox').get("token"),
                  );

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
                  onTap: () async {
                    await _launchUrl(
                        "https://docs.google.com/forms/d/e/1FAIpQLSfSKWO1hU-WhnOd0MBH32VOrlfnirZebrjN5-PXl0v42VRHCw/viewform?usp=sf_link");
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => const WebViewApp(
                    //               webViewTitle: "CluedIn Feedback form",
                    //               webViewLink:
                    //                   'https://docs.google.com/forms/d/e/1FAIpQLSfSKWO1hU-WhnOd0MBH32VOrlfnirZebrjN5-PXl0v42VRHCw/viewform?usp=sf_link',
                    //             )));
                  },
                  title: const Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Text("Leave us a Feedback!"),
                  ),
                  subtitle: const Text(
                      "Your feedback helps us to improve the product"),
                  trailing: Lottie.asset(
                    'assets/lottiefiles/feedback.json', // Replace with the actual path to your Lottie animation
                    width: 48, // Adjust the width as needed
                    height: 48, // Adjust the height as needed
                    fit: BoxFit.cover,
                  ),
                ),
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
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const ContactDirectory()));
                },
                leading: LottieBuilder.asset(
                  'assets/lottiefiles/pointofcontact.json', // Replace with the actual path to your Lottie animation
                  width: 42, // Adjust the width as needed
                  height: 42, // Adjust the height as needed
                  fit: BoxFit.cover,
                  reverse: true,
                ),
                title: Transform.translate(
                    offset: const Offset(-10.0, 0.0),
                    child: const Text("Point of Contact")),
                // subtitle: const Text("Share the App with your friends"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              ),
              const CustomDivider(),
              ListTile(
                // horizontalTitleGap: 0,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                onTap: () {
                  if (!_isSharing) {
                    shareAppDebounced();
                  }
                },

                leading: LottieBuilder.asset(
                  'assets/lottiefiles/share.json', // Replace with the actual path to your Lottie animation
                  width: 28, // Adjust the width as needed
                  height: 28, // Adjust the height as needed
                  fit: BoxFit.cover,
                  reverse: true,
                ),
                title: const Text("Spread the word"),
                subtitle: const Text("Share the App with your friends"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              ),
              const CustomDivider(),
              ListTile(
                // horizontalTitleGap: 0,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                onTap: () {
                  rateUsDebounced();
                },
                leading: LottieBuilder.asset(
                  'assets/lottiefiles/rating.json', // Replace with the actual path to your Lottie animation
                  width: 28, // Adjust the width as needed
                  height: 28, // Adjust the height as needed
                  fit: BoxFit.cover,
                  reverse: true,
                ),
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
                    "https://staycluedin.vercel.app/",
                  );
                  if (!await launchUrl(url, mode: LaunchMode.platformDefault)) {
                    throw 'Could not launch $url';
                  }
                },
                leading: LottieBuilder.asset(
                  'assets/lottiefiles/aboutus.json',
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  reverse: true,
                ),
                title: const Text("About CluedIn"),
                subtitle: const Text("Know more about us"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 20),
              ),
              const CustomDivider(),
            ],
          ),
          const SizedBox(
            height: 20,
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
            height: 10,
          ),
          Text("Version $appVersion"),
          const SizedBox(
            height: 64,
          ),
        ]),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void debounce(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
