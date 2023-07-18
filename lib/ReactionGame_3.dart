import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReactionGameScreen3 extends StatefulWidget {
  final Function(int) updateBestReactionScore3;
  const ReactionGameScreen3(
      {super.key, required this.updateBestReactionScore3});

  @override
  _ReactionGameScreen3State createState() => _ReactionGameScreen3State();
}

class _ReactionGameScreen3State extends State<ReactionGameScreen3> {
  int score = 0;
  Timer? timer;
  int secondsLeft = 20;
  int? currentColoredIndex;
  List<bool> isColoredList = List.generate(12, (index) => false);
  int bestReactionScore3 = 0;

  @override
  void initState() {
    super.initState();
    retrieveBestReactionScore3();
    startGame();
  }

  void startGame() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsLeft > 0) {
        setState(() {
          secondsLeft--;
        });
      } else {
        timer.cancel();

        if (bestReactionScore3 == 0 || bestReactionScore3 < score) {
          bestReactionScore3 = score;
          print(bestReactionScore3);
          storeBestReactionScore3(bestReactionScore3);
          widget.updateBestReactionScore3(bestReactionScore3);
        }
        ;
        showGameOverDialog();
      }
    });
    currentColoredIndex = null;

    generateRandomColoredCircle();
  }

  void generateRandomColoredCircle() {
    // Clear any existing colored circles
    isColoredList = List.generate(12, (index) => false);

    // Generate a random index for the next colored circle
    int newIndex;
    do {
      newIndex = Random().nextInt(12);
    } while (newIndex == currentColoredIndex);

    currentColoredIndex = newIndex;
    isColoredList[currentColoredIndex!] = true;
  }

  void onTapCircle(int index) {
    if (isColoredList[index]) {
      setState(() {
        score++;
        isColoredList[index] = false;
      });

      generateRandomColoredCircle();
    }
  }

  void storeBestReactionScore3(int bestReactionScore3) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('bestReactionScore3', bestReactionScore3);
  }

  void retrieveBestReactionScore3() async {
    final prefs = await SharedPreferences.getInstance();
    final storedScore = prefs.getInt('bestReactionScore3');
    setState(() {
      bestReactionScore3 = storedScore ?? 0;
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: Text('Game Over', textAlign: TextAlign.center),
          content: Text('Your score: $score', textAlign: TextAlign.center),
          actions: [
            // SizedBox(
            //   width: double.infinity,
            //   child: TextButton(
            //     style: ButtonStyle(
            //       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //         RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(12.0),
            //         ),
            //       ),
            //       backgroundColor: MaterialStateProperty.all(Colors.black),
            //     ),
            //     child: Text(
            //       'Play Again',
            //       style: TextStyle(
            //         color: Colors.white,
            //       ),
            //     ),
            //     onPressed: () {
            //       setState(() {
            //         score = 0;
            //         secondsLeft = 20;
            //       });
            //       startGame();
            //       Navigator.of(context).pop();
            //     },
            //   ),
            // ),
            // SizedBox(
            //   width: 10,
            // ),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  child: Text(
                    'Exit',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
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
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
          ),
          title: Text(
            'SPEED',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            Container(
              // height: screenHeight * 0.23,
              // width: screenWidth,
              padding: EdgeInsets.all(16.0),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.0),
                  Text(
                    '1. Tap the red circles as fast as possible',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    '2. You have 20 seconds',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    //textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    '3. React quickly!',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    //textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Score: $score',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 20),
                  Text(
                    'Time: $secondsLeft',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: List.generate(12, (index) {
                  return GestureDetector(
                    onTap: () => onTapCircle(index),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: isColoredList[index]
                            ? Colors.red
                            : Colors.transparent,
                        radius: 50,
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
