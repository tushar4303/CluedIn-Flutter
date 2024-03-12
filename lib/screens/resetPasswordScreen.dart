import 'dart:convert';
import 'package:cluedin_app/screens/login_page.dart';
import 'package:cluedin_app/utils/globals.dart';
import 'package:cluedin_app/utils/links.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ResetPasswordPage extends StatelessWidget {
  final int userId;
  final String token;

  const ResetPasswordPage({
    super.key,
    required this.userId,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: isSmallScreen
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: _FormContent(userId: userId, token: token)),
                      const SizedBox(height: 16),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14, top: 14),
                            child: RichText(
                              text: TextSpan(
                                text: "Already have an account? ",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87.withOpacity(0.7),
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: "Sign in",
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pop(context);
                                      },
                                    style: const TextStyle(
                                      color: Colors.deepPurple,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                : Container(
                    padding: const EdgeInsets.all(32.0),
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Row(
                      children: [
                        Expanded(
                          child: Center(
                              child:
                                  _FormContent(userId: userId, token: token)),
                        ),
                        RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87.withOpacity(0.7),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: "Sign in",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pop(context);
                                  },
                                style: const TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

class _FormContent extends StatefulWidget {
  final int userId;
  final String token;

  const _FormContent({required this.userId, required this.token});

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

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
            const SizedBox(height: 8),
            TextFormField(
              controller: newPasswordController,
              style: const TextStyle(fontSize: 16),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                if (!isPasswordComplex(value)) {
                  return 'Password must contain at least one uppercase letter, one lowercase letter, one digit, and one special character';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'New Password',
                hintText: 'Enter your new password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            _gap(),
            TextFormField(
              controller: confirmPasswordController,
              style: const TextStyle(fontSize: 16),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                if (value != newPasswordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                hintText: 'Confirm your new password',
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.05,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    'Reset Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    resetPassword(context);
                  }
                },
              ),
            ),
            _gap(),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);

  void resetPassword(BuildContext context) async {
    final String newPassword = newPasswordController.text;
    final String confirmPassword = confirmPasswordController.text;

    // JSON body
    final Map<String, dynamic> body = {
      'password': newPassword,
      'confirmPassword': confirmPassword,
      'user_id': widget.userId,
      'token': widget.token,
    };

    // Encoding body to JSON format
    final jsonBody = jsonEncode(body);

    // Sending POST request
    final response = await http.post(
      Uri.parse(setNewPassword),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonBody,
    );

    // Handling response
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final message = jsonResponse['message'];
      final success = jsonResponse['success'];

      // Show message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoginPage(),
        ),
        (route) => false,
      );
      print(message);
    } else {
      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to reset password. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
      print('Failed to reset password. Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
    }
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
