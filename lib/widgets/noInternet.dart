import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorView({super.key, required this.onRetry});

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
          padding: const EdgeInsets.only(left: 32, right: 32),
          child: Lottie.asset('assets/files/noInternet.json'),
        ),
        const SizedBox(height: 18),
        const Text(
          'Well, this is awkward!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'We don\'t seem to be connected...',
          style: TextStyle(
            fontSize: 18,
            color: Color.fromRGBO(109, 109, 109, 0.8),
          ),
        ),
        const Text(
          'Check your internet and try again',
          style: TextStyle(
              fontSize: 18, color: Color.fromRGBO(109, 109, 109, 0.8)),
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
              visualDensity: VisualDensity.adaptivePlatformDensity,
              backgroundColor: MaterialStateProperty.all(Colors.black),
            ),
            clipBehavior: Clip.hardEdge,
            onPressed: onRetry,
            child: const Text(
              "Try again",
              style: TextStyle(color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
