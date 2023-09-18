import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_game/ad_helper.dart';

import 'info_screen.dart';

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
  List<bool> isColoredList = List.generate(15, (index) => false);
  int bestReactionScore3 = 0;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
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
    isColoredList = List.generate(15, (index) => false);

    // Generate a random index for the next colored circle
    int newIndex;
    do {
      newIndex = Random().nextInt(15);
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
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            title: Text('Checkered Flag', textAlign: TextAlign.center),
            content: Text('Your score: $score', textAlign: TextAlign.center),
            actions: [
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
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  void navigateToInfoScreen() async {
    // Pause the game
    timer?.cancel();

    // Navigate to the info screen and wait for it to complete
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => info_screen(initialPageIndex: 2),
      ),
    );

    // Resume the game
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: (_bannerAd != null)
            ? SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              )
            : SizedBox(),
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
          actions: [
            IconButton(
              color: Colors.black,
              onPressed: navigateToInfoScreen,
              icon: Icon(Icons.info_outline),
              iconSize: 40,
            )
          ],
        ),
        body: Column(
          children: [
            // Container(
            //   // height: screenHeight * 0.23,
            //   // width: screenWidth,
            //   padding: EdgeInsets.all(16.0),
            //   child: const Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       SizedBox(height: 16.0),
            //       Text(
            //         '1. Tap the red circles as fast as possible',
            //         style: TextStyle(
            //           color: Colors.grey,
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold,
            //         ),
            //         textAlign: TextAlign.left,
            //       ),
            //       SizedBox(height: 10.0),
            //       Text(
            //         '2. You have 20 seconds',
            //         style: TextStyle(
            //           color: Colors.grey,
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold,
            //         ),
            //         //textAlign: TextAlign.center,
            //       ),
            //       SizedBox(height: 10.0),
            //       Text(
            //         '3. React quickly!',
            //         style: TextStyle(
            //           color: Colors.grey,
            //           fontSize: 18,
            //           fontWeight: FontWeight.bold,
            //         ),
            //         //textAlign: TextAlign.center,
            //       ),
            //     ],
            //   ),
            // ),
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
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final screenWidth = constraints.maxWidth;
                  final availableSpaceForCircles =
                      screenWidth - 16; // Adjust padding as needed
                  double circleSize;
                  if (screenWidth >= 400) {
                    // For bigger phones or tablets
                    circleSize = availableSpaceForCircles / 3;
                  } else {
                    // For smaller phones
                    circleSize = availableSpaceForCircles / 4;
                  }
                  return Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(15, (index) {
                      return GestureDetector(
                        onTap: () => onTapCircle(index),
                        child: Container(
                          width: constraints.maxWidth / 3 - 8,
                          height: circleSize,
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
                            radius: (constraints.maxWidth / 3 - 8) / 2,
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
