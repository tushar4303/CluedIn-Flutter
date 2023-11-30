import 'dart:io';
import 'package:cluedin_app/widgets/ErrorView.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ErrorHandlingWidget extends StatelessWidget {
  final dynamic error;
  final VoidCallback onRetry;

  const ErrorHandlingWidget({super.key, required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    String errorCode = 'Error status code: Unknown';
    String title = 'Something went wrong!';
    String subtitle = 'Hopefully Bob the builder fixes it soon';
    String errorJson = 'assets/lottiefiles/error.json';

    // Extract error information dynamically
    if (error is http.Response) {
      final http.Response response = error as http.Response;
      print(response);
      errorCode = response.statusCode.toString();
      print("code: $errorCode");

      // Handle specific HTTP status codes
      if (response.statusCode == 500) {
        errorCode = 'Error status code: 500';
        subtitle = 'Oh no, the server hiccuped! Try again in a moment.';
      } else if (response.statusCode == 404) {
        errorCode = 'Error status code: 404';
        subtitle =
            '404: Humor not found. But seriously, couldn\'t find what you were looking for.';
      }
    } else if (error is SocketException) {
      final SocketException socketException = error as SocketException;
      if (socketException.osError?.message == 'Connection refused') {
        title = "Oops, something broke!!";
        errorCode = 'Looks like the server is on a coffee break.';
        subtitle = 'Please try again later.';
        errorJson = 'assets/lottiefiles/error.json';
      } else {
        title = "Well, this is awkward!";
        errorCode = 'We don\'t seem to be connected...';
        subtitle =
            'Looks like the internet is playing hide and seek. Check your connection and try again';
        errorJson = 'assets/lottiefiles/noInternet.json';
      }
    }

    return ErrorView(
      errorCode: errorCode,
      customTitle: title,
      customSubtitle: subtitle,
      lottieJson: errorJson,
      onRetry: onRetry,
    );
  }
}
