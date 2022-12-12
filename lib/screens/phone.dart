import 'package:cluedin_app/models/validateUser.dart';
import 'package:cluedin_app/screens/verify.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cluedin_app/models/validateUser.dart';

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  TextEditingController countryController = TextEditingController();
  late TextEditingController numberController = TextEditingController();
  String _error = '<none>';
  bool _pending = false;
  var phone = "";

  bool isEnabled = false;

  @override
  void initState() {
    // TODO: implement initState
    countryController.text = "+91";

    super.initState();
  }

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
                      controller: numberController,
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
                        ? () => _httpPost(numberController.text)
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

  Future<void> _httpPost(String number) async {
    setState(() => _pending = true);
    try {
      final http.Response response = await http.post(
        Uri.parse('http://localhost:5000/api/app/authAppUser'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{'usermobno': number}),
      );
      // If the server did return a 201 CREATED response.

      ValidateUser validateResponse =
          ValidateUser.fromJson(json.decode(response.body));
      if (validateResponse.success.toString() == "true") {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: countryController.text + phone,
          verificationCompleted: (PhoneAuthCredential credential) {},
          verificationFailed: (FirebaseAuthException e) {
            if (e.code == 'invalid-phone-number') {
              print('The provided phone number is not valid.');
            }
          },
          codeSent: (String verificationId, int? resendToken) {
            MyPhone.verify = verificationId;
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
        // ignore: use_build_context_synchronously
        Navigator.push(context,
            CupertinoPageRoute(builder: (context) => MyVerify(phone: phone)));
      } else {
        print("User not registered");
      }
    } catch (e) {
      setState(() => _error = 'Exception occured: $e');
    }
    setState(() => _pending = false);
  }
}
