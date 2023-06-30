import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_game/ReactionGame_2.dart';
import 'package:test_game/ReactionGame_3.dart';
import 'ReactionGame_1.dart';

void main() {
  runApp(GameApp());
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Games App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MenuScreen(),
    );
  }
}

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late final Function(int) updateBestReactionTime;
  late final Function(int) updateBestReactionTime2;
  late final Function(int) updateBestReactionScore3;

  int? bestReactionTime;
  int? bestReactionTime2;
  int? bestReactionScore3;
  int aggregateScore = 0;

  @override
  void initState() {
    super.initState();
    loadBestReactionTime();
    loadBestReactionTime2();
    loadBestReactionScore3();
  }

  void loadBestReactionTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bestReactionTime = prefs.getInt('bestReactionTime') ?? 0;
      updateAggregateScore();
    });
  }

  void loadBestReactionTime2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bestReactionTime2 = prefs.getInt('bestReactionTime2') ?? 0;
      updateAggregateScore();
    });
  }

  void loadBestReactionScore3() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bestReactionScore3 = prefs.getInt('bestReactionScore3') ?? 0;
      updateAggregateScore();
    });
  }

  void updateAggregateScore() {
    double totalScore = ((10000 / (bestReactionTime ?? 1)) +
        (10000 / (bestReactionTime2 ?? 1)) +
        (bestReactionScore3 ?? 0));

    double aggregateScore = (totalScore / 3) * 100;

    setState(() {
      this.aggregateScore = aggregateScore.round();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReactionGameScreen1(
                            updateBestReactionTime: (newBestReactionTime) {
                              setState(() {
                                bestReactionTime = newBestReactionTime;
                                updateAggregateScore();
                              });
                            },
                          )),
                );
              },
              child: Text('Reaction Game 1'),
            ),
            Text(
              'Best: ${bestReactionTime.toString()} ms',
              style: TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReactionGameScreen2(
                      updateBestReactionTime2: (newBestReactionTime2) {
                        setState(() {
                          bestReactionTime2 = newBestReactionTime2;
                          updateAggregateScore();
                        });
                      },
                    ),
                  ),
                );
              },
              child: const Text('Reaction Game 2'),
            ),
            Text(
              'Best: ${bestReactionTime2.toString()} ms',
              style: TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ReactionGameScreen3(
                      updateBestReactionScore3: (newBestReactionScore3) {
                        setState(() {
                          bestReactionScore3 = newBestReactionScore3;
                          updateAggregateScore();
                        });
                      },
                    ),
                  ),
                );
              },
              child: const Text('Reaction Game 3'),
            ),
            Text(
              'Best: ${bestReactionScore3.toString()} score',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Aggregate Score: $aggregateScore',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
