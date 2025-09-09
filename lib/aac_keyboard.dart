import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AACKeyboard extends StatefulWidget {
  const AACKeyboard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AACKeyboardState createState() => _AACKeyboardState();
}

class _AACKeyboardState extends State<AACKeyboard> {
  late FlutterTts flutterTts;
  List<String> selectedWords = [];

  // Predefined words/labels for the communication board
  final List<Map<String, String>> aacWords = [
    {'label': 'I', 'image': 'assets/i.png'},
    {'label': 'to' ,'image': 'to.png'},
    {'label': 'go' , 'image': 'go.png'},
    {'label': 'am' , 'image': 'am.png'},
    {'label': 'eat', 'image': 'assets/eat.jpg'},
    {'label': 'drink', 'image': 'assets/drink.jpg'},
    {'label': 'happy', 'image': 'assets/happy (2).jpg'},
    {'label': 'sad', 'image': 'assets/sad (2).jpg'},
    {'label': 'hurt', 'image': 'assets/hurt.jpg'},
    {'label': 'bathroom', 'image': 'assets/bathroom.jpg'},
    {'label': 'mad', 'image': 'assets/mad.jpg'},
    {'label': 'tired', 'image': 'assets/tired.jpg'},
    {'label': 'want', 'image': 'assets/want.jpg'},
    {'label': 'where', 'image': 'assets/where.png'},
    {'label': 'go', 'image': 'assets/go.jpg'},
    {'label': 'stop', 'image': 'assets/stop.png'},
    {'label': 'look', 'image': 'assets/look.png'},
    {'label': 'help', 'image': 'assets/help.png'},
    {'label': 'more', 'image': 'assets/more.png'},
  ];

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    flutterTts.setLanguage('en-US');
  }

  void _onTileTap(String word) {
    setState(() {
      selectedWords.add(word);
    });
  }

  Future<void> _speakMessage() async {
    String message = selectedWords.join(' ');
    if (message.isNotEmpty) {
      await flutterTts.speak(message);
    }
  }

  void _clearMessage() {
    setState(() {
      selectedWords.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AAC Communication Board'),
      ),
      body: Column(
        children: [
          // Buttons at the top: Speak and Clear
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _speakMessage,
                  child: const Text('Speak'),
                ),
                ElevatedButton(
                  onPressed: _clearMessage,
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),

          // Display selected words at the top
          Container(
            padding: const EdgeInsets.all(10),
            child: Text(
              selectedWords.join(' '),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),

          // AAC Keyboard grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, // 4 columns
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: aacWords.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onTileTap(aacWords[index]['label']!),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.teal[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.teal),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          aacWords[index]['image']!, // Image for each word
                          height: 50,
                          width: 50,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          aacWords[index]['label']!,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
