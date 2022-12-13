import 'package:flutter/material.dart';

class MyEvents extends StatelessWidget {
  const MyEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          toolbarHeight: 96,
          elevation: 0.3,
          title: Transform(
            transform: Matrix4.translationValues(8.0, 10.0, 0),
            child: const Text(
              "Events",
              textAlign: TextAlign.left,
              textScaleFactor: 1.3,
              style: TextStyle(color: Color.fromARGB(255, 30, 29, 29)),
            ),
          )),
      // body: ,
    );
  }
}