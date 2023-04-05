// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:cluedin_app/widgets/navigation_controls.dart';
import 'package:cluedin_app/widgets/web_view_stack.dart';

class WebViewApp extends StatefulWidget {
  const WebViewApp({
    Key? key,
    this.webViewTitle = "Flutter WebView",
    required this.webViewLink,
  }) : super(key: key);
  final String webViewTitle;
  final String webViewLink;

  @override
  State<WebViewApp> createState() => _WebViewAppState();
}

class _WebViewAppState extends State<WebViewApp> {
  // Add from here...
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(
        Uri.parse(widget.webViewLink),
      );
  }
  // ...to here.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.webViewTitle),
        // Add from here...
        actions: [
          NavigationControls(controller: controller),
        ],
        // ...to here.
      ),
      body: WebViewStack(controller: controller), // MODIFY
    );
  }
}
