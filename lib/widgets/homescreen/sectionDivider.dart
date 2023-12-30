import 'package:flutter/material.dart';

class SectionDivider extends StatelessWidget {
  final String text;

  const SectionDivider({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 24),
            child: Container(
              height: 0.5, // Height of the line
              color:
                  const Color.fromRGBO(125, 125, 125, 0.7), // Color of the line
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color.fromRGBO(125, 125, 125, 1),
              letterSpacing: 1.5,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 24),
            child: Container(
              height: 0.5, // Height of the line
              color:
                  const Color.fromRGBO(125, 125, 125, 0.7), // Color of the line
            ),
          ),
        ),
      ],
    );
  }
}
