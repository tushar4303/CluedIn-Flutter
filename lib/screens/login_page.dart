import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                              children: const <TextSpan>[
                                TextSpan(
                                    text: " Sign up",
                                    style: TextStyle(
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
                          children: const <TextSpan>[
                            TextSpan(
                                text: " Sign up",
                                style: TextStyle(
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
  const _Logo({Key? key}) : super(key: key);

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
  const _FormContent({Key? key}) : super(key: key);

  @override
  State<_FormContent> createState() => __FormContentState();
}

class __FormContentState extends State<_FormContent> {
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
              style: const TextStyle(fontSize: 16),
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                bool emailValid = RegExp(r"^[0-9]{10}$").hasMatch(value);
                if (!emailValid) {
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
                    /// do something
                  }
                },
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
                children: const <TextSpan>[
                  TextSpan(
                      text: "Get help signing in",
                      style: TextStyle(
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
