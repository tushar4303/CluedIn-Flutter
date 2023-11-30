//globals.dart

import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

String convertDriveLink(String originalLink) {
  final RegExp regExp = RegExp(r"/file/d/(.*?)/");
  final Match? match = regExp.firstMatch(originalLink);

  if (match != null && match.groupCount == 1) {
    final fileId = match.group(1);
    return 'https://drive.google.com/uc?id=$fileId';
  } else {
    // If the regex doesn't match, return the original link
    return originalLink;
  }
}
