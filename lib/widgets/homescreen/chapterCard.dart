import 'package:cached_network_image/cached_network_image.dart';
import 'package:cluedin_app/models/home.dart';
import 'package:flutter/material.dart';

import '../../screens/studentChapterPage.dart';

class ChapterCard extends StatelessWidget {
  const ChapterCard({super.key, required this.chapter});

  final StudentChapters chapter;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        right: 8.0,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StudentChapterPage(
                        chapter: chapter,
                      )));
        },
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: const Color.fromARGB(75, 158, 158, 158)
                          .withOpacity(0.2),
                      blurRadius: 0.65,
                      offset: const Offset(0.25, 0.35))
                ],
                color: const Color.fromRGBO(250, 250, 250, 1),
                borderRadius: BorderRadius.circular(
                  16.0,
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                child: Stack(children: <Widget>[
                  // Positioned.fill(
                  //     child: Image.asset(
                  //   "assets/images/csi.png",
                  //   fit: BoxFit.cover,
                  // )),
                  Positioned.fill(
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: chapter.logo,
                      placeholder: (context, url) {
                        return Image.asset(
                          "assets/images/placeholder.png",
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                  Positioned(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 60,
                        // margin: EdgeInsets.only(bottom: 10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            end: const Alignment(0.0, -1),
                            begin: const Alignment(0.0, 0.9),
                            colors: <Color>[
                              const Color.fromARGB(179, 179, 178, 178)
                                  .withOpacity(0.25),
                              const Color.fromARGB(138, 230, 227, 227)
                                  .withOpacity(0.0)
                            ],
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 12, bottom: 8, right: 10),
                            child: Text(
                              textScaleFactor: 0.9,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              chapter.title,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
