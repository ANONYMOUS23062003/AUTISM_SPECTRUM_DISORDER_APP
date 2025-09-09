// import 'dart:math';
// import 'package:flutter/material.dart';

// class BloodRelationGame extends StatefulWidget {
//   const BloodRelationGame({super.key});

//   @override
//   // ignore: library_private_types_in_public_api
//   _BloodRelationGameState createState() => _BloodRelationGameState();
// }

// class _BloodRelationGameState extends State<BloodRelationGame> {
//   final List<Map<String, String>> questions = [
//     {
//       'question': 'My mother\'s daughter is my?',
//       'answer': 'SISTER',
//       'image': 'sister.png',
//     },
//     {
//       'question': 'My father\'s father is my?',
//       'answer': 'GRANDFATHER',
//       'image': 'grandfather.jpg',
//     },
//     {
//       'question': 'My mother\'s son is my?',
//       'answer': 'BROTHER',
//       'image': 'brother.png',
//     },
//     {
//       'question': 'My mother\'s sister is my?',
//       'answer': 'AUNT',
//       'image': 'aunt.jpg',
//     },
//     {
//       'question': 'My father\'s brother is my?',
//       'answer': 'UNCLE',
//       'image': 'uncle.jpg',
//     },
//     {
//       'question': 'The people who gave birth to me are my?',
//       'answer': 'PARENTS',
//       'image': 'parents.jpg',
//     },
//     {
//       'question': 'My father\'s mother is my?',
//       'answer': 'GRANDMOTHER',
//       'image': 'grandmother.jpg',
//     },
//     {
//       'question': 'The person who teaches me is my?',
//       'answer': 'TEACHER',
//       'image': 'teacher.jpg',
//     },
//     // Add more relations here...
//   ];

//   String currentQuestion = '';
//   String currentAnswer = '';
//   String currentImage = '';
//   List<String> shuffledLetters = [];
//   List<String> userAnswer = [];
//   int currentIndex = 0;
//   List<Map<String, String>> shuffledQuestions = [];

//   @override
//   void initState() {
//     super.initState();
//     shuffleQuestions();
//     generateQuestion();
//   }

//   // Function to shuffle the list of questions at the start.
//   void shuffleQuestions() {
//     shuffledQuestions = List.from(questions);
//     shuffledQuestions.shuffle();
//   }

//   // Function to generate the next question.
//   void generateQuestion() {
//     if (currentIndex < shuffledQuestions.length) {
//       setState(() {
//         currentQuestion = shuffledQuestions[currentIndex]['question']!;
//         currentAnswer = shuffledQuestions[currentIndex]['answer']!;
//         currentImage = shuffledQuestions[currentIndex]['image']!;
//         shuffledLetters = shuffleLetters(currentAnswer);
//         userAnswer = List.filled(currentAnswer.length, '');
//       });
//     } else {
//       // If all questions are answered, show a completion dialog.
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Congratulations!'),
//           content: const Text('You have completed all the questions!'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 resetGame();
//               },
//               child: const Text('Restart Game'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   // Function to reset the game and shuffle the questions again.
//   void resetGame() {
//     setState(() {
//       currentIndex = 0;
//       shuffleQuestions();
//       generateQuestion();
//     });
//   }

//   // Shuffle the answer letters with additional random letters.
//   List<String> shuffleLetters(String word) {
//     List<String> letters = word.split('') + generateRandomLetters(word.length);
//     letters.shuffle();
//     return letters;
//   }

//   // Generate random letters to mix with the correct answer letters.
//   List<String> generateRandomLetters(int count) {
//     const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
//     Random random = Random();
//     return List.generate(
//         count, (index) => alphabet[random.nextInt(alphabet.length)]);
//   }

//   // Check if the user has correctly answered the question.
//   void checkAnswer() {
//     if (userAnswer.join() == currentAnswer) {
//       // Show success message and move to next question.
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Correct!'),
//           content: const Text('You got it right!'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 setState(() {
//                   currentIndex++;
//                   generateQuestion();
//                 });
//               },
//               child: const Text('Next Question'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Blood Relations Game')),
//       body: Column(
//         children: [
//           // Display character image for the current question.
//           Image.asset(
//             currentImage,
//             height: 150,
//           ),
//           const SizedBox(height: 20),

//           // Display the question text.
//           Text(
//             currentQuestion,
//             style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 20),

//           // Display the answer slots where the user will place letters.
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(
//               currentAnswer.length,
//               (index) {
//                 return Container(
//                   width: 40,
//                   height: 40,
//                   margin: const EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.blueAccent),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Center(
//                     child: Text(
//                       userAnswer[index],
//                       style: const TextStyle(
//                           fontSize: 24, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//           const SizedBox(height: 20),

//           // Display the shuffled letters for the user to select.
//           Wrap(
//             spacing: 8,
//             runSpacing: 8,
//             alignment: WrapAlignment.center,
//             children: List.generate(
//               shuffledLetters.length,
//               (index) {
//                 return GestureDetector(
//                   onTap: () {
//                     for (int i = 0; i < userAnswer.length; i++) {
//                       if (userAnswer[i] == '') {
//                         setState(() {
//                           userAnswer[i] = shuffledLetters[index];
//                           shuffledLetters[index] = '';
//                         });
//                         break;
//                       }
//                     }
//                     checkAnswer();
//                   },
//                   child: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: shuffledLetters[index] != ''
//                           ? Colors.blueAccent
//                           : Colors.grey,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Center(
//                       child: Text(
//                         shuffledLetters[index],
//                         style: const TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           const SizedBox(height: 20),

//           // Button to reload or reshuffle the letters.
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 userAnswer = List.filled(currentAnswer.length, '');
//                 shuffledLetters = shuffleLetters(currentAnswer);
//               });
//             },
//             child: const Text('Reload Letters'),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BloodRelationGame extends StatefulWidget {
  const BloodRelationGame({super.key});

  @override
  BloodRelationGameState createState() => BloodRelationGameState();
}

