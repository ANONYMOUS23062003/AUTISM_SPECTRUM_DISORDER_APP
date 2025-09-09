
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MazeGame extends StatefulWidget {
  const MazeGame({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MazeGameState createState() => _MazeGameState();
}

class _MazeGameState extends State<MazeGame> {
  final int numRows = 10;
  final int numCols = 10;
  List<List<int>> maze = [];
  int playerRow = 0;
  int playerCol = 0;
  final int targetRow = 9;
  final int targetCol = 9;
  List<List<bool>> coins = [];
  int score = 0;
  final Stopwatch gameStopwatch = Stopwatch();
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _generateMaze();
    _placeCoins();
    gameStopwatch.start(); 
  }

  void _generateMaze() {
    maze = List.generate(numRows, (row) => List.generate(numCols, (col) => 0));

    // Randomly add walls (green colored obstacles)
    for (int i = 0; i < 20; i++) {
      int randomRow = random.nextInt(numRows);
      int randomCol = random.nextInt(numCols);

      // Ensure walls are not placed at the start or end
      if ((randomRow != playerRow || randomCol != playerCol) &&
          (randomRow != targetRow || randomCol != targetCol)) {
        maze[randomRow][randomCol] = 1;
      }
    }
  }

  // Randomly place coins on the maze
  void _placeCoins() {
    coins = List.generate(numRows, (row) => List.generate(numCols, (col) => false));

    int coinCount = 5;
    while (coinCount > 0) {
      int randomRow = random.nextInt(numRows);
      int randomCol = random.nextInt(numCols);

      if (maze[randomRow][randomCol] == 0 &&
          (randomRow != playerRow || randomCol != playerCol) &&
          (randomRow != targetRow || randomCol != targetCol) &&
          !coins[randomRow][randomCol]) {
        coins[randomRow][randomCol] = true;
        coinCount--;
      }
    }
  }

  // Handle player movement
  void _movePlayer(LogicalKeyboardKey key) {
    setState(() {
      if (key == LogicalKeyboardKey.arrowUp && playerRow > 0 && maze[playerRow - 1][playerCol] == 0) {
        playerRow--;
      } else if (key == LogicalKeyboardKey.arrowDown && playerRow < numRows - 1 && maze[playerRow + 1][playerCol] == 0) {
        playerRow++;
      } else if (key == LogicalKeyboardKey.arrowLeft && playerCol > 0 && maze[playerRow][playerCol - 1] == 0) {
        playerCol--;
      } else if (key == LogicalKeyboardKey.arrowRight && playerCol < numCols - 1 && maze[playerRow][playerCol + 1] == 0) {
        playerCol++;
      }

      // Collect coin
      if (coins[playerRow][playerCol]) {
        score++;
        coins[playerRow][playerCol] = false;
      }

      // Check if player reached target
      if (isAtTarget()) {
        _showWinDialog();
      }
    });
  }

  bool isAtTarget() {
    return playerRow == targetRow && playerCol == targetCol;
  }

  // Save game data to Firebase
  Future<void> _saveGameData() async {
    try {
      await FirebaseFirestore.instance.collection('scores').add({
        'game_name': 'Maze Game',
        'score': score,
        'time': gameStopwatch.elapsedMilliseconds,
        'date': DateTime.now(),
      });
    } catch (e) {
      print('Error saving game data: $e');
    }
  }

  // Show a win dialog
  void _showWinDialog() async {
    gameStopwatch.stop();
    await _saveGameData(); // Save game data to Firebase
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: Text('You collected $score coins in ${getFormattedTime()}!'),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Restart'),
              onPressed: () {
                Navigator.of(context).pop();
                _restartGame();
              },
            ),
          ],
        );
      },
    );
  }

  // Restart the game
  void _restartGame() {
    setState(() {
      playerRow = 0;
      playerCol = 0;
      score = 0;
      _generateMaze();
      _placeCoins();
      gameStopwatch.reset();
      gameStopwatch.start();
    });
  }

  String getFormattedTime() {
    final elapsed = gameStopwatch.elapsed;
    return '${elapsed.inMinutes}:${(elapsed.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maze Game'),
      ),
      // ignore: deprecated_member_use
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        // ignore: deprecated_member_use
        onKey: (RawKeyEvent event) {
          // ignore: deprecated_member_use
          if (event is RawKeyDownEvent) {
            _movePlayer(event.logicalKey);
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Score: $score', style: const TextStyle(fontSize: 24)),
              Text('Elapsed Time: ${getFormattedTime()}', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),
              for (int row = 0; row < numRows; row++)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int col = 0; col < numCols; col++)
                      Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: _getTileColor(row, col),
                          border: Border.all(color: Colors.black),
                        ),
                        child: _getTileIcon(row, col),
                      ),
                  ],
                ),
              const SizedBox(height: 20),
              const Text('Use arrow keys to move the rabbit!'),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTileColor(int row, int col) {
    if (maze[row][col] == 1) {
      return Colors.green; // Wall
    } else {
      return Colors.brown; // Path
    }
  }

  Widget? _getTileIcon(int row, int col) {
    if (row == playerRow && col == playerCol) {
      return const Icon(Icons.pets, color: Colors.blue); // Rabbit
    } else if (row == targetRow && col == targetCol) {
      return const Icon(Icons.restaurant_menu, color: Colors.orange); // Carrot
    } else if (coins[row][col]) {
      return const Icon(Icons.monetization_on, color: Colors.yellow); // Coin
    }
    return null;
  }
}
