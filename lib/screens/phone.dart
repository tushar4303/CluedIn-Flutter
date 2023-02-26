import 'package:cluedin_app/screens/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../services/validate_user.dart';
import 'package:cluedin_app/utils/globals.dart';

class MyPhone extends StatefulWidget {
  static String yourNumber = '';

  const MyPhone({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  late TextEditingController numberController = TextEditingController();
  String _error = '';
  var phone = "";
  late final String _verificationId;
  bool isEnabled = false;

  // ignore: non_constant_identifier_names
  validate_user() async {
    final service = ValidateUser();

    MyPhone.yourNumber = countryController.text + phone;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: MyPhone.yourNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
        FirebaseAuth.instance.signInWithCredential(credential);

        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomePage(),
          ),
          (route) => false,
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          setState(() => _error = 'Error: ${e.code}');
          print(countryController.text + phone);
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        // MyPhone.verify = verificationId;
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) =>
                    MyVerify(phone: phone, verificationId: _verificationId)));
      },
    );

    service.apiCallLogin(
      {
        "usermobno": numberController.text,
      },
    ).then((value) async {
      if (value?.error != null) {
        setState(() => _error = 'Error: ${value?.error!}');
      } else {
        if (value?.success == 'true') {
          MyPhone.yourNumber = countryController.text + phone;
          await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: MyPhone.yourNumber,
            verificationCompleted: (PhoneAuthCredential credential) {
              FirebaseAuth.instance.signInWithCredential(credential);

              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => HomePage(),
                ),
                (route) => false,
              );
            },
            verificationFailed: (FirebaseAuthException e) {
              if (e.code == 'invalid-phone-number') {
                setState(() => _error = 'Error: ${e.code}');
                print(countryController.text + phone);
              }
            },
            codeAutoRetrievalTimeout: (String verificationId) {
              _verificationId = verificationId;
            },
            codeSent: (String verificationId, int? resendToken) {
              _verificationId = verificationId;
              // MyPhone.verify = verificationId;
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (context) => MyVerify(
                          phone: phone, verificationId: _verificationId)));
            },
          );
          // ignore: use_build_context_synchronously
        } else {
          setState(() => _error =
              'User not registered. Contact the admin for getting yourself registered');
          final SnackBar snackBar = SnackBar(content: Text(_error));
          snackbarKey.currentState?.showSnackBar(snackBar);
        }
        //push
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(builder: (context) {
        return Container(
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
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                        controller: numberController,
                        maxLength: 10,
                        onChanged: (value) {
                          phone = value;
                          setState(() {
                            if (value.length > 9) {
                              isEnabled = true;
                              FocusManager.instance.primaryFocus?.unfocus();
                            } else {
                              isEnabled = false;
                            }
                          });
                        },
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
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
                              const Color.fromRGBO(124, 77, 255, 0.65),
                          backgroundColor: Colors.deepPurpleAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      onPressed: isEnabled
                          ? (() {
                              validate_user();
                              // ignore: unnecessary_null_comparison
                              if (_error != null) {
                                final SnackBar snackBar =
                                    SnackBar(content: Text(_error));
                                snackbarKey.currentState
                                    ?.showSnackBar(snackBar);
                              }
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
        );
      }),
    );
  }
}
