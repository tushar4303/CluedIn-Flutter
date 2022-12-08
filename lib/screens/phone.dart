import 'package:cluedin_app/screens/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  TextEditingController numberLengthController = TextEditingController();
  var phone = "";

  bool isEnabled = false;

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";
    // numberLengthController.addListener(() {
    //   if (numberLengthController.text.length == 10) {
    //     setState(() {
    //       isEnabled = true;
    //     });
    //   }
    // });

    super.initState();
  }

  // void dispose() {
  //   // Clean up the controller when the widget is disposed.
  //   numberLengthController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Let's Get Started",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "We will send an OTP to your mobile number",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        controller: countryController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextFormField(
                      // controller: numberLengthController,
                      maxLength: 10,
                      onChanged: (value) {
                        phone = value;
                        setState(() {
                          if (value.length > 9) {
                            isEnabled = true;
                          } else {
                            isEnabled = false;
                          }
                        });
                      },
                      keyboardType: TextInputType.phone,
                      // ignore: prefer_const_constructors
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: '',
                        hintText: "Phone",
                      ),
                    ))
                  ],
                ),
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
                            Color.fromRGBO(124, 77, 255, 0.65),
                        backgroundColor: Colors.deepPurpleAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    onPressed: isEnabled
                        ? (() async {
                            await FirebaseAuth.instance.verifyPhoneNumber(
                              phoneNumber: countryController.text + phone,
                              verificationCompleted:
                                  (PhoneAuthCredential credential) {},
                              verificationFailed: (FirebaseAuthException e) {
                                if (e.code == 'invalid-phone-number') {
                                  print(
                                      'The provided phone number is not valid.');
                                }
                              },
                              codeSent:
                                  (String verificationId, int? resendToken) {
                                MyPhone.verify = verificationId;
                              },
                              codeAutoRetrievalTimeout:
                                  (String verificationId) {},
                            );
                            // ignore: use_build_context_synchronously
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) =>
                                        MyVerify(phone: phone)));
                          })
                        : null,
                    child: const Text(
                      "Send the code",
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
