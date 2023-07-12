import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReactionGameScreen4 extends StatefulWidget {
  final Function(int) updateBestReactionTime4;
  const ReactionGameScreen4({Key? key, required this.updateBestReactionTime4});

  @override
  State<ReactionGameScreen4> createState() => _ReactionGameScreen4State();
}

class _ReactionGameScreen4State extends State<ReactionGameScreen4> {
  static late AudioPlayer player;
  bool gameStarted = false;
  DateTime? beepTime;
  Duration? reactionTime;
  int countdown = 3;
  int bestReactionTime4 = 0;
  bool gameEnded = false;

  @override
  void initState() {
    super.initState();
    retrieveBestReactionScore4();
    player = AudioPlayer();
    startCountdown();
  }

  void startCountdown() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        if (mounted) {
          setState(() {
            countdown--;
          });
        }
      } else {
        timer.cancel();
        startGame();
      }
    });
  }

  void startGame() {
    if (mounted) {
      setState(() {
        gameStarted = true;
        reactionTime = null;
        beepTime = null;
      });
    }

    // Generate a random delay between 1 and 5 seconds
    final randomDelay = Duration(seconds: 1 + (DateTime.now().millisecond % 2));

    // Play the beep sound after the random delay
    Future.delayed(randomDelay, () {
      if (gameEnded == false) {
        player.play(AssetSource('beep_sound.mp3'));
        if (mounted) {
          setState(() {
            beepTime = DateTime.now();
          });
        }
      }
    });
  }

  void handleTap() {
    if (gameStarted && beepTime != null) {
      setState(() {
        reactionTime = DateTime.now().difference(beepTime!);
        gameStarted = false;
        gameEnded = true;
        if (reactionTime!.inMilliseconds < bestReactionTime4 ||
            bestReactionTime4 == 0) {
          bestReactionTime4 = reactionTime!.inMilliseconds;
          storeBestReactionScore4(bestReactionTime4);
          widget.updateBestReactionTime4(bestReactionTime4);
        }
      });
    } else {
      setState(() {
        gameEnded = true; // End the game
        gameStarted = false;
        beepTime = null;
        player.stop();
      });
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid Tap'),
            content: Text('Wait for the beep sound'),
            actions: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        gameEnded = true; // End the game
                        beepTime = null;
                        player.stop();
                      });
                      Navigator.pop(context);
                    },
                    child: Text('Exit'),
                  ),
                ],
              )
            ],
          );
        },
      );
    }
  }

  void storeBestReactionScore4(int bestReactionScore3) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bestReactionTime4', bestReactionTime4);
  }

  void retrieveBestReactionScore4() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTime = prefs.getInt('bestReactionTime4');
    setState(() {
      bestReactionTime4 = storedTime ?? 0;
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.white,
          ),
          title: Text(
            'SOUND',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                // height: screenHeight * 0.23,
                // width: screenWidth,
                padding: EdgeInsets.all(16.0),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16.0),
                    Text(
                      '1. Wait for the beed sound',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      '2. Tap the screen once you hear the sound',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      //textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      '3. React Quickly!',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      //textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (!gameStarted && countdown > 0)
                      Text(
                        '$countdown',
                        style: TextStyle(fontSize: 60, color: Colors.grey),
                      ),
                    if (beepTime != null && reactionTime == null)
                      Text('Beep! Tap the screen as fast as you can!'),
                    if (reactionTime != null && gameEnded == true)
                      Text(
                        'Your reaction time: ${reactionTime?.inMilliseconds} ms',
                        style: TextStyle(fontSize: 24),
                      ),
                  ],
                ),
              ),
            ),
            if (gameEnded)
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Restart Game',
                iconSize: 40,
                onPressed: () {
                  if (mounted) {
                    setState(() {
                      gameEnded = false;
                      countdown = 3;
                      startCountdown();
                    });
                  }
                },
              )
            else
              GestureDetector(
                onTap: handleTap,
                child: Container(
                  color: Colors.black,
                  height: 100,
                  alignment: Alignment.center,
                  child: Text(
                    'Tap Here',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}