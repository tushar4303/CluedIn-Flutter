//globals.dart

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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

Future<File> createFileOfPdfUrl(String filrUrl) async {
  Completer<File> completer = Completer();
  print("Start download file from internet!");
  try {
    final url = filrUrl;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    var dir = await getApplicationDocumentsDirectory();
    print("Download files");
    print("${dir.path}/$filename");
    File file = File("${dir.path}/$filename");

    await file.writeAsBytes(bytes, flush: true);
    completer.complete(file);
  } catch (e) {
    throw Exception('Error parsing asset file!');
  }

  return completer.future;
}

List<String> extractYouTubeLinks(String message) {
  final RegExp regex =
      RegExp(r'(https?://)?(www\.)?(youtube|youtu|youtube-nocookie)\.(com|be)/'
          '(watch?v=|embed/|v/|.+?v=)?([^&=%?]{11})');
  final Iterable<RegExpMatch> matches = regex.allMatches(message);
  return matches.map((match) => match.group(0)!).toList();
}
