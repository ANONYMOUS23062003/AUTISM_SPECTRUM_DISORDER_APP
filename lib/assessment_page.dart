import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssessmentPage extends StatefulWidget {
  const AssessmentPage({super.key});

  @override
  AssessmentPageState createState() => AssessmentPageState();
}

class AssessmentPageState extends State<AssessmentPage> {
  final List<String> _questions = [
    '1. Does your child look at you when you call his/her name?',
    '2. How easy is it for you to get eye contact with your child?',
    '3. Does your child point to indicate that s/he wants something?',
    '4. Does your child point to share interest with you?',
    '5. Does your child pretend? (e.g. care for dolls, talk on a toy phone)',
    '6. Does your child follow where you’re looking?',
    '7. If you or someone else in the family is visibly upset, does your child show signs of wanting to comfort them?',
    '8. Would you describe your child’s first words as:',
    '9. Does your child use simple gestures? (e.g. wave goodbye)',
    '10. Does your child stare at nothing with no apparent purpose?'
  ];

  final List<List<String>> _options = [
    ['Always', 'Usually', 'Sometimes', 'Rarely', 'Never'], // Question 1
    [
      'Very easy',
      'Quite easy',
      'Quite difficult',
      'Very difficult',
      'Impossible'
    ], // Question 2
    [
      'Many times a day',
      'A few times a day',
      'A few times a week',
      'Less than once a week',
      'Never'
    ], // Question 3
    [
      'Many times a day',
      'A few times a day',
      'A few times a week',
      'Less than once a week',
      'Never'
    ], // Question 4
    [
      'Many times a day',
      'A few times a day',
      'A few times a week',
      'Less than once a week',
      'Never'
    ], // Question 5
    [
      'Many times a day',
      'A few times a day',
      'A few times a week',
      'Less than once a week',
      'Never'
    ], // Question 6
    ['Always', 'Usually', 'Sometimes', 'Rarely', 'Never'], // Question 7
    [
      'Very typical',
      'Quite typical',
      'Slightly unusual',
      'Very unusual',
      'My child does not speak'
    ], // Question 8
    [
      'Many times a day',
      'A few times a day',
      'A few times a week',
      'Less than once a week',
      'Never'
    ], // Question 9
    [
      'Many times a day',
      'A few times a day',
      'A few times a week',
      'Less than once a week',
      'Never'
    ],
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: AppBar(
        title: const Text('Assessment'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ...List.generate(_questions.length, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _questions[index],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal[900],
                      ),
                    ),
                    Column(
                      children:
                          List.generate(_options[index].length, (optIndex) {
                        return RadioListTile<String>(
                          title: Text(_options[index][optIndex]),
                          value: _options[index][optIndex],
                          groupValue: _answers[index],
                          onChanged: (value) {
                            setState(() {
                              _answers[index] = value;
                            });
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }),
              ElevatedButton(
                onPressed: () {
                  if (_areAllQuestionsAnswered()) {
                    saveAssessmentToFirestore();
                    calculateScoreAndShowDialog(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('All questions are compulsory!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String?> _answers = [];

  @override
  void initState() {
    super.initState();
    _answers = List<String?>.filled(_questions.length, null);
  }

  bool _areAllQuestionsAnswered() {
    return !_answers.contains(null);
  }

  // Save assessment data to Firestore
  Future<void> saveAssessmentToFirestore() async {
    try {
      final docRef = FirebaseFirestore.instance.collection('assessments').doc();
      await docRef.set({
        'questions': _questions,
        'answers': _answers,
        'timestamp': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Assessment submitted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting assessment: $e')),
      );
    }
  }

  void calculateScoreAndShowDialog(BuildContext context) {
    int totalScore = 0;

    for (int i = 0; i < _answers.length; i++) {
      if (i < 9) {
        // For Questions 1 to 9
        if (_answers[i] == _options[i][2] || // C
            _answers[i] == _options[i][3] || // D
            _answers[i] == _options[i][4]) {
          // E
          totalScore += 1;
        }
      } else if (i == 9) {
        // For Question 10
        if (_answers[i] == _options[i][0] || // A
            _answers[i] == _options[i][1] || // B
            _answers[i] == _options[i][2]) {
          // C
          totalScore += 1;
        }
      }
    }

    String message = 'Your total score is $totalScore out of 10.\n\n';

    // Append diagnostic message based on the total score
    if (totalScore <= 3) {
      message += 'Your child may not show significant signs of ASD.';
    } else if (totalScore <= 6) {
      message +=
          'Your child may show some signs of ASD. Consider consulting a doctor.';
    } else {
      message +=
          'Your child may have a severe form of ASD. Please consult a doctor immediately.';
    }

    // Display dialog with the score and message
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Assessment Result'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
