import 'dart:async';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_game/level_ranges.dart';

import 'info_screen.dart';

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

  void navigateToInfoScreen() async {
    // Pause the game
    setState(() {
      gameStarted = false;
      gameEnded = true;
      beepTime = null;
      player.stop();
    });

    // Navigate to the info screen and wait for it to complete
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => info_screen(initialPageIndex: 3),
      ),
    );

    // Resume the game
    setState(() {
      gameEnded = false;
      countdown = 3;
      startCountdown();
    });
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
    final randomDelay = Duration(seconds: 2 + (DateTime.now().millisecond % 6));

    // Play the beep sound after the random delay
    Future.delayed(randomDelay, () {
      if (gameEnded == false) {
        if (mounted) {
          player.play(AssetSource('beep_sound.mp3'));

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

        if (reactionTime!.inMilliseconds < baseThresholdGameFour) {
          reactionTime = Duration(milliseconds: bestReactionTime4);

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
                          setState(() {
                            gameEnded = true; // End the game
                            beepTime = null;
                            player.stop();
                          });
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
        } else {
          if (reactionTime!.inMilliseconds < bestReactionTime4 ||
              bestReactionTime4 == 0) {
            bestReactionTime4 = reactionTime!.inMilliseconds;
            storeBestReactionScore4(bestReactionTime4);
            widget.updateBestReactionTime4(bestReactionTime4);
          }
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
            title: Text('Invalid Tap', textAlign: TextAlign.center),
            content:
                Text('Wait for the beep sound', textAlign: TextAlign.center),
            actions: [
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        gameEnded = true; // End the game
                        beepTime = null;
                        player.stop();
                      });
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(Colors.black),
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
    final screenHeight = MediaQuery.of(context).size.height;

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
          actions: [
            IconButton(
              color: Colors.white,
              onPressed: navigateToInfoScreen,
              icon: Icon(Icons.info_outline),
              iconSize: 40,
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.only(top: 16.0),
            //   child: Container(
            //     // height: screenHeight * 0.23,
            //     // width: screenWidth,
            //     padding: EdgeInsets.all(16.0),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         SizedBox(height: 16.0),
            //         Text(
            //           '1. Wait for the beed sound',
            //           style: TextStyle(
            //             color: Colors.grey,
            //             fontSize: 22,
            //             fontWeight: FontWeight.bold,
            //           ),
            //           textAlign: TextAlign.left,
            //         ),
            //         SizedBox(height: 10.0),
            //         Text(
            //           '2. Tap the screen once you hear the sound',
            //           style: TextStyle(
            //             color: Colors.grey,
            //             fontSize: 22,
            //             fontWeight: FontWeight.bold,
            //           ),
            //           //textAlign: TextAlign.center,
            //         ),
            //         SizedBox(height: 10.0),
            //         Text(
            //           '3. React Quickly!',
            //           style: TextStyle(
            //             color: Colors.grey,
            //             fontSize: 22,
            //             fontWeight: FontWeight.bold,
            //           ),
            //           //textAlign: TextAlign.center,
            //         ),
            //         SizedBox(
            //           height: 20.0,
            //         ),
            //         if (!gameEnded)
            //           Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Icon(
            //                 Icons.volume_up,
            //                 color: Colors.grey,
            //                 size: 100,
            //               ),
            //               Text(
            //                 'Sound On',
            //                 style: TextStyle(color: Colors.grey),
            //               ),
            //             ],
            //           )
            //       ],
            //     ),
            //   ),
            // ),
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

                    // if (beepTime != null && reactionTime == null)
                    //   Text('Beep! Tap the screen as fast as you can!'),
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
                onLongPress: () {},
                child: Container(
                  color: Colors.black,
                  height: screenHeight * 0.75,
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
