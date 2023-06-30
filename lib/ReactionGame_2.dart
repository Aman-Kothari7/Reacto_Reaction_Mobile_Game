import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReactionGameScreen2 extends StatefulWidget {
  final Function(int) updateBestReactionTime2;
  const ReactionGameScreen2({super.key, required this.updateBestReactionTime2});

  @override
  State<ReactionGameScreen2> createState() => _ReactionGameScreen2State();
}

class _ReactionGameScreen2State extends State<ReactionGameScreen2> {
  List<Color> confusingColors = [
    Colors.blue,
    Colors.purple,
    Colors.green,
  ];
  Color screenColor = Colors.grey;
  bool isPressed = false;
  Stopwatch stopwatch = Stopwatch();
  Duration? reactionTime;
  Timer? colorTimer;
  int? bestReactionTime2;
  int? storeReactionTimeInInt;

  @override
  void initState() {
    super.initState();
    retrieveBestReactionTime();
  }

  @override
  void dispose() {
    colorTimer?.cancel(); // Cancel the timer in the dispose() method
    super.dispose();
  }

  void startGame() {
    setState(() {
      isPressed = true;
      startColorTimer();
    });
  }

  void stopGame() {
    if (isPressed) {
      stopColorTimer();
      if (screenColor == Colors.green) {
        stopwatch.stop();
        print(bestReactionTime2);
        reactionTime = stopwatch.elapsed;
        storeReactionTimeInInt = reactionTime!.inMilliseconds;
        //resetGame();
        print(storeReactionTimeInInt);

        if (bestReactionTime2 == null ||
            storeReactionTimeInInt! < bestReactionTime2! ||
            bestReactionTime2 == 0) {
          bestReactionTime2 = reactionTime!.inMilliseconds;
          storeBestReactionTime(bestReactionTime2!);
          print(bestReactionTime2);
          widget.updateBestReactionTime2(bestReactionTime2!);
        }
      } else {
        resetGame();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Invalid Release'),
              content: const Text(
                  'Only release when the screen turns green to calculate reaction time.'),
              actions: <Widget>[
                TextButton(
                  child: Text('Return'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
      setState(() {
        isPressed = false;
      });
    }
  }

  void storeBestReactionTime(int bestReactionTime2) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bestReactionTime2', bestReactionTime2);
  }

  void retrieveBestReactionTime() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTime = prefs.getInt('bestReactionTime2');
    setState(() {
      bestReactionTime2 = storedTime ?? 0;
    });
  }

  void startColorTimer() {
    colorTimer =
        Timer.periodic(Duration(seconds: Random().nextInt(2) + 1), (_) {
      setState(() {
        screenColor = _getRandomConfusingColor();
        if (screenColor == Colors.green && isPressed) {
          stopwatch.reset();
          stopwatch.start();
          stopColorTimer();
        }
      });
    });
  }

  void stopColorTimer() {
    if (colorTimer != null) {
      colorTimer?.cancel();
    }
  }

  void resetGame() {
    stopColorTimer();
    stopwatch.reset();
    reactionTime = null;
    setState(() {
      screenColor = Colors.grey;
      isPressed = false;
    });
  }

  Color _getRandomConfusingColor() {
    return confusingColors[Random().nextInt(confusingColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => startGame(),
      onTapUp: (_) => stopGame(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Reaction Time Game'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  color: screenColor,
                  child: Center(
                    child: Text(
                      isPressed
                          ? 'Release on Green'
                          : reactionTime != null
                              ? 'Reaction Time: ${reactionTime!.inMilliseconds} ms'
                              : 'Press and Hold',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
