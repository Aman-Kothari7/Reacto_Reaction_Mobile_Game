import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MemoryGameScreen.dart';
import 'ReactionGameScreen.dart';

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
      home: MenuScreen(),
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
  late final Function(int) updateBestMemoryLevel;
  int? bestReactionTime;
  int highestLevel = 0;

  @override
  void initState() {
    super.initState();
    loadBestReactionTime();
    loadHighestMemoryLevel();
  }

  void loadBestReactionTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bestReactionTime = prefs.getInt('bestReactionTime') ?? 0;
    });
  }

  void loadHighestMemoryLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highestLevel = prefs.getInt('highestLevel') ?? 0;
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
                      builder: (context) => ReactionGameScreen(
                            updateBestReactionTime: (newBestReactionTime) {
                              setState(() {
                                bestReactionTime = newBestReactionTime;
                              });
                            },
                          )),
                );
              },
              child: Text('Reaction Game'),
            ),
            Text(
              'Best Reaction Time: ${bestReactionTime.toString()} ms',
              style: TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MemoryGameScreen(
                        updateBestMemoryScore: (newBestMemoryScore) {
                      setState(() {
                        highestLevel = newBestMemoryScore;
                      });
                    }),
                  ),
                );
              },
              child: Text('Memory Game'),
            ),
            Text(
              'Best Memory Score: ${highestLevel.toString()} digits',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
