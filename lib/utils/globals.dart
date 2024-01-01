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

List<String> extractYouTubeLinks(String message) {
  final RegExp regex =
      RegExp(r'(https?://)?(www\.)?(youtube|youtu|youtube-nocookie)\.(com|be)/'
          '(watch\?v=|embed/|v/|.+\?v=)?([^&=%\?]{11})');
  final Iterable<RegExpMatch> matches = regex.allMatches(message);
  return matches.map((match) => match.group(0)!).toList();
}
