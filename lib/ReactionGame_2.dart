import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_game/level_ranges.dart';

import 'info_screen.dart';

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
  bool gameEnded = false;

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
        //print(bestReactionTime2);
        reactionTime = stopwatch.elapsed;
        storeReactionTimeInInt = reactionTime!.inMilliseconds;
        //resetGame();
        //print(storeReactionTimeInInt);
        if (storeReactionTimeInInt! < baseThresholdGameTwo) {
          storeReactionTimeInInt = bestReactionTime2!;

          resetGame();
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                title: Text('Impossible Reaction Time!',
                    textAlign: TextAlign.center),
                content: Text('Please retry for fair competition',
                    textAlign: TextAlign.center),
                actions: [
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                        ),
                        child: Text(
                          'Exit',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          );

          setState(() {
            isPressed = false;
          });
        } else {
          if (bestReactionTime2 == null ||
              storeReactionTimeInInt! < bestReactionTime2! ||
              bestReactionTime2 == 0) {
            bestReactionTime2 = reactionTime!.inMilliseconds;
            storeBestReactionTime(bestReactionTime2!);
            //print(bestReactionTime2);
            widget.updateBestReactionTime2(bestReactionTime2!);
          }
        }

        setState(() {
          gameEnded = true; // Set game ended state to true
        });
      } else {
        resetGame();
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              title: Text('INVALID RELEASE', textAlign: TextAlign.center),
              content: Text('Only release when the screen turns green!',
                  textAlign: TextAlign.center),
              actions: [
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      child: Text(
                        'Exit',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            );

            // AlertDialog(
            //   title: const Text('Invalid Release'),
            //   content: const Text(
            //       'Only release when the screen turns green to calculate reaction time.'),
            //   actions: <Widget>[
            //     TextButton(
            //       child: Text('Return'),
            //       onPressed: () {
            //         Navigator.of(context).pop();
            //         Navigator.pop(context);
            //       },
            //     ),
            //   ],
            // );
          },
        );
      }
      setState(() {
        isPressed = false;
      });
    }
  }

  void resetGame() {
    stopColorTimer();
    stopwatch.reset();
    reactionTime = null;
    setState(() {
      screenColor = Colors.grey;
      isPressed = false;
      gameEnded = false; // Reset game ended state
    });
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
    if (mounted) {
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
  }

  void stopColorTimer() {
    if (colorTimer != null) {
      colorTimer?.cancel();
    }
  }

  Color _getRandomConfusingColor() {
    return confusingColors[Random().nextInt(confusingColors.length)];
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
            'COLOR',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            info_screen(initialPageIndex: 1)));
              },
              icon: Icon(Icons.info_outline),
              iconSize: 40,
            )
          ],
        ),
        body: GestureDetector(
          onPanDown: (_) => startGame(),
          onPanEnd: (_) => stopGame(),
          child: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Container(
                  //   color: screenColor,
                  //   // height: screenHeight * 0.23,
                  //   // width: screenWidth,
                  //   padding: EdgeInsets.all(16.0),
                  //   child: const Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       SizedBox(height: 16.0),
                  //       Text(
                  //         '1. Hold screen -> wait for color change ',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 22,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //         textAlign: TextAlign.left,
                  //       ),
                  //       SizedBox(height: 10.0),
                  //       Text(
                  //         '2. Leave screen -> as soon as screen color is green',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 22,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //         //textAlign: TextAlign.center,
                  //       ),
                  //       SizedBox(height: 10.0),
                  //       Text(
                  //         '3. React quickly!',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 22,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //         //textAlign: TextAlign.center,
                  //       ),
                  //     ],
                  //   ),
                  // ),
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
                  gameEnded
                      ? IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: resetGame,
                          tooltip: 'Restart Game',
                          iconSize: 40,
                        )
                      : SizedBox(),

                  // const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
