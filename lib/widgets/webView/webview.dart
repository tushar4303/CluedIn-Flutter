import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:navbar_router/navbar_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class WebViewApp extends StatefulWidget {
  const WebViewApp({
    Key? key,
    required this.webViewTitle,
    required this.webViewLink,
  }) : super(key: key);

  final String webViewTitle;
  final String webViewLink;

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  late InAppWebViewController _webViewController;
  late String localPath;
  bool showLoading = true;
  double progress = 0.0;

  @override
  void initState() {
    super.initState();
    FlutterDownloader.registerCallback(downloadCallback);
  }

  Future<String?> findLocalPath() async {
    var externalStorageDirPath;
    if (Platform.isAndroid) {
      try {
        externalStorageDirPath = await AndroidPathProvider.documentsPath;
      } catch (e) {
        final directory = await getDownloadsDirectory();
        externalStorageDirPath = directory?.path;
      }
    } else if (Platform.isIOS) {
      externalStorageDirPath =
          (await getApplicationDocumentsDirectory()).absolute.path;
    }
    return externalStorageDirPath;
  }

  Future<void> prepareSaveDir() async {
    localPath = (await findLocalPath())!;
    final savedDir = Directory(localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
    return;
  }

  Future<bool> _checkPermission(platform) async {
    if (Platform.isIOS) return true;
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    if (platform == TargetPlatform.android &&
        androidInfo.version.sdkInt <= 28) {
      final status = await Permission.storage.status;
      // final status2 = await Permission.manageExternalStorage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        // final result2 = await Permission.manageExternalStorage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  static void downloadCallback(String id, int status, int progress) {
    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port')!;
    send.send([id, status, progress]);
    if (status == DownloadTaskStatus.complete.index) {
      // Show toast when download is finished
      Fluttertoast.showToast(
        msg: 'Download finished',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(
              'Confirm Exit',
              style:
                  TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
            ),
            content: const Text(
              'Do you want to exit the web view?',
              style: TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.webViewTitle),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (_webViewController != null) {
                  _webViewController.goBack();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                if (_webViewController != null) {
                  _webViewController.goForward();
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                if (_webViewController != null) {
                  _webViewController.reload();
                }
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.webViewLink)),
              onWebViewCreated: (controller) {
                _webViewController = controller;
              },
              onLoadStart: (controller, url) {
                // Your onLoadStart logic here
              },
              onProgressChanged: (_, newProgress) {
                setState(() {
                  progress = newProgress / 100;
                  if (newProgress >= 100) {
                    showLoading = false;
                  }
                });
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                var uri = navigationAction.request.url!;

                if (![
                  "http",
                  "https",
                  "file",
                  "chrome",
                  "data",
                  "javascript",
                  "about"
                ].contains(uri.scheme)) {
                  if (await canLaunchUrl(uri)) {
                    // Launch the App
                    await launchUrl(
                      uri,
                    );
                    // and cancel the request
                    return NavigationActionPolicy.CANCEL;
                  }
                }

                return NavigationActionPolicy.ALLOW;
              },
              onDownloadStartRequest:
                  (controller, DownloadStartRequest request) async {
                FlutterDownloader.registerCallback(downloadCallback);
                final platform = Theme.of(context).platform;
                bool value = await _checkPermission(platform);
                if (value) {
                  await prepareSaveDir();
                  {
                    final taskId = await FlutterDownloader.enqueue(
                      url: request.url.toString(),
                      savedDir: localPath,
                      showNotification: true,
                      saveInPublicStorage:
                          true, // show download progress in status bar (for Android)
                      openFileFromNotification: true,
                      // click on notification to open downloaded file (acfor Android)
                    );
                  }
                }
              },
              onLoadStop: (controller, url) {
                // Your onLoadStop logic here
              },
            ),
            if (showLoading)
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
          ],
        ),
      ),
    );
  }
}


// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// import 'package:cluedin_app/widgets/webView/navigation_controls.dart';
// import 'package:cluedin_app/widgets/webView/web_view_stack.dart';

// class WebViewApp extends StatefulWidget {
//   const WebViewApp({
//     super.key,
//     required this.webViewTitle,
//     required this.webViewLink,
//   });

//   final String webViewTitle;
//   final String webViewLink;

//   @override
//   State<WebViewApp> createState() => _WebViewAppState();
// }

// class _WebViewAppState extends State<WebViewApp> {
//   late final WebViewController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..loadRequest(
//         Uri.parse(widget.webViewLink),
//       )
//       ..clearCache();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.webViewTitle),
//         actions: [
//           NavigationControls(controller: controller),
//         ],
//       ),
//       body: WebViewStack(controller: controller),
//     );
//   }
// }
