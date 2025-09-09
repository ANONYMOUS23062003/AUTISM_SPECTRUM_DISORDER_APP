import 'package:flutter/material.dart';
class FeedbackPage extends StatelessWidget {
  final TextEditingController feedbackController = TextEditingController();

  FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/profile.png'), // Replace with your profile image
              radius: 40,
            ),
            const SizedBox(height: 10),
            const Text('Name', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text('Please Send Your Feedback', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sentiment_satisfied, size: 40),
                SizedBox(width: 10),
                Icon(Icons.sentiment_very_satisfied, size: 40),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: feedbackController,
              decoration: const InputDecoration(
                hintText: 'Type Your Message...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logic to handle sending feedback
                final feedback = feedbackController.text;
                if (feedback.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Feedback sent successfully!')),
                  );
                  feedbackController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter some feedback!')),
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        ),
      ),
    );
  }
}
