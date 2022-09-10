import 'package:flutter/material.dart';

import '../widgets/drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("CluedIn")),
      body: Center(child: Container(child: Text("CluedIn"))),
      drawer: MyDrawer(),
    );
  }
}

// ignore_for_file: prefer_const_constructors