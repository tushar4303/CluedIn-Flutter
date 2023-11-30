import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorView extends StatelessWidget {
  final VoidCallback onRetry;
  final String customTitle;
  final String errorCode;
  final String customSubtitle;
  final String lottieJson;

  const ErrorView({
    Key? key,
    required this.onRetry,
    this.customTitle = 'Well, this is awkward!',
    this.errorCode = 'We don\'t seem to be connected...',
    this.customSubtitle = 'Check your internet and try again',
    this.lottieJson = 'assets/lottiefiles/noInternet.json',
  }) : super(key: key);

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
          child: Lottie.asset(lottieJson),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Text(
            customTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Text(
            errorCode,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              color: Color.fromRGBO(109, 109, 109, 0.8),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Text(
            textAlign: TextAlign.center,
            customSubtitle,
            style: const TextStyle(
                fontSize: 18, color: Color.fromRGBO(109, 109, 109, 0.8)),
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
