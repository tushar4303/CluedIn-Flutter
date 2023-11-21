import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoResultsFound extends StatelessWidget {
  final VoidCallback onResetFiltersPressed;

  const NoResultsFound({super.key, required this.onResetFiltersPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.025,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 32),
          child: Lottie.asset('assets/lottiefiles/noResults.json'),
        ),
        const SizedBox(height: 18),
        const Text(
          'No Results Found',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        const Text(
          'Use fewer filters or reset all filters',
          style: TextStyle(
              fontSize: 18, color: Color.fromRGBO(109, 109, 109, 0.8)),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            // Handle reset filters button press
            onResetFiltersPressed();
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            visualDensity: VisualDensity.adaptivePlatformDensity,
            backgroundColor: MaterialStateProperty.all(Colors.black),
          ),
          child: const Text(
            'Reset all filters',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
