//globals.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cluedin_app/screens/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

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

Future<File> createFileOfPdfUrl(String filrUrl, BuildContext context,
    {bool includeAuthHeader = false}) async {
  Completer<File> completer = Completer();
  print("Start download file from internet!");
  try {
    final url = filrUrl;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));

    // Add authorization header if required
    if (includeAuthHeader) {
      var token = Hive.box('userBox').get("token");
      request.headers.set('Authorization', 'Bearer $token');
    }

    var response = await request.close();

    if (response.statusCode == 200) {
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory();
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");

      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } else {
      final error = await response.transform(utf8.decoder).join();
      final errorJson = jsonDecode(error);
      var message = errorJson['msg'];

      if (message != null && message.toLowerCase().contains('unauthorized')) {
        // Handle unauthorized access
        NavbarNotifier.hideBottomNavBar = true;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => const LoginPage()), (r) => false);
        final box = await Hive.openBox("UserBox");
        await box.clear();

        Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } else {
        // Handle other error messages
        throw Exception('Failed to download file: $message');
      }
    }
  } catch (e) {
    throw Exception('Error downloading file: $e');
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
