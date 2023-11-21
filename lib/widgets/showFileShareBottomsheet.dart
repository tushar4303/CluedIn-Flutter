import 'package:cluedin_app/utils/shareAndDownloadFiles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

void showFileOptionsBottomSheet(BuildContext context, String fileUrl) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (BuildContext context) {
      return Container(
        height: MediaQuery.of(context).size.height *
            0.2, // Adjust the height as needed
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8, bottom: 8),
              width: 40.0,
              height: 5.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: Colors.grey,
              ),
            ),
            ListTile(
              leading: LottieBuilder.asset(
                'assets/lottiefiles/share.json', // Replace with the actual path to your Lottie animation
                width: 28, // Adjust the width as needed
                height: 28, // Adjust the height as needed
                fit: BoxFit.cover,
                reverse: true,
              ),
              title: const Text(
                'Share File',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(30, 29, 29, 0.8)),
              ),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                ShareAndDownloadFiles.shareFile(fileUrl);
              },
            ),
            const Divider(
              thickness: 0.5,
              color: Colors.grey,
            ),
            ListTile(
              leading: LottieBuilder.asset(
                'assets/lottiefiles/download.json', // Replace with the actual path to your Lottie animation
                width: 28, // Adjust the width as needed
                height: 28, // Adjust the height as needed
                fit: BoxFit.cover,
                reverse: true,
              ),
              title: const Text(
                'Download File',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color.fromRGBO(30, 29, 29, 0.8)),
              ),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                ShareAndDownloadFiles.downloadFile(fileUrl);
                Fluttertoast.showToast(
                  msg: "Saved to Downloads",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
