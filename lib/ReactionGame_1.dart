import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

class ReactionGameScreen1 extends StatefulWidget {
  final Function(int) updateBestReactionTime;

  const ReactionGameScreen1({super.key, required this.updateBestReactionTime});

  @override
  _ReactionGameScreen1State createState() => _ReactionGameScreen1State();
}

class _ReactionGameScreen1State extends State<ReactionGameScreen1> {
  List<bool> showCircle = [false, false, false];
  int circleIndex = 0;
  bool changeColors = false;
  DateTime? colorChangeTime;
  DateTime? tapTime;
  int? reactionTime;
  bool gameInProgress = true;
  Timer? circlesTimer;
  int? bestReactionTime;

  @override
  void initState() {
    super.initState();
    retrieveBestReactionTime();
    startShowingCircles();
  }

  @override
  void dispose() {
    circlesTimer?.cancel(); // Cancel the timer in the dispose() method
    super.dispose();
  }

  void startShowingCircles() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (!gameInProgress) {
        timer.cancel(); // Stop the timer if game is no longer in progress
        return;
      }
      if (showCircle.every((shown) => shown)) {
        timer.cancel();
        final randomDelay = Random().nextInt(5) + 2;
        Timer(Duration(seconds: randomDelay), () {
          if (mounted) {
            setState(() {
              changeColors = true;
              colorChangeTime = DateTime.now();
            });
          }
        });
      } else {
        for (int i = 0; i < showCircle.length; i++) {
          if (!showCircle[i]) {
            if (mounted) {
              setState(() {
                showCircle[i] = true;
              });
              break;
            }
          }
        }
      }
    });
  }

  // Store the best reaction time in shared preferences
  void storeBestReactionTime(int bestReactionTime) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bestReactionTime', bestReactionTime);
  }

  // Retrieve the best reaction time from shared preferences
  void retrieveBestReactionTime() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTime = prefs.getInt('bestReactionTime');
    setState(() {
      bestReactionTime = storedTime ?? 0;
    });
  }

  void handleTap() {
    if (changeColors && tapTime == null && colorChangeTime != null) {
      setState(() {
        tapTime = DateTime.now();
        reactionTime = tapTime?.difference(colorChangeTime!).inMilliseconds;

        if (bestReactionTime == 0 || reactionTime! < bestReactionTime!) {
          bestReactionTime = reactionTime;
          storeBestReactionTime(
              bestReactionTime!); // Store the best time in shared preferences
          widget.updateBestReactionTime(bestReactionTime!);
          //print(bestReactionTime);
        }
      });
    } else if (mounted && changeColors == false && colorChangeTime == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Tap'),
            content: Text('Wait for the lights to change color'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    gameInProgress = false; // End the game
                  });
                  Navigator.pop(context);
                },
                child: Text('Return'),
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reaction Time Game'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: handleTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showCircle[0]) _buildCircle(changeColors),
                  if (showCircle[1]) _buildCircle(changeColors),
                  if (showCircle[2]) _buildCircle(changeColors),
                ],
              ),
              if (reactionTime != null)
                Text(
                  'Reaction Time: ${reactionTime} ms',
                  style: TextStyle(fontSize: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircle(bool changeColors) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: changeColors ? Colors.white : Colors.red,
        border: Border.all(
            color: changeColors ? Colors.black : Colors.transparent, width: 2),
      ),
      margin: EdgeInsets.all(10),
    );
  }
}
