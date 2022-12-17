import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  const Label({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 24, top: 12, bottom: 24),
      decoration: const BoxDecoration(
          color: Color.fromRGBO(240, 221, 245, 1),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "Academics",
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 30, 29, 29)),
        ),
      ),
    );
  }
}
