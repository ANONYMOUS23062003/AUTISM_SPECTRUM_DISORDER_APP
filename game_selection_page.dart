import 'package:asd_app/aac_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:asd_app/animal_identification_game.dart';
import 'package:asd_app/math_quiz.dart';
import 'matchinggame.dart';
import 'tile_matching_game.dart';
import 'mazegame.dart';
import 'blood_relation_game.dart';
import 'emotion_learning_game.dart';

class GamesSelectionPage extends StatelessWidget {
  const GamesSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Game'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3, // Two items per row
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            buildGameCard(
              context,
              title: 'Object Matching Game',
              icon: Icons.grid_on,
              color: Colors.pinkAccent,
              destination: const MatchingGame(),
            ),
            buildGameCard(
              context,
              title: 'Tile Matching Game',
              icon: Icons.apps,
              color: Colors.orangeAccent,
              destination: const TileMatchingGame(),
            ),
            buildGameCard(
              context,
              title: 'Maze Game',
              icon: Icons.map,
              color: Colors.lightGreen,
              destination: const MazeGame(),
            ),
            buildGameCard(
              context,
              title: 'Math Game',
              icon: Icons.calculate,
              color: Colors.cyanAccent,
              destination: const MathGame(),
            ),
            buildGameCard(
              context,
              title: 'Animal ID Game',
              icon: Icons.pets,
              color: Colors.blueAccent,
              destination: const AnimalIdentificationGame(),
            ),
            buildGameCard(
              context,
              title: 'Relation ID Game',
              icon: Icons.family_restroom,
              color: Colors.deepPurpleAccent,
              destination: const BloodRelationGame(),
            ),
            buildGameCard(
              context,
              title: 'Emotion Learning Game',
              icon: Icons.emoji_emotions,
              color: Colors.tealAccent,
              destination: const EmotionGame(),
            ),
            buildGameCard(
              context,
              title: 'AAC Keyboard',
              icon: Icons.keyboard,
              color: Colors.greenAccent,
              destination: const AACKeyboard(),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build game cards
  Widget buildGameCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required Widget destination}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
