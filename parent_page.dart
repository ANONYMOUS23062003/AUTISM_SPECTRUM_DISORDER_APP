// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:percent_indicator/percent_indicator.dart';

// class LineChartWidget extends StatelessWidget {
//   final List<FlSpot> dataPoints;
//   final String title;

//   const LineChartWidget({super.key, required this.dataPoints, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: 250,
//           child: LineChart(
//             LineChartData(
//               borderData: FlBorderData(show: true),
//               titlesData: FlTitlesData(
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     reservedSize: 22,
//                     getTitlesWidget: (value, meta) {
//                       return Text(
//                         'Try ${(value.toInt() + 1)}',
//                         style: const TextStyle(fontSize: 12),
//                       );
//                     },
//                   ),
//                 ),
//                 leftTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     reservedSize: 28,
//                     getTitlesWidget: (value, meta) {
//                       return Text(
//                         '${value.toInt()}s',
//                         style: const TextStyle(fontSize: 12),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               gridData: FlGridData(
//                 show: true,
//                 drawVerticalLine: true,
//                 getDrawingHorizontalLine: (value) => FlLine(
//                   color: Colors.grey[300]!,
//                   strokeWidth: 1,
//                 ),
//                 getDrawingVerticalLine: (value) => FlLine(
//                   color: Colors.grey[300]!,
//                   strokeWidth: 1,
//                 ),
//               ),
//               lineBarsData: [
//                 LineChartBarData(
//                   isCurved: true,
//                   spots: dataPoints,
//                   barWidth: 3,
//                   gradient: const LinearGradient(
//                     colors: [Colors.blue, Colors.blueAccent],
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                   ),
//                   isStrokeCapRound: true,
//                   dotData: FlDotData(show: true),
//                   belowBarData: BarAreaData(
//                     show: true,
//                     gradient: LinearGradient(
//                       colors: [Colors.blue.withOpacity(0.2), Colors.blueAccent.withOpacity(0.1)],
//                       begin: Alignment.centerLeft,
//                       end: Alignment.centerRight,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }



// class BarChartWidget extends StatelessWidget {
//   final List<BarChartGroupData> barData;
//   final String title;

//   const BarChartWidget({super.key, required this.barData, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 10),
//         SizedBox(
//           height: 200,
//           child: BarChart(
//             BarChartData(
//               borderData: FlBorderData(show: false),
//               titlesData: FlTitlesData(
//                 bottomTitles: AxisTitles(
//                   sideTitles: SideTitles(
//                     showTitles: true,
//                     getTitlesWidget: (value, meta) {
//                       return Text(
//                         'Game ${(value.toInt() + 1)}',
//                         style: const TextStyle(fontSize: 12),
//                       );
//                     },
//                   ),
//                 ),
//                 leftTitles: const AxisTitles(
//                   sideTitles: SideTitles(showTitles: true),
//                 ),
//               ),
//               barGroups: barData,
//               gridData: const FlGridData(show: false),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class ParentPage extends StatefulWidget {
//   const ParentPage({super.key});

//   @override
//   State<ParentPage> createState() => _ParentPageState();
// }

// class _ParentPageState extends State<ParentPage> {
//   final List<Map<String, dynamic>> gameScores = [
//     {
//       'game': 'Blood Relation Game',
//       'scores': [10, 40, 80, 20, 70],
//       'progress': 80 / 100,
//     },
//     {
//       'game': 'Tile Matching Game',
//       'scores': [6, 6],
//       'tries': [3, 5],
//       'progress': 6 / 6,
//     },
//     {
//       'game': 'Maze Game',
//       'scores': [3, 4, 3],
//       'progress': 3 / 3,
//     },
//   ];

//   List<FlSpot> _generateLineData(List<int> scores, List<int> tries) {
//     return scores.asMap().entries.map((entry) {
//       final index = entry.key;
//       return FlSpot(tries[index].toDouble(), entry.value.toDouble());
//     }).toList();
//   }

//   List<BarChartGroupData> _generateBarData(List<int> scores) {
//     return scores.asMap().entries.map((entry) {
//       final index = entry.key;
//       final value = entry.value;
//       return BarChartGroupData(
//         x: index,
//         barRods: [
//           BarChartRodData(
//             toY: value.toDouble(),
//             color: Colors.blue,
//             width: 16,
//             borderRadius: BorderRadius.circular(4),
//           ),
//         ],
//       );
//     }).toList();
//   }

//   String _generateSuggestions(String game, double progress) {
//     if (progress < 0.5) {
//       return 'The progress in $game needs improvement. Encourage your child to practice more.';
//     } else if (progress < 0.75) {
//       return 'Good progress in $game. Keep up the momentum and aim for higher scores.';
//     } else {
//       return 'Excellent performance in $game! Keep reinforcing their skills.';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Child Progress Tracker'),
//         backgroundColor: Colors.blue,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'Child\'s Progress in Games',
//                 style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20),
//               ...gameScores.map((gameData) {
//                 final game = gameData['game'];
//                 final scores = gameData['scores'] as List<int>;
//                 final progress = gameData['progress'] as double;
//                 final suggestions = _generateSuggestions(game, progress);

