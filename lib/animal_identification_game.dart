// // ignore: file_names
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AnimalIdentificationGame extends StatefulWidget {
  const AnimalIdentificationGame({super.key});

  @override
  _AnimalIdentificationGameState createState() =>
      _AnimalIdentificationGameState();
}

class _AnimalIdentificationGameState extends State<AnimalIdentificationGame> {
  int score = 0;
  String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'anonymous';
  final String gameName = 'Animal Identification Game'; // Name of the game

  final List<Map<String, String>> animals = [
    {'name': 'CAT', 'image': 'assets/cat.jpg'},
    {'name': 'DOG', 'image': 'assets/dog.png'},
    {'name': 'FISH', 'image': 'assets/fish.jpg'},
    {'name': 'BUTTERFLY', 'image': 'assets/butterfly.jpg'},
    {'name': 'RABBIT', 'image': 'assets/rabbit.jpg'},
    {'name': 'KANGAROO', 'image': 'assets/kangaroo.png'},
    {'name': 'FROG', 'image': 'assets/frog.jpg'},
    {'name': 'GIRAFFE', 'image': 'assets/giraffe.jpg'},
    {'name': 'TURTLE', 'image': 'assets/turtle.png'},
  ];

  String currentQuestion = '';
  String currentAnswer = '';
  String currentImage = '';
  List<String> shuffledLetters = [];
  List<String> userAnswer = [];
  int currentIndex = 0;
  List<Map<String, String>> shuffledAnimals = [];

  @override
  void initState() {
    super.initState();
    shuffleAnimals();
    generateQuestion();
  }

  void shuffleAnimals() {
    shuffledAnimals = List.from(animals);
    shuffledAnimals.shuffle();
  }

