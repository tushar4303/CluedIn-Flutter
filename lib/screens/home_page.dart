import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // final String name = "CluedIn";

    return Scaffold(
      appBar: AppBar(title: Text("CluedIn")),
      body: Center(child: Container(child: Text("CluedIn"))),
      drawer: Drawer(),
    );
  }
}

// ignore_for_file: prefer_const_constructors