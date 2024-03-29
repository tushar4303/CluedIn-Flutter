import 'dart:async';

import 'package:cluedin_app/widgets/ErrorView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFScreen extends StatefulWidget {
  final String? path;

  const PDFScreen({super.key, this.path});

  @override
  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Document"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 8, right: 8),
        child: Stack(
          children: <Widget>[
            PDFView(
              filePath: widget.path,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: true,
              pageSnap: true,
              defaultPage: currentPage!,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation:
                  false, // if set to true the link is handled in flutter
              onRender: (pages) {
                setState(() {
                  pages = pages;
                  isReady = true;
                });
              },
              onError: (error) {
                setState(() {
                  errorMessage = error.toString();
                });
                print(error.toString());
              },
              onPageError: (page, error) {
                setState(() {
                  errorMessage = '$page: ${error.toString()}';
                });
                print('$page: ${error.toString()}');
              },
              onViewCreated: (PDFViewController pdfViewController) {
                _controller.complete(pdfViewController);
              },
              onLinkHandler: (String? uri) {
                print('goto uri: $uri');
              },
              onPageChanged: (int? page, int? total) {
                print('page change: $page/$total');
                setState(() {
                  currentPage = page;
                });
              },
            ),
            errorMessage.isEmpty
                ? !isReady
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container()
                : const ErrorView(
                    customTitle: 'Resource not found',
                    errorCode:
                        'The PDF has probably not been uploaded/updated yet. Ask your class teacher for the updates.',
                    customSubtitle: '',
                    lottieJson: 'assets/lottiefiles/noResults.json',
                  )
          ],
        ),
      ),
    );
  }
}
