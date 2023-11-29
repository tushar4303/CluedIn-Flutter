// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cluedin_app/widgets/ticket.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// class MyTickets extends StatelessWidget {
//   const MyTickets({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           automaticallyImplyLeading: false,
//           toolbarHeight: MediaQuery.of(context).size.height * 0.096,
//           elevation: 0.3,
//           title: Transform(
//             transform: Matrix4.translationValues(8.0, -5.6, 0),
//             child: const Text(
//               "My Tickets",
//               textAlign: TextAlign.left,
//               textScaler: TextScaler.linear(1.3),
//               style: TextStyle(color: Color.fromARGB(0, 115, 115, 115)),
//             ),
//           )),
//       body: SafeArea(
//         child: Center(
//           child: Container(
//             height: 464,
//             margin: const EdgeInsets.all(32),
//             width: MediaQuery.of(context).size.width * 0.7,
//             child: CustomPaint(
//               painter: TicketPainter(
//                 borderColor: Colors.black45,
//                 bgColor: Colors.white,
//               ),
//               child:
//                   Column(mainAxisAlignment: MainAxisAlignment.end, children: [
//                 Expanded(
//                     child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: ClipRRect(
//                       borderRadius:
//                           const BorderRadius.all(Radius.circular(14.0)),
//                       child: CachedNetworkImage(
//                         imageUrl:
//                             "https://cdn.discordapp.com/attachments/989274745495240734/1163584869847281704/Jon__black_lotus_scientific_infographic_poster_mtg_c88ca790-3628-4a8b-af81-89bc637a31fb.png?ex=65401bdb&is=652da6db&hm=706304a97f247a90c3f94443114a31d5b73ef3e9c08109ac265515138c",
//                         fit: BoxFit.fill,
//                         placeholder: (context, url) {
//                           return Image.asset(
//                             "assets/images/placeholder_landscape.png",
//                             fit: BoxFit.cover,
//                           );
//                         },
//                       ),
//                     ),
//                   ),
//                 )),
//                 const Padding(
//                   padding: EdgeInsets.only(
//                     bottom: 24,
//                   ),
//                   child: Text("Garba Raas 2023",
//                       style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 16,
//                           color: Color.fromRGBO(115, 115, 115, 1))),
//                 ),
//                 const Padding(
//                   padding: EdgeInsets.only(left: 32, right: 32),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       Text("Date: April 23",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 16,
//                               color: Color.fromRGBO(115, 115, 115, 1))),
//                       Text(
//                         "Time: 6 p.m.",
//                         style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: 16,
//                             color: Color.fromRGBO(115, 115, 115, 1)),
//                       )
//                     ],
//                   ),
//                 ),
//                 Padding(
//                   padding: EdgeInsets.only(
//                     bottom: 16,
//                   ),
// //                   child: Center(
//                     child: QrImageView(
//                       eyeStyle: const QrEyeStyle(
//                           color: Color.fromRGBO(115, 115, 115, 1)),
//                       dataModuleStyle: const QrDataModuleStyle(
//                           color: Color.fromRGBO(115, 115, 115, 1)),
//                       data: 'https://github.com/tushar4303/CluedIn-Flutter',
//                       version: QrVersions.auto,
//                       size: 130,
//                       gapless: false,
//                     ),
//                   ),
//                 )
//               ]),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:io';
import 'dart:ui' as ui;
import 'package:cluedin_app/widgets/ticket.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyTickets extends StatefulWidget {
  const MyTickets({Key? key}) : super(key: key);

  @override
  _MyTicketsState createState() => _MyTicketsState();
}

class _MyTicketsState extends State<MyTickets> {
  final GlobalKey _globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // ... (Your existing app bar code)
          ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Container(
              height: 600,
              margin: const EdgeInsets.all(32),
              width: MediaQuery.of(context).size.width * 0.55,
              child: RepaintBoundary(
                key: _globalKey,
                child: CustomPaint(
                  painter: TicketPainter(
                    borderColor: Colors.black45,
                    bgColor: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(14.0)),
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://cdn.discordapp.com/attachments/989274745495240734/1163584869847281704/Jon__black_lotus_scientific_infographic_poster_mtg_c88ca790-3628-4a8b-af81-89bc637a31fb.png?ex=65401bdb&is=652da6db&hm=706304a97f247a90c3f94443114a31d5b73ef3e9c08109ac265515138c",
                              fit: BoxFit.fill,
                              placeholder: (context, url) {
                                return Image.asset(
                                  "assets/images/placeholder_landscape.png",
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        ),
                      )),
                      // const Padding(
                      //   padding: EdgeInsets.only(
                      //     bottom: 24,
                      //   ),
                      //   child: Text("Garba Raas 2023",
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w600,
                      //           fontSize: 16,
                      //           color: Color.fromRGBO(115, 115, 115, 1))),
                      // ),
                      // const Padding(
                      //   padding: EdgeInsets.only(left: 32, right: 32),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //     children: [
                      //       Text("Date: April 23",
                      //           style: TextStyle(
                      //               fontWeight: FontWeight.w600,
                      //               fontSize: 16,
                      //               color: Color.fromRGBO(115, 115, 115, 1))),
                      //       Text(
                      //         "Time: 6 p.m.",
                      //         style: TextStyle(
                      //             fontWeight: FontWeight.w600,
                      //             fontSize: 16,
                      //             color: Color.fromRGBO(115, 115, 115, 1)),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(
                        height: 0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Center(
                          child: QrImageView(
                            eyeStyle: const QrEyeStyle(
                                color: Color.fromRGBO(115, 115, 115, 1)),
                            dataModuleStyle: const QrDataModuleStyle(
                                color: Color.fromRGBO(115, 115, 115, 1)),
                            data:
                                'https://github.com/tushar4303/CluedIn-Flutter',
                            version: QrVersions.auto,
                            size: 150,
                            gapless: false,
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          captureAndSavePng();
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  Future<void> captureAndSavePng() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      double pixelRatio =
          5.0; // Set the pixel ratio to a higher value for 4K resolution
      ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Save the image to the device's gallery or other desired location
      saveImageToDevice(pngBytes);

      print("Image saved successfully!");
    } catch (e) {
      print("Error capturing or saving image: $e");
    }
  }

  void saveImageToDevice(Uint8List pngBytes) async {
    final Directory? appDirectory = await getExternalStorageDirectory();
    final String storagePath = appDirectory!.path;
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$storagePath/my_ticket_$timestamp.png';

    final File file = File(filePath);
    await file.writeAsBytes(pngBytes);

    // Show a toast or notification that the image has been saved
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Image saved to $filePath'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
