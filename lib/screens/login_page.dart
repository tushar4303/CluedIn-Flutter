import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cluedin_app/screens/signUp.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:retry/retry.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:cluedin_app/models/profile.dart';
import '../main.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
        body: Stack(children: [
      Center(
          child: isSmallScreen
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Expanded(child: _FormContent()),
                    const SizedBox(
                      height: 16,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 14, top: 14),
                          child: RichText(
                            text: TextSpan(
                              text: "Don't have an account?",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87.withOpacity(0.7)),
                              children: <TextSpan>[
                                TextSpan(
                                    text: " Sign up",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  const SignUpPage()),
                                        );
                                      },
                                    style: const TextStyle(
                                        color: Colors.deepPurple,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              : Container(
                  padding: const EdgeInsets.all(32.0),
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Center(child: _FormContent()),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Don't have an account?",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87.withOpacity(0.7)),
                          children: <TextSpan>[
                            TextSpan(
                                text: " Sign up",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    final url =
                                        Uri.parse("https://csi.dbit.in/");
                                    if (!await launchUrl(url,
                                        mode: LaunchMode.platformDefault)) {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                style: const TextStyle(
                                    color: Colors.deepPurple,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
    ]));
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    // final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Transform(
            transform: Matrix4.translationValues(-7, 0, 0),
            child: Image.asset(
              "assets/images/splash.png",
              width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
        )
      ],
    );
  }
}

class _FormContent extends StatefulWidget {
  const _FormContent();

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String fcmToken = "firebase token";
  bool isLoading = false;
  final TextEditingController mobnoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getToken();
  }

  getToken() async {
    print("inside get token");
    await _firebaseMessaging.deleteToken();
    String? token = await _firebaseMessaging.getToken();
    fcmToken = token!;
    print(token);
    await Hive.box('userBox').put('fcmtoken', fcmToken);
  }

  Future sendToken() async {
    print("inside send token");
    final uri = Uri.http('cluedin.creast.in:5000', '/api/app/firebaseToken');
    int userid = Hive.box('userBox').get("userid") as int;
    var fcmtoken = Hive.box('userBox').get("fcmtoken");

    const r = RetryOptions(maxAttempts: 3);
    final response = await r.retry(
      // Make a GET request
      () => http.post(uri, body: {
        'user_id': userid.toString(),
        'firebaseToken': fcmtoken
      }).timeout(const Duration(seconds: 2)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );
    try {
      if (response.statusCode == 200) {
        print("Token sent successfully");
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

  Future<void> signIn() async {
    final uri = Uri.http('cluedin.creast.in:5000', '/api/app/authAppUser');
    // getToken();

    const r = RetryOptions(maxAttempts: 3);
    try {
      final response = await r.retry(
        // Make a GET request
        () => http.post(uri, body: {
          'usermobno': mobnoController.text,
          'password': passwordController.text,
        }).timeout(const Duration(seconds: 2)),
        // Retry on SocketException or TimeoutException
        retryIf: (e) => e is SocketException || e is TimeoutException,
      );

      if (response.statusCode != 200) {
        final error = response.body;
        final decodedData = jsonDecode(error);
        print(decodedData);
        var message = decodedData["msg"];
        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
        );
      } else {
        final UserDetailsJson = response.body;
        print(UserDetailsJson);

        final userBox = Hive.box('userBox');

        final decodedData = jsonDecode(UserDetailsJson);
        print(decodedData);
        var userDetails = decodedData["data"];

        userDetails = UserDetails.fromMap(userDetails);
        await userBox.put('userid', userDetails.userid);
        await userBox.put('fname', userDetails.fname);
        await userBox.put('lname', userDetails.lname);
        await userBox.put('mobno', userDetails.mobno);
        await userBox.put('email', userDetails.email);
        await userBox.put('branchName', userDetails.branchName);
        await userBox.put('profilePic',
            "http://cluedin.creast.in:5000/${userDetails.profilePic}");
        await userBox.put('semester', userDetails.semester);
        await userBox.put('bsdId', userDetails.bsdId);
        await userBox.put('department', userDetails.department);
        await userBox.put('classValue', userDetails.classValue);
        await userBox.put('division', userDetails.division);
        await userBox.put('token', userDetails.token);
        await userBox.put('isLoggedIn', true);

        await sendToken();

        Fluttertoast.showToast(
          msg: "logged in successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );

        NavbarNotifier.hideBottomNavBar = false;

        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomePage(),
          ),
          (route) => false,
        );

        // ignore: use_build_context_synchronously
      }
    } on Exception {
      // Handle other exceptions (e.g., generic error message)
      Fluttertoast.showToast(
        msg: "An error occurred. Please try again later.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
      );
    }
  }

  bool _isPasswordVisible = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 330),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const _Logo(),
            const SizedBox(
              height: 8,
            ),
            TextFormField(
              controller: mobnoController,
              style: const TextStyle(fontSize: 16),
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                bool phoneValid = RegExp(r"^[0-9]{10}$").hasMatch(value);
                if (!phoneValid) {
                  return 'Please enter a valid number';
                }

                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Phone',
                hintText: 'Enter your phone no',
                prefixIcon: Icon(Icons.call),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              ),
            ),
            _gap(),
            TextFormField(
              controller: passwordController,
              style: const TextStyle(fontSize: 16),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  )),
            ),
            _gap(),

            // _gap(),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.05,
              child: AbsorbPointer(
                absorbing: isLoading,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent[200],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      setState(() {
                        isLoading = true;
                      });
                      signIn();
                      Timer(const Duration(seconds: 2), () {
                        setState(() {
                          isLoading = false;
                        });
                      });
                    }
                  },
                ),
              ),
            ),
            _gap(),
            RichText(
              text: TextSpan(
                text: 'Forgot your login details? ',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87.withOpacity(0.7)),
                children: <TextSpan>[
                  TextSpan(
                      text: "Get help signing in",
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final url =
                              Uri.parse("http://cluedin.creast.in:5000/signup");
                          if (!await launchUrl(url,
                              mode: LaunchMode.platformDefault)) {
                            throw 'Could not launch $url';
                          }
                        },
                      style: const TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
