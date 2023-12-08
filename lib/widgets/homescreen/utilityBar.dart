import 'package:cluedin_app/screens/HomeScreen/calendar.dart';
import 'package:cluedin_app/widgets/webView/webview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class utilityBar extends StatelessWidget {
  const utilityBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        // border: Border.all(color: Colors.grey.withOpacity(0.025)),
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 3,
              offset: const Offset(0.0, 0.75))
        ],
        color: const Color.fromRGBO(251, 251, 252, 1),
        borderRadius: BorderRadius.circular(
          16.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.black12, //color of border
                        width: 0.15, //width of border
                      ),
                      color: const Color.fromRGBO(242, 242, 242, 1)),
                  child: Column(
                    children: [
                      // IconButton(
                      //   iconSize: 30,
                      //   icon: const Icon(Icons.calendar_today),
                      //   color: Colors.black.withOpacity(0.8),
                      //   // tooltip: 'Increase volume by 10',
                      //   onPressed: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => const WebViewApp(
                      //                   webViewTitle: 'Class Timetable',
                      //                   webViewLink:
                      //                       'http://cluedin.creast.in:5000/file/nm-1679524971299-AdminLTE%203%20%20DataTables.pdf',
                      //                 )));
                      //   },
                      // ),
                      IconButton(
                        iconSize: 30,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WebViewApp(
                                webViewTitle: 'Class Timetable',
                                webViewLink:
                                    'http://cluedin.creast.in:5000/file/nm-1679524971299-AdminLTE%203%20%20DataTables.pdf',
                              ),
                            ),
                          );
                        },
                        // Instead of Icon, use Lottie.asset
                        icon: LottieBuilder.asset(
                          'assets/lottiefiles/timetable.json', // Replace with the actual path to your Lottie animation
                          width: 30, // Adjust the width as needed
                          height: 30, // Adjust the height as needed
                          fit: BoxFit.cover,
                          repeat: false,
                          reverse:
                              true, // Set this to true to play the animation in reverse
                        ),
                        color: Colors.black.withOpacity(0.8),
                        // Add tooltip if needed
                        tooltip: 'Timetable',
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  "Timetable",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                )
              ],
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.black12, //color of border
                        width: 0.15, //width of border
                      ),
                      color: const Color.fromRGBO(242, 242, 242, 1)),
                  child: Column(
                    children: [
                      IconButton(
                        iconSize: 30,
                        icon: LottieBuilder.asset(
                          'assets/lottiefiles/library.json', // Replace with the actual path to your Lottie animation
                          width: 30, // Adjust the width as needed
                          height: 30, // Adjust the height as needed
                          fit: BoxFit.cover,
                          repeat: false,

                          reverse: true,
                        ),
                        color: Colors.black.withOpacity(0.8),
                        // tooltip: 'Increase volume by 10',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WebViewApp(
                                        webViewTitle: "E-Library services",
                                        webViewLink: 'http://opac.dbit.in/',
                                      )));
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  "E-library",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                )
              ],
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.black12, //color of border
                        width: 0.15, //width of border
                      ),
                      color: const Color.fromRGBO(242, 242, 242, 1)),
                  child: Column(
                    children: [
                      IconButton(
                        iconSize: 30,
                        icon: LottieBuilder.asset(
                          'assets/lottiefiles/moodle.json', // Replace with the actual path to your Lottie animation
                          width: 30, // Adjust the width as needed
                          height: 30, // Adjust the height as needed
                          fit: BoxFit.cover,
                          repeat: false,
                          reverse: true,
                        ),
                        color: Colors.black.withOpacity(0.8),
                        // tooltip: 'Increase volume by 10',
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const WebViewApp(
                                        webViewTitle: "Moodle E-learn",
                                        webViewLink: 'https://elearn.dbit.in/',
                                      )));
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  "Moodle",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                )
              ],
            ),
            Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(
                        color: Colors.black12, //color of border
                        width: 0.15, //width of border
                      ),
                      color: const Color.fromRGBO(242, 242, 242, 1)),
                  child: Column(
                    children: [
                      IconButton(
                        iconSize: 30,
                        icon: LottieBuilder.asset(
                          'assets/lottiefiles/academicCalendar.json', // Replace with the actual path to your Lottie animation
                          width: 30, // Adjust the width as needed
                          height: 30, // Adjust the height as needed
                          fit: BoxFit.cover,
                          repeat: false,
                          reverse: true,
                        ),
                        color: Colors.black.withOpacity(0.8),
                        // tooltip: 'Increase volume by 10',
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => const MonthViewWidget()),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                const Text(
                  "TermPlan",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
