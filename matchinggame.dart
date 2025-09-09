import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MatchingGame extends StatelessWidget {
  const MatchingGame({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Object Matching Game",
      home: _MatchingGame(),
    );
  }
}

class _MatchingGame extends StatefulWidget {
  const _MatchingGame();

  @override
  _MatchingGameState createState() => _MatchingGameState();
}

class _MatchingGameState extends State<_MatchingGame> {
  late List<ItemModel> items;
  late List<ItemModel> items2;
  late int score;
  late bool gameOver;

  @override
  void initState() {
    super.initState();
    initGame();
  }

  void initGame() {
    gameOver = false;
    score = 0;
    items = [
      ItemModel(icon: FontAwesomeIcons.coffee, name: "Coffee", value: "Coffee"),
      ItemModel(icon: FontAwesomeIcons.dog, name: "Dog", value: "Dog"),
      ItemModel(icon: FontAwesomeIcons.cat, name: "Cat", value: "Cat"),
      ItemModel(icon: FontAwesomeIcons.birthdayCake, name: "Cake", value: "Cake"),
      ItemModel(icon: FontAwesomeIcons.bus, name: "Bus", value: "Bus"),
    ];
    items2 = List<ItemModel>.from(items);
    items.shuffle();
    items2.shuffle();
  }

  Future<void> saveScoreToFirebase(int finalScore) async {
    await FirebaseFirestore.instance.collection('scores').add({
      'score': finalScore,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      setState(() {
        gameOver = true;
        saveScoreToFirebase(score); // Save score to Firebase when the game ends
      });
    }

    return Scaffold(
      backgroundColor: Colors.amber,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Object Matching Game'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text.rich(TextSpan(
              children: [
                const TextSpan(text: "Score: "),
                TextSpan(
                  text: "$score",
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                  ),
                )
              ],
            )),
            if (!gameOver)
              Row(
                children: <Widget>[
                  Column(
                    children: items.map((item) {
                      return Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Draggable<ItemModel>(
                          data: item,
                          childWhenDragging:
                              Icon(item.icon, color: Colors.grey, size: 50.0),
                          feedback:
                              Icon(item.icon, color: Colors.teal, size: 50),
                          child: Icon(item.icon, color: Colors.teal, size: 50),
                        ),
                      );
                    }).toList(),
                  ),
                  const Spacer(),
                  Column(
                    children: items2.map((item) {
                      return DragTarget<ItemModel>(
                        onAcceptWithDetails: (details) {
                          final receivedItem = details.data; // Extract the actual item
                          if (item.value == receivedItem.value) {
                            setState(() {
                              items.remove(receivedItem);
                              items2.remove(item);
                              score += 10;
                              item.accepting = false;
                            });
                          } else {
                            setState(() {
                              score -= 5;
                              item.accepting = false;
                            });
                          }
                        },
                        onLeave: (details) {
                          setState(() {
                            item.accepting = false;
                          });
                        },
                        onWillAcceptWithDetails: (details) {
                          setState(() {
                            item.accepting = true;
                          });
                          return true;
                        },
                        builder: (context, acceptedItems, rejectedItem) =>
                            Container(
                          color: item.accepting ? Colors.red : Colors.teal,
                          height: 50,
                          width: 100,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(8.0),
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            if (gameOver)
              const Text(
                "Game Over",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
            if (gameOver)
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.pink,
                  ),
                  child: const Text("New Game"),
                  onPressed: () {
                    initGame();
                    setState(() {});
                  },
                ),
              ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                child: const Text("Back"),
                onPressed: () {
                  Navigator.pop(
                      context); // Navigate back to the previous screen
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ItemModel {
  final String name;
  final String value;
  final IconData icon;
  bool accepting;

  ItemModel({
    required this.name,
    required this.value,
    required this.icon,
    this.accepting = false,
  });
}