  void generateQuestion() {
    if (currentIndex < shuffledAnimals.length) {
      setState(() {
        currentQuestion = "What is this Animal Name?";
        currentAnswer = shuffledAnimals[currentIndex]['name']!;
        currentImage = shuffledAnimals[currentIndex]['image']!;
        shuffledLetters = shuffleLetters(currentAnswer);
        userAnswer = List.filled(currentAnswer.length, '');
      });
    } else {
      saveScoreToFirebase();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text('You have identified all the animals!'),
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
  }

  void resetGame() {
    setState(() {
      score = 0;
      currentIndex = 0;
      shuffleAnimals();
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

  void checkAnswer() {
    if (userAnswer.join() == currentAnswer) {
      setState(() {
        score++;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Correct!'),
          content: Text('You got it right! Your current score is $score.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  currentIndex++;
                  generateQuestion();
                });
              },
              child: const Text('Next Animal'),
            ),
          ],
        ),
      );
    } else {
      setState(() {
        if (score > 0) score--;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Incorrect!'),
          content: const Text('Try again!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> saveScoreToFirebase() async {
    try {
      await FirebaseFirestore.instance.collection('scores').add({
        'gameName': gameName,
        'email': userEmail,
        'score': score,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error saving score to Firebase: $e");
    }
  }

  void removeLastLetter() {
    setState(() {
      for (int i = userAnswer.length - 1; i >= 0; i--) {
        if (userAnswer[i] != '') {
          userAnswer[i] = '';
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animal Identification Game')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Score: $score',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Image.asset(
              currentImage,
              height: 150,
              fit: BoxFit.contain,
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
                (index) => Container(
                  width: 35,
                  height: 35,
                  margin: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      userAnswer[index],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 12,
                crossAxisSpacing: 4,
                mainAxisSpacing: 8,
              ),
              itemCount: shuffledLetters.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      for (int i = 0; i < userAnswer.length; i++) {
                        if (userAnswer[i] == '') {
                          userAnswer[i] = shuffledLetters[index];
                          shuffledLetters[index] = '';
                          break;
                        }
                      }
                    });
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      color: shuffledLetters[index] != ''
                          ? Colors.blueAccent
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Text(
                        shuffledLetters[index],
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: removeLastLetter,
                    icon: const Icon(Icons.backspace),
                    label: const Text('Backspace'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        shuffledLetters = shuffleLetters(currentAnswer);
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reload Letters'),
                  ),
                  ElevatedButton.icon(
                    onPressed: checkAnswer,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next'),
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

// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class AnimalIdentificationGame extends StatefulWidget {
//   const AnimalIdentificationGame({super.key});

//   @override
//   _AnimalIdentificationGameState createState() =>
//       _AnimalIdentificationGameState();
// }

// class _AnimalIdentificationGameState extends State<AnimalIdentificationGame> {
//   int score = 0;
//   String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'anonymous';

//   // List of animals with their names and corresponding images.
//   final List<Map<String, String>> animals = [
//     {'name': 'CAT', 'image': 'assets/cat.jpg'},
//     {'name': 'DOG', 'image': 'assets/dog.png'},
//     {'name': 'FISH', 'image': 'assets/fish.jpg'},
//     {'name': 'BUTTERFLY', 'image': 'assets/butterfly.jpg'},
//     {'name': 'RABBIT', 'image': 'assets/rabbit.jpg'},
//     {'name': 'KANGAROO', 'image': 'assets/kangaroo.png'},
//     {'name': 'FROG', 'image': 'assets/frog.jpg'},
//     {'name': 'GIRAFFE', 'image': 'assets/giraffe.jpg'},
//     {'name': 'TURTLE', 'image': 'assets/turtle.png'},
//   ];

//   String currentQuestion = '';
//   String currentAnswer = '';
//   String currentImage = '';
//   List<String> shuffledLetters = [];
//   List<String> userAnswer = [];
//   int currentIndex = 0;
//   List<Map<String, String>> shuffledAnimals = [];

//   @override
//   void initState() {
//     super.initState();
//     shuffleAnimals();
//     generateQuestion();
//   }

//   // Shuffle the animal questions.
//   void shuffleAnimals() {
//     shuffledAnimals = List.from(animals);
//     shuffledAnimals.shuffle();
//   }

//   // Generate the next question.
//   void generateQuestion() {
//     if (currentIndex < shuffledAnimals.length) {
//       setState(() {
//         currentQuestion = "What is this Animal Name?";
//         currentAnswer = shuffledAnimals[currentIndex]['name']!;
//         currentImage = shuffledAnimals[currentIndex]['image']!;
//         shuffledLetters = shuffleLetters(currentAnswer);
//         userAnswer = List.filled(currentAnswer.length, '');
//       });
//     } else {
//       // When all questions are answered, show a completion dialog and save the score.
//       saveScoreToFirebase();

//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Congratulations!'),
//           content: const Text('You have identified all the animals!'),
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

//   // Reset the game to start over.
//   void resetGame() {
//     setState(() {
//       score = 0;
//       currentIndex = 0;
//       shuffleAnimals();
//       generateQuestion();
//     });
//   }

//   // Shuffle letters from the animal name and add random letters.
//   List<String> shuffleLetters(String word) {
//     List<String> letters = word.split('') + generateRandomLetters(word.length);
//     letters.shuffle();
//     return letters;
//   }

//   // Generate random letters for distraction.
//   List<String> generateRandomLetters(int count) {
//     const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
//     Random random = Random();
//     return List.generate(
//         count, (index) => alphabet[random.nextInt(alphabet.length)]);
//   }

//   // Check if the user's answer is correct.
//   void checkAnswer() {
//     if (userAnswer.join() == currentAnswer) {
//       setState(() {
//         score++;  // Increment the score if the answer is correct
//       });
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Correct!'),
//           content: Text('You got it right! Your current score is $score.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 setState(() {
//                   currentIndex++;
//                   generateQuestion();
//                 });
//               },
//               child: const Text('Next Animal'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   // Save the score to Firebase
//   Future<void> saveScoreToFirebase() async {
//     await FirebaseFirestore.instance.collection('scores').add({
//       'email': userEmail,
//       'score': score,
//       'timestamp': FieldValue.serverTimestamp(),
//     });

//     // Optionally, show a confirmation dialog
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text('Score Saved!'),
//         content: Text('Your score of $score has been saved to Firebase!'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               resetGame();
//             },
//             child: const Text('OK'),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Animal Identification Game')),
//       body: Column(
//         children: [
//           // Display the animal image.
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Score: $score',
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Image.asset(
//             currentImage,
//             height: 150,
//           ),
//           const SizedBox(height: 20),

//           // Display the question.
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
// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class AnimalIdentificationGame extends StatefulWidget {
//   const AnimalIdentificationGame({super.key});

//   @override
//   _AnimalIdentificationGameState createState() =>
//       _AnimalIdentificationGameState();
// }

// class _AnimalIdentificationGameState extends State<AnimalIdentificationGame> {
//   int score = 0;
//   String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'anonymous';
//   final String gameName = 'Animal Identification Game';  // Name of the game

//   // List of animals with their names and corresponding images.
//   final List<Map<String, String>> animals = [
//     {'name': 'CAT', 'image': 'assets/cat.jpg'},
//     {'name': 'DOG', 'image': 'assets/dog.png'},
//     {'name': 'FISH', 'image': 'assets/fish.jpg'},
//     {'name': 'BUTTERFLY', 'image': 'assets/butterfly.jpg'},
//     {'name': 'RABBIT', 'image': 'assets/rabbit.jpg'},
//     {'name': 'KANGAROO', 'image': 'assets/kangaroo.png'},
//     {'name': 'FROG', 'image': 'assets/frog.jpg'},
//     {'name': 'GIRAFFE', 'image': 'assets/giraffe.jpg'},
//     {'name': 'TURTLE', 'image': 'assets/turtle.png'},
//   ];

//   String currentQuestion = '';
//   String currentAnswer = '';
//   String currentImage = '';
//   List<String> shuffledLetters = [];
//   List<String> userAnswer = [];
//   int currentIndex = 0;
//   List<Map<String, String>> shuffledAnimals = [];

//   @override
//   void initState() {
//     super.initState();
//     shuffleAnimals();
//     generateQuestion();
//   }

//   // Shuffle the animal questions.
//   void shuffleAnimals() {
//     shuffledAnimals = List.from(animals);
//     shuffledAnimals.shuffle();
//   }

//   // Generate the next question.
//   void generateQuestion() {
//     if (currentIndex < shuffledAnimals.length) {
//       setState(() {
//         currentQuestion = "What is this Animal Name?";
//         currentAnswer = shuffledAnimals[currentIndex]['name']!;
//         currentImage = shuffledAnimals[currentIndex]['image']!;
//         shuffledLetters = shuffleLetters(currentAnswer);
//         userAnswer = List.filled(currentAnswer.length, '');
//       });
//     } else {
//       // When all questions are answered, show a completion dialog and save the score.
//       saveScoreToFirebase();

//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Congratulations!'),
//           content: const Text('You have identified all the animals!'),
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

//   // Reset the game to start over.
//   void resetGame() {
//     setState(() {
//       score = 0;
//       currentIndex = 0;
//       shuffleAnimals();
//       generateQuestion();
//     });
//   }

//   // Shuffle letters from the animal name and add random letters.
//   List<String> shuffleLetters(String word) {
//     List<String> letters = word.split('') + generateRandomLetters(word.length);
//     letters.shuffle();
//     return letters;
//   }

//   // Generate random letters for distraction.
//   List<String> generateRandomLetters(int count) {
//     const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
//     Random random = Random();
//     return List.generate(
//         count, (index) => alphabet[random.nextInt(alphabet.length)]);
//   }

//   // Check if the user's answer is correct.
//   void checkAnswer() {
//     if (userAnswer.join() == currentAnswer) {
//       setState(() {
//         score++;  // Increment the score if the answer is correct
//       });
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Correct!'),
//           content: Text('You got it right! Your current score is $score.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 setState(() {
//                   currentIndex++;
//                   generateQuestion();
//                 });
//               },
//               child: const Text('Next Animal'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   // Save the score to Firebase
//   Future<void> saveScoreToFirebase() async {
//     try {
//       await FirebaseFirestore.instance.collection('scores').add({
//         'gameName': gameName,
//         'email': userEmail,
//         'score': score,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       // Optionally, show a confirmation dialog
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Score Saved!'),
//           content: Text('Your score of $score has been saved to Firebase!'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 resetGame();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       print("Error saving score to Firebase: $e");
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Error'),
//           content: const Text('There was an issue saving your score. Please try again.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Animal Identification Game')),
//       body: Column(
//         children: [
//           // Display the animal image.
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Score: $score',
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Image.asset(
//             currentImage,
//             height: 150,
//           ),
//           const SizedBox(height: 20),

//           // Display the question.
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
// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class AnimalIdentificationGame extends StatefulWidget {
//   const AnimalIdentificationGame({super.key});

//   @override
//   _AnimalIdentificationGameState createState() =>
//       _AnimalIdentificationGameState();
// }

// class _AnimalIdentificationGameState extends State<AnimalIdentificationGame> {
//   int score = 0;
//   String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'anonymous';
//   final String gameName = 'Animal Identification Game';  // Name of the game

//   // List of animals with their names and corresponding images.
//   final List<Map<String, String>> animals = [
//     {'name': 'CAT', 'image': 'assets/cat.jpg'},
//     {'name': 'DOG', 'image': 'assets/dog.png'},
//     {'name': 'FISH', 'image': 'assets/fish.jpg'},
//     {'name': 'BUTTERFLY', 'image': 'assets/butterfly.jpg'},
//     {'name': 'RABBIT', 'image': 'assets/rabbit.jpg'},
//     {'name': 'KANGAROO', 'image': 'assets/kangaroo.png'},
//     {'name': 'FROG', 'image': 'assets/frog.jpg'},
//     {'name': 'GIRAFFE', 'image': 'assets/giraffe.jpg'},
//     {'name': 'TURTLE', 'image': 'assets/turtle.png'},
//   ];

//   String currentQuestion = '';
//   String currentAnswer = '';
//   String currentImage = '';
//   List<String> shuffledLetters = [];
//   List<String> userAnswer = [];
//   int currentIndex = 0;
//   List<Map<String, String>> shuffledAnimals = [];

//   @override
//   void initState() {
//     super.initState();
//     shuffleAnimals();
//     generateQuestion();
//   }

//   // Shuffle the animal questions.
//   void shuffleAnimals() {
//     shuffledAnimals = List.from(animals);
//     shuffledAnimals.shuffle();
//   }

//   // Generate the next question.
//   void generateQuestion() {
//     if (currentIndex < shuffledAnimals.length) {
//       setState(() {
//         currentQuestion = "What is this Animal Name?";
//         currentAnswer = shuffledAnimals[currentIndex]['name']!;
//         currentImage = shuffledAnimals[currentIndex]['image']!;
//         shuffledLetters = shuffleLetters(currentAnswer);
//         userAnswer = List.filled(currentAnswer.length, '');
//       });
//     } else {
//       // When all questions are answered, show a completion dialog and save the score.
//       saveScoreToFirebase();

//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Congratulations!'),
//           content: const Text('You have identified all the animals!'),
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

//   // Reset the game to start over.
//   void resetGame() {
//     setState(() {
//       score = 0;
//       currentIndex = 0;
//       shuffleAnimals();
//       generateQuestion();
//     });
//   }

//   // Shuffle letters from the animal name and add random letters.
//   List<String> shuffleLetters(String word) {
//     List<String> letters = word.split('') + generateRandomLetters(word.length);
//     letters.shuffle();
//     return letters;
//   }

//   // Generate random letters for distraction.
//   List<String> generateRandomLetters(int count) {
//     const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
//     Random random = Random();
//     return List.generate(
//         count, (index) => alphabet[random.nextInt(alphabet.length)]);
//   }

//   // Check if the user's answer is correct.
//   void checkAnswer() {
//     if (userAnswer.join() == currentAnswer) {
//       setState(() {
//         score++;  // Increment the score if the answer is correct
//       });
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Correct!'),
//           content: Text('You got it right! Your current score is $score.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 setState(() {
//                   currentIndex++;
//                   generateQuestion();
//                 });
//               },
//               child: const Text('Next Animal'),
//             ),
//           ],
//         ),
//       );
//     } else {
//       // Deduct the score for incorrect answer
//       setState(() {
//         if (score > 0) score--;  // Deduct score but don't go below 0
//       });

//       // Show message for wrong answer
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Incorrect!'),
//           content: const Text('Try again!'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   // Save the score to Firebase
//   Future<void> saveScoreToFirebase() async {
//     try {
//       await FirebaseFirestore.instance.collection('scores').add({
//         'gameName': gameName,
//         'email': userEmail,
//         'score': score,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       // Optionally, show a confirmation dialog
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Score Saved!'),
//           content: Text('Your score of $score has been saved to Firebase!'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 resetGame();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       print("Error saving score to Firebase: $e");
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Error'),
//           content: const Text('There was an issue saving your score. Please try again.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   // Backspace function to remove the last entered letter.
//   void removeLastLetter() {
//     setState(() {
//       for (int i = userAnswer.length - 1; i >= 0; i--) {
//         if (userAnswer[i] != '') {
//           userAnswer[i] = '';
//           break;
//         }
//       }
//     });
//   }

//   // Next button function to move to the next question
//   void nextQuestion() {
//     setState(() {
//       if (currentIndex < shuffledAnimals.length - 1) {
//         currentIndex++;
//         generateQuestion();
//       } else {
//         // If all questions are done, show a completion message.
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Game Over'),
//             content: Text('You have completed the game with a score of $score!'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   resetGame();
//                 },
//                 child: const Text('Restart Game'),
//               ),
//             ],
//           ),
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Animal Identification Game')),
//       body: Column(
//         children: [
//           // Display the animal image.
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Score: $score',
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Image.asset(
//             currentImage,
//             height: 150,
//           ),
//           const SizedBox(height: 20),

//           // Display the question.
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

//           // Buttons for Reload, Next, and Backspace
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     userAnswer = List.filled(currentAnswer.length, '');
//                     shuffledLetters = shuffleLetters(currentAnswer);
//                   });
//                 },
//                 child: const Text('Reload Letters'),
//               ),
//               const SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: removeLastLetter,
//                 child: const Text('Backspace'),
//               ),
//               const SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: nextQuestion,
//                 child: const Text('Next'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class AnimalIdentificationGame extends StatefulWidget {
//   const AnimalIdentificationGame({super.key});

//   @override
//   _AnimalIdentificationGameState createState() =>
//       _AnimalIdentificationGameState();
// }

// class _AnimalIdentificationGameState extends State<AnimalIdentificationGame> {
//   int score = 0;
//   String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'anonymous';
//   final String gameName = 'Animal Identification Game'; // Name of the game

//   // List of animals with their names and corresponding images.
//   final List<Map<String, String>> animals = [
//     {'name': 'CAT', 'image': 'assets/cat.jpg'},
//     {'name': 'DOG', 'image': 'assets/dog.png'},
//     {'name': 'FISH', 'image': 'assets/fish.jpg'},
//     {'name': 'BUTTERFLY', 'image': 'assets/butterfly.jpg'},
//     {'name': 'RABBIT', 'image': 'assets/rabbit.jpg'},
//     {'name': 'KANGAROO', 'image': 'assets/kangaroo.png'},
//     {'name': 'FROG', 'image': 'assets/frog.jpg'},
//     {'name': 'GIRAFFE', 'image': 'assets/giraffe.jpg'},
//     {'name': 'TURTLE', 'image': 'assets/turtle.png'},
//   ];

//   String currentQuestion = '';
//   String currentAnswer = '';
//   String currentImage = '';
//   List<String> shuffledLetters = [];
//   List<String> userAnswer = [];
//   int currentIndex = 0;
//   List<Map<String, String>> shuffledAnimals = [];

//   @override
//   void initState() {
//     super.initState();
//     shuffleAnimals();
//     generateQuestion();
//   }

//   // Shuffle the animal questions.
//   void shuffleAnimals() {
//     shuffledAnimals = List.from(animals);
//     shuffledAnimals.shuffle();
//   }

//   // Generate the next question.
//   void generateQuestion() {
//     if (currentIndex < shuffledAnimals.length) {
//       setState(() {
//         currentQuestion = "What is this Animal Name?";
//         currentAnswer = shuffledAnimals[currentIndex]['name']!;
//         currentImage = shuffledAnimals[currentIndex]['image']!;
//         shuffledLetters = shuffleLetters(currentAnswer);
//         userAnswer = List.filled(currentAnswer.length, '');
//       });
//     } else {
//       // When all questions are answered, show a completion dialog and save the score.
//       saveScoreToFirebase();

//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Congratulations!'),
//           content: const Text('You have identified all the animals!'),
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

//   // Reset the game to start over.
//   void resetGame() {
//     setState(() {
//       score = 0;
//       currentIndex = 0;
//       shuffleAnimals();
//       generateQuestion();
//     });
//   }

//   // Shuffle letters from the animal name and add random letters.
//   List<String> shuffleLetters(String word) {
//     List<String> letters = word.split('') + generateRandomLetters(word.length);
//     letters.shuffle();
//     return letters;
//   }

//   // Generate random letters for distraction.
//   List<String> generateRandomLetters(int count) {
//     const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
//     Random random = Random();
//     return List.generate(
//         count, (index) => alphabet[random.nextInt(alphabet.length)]);
//   }

//   // Check if the user's answer is correct.
//   void checkAnswer() {
//     if (userAnswer.join() == currentAnswer) {
//       setState(() {
//         score++;  // Increment the score if the answer is correct
//       });
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Correct!'),
//           content: Text('You got it right! Your current score is $score.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 setState(() {
//                   currentIndex++;
//                   generateQuestion();
//                 });
//               },
//               child: const Text('Next Animal'),
//             ),
//           ],
//         ),
//       );
//     } else {
//       // Deduct the score for incorrect answer
//       setState(() {
//         if (score > 0) score--;  // Deduct score but don't go below 0
//       });

//       // Show message for wrong answer
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Incorrect!'),
//           content: const Text('Try again!'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   // Save the score to Firebase
//   Future<void> saveScoreToFirebase() async {
//     try {
//       await FirebaseFirestore.instance.collection('scores').add({
//         'gameName': gameName,
//         'email': userEmail,
//         'score': score,
//         'timestamp': FieldValue.serverTimestamp(),
//       });

//       // Optionally, show a confirmation dialog
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Score Saved!'),
//           content: Text('Your score of $score has been saved to Firebase!'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 resetGame();
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     } catch (e) {
//       print("Error saving score to Firebase: $e");
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Error'),
//           content: const Text('There was an issue saving your score. Please try again.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   // Backspace function to remove the last entered letter.
//   void removeLastLetter() {
//     setState(() {
//       for (int i = userAnswer.length - 1; i >= 0; i--) {
//         if (userAnswer[i] != '') {
//           userAnswer[i] = '';
//           break;
//         }
//       }
//     });
//   }

//   // Next button function to move to the next question
//   void nextQuestion() {
//     setState(() {
//       if (currentIndex < shuffledAnimals.length - 1) {
//         currentIndex++;
//         generateQuestion();
//       } else {
//         // If all questions are done, show a completion message.
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: const Text('Game Over'),
//             content: Text('You have completed the game with a score of $score!'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   resetGame();
//                 },
//                 child: const Text('Restart Game'),
//               ),
//             ],
//           ),
//         );
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Animal Identification Game')),
//       body: Column(
//         children: [
//           // Display the animal image.
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Text(
//               'Score: $score',
//               style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//           ),
//           Image.asset(
//             currentImage,
//             height: 150,
//           ),
//           const SizedBox(height: 20),

//           // Display the question.
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

//           // Display the shuffled letters to drag.
//           GridView.builder(
//             shrinkWrap: true,
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 6,
//               crossAxisSpacing: 10,
//               mainAxisSpacing: 10,
//             ),
//             itemCount: shuffledLetters.length,
//             itemBuilder: (context, index) {
//               return GestureDetector(
//                 onTap: () {
//                   setState(() {
//                     for (int i = 0; i < userAnswer.length; i++) {
//                       if (userAnswer[i] == '') {
//                         userAnswer[i] = shuffledLetters[index];
//                         shuffledLetters[index] = '';
//                         break;
//                       }
//                     }
//                   });
//                 },
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: shuffledLetters[index] != ''
//                         ? Colors.blueAccent
//                         : Colors.grey,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Center(
//                     child: Text(
//                       shuffledLetters[index],
//                       style: const TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),

//           // Reload, Backspace, and Next buttons.
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     userAnswer = List.filled(currentAnswer.length, '');
//                     shuffledLetters = shuffleLetters(currentAnswer);
//                   });
//                 },
//                 child: const Text('Reload Letters'),
//               ),
//               const SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: removeLastLetter,
//                 child: const Text('Backspace'),
//               ),
//               const SizedBox(width: 10),
//               ElevatedButton(
//                 onPressed: nextQuestion,
//                 child: const Text('Next'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:math';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class AnimalIdentificationGame extends StatefulWidget {
//   const AnimalIdentificationGame({super.key});

//   @override
//   _AnimalIdentificationGameState createState() =>
//       _AnimalIdentificationGameState();
// }

// class _AnimalIdentificationGameState extends State<AnimalIdentificationGame> {
//   int score = 0;
//   String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'anonymous';
//   final String gameName = 'Animal Identification Game'; // Name of the game

//   final List<Map<String, String>> animals = [
//     {'name': 'CAT', 'image': 'assets/cat.jpg'},
//     {'name': 'DOG', 'image': 'assets/dog.png'},
//     {'name': 'FISH', 'image': 'assets/fish.jpg'},
//     {'name': 'BUTTERFLY', 'image': 'assets/butterfly.jpg'},
//     {'name': 'RABBIT', 'image': 'assets/rabbit.jpg'},
//     {'name': 'KANGAROO', 'image': 'assets/kangaroo.png'},
//     {'name': 'FROG', 'image': 'assets/frog.jpg'},
//     {'name': 'GIRAFFE', 'image': 'assets/giraffe.jpg'},
//     {'name': 'TURTLE', 'image': 'assets/turtle.png'},
//   ];

//   String currentQuestion = '';
//   String currentAnswer = '';
//   String currentImage = '';
//   List<String> shuffledLetters = [];
//   List<String> userAnswer = [];
//   int currentIndex = 0;
//   List<Map<String, String>> shuffledAnimals = [];

//   @override
//   void initState() {
//     super.initState();
//     shuffleAnimals();
//     generateQuestion();
//   }

//   void shuffleAnimals() {
//     shuffledAnimals = List.from(animals);
//     shuffledAnimals.shuffle();
//   }

//   void generateQuestion() {
//     if (currentIndex < shuffledAnimals.length) {
//       setState(() {
//         currentQuestion = "What is this Animal Name?";
//         currentAnswer = shuffledAnimals[currentIndex]['name']!;
//         currentImage = shuffledAnimals[currentIndex]['image']!;
//         shuffledLetters = shuffleLetters(currentAnswer);
//         userAnswer = List.filled(currentAnswer.length, '');
//       });
//     } else {
//       saveScoreToFirebase();
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Congratulations!'),
//           content: const Text('You have identified all the animals!'),
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

//   void resetGame() {
//     setState(() {
//       score = 0;
//       currentIndex = 0;
//       shuffleAnimals();
//       generateQuestion();
//     });
//   }

//   List<String> shuffleLetters(String word) {
//     List<String> letters = word.split('') + generateRandomLetters(word.length);
//     letters.shuffle();
//     return letters;
//   }

//   List<String> generateRandomLetters(int count) {
//     const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
//     Random random = Random();
//     return List.generate(
//         count, (index) => alphabet[random.nextInt(alphabet.length)]);
//   }

//   void checkAnswer() {
//     if (userAnswer.join() == currentAnswer) {
//       setState(() {
//         score++;
//       });

//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Correct!'),
//           content: Text('You got it right! Your current score is $score.'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//                 setState(() {
//                   currentIndex++;
//                   generateQuestion();
//                 });
//               },
//               child: const Text('Next Animal'),
//             ),
//           ],
//         ),
//       );
//     } else {
//       setState(() {
//         if (score > 0) score--;
//       });

//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Incorrect!'),
//           content: const Text('Try again!'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   Future<void> saveScoreToFirebase() async {
//     try {
//       await FirebaseFirestore.instance.collection('scores').add({
//         'gameName': gameName,
//         'email': userEmail,
//         'score': score,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//     } catch (e) {
//       print("Error saving score to Firebase: $e");
//     }
//   }

//   void removeLastLetter() {
//     setState(() {
//       for (int i = userAnswer.length - 1; i >= 0; i--) {
//         if (userAnswer[i] != '') {
//           userAnswer[i] = '';
//           break;
//         }
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Animal Identification Game')),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Text(
//                 'Score: $score',
//                 style:
//                     const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//             ),
//             Image.asset(
//               currentImage,
//               height: 150,
//               fit: BoxFit.contain,
//             ),
//             const SizedBox(height: 20),
//             Text(
//               currentQuestion,
//               style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: List.generate(
//                 currentAnswer.length,
//                 (index) => Container(
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
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 8, // Increased crossAxisCount for smaller boxes
//                 crossAxisSpacing: 8,
//                 mainAxisSpacing: 8,
//               ),
//               itemCount: shuffledLetters.length,
//               itemBuilder: (context, index) {
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       for (int i = 0; i < userAnswer.length; i++) {
//                         if (userAnswer[i] == '') {
//                           userAnswer[i] = shuffledLetters[index];
//                           shuffledLetters[index] = '';
//                           break;
//                         }
//                       }
//                     });
//                   },
//                   child: Container(
//                     width: 35,
//                     height: 35, // Reduced the size
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
//                           fontSize: 18, // Adjusted font size for smaller boxes
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             const SizedBox(height: 20),
//             // Buttons for actions
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: removeLastLetter,
//                     icon: const Icon(Icons.backspace),
//                     label: const Text('Backspace'),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () {
//                       setState(() {
//                         shuffledLetters = shuffleLetters(currentAnswer);
//                       });
//                     },
//                     icon: const Icon(Icons.refresh),
//                     label: const Text('Reload Letters'),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: checkAnswer,
//                     icon: const Icon(Icons.arrow_forward),
//                     label: const Text('Next'),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
