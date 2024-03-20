// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cluedin_app/models/home.dart';
import 'package:cluedin_app/utils/globals.dart';
import 'package:cluedin_app/widgets/customGallery.dart';
import 'package:cluedin_app/widgets/homescreen/sectionDivider.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';

import '../widgets/webView/webview.dart';

class StudentChapterPage extends StatefulWidget {
  const StudentChapterPage({
    super.key,
    required this.chapter,
  });

  final dynamic chapter;

  @override
  State<StudentChapterPage> createState() => _StudentChapterPageState();
}

class _StudentChapterPageState extends State<StudentChapterPage> {
  late List<String> listOfUrls;

  @override
  void initState() {
    super.initState();
    listOfUrls = widget.chapter.gallery ?? [];
    convertDriveLinks(listOfUrls);
  }

  void convertDriveLinks(List<String> urls) {
    List<String> filteredUrls = [];
    for (int i = 0; i < urls.length; i++) {
      if (urls[i].contains("drive.google.com")) {
        filteredUrls.add(convertDriveLink(urls[i]));
      } else {
        filteredUrls.add(urls[i]);
      }
    }
    setState(() {
      listOfUrls = filteredUrls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Set status bar color here
        statusBarIconBrightness:
            Brightness.dark, // Set status bar icons brightness
      ),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              const SliverAppBar(
                backgroundColor: Color.fromARGB(255, 255, 255, 255),
                floating: true,
              )
            ],
            body: Padding(
              padding: const EdgeInsets.only(
                  left: 24, right: 24, bottom: 54, top: 8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 16),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(30, 29, 29, 0.8),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              widget.chapter is StudentChapters
                                  ? "Student Chapter"
                                  : "Student Club",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 8, bottom: 16),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(30, 29, 29, 0.8),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Since ${widget.chapter.establisedIn.toString()}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.chapter.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 28,
                        color: Color.fromARGB(255, 30, 29, 29),
                      ),
                    ),
                    if (widget.chapter.coverPic.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          child: Center(
                            child: CachedNetworkImage(
                              imageUrl: widget.chapter.coverPic,
                              placeholder: (context, url) {
                                return Image.asset(
                                  "assets/images/placeholder.png",
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    GestureDetector(
                      onTap: () {
                        if (FocusScope.of(context).hasPrimaryFocus) {
                          FocusScope.of(context).unfocus();
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: SelectableText(
                          widget.chapter.desc,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    if (listOfUrls
                        .isNotEmpty) // Check if there are any URLs to display
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 16, bottom: 16),
                            child: SectionDivider(text: "See what's new"),
                          ),
                          CustomImageGallery(
                            imageUrls: listOfUrls,
                            columns: 3,
                            imageSize: 120.0,
                            spacing: 8.0,
                          ),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 56),
                      child: Center(
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: const Text(
                              "Visit Website for more Info",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewApp(
                                    webViewTitle: widget.chapter.title,
                                    webViewLink: widget.chapter.website,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
