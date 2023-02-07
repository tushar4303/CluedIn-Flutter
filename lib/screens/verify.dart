import 'package:cluedin_app/main.dart';
import 'package:cluedin_app/screens/phone.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../utils/globals.dart';

class MyVerify extends StatefulWidget {
  final String phone;
  final String verificationId;

  const MyVerify({Key? key, required this.phone, required this.verificationId})
      : super(key: key);
  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isEnabled = false;

  @override
  // ignore: duplicate_ignore
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    // ignore: unused_local_variable
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    // ignore: unused_local_variable
    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    var code = "";
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/illustration-1.png',
                  width: 220,
                  height: 220,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "Awesome, Thanks!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 8,
              ),
              // Text(
              //   'Please enter the OTP sent to ${widget.phone}',
              //   style: const TextStyle(fontSize: 16, color: Colors.black45),
              //   textAlign: TextAlign.start,
              // ),
              RichText(
                text: TextSpan(
                  text: 'Please enter the OTP sent to ',
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                  children: <TextSpan>[
                    TextSpan(
                        text: "${widget.phone} ",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const TextSpan(
                        text: "Edit",
                        // recognizer:
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurpleAccent))
                  ],
                ),
              ),

              const SizedBox(
                height: 24,
              ),
              Pinput(
                length: 6,
                // defaultPinTheme: defaultPinTheme,
                // focusedPinTheme: focusedPinTheme,
                // submittedPinTheme: submittedPinTheme,
                onChanged: (value) {
                  code = value;
                  setState(() {
                    if (value.length > 5) {
                      isEnabled = true;
                    } else {
                      isEnabled = false;
                    }
                  });
                },
                showCursor: true,
                onCompleted: (pin) => print(pin),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        disabledBackgroundColor:
                            const Color.fromRGBO(124, 77, 255, 0.65),
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: isEnabled
                        ? () async {
                            print("reached in verify before credential");

                            try {
                              PhoneAuthCredential credential =
                                  PhoneAuthProvider.credential(
                                      verificationId: widget.verificationId,
                                      smsCode: code);
                              print("credential:$credential");

                              // Sign the user in (or link) with the credential

                              await FirebaseAuth.instance
                                  .signInWithCredential(credential);

                              // ignore: use_build_context_synchronously
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => HomePage(),
                                ),
                                (route) => false,
                              );
                              // ignore: use_build_context_synchronously

                            } catch (e) {
                              print(e.toString());
                              final SnackBar snackBar =
                                  SnackBar(content: Text(e.toString()));
                              snackbarKey.currentState?.showSnackBar(snackBar);
                            }
                          }
                        : null,
                    child: const Text(
                      "Verify",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    )),
              ),
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Didn't receive OTP ? Resend in 59 s",
                    style: TextStyle(
                        color: Color.fromRGBO(0, 0, 0, 0.8), fontSize: 14),
                    textAlign: TextAlign.start,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
