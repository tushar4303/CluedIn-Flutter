// image_utils.dart

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class ShareAndDownloadFiles {
  static void shareFile(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final fileName = imageUrl.split('/').last;
        File file = await File('${directory.path}/$fileName')
            .writeAsBytes(response.bodyBytes);
        await Share.shareXFiles([XFile(file.path)], text: 'Share');
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      print('Error: $e');
      // Handle the error as needed
    }
  }

  static void downloadFile(String imageUrl) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        // Get the Downloads directory
        var downloadsDirectory = await getDownloadsDirectory();
        final fileName = imageUrl.split('/').last;

        if (Platform.isAndroid) {
          // If Android, adjust the path to point to /Download/
          downloadsDirectory = Directory('/storage/emulated/0/Download/');
        }

        // Create a File instance with the desired path
        final file = File('${downloadsDirectory!.path}/$fileName');

        // Write the downloaded image to the file
        await file.writeAsBytes(response.bodyBytes);

        // Display a message or perform any other actions as needed
        print('Downloaded and saved to ${file.path}');
      } else {
        // Handle the case when the image download fails
        print('Failed to download File');
      }
    } catch (e) {
      // Handle any exceptions that may occur during the download process
      print('Error: $e');
    }
  }
}
