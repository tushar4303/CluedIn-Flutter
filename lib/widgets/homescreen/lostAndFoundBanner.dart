import 'package:cluedin_app/screens/HomeScreen/calendar.dart';
import 'package:cluedin_app/screens/HomeScreen/lostAndFoundCenter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:navbar_router/navbar_router.dart';

class LostFoundCard extends StatelessWidget {
  const LostFoundCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Set NavbarNotifier.hideBottomNavBar to true when navigating to LostAndFoundPage.
        NavbarNotifier.hideBottomNavBar = true;

        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => const LostAndFoundPage()),
        ).then((value) {
          // This code block executes when LostAndFoundPage is popped.
          // Set NavbarNotifier.hideBottomNavBar to false.
          NavbarNotifier.hideBottomNavBar = false;
        });
      },
      child: Container(
        margin: const EdgeInsets.all(16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 3,
              offset: const Offset(0.0, 0.75),
            ),
          ],
          color: const Color.fromRGBO(251, 251, 252, 1),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Lottie.asset(
                'assets/lottiefiles/lost.json', // Replace 'animation.json' with your animation file
                // height: 100,
                width: 200,
              ),
            ),
            // ignore: prefer_const_constructors
            SizedBox(
              width: 12,
            ),
            const Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lost or found something?',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "Let's get it back to where it belongs!",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
