import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  static var route;

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          toolbarHeight: MediaQuery.of(context).size.height * 0.096,
          elevation: 0.3,
          title: Transform(
            transform: Matrix4.translationValues(8.0, 0.0, 0),
            child: const Text(
              "HomeScreen",
              textAlign: TextAlign.left,
              textScaleFactor: 1.3,
              style: TextStyle(color: Color.fromARGB(255, 30, 29, 29)),
            ),
          )),
    );
  }
}
