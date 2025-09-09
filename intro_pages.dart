import 'package:flutter/material.dart';

class IntroPage extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final VoidCallback onNext;

  const IntroPage({super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent, // Background color
      body: Center(
        child:Column(
         mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
          Image.asset(imagePath, height: 250),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Text color
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              description,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white, // Text color
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: onNext,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.deepOrange, // Button color
            ),
            child: const Text('Next'),
          ),
        ],
      ),
      )
    );
  }
}