class BloodRelationGameState extends State<BloodRelationGame> {
  final List<Map<String, String>> questions = [
    {
      'question': 'My mother\'s daughter is my?',
      'answer': 'SISTER',
      'image': 'sister.png',
    },
    {
      'question': 'My father\'s father is my?',
      'answer': 'GRANDFATHER',
      'image': 'grandfather.jpg',
    },
    {
      'question': 'My mother\'s son is my?',
      'answer': 'BROTHER',
      'image': 'brother.png',
    },
    {
      'question': 'My mother\'s sister is my?',
      'answer': 'AUNT',
      'image': 'aunt.jpg',
    },
    {
      'question': 'My father\'s brother is my?',
      'answer': 'UNCLE',
      'image': 'uncle.jpg',
    },
    {
      'question': 'The people who gave birth to me are my?',
      'answer': 'PARENTS',
      'image': 'parents.jpg',
    },
    {
      'question': 'My father\'s mother is my?',
      'answer': 'GRANDMOTHER',
      'image': 'grandmother.jpg',
    },
    {
      'question': 'The person who teaches me is my?',
      'answer': 'TEACHER',
      'image': 'teacher.jpg',
    },
  ];

  final String gameName = 'Blood Relation Game';
  int score = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String currentQuestion = '';
  String currentAnswer = '';
  String currentImage = '';
  List<String> shuffledLetters = [];
  List<String> userAnswer = [];
  int currentIndex = 0;
  List<Map<String, String>> shuffledQuestions = [];

  @override
  void initState() {
    super.initState();
    shuffleQuestions();
    generateQuestion();
  }

  void shuffleQuestions() {
    shuffledQuestions = List.from(questions);
    shuffledQuestions.shuffle();
  }

  void generateQuestion() {
    if (currentIndex < shuffledQuestions.length) {
      setState(() {
        currentQuestion = shuffledQuestions[currentIndex]['question']!;
        currentAnswer = shuffledQuestions[currentIndex]['answer']!;
        currentImage = shuffledQuestions[currentIndex]['image']!;
        shuffledLetters = shuffleLetters(currentAnswer);
        userAnswer = List.filled(currentAnswer.length, '');
      });
    } else {
      showCompletionDialog();
    }
  }

  void resetGame() {
    setState(() {
      score = 0;
      currentIndex = 0;
      shuffleQuestions();
      generateQuestion();
    });
  }

  List<String> shuffleLetters(String word) {
    List<String> letters = word.split('') + generateRandomLetters(word.length);
    letters.shuffle();
    return letters;
  }

  List<String> generateRandomLetters(int count) {
    const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    Random random = Random();
    return List.generate(
        count, (index) => alphabet[random.nextInt(alphabet.length)]);
  }

  Future<void> saveScoreToFirebase() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      final String email = user?.email ?? 'Anonymous';

      await _firestore.collection('scores').add({
        'user': email, // Use the logged-in user's email.
        'game': gameName, // Add the game name.
        'score': score,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error saving score: $e');
    }
  }

  void checkAnswer() {
    if (userAnswer.join() == currentAnswer) {
      setState(() {
        score += 10; // Increment score.
      });

      // Save the score and game name to Firebase.
      saveScoreToFirebase();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Correct!'),
          content: const Text('You got it right!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  currentIndex++;
                  generateQuestion();
                });
              },
              child: const Text('Next Question'),
            ),
          ],
        ),
      );
    }
  }

  void showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Congratulations!'),
        content: Text(
            'You have completed all the questions! Your final score is $score.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              resetGame();
            },
            child: const Text('Restart Game'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blood Relations Game')),
      body: Column(
        children: [
          Image.asset(
            currentImage,
            height: 150,
          ),
          const SizedBox(height: 20),
          Text(
            currentQuestion,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              currentAnswer.length,
              (index) {
                return Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      userAnswer[index],
                      style: const TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: List.generate(
              shuffledLetters.length,
              (index) {
                return GestureDetector(
                  onTap: () {
                    for (int i = 0; i < userAnswer.length; i++) {
                      if (userAnswer[i] == '') {
                        setState(() {
                          userAnswer[i] = shuffledLetters[index];
                          shuffledLetters[index] = '';
                        });
                        break;
                      }
                    }
                    checkAnswer();
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: shuffledLetters[index] != ''
                          ? Colors.blueAccent
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        shuffledLetters[index],
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                userAnswer = List.filled(currentAnswer.length, '');
                shuffledLetters = shuffleLetters(currentAnswer);
              });
            },
            child: const Text('Reload Letters'),
          ),
        ],
      ),
    );
  }
}
