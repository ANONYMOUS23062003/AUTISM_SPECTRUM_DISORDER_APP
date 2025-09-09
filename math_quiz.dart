import 'package:flutter/material.dart';
import 'dart:math';

class MathGame extends StatefulWidget {
  const MathGame({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MathGameState createState() => _MathGameState();
}

class _MathGameState extends State<MathGame> {
  int score = 0;
  bool gameOver = false;

  List<String> questions = [];
  List<int> correctAnswers = [];
  List<int> selectedAnswers = [-1, -1, -1]; // Holds the selected answers

  final List<int> answerOptions = [3, 6, 8, 10, 12];

  @override
  void initState() {
    super.initState();
    generateQuestions(); // Generate questions on init
  }

  void generateQuestions() {
    questions = [];
    correctAnswers = [];
    Random random = Random();

    // Generate 3 random multiplication questions
    for (int i = 0; i < 3; i++) {
      int num1 = random.nextInt(6) + 1; // Random number between 1 and 6
      int num2 = random.nextInt(6) + 1; // Random number between 1 and 6
      questions.add('$num1 × $num2 = ?');
      correctAnswers.add(num1 * num2); // Correct answer
    }

    // Shuffle the answer options to add more variety
    answerOptions.shuffle();
  }

  void checkGameOver() {
    if (selectedAnswers.every((element) => element != -1)) {
      setState(() {
        gameOver = true;
        score = calculateScore();
      });
    }
  }

  int calculateScore() {
    int calculatedScore = 0;
    for (int i = 0; i < selectedAnswers.length; i++) {
      if (selectedAnswers[i] == correctAnswers[i]) {
        calculatedScore += 30; // 30 points for each correct answer
      }
    }
    return calculatedScore;
  }

  void resetGame() {
    setState(() {
      score = 0;
      gameOver = false;
      selectedAnswers = [-1, -1, -1]; // Reset answers
      generateQuestions(); // Generate new questions
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Math Balloons Game'),
      ),
      body: gameOver
          ? _buildGameOverScreen()
          : Column(
        children: [
          const SizedBox(height: 20),
          _buildScore(),
          const SizedBox(height: 20),
          Expanded(child: _buildGame()),
        ],
      ),
    );
  }

  Widget _buildScore() {
    return Text(
      'Score: $score',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
    );
  }

  Widget _buildGameOverScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Colors.blue,
            size: 100,
          ),
          const SizedBox(height: 20),
          const Text(
            'Game Over',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text('Your Score: $score'),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: resetGame, // Reset the game
            child: const Text('Replay'),
          ),
          ElevatedButton(
            onPressed: resetGame, // Start new game (same as replay)
            child: const Text('Start New Game'),
          ),
        ],
      ),
    );
  }

  Widget _buildGame() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(questions.length, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      questions[index],
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 20),
                    selectedAnswers[index] != -1
                        ? _buildBalloons(selectedAnswers[index])
                        : const Text('?', style: TextStyle(fontSize: 20)),
                  ],
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            children: List.generate(answerOptions.length, (index) {
              return GestureDetector(
                onTap: () {
                  for (int i = 0; i < selectedAnswers.length; i++) {
                    if (selectedAnswers[i] == -1) {
                      setState(() {
                        selectedAnswers[i] = answerOptions[index];
                      });
                      break;
                    }
                  }
                  checkGameOver();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildBalloons(answerOptions[index]),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildBalloons(int count) {
    return Row(
      children: List.generate(count, (index) {
        return Padding(
          padding: const EdgeInsets.all(2.0),
          child: Image.asset(
            'assets/balloon.jpg', // Your balloon image here
            width: 20,
            height: 20,
          ),
        );
      }),
    );
  }
}