//                 if (game == 'Tile Matching Game') {
//                   final tries = gameData['tries'] as List<int>;
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       LineChartWidget(
//                         dataPoints: _generateLineData(scores, tries),
//                         title: '$game: Scores vs. Tries',
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         'Progress: ${(progress * 100).toInt()}%',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       LinearPercentIndicator(
//                         lineHeight: 14.0,
//                         percent: progress,
//                         center: Text(
//                           '${(progress * 100).toInt()}%',
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                         backgroundColor: Colors.grey[300],
//                         progressColor: Colors.green,
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         'Suggestions: $suggestions',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       const Divider(thickness: 1, height: 40),
//                     ],
//                   );
//                 } else {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       BarChartWidget(
//                         barData: _generateBarData(scores),
//                         title: '$game Scores',
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         'Progress: ${(progress * 100).toInt()}%',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       LinearPercentIndicator(
//                         lineHeight: 14.0,
//                         percent: progress,
//                         center: Text(
//                           '${(progress * 100).toInt()}%',
//                           style: const TextStyle(fontSize: 12),
//                         ),
//                         backgroundColor: Colors.grey[300],
//                         progressColor: Colors.green,
//                       ),
//                       const SizedBox(height: 10),
//                       Text(
//                         'Suggestions: $suggestions',
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                       const Divider(thickness: 1, height: 40),
//                     ],
//                   );
//                 }
//               }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import for charts
import 'package:percent_indicator/percent_indicator.dart'; // Import for percent indicator
import 'assessment_page.dart'; // Import the AssessmentPage

class ParentPage extends StatefulWidget {
  const ParentPage({super.key});

  @override
  State<ParentPage> createState() => _ParentPageState();
}

class _ParentPageState extends State<ParentPage> {
  final List<Map<String, dynamic>> gameScores = [
    {
      'game': 'Blood Relation Game',
      'scores': [10, 40, 80, 20, 70],
      'progress': 80 / 100,
    },
    {
      'game': 'Tile Matching Game',
      'scores': [6, 6],
      'tries': [3, 5],
      'progress': 6 / 6,
    },
    {
      'game': 'Maze Game',
      'scores': [3, 4, 3],
      'progress': 3 / 3,
    },
  ];

  List<FlSpot> _generateLineData(List<int> scores, List<int> tries) {
    return scores.asMap().entries.map((entry) {
      final index = entry.key;
      return FlSpot(tries[index].toDouble(), entry.value.toDouble());
    }).toList();
  }

  List<BarChartGroupData> _generateBarData(List<int> scores) {
    return scores.asMap().entries.map((entry) {
      final index = entry.key;
      final value = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: value.toDouble(),
            color: Colors.blue,
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();
  }

  String _generateSuggestions(String game, double progress) {
    if (progress < 0.5) {
      return 'The progress in $game needs improvement. Encourage your child to practice more.';
    } else if (progress < 0.75) {
      return 'Good progress in $game. Keep up the momentum and aim for higher scores.';
    } else {
      return 'Excellent performance in $game! Keep reinforcing their skills.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Child Progress Tracker'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Child\'s Progress in Games',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              ...gameScores.map((gameData) {
                final game = gameData['game'];
                final scores = gameData['scores'] as List<int>;
                final progress = gameData['progress'] as double;
                final suggestions = _generateSuggestions(game, progress);

                if (game == 'Tile Matching Game') {
                  final tries = gameData['tries'] as List<int>;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LineChartWidget(
                        dataPoints: _generateLineData(scores, tries),
                        title: '$game: Scores vs. Tries',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Progress: ${(progress * 100).toInt()}%',
                        style: const TextStyle(fontSize: 16),
                      ),
                      LinearPercentIndicator(
                        lineHeight: 14.0,
                        percent: progress,
                        center: Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.grey[300],
                        progressColor: Colors.green,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Suggestions: $suggestions',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Divider(thickness: 1, height: 40),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BarChartWidget(
                        barData: _generateBarData(scores),
                        title: '$game Scores',
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Progress: ${(progress * 100).toInt()}%',
                        style: const TextStyle(fontSize: 16),
                      ),
                      LinearPercentIndicator(
                        lineHeight: 14.0,
                        percent: progress,
                        center: Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.grey[300],
                        progressColor: Colors.green,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Suggestions: $suggestions',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Divider(thickness: 1, height: 40),
                    ],
                  );
                }
              }).toList(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to the Assessment Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AssessmentPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                ),
                child: const Text('Start Assessment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BarChartWidget extends StatelessWidget {
  final List<BarChartGroupData> barData;
  final String title;

  const BarChartWidget({
    required this.barData,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: BarChart(
            BarChartData(
              barGroups: barData,
              titlesData: const FlTitlesData(show: false),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ],
    );
  }
}

class LineChartWidget extends StatelessWidget {
  final List<FlSpot> dataPoints;
  final String title;

  const LineChartWidget({
    required this.dataPoints,
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: dataPoints,
                  isCurved: true,
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.blueAccent],
                  ),                  barWidth: 4,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              titlesData: const FlTitlesData(show: false),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
      ],
    );
  }
}
