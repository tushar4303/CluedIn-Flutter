import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.035,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          child: SvgPicture.asset(
            "assets/images/offline.svg",
            height: MediaQuery.of(context).size.height * 0.45,
          ),
        ),
        const Text(
          'Well, this is awkward!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 30, 29, 29),
          ),
        ),
        const Text(
          'We don\'t seem to be connected...',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color.fromARGB(255, 30, 29, 29),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              visualDensity: VisualDensity.comfortable,
              backgroundColor: MaterialStateProperty.all(Colors.black),
            ),
            clipBehavior: Clip.hardEdge,
            child: const Text(
              "Try again",
              style: TextStyle(color: Colors.white),
            ),
            onPressed: onRetry,
          ),
        )
      ],
    );
  }
}
