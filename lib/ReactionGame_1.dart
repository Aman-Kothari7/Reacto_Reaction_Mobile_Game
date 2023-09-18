import 'dart:async';
import 'dart:math';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:test_game/ad_helper.dart';
import 'package:test_game/level_ranges.dart';

import 'info_screen.dart';

class ReactionGameScreen1 extends StatefulWidget {
  final Function(int) updateBestReactionTime;

  const ReactionGameScreen1({super.key, required this.updateBestReactionTime});

  @override
  _ReactionGameScreen1State createState() => _ReactionGameScreen1State();
}

class _ReactionGameScreen1State extends State<ReactionGameScreen1> {
  List<bool> showCircle = [false, false, false, false, false];
  int circleIndex = 0;
  bool changeColors = false;
  DateTime? colorChangeTime;
  DateTime? tapTime;
  int? reactionTime;
  bool gameInProgress = true;
  Timer? circlesTimer;
  int? bestReactionTime;
  bool gameEnded = false;
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

    retrieveBestReactionTime();
    startShowingCircles();
  }

  @override
  void dispose() {
    circlesTimer?.cancel(); // Cancel the timer in the dispose() method
    _bannerAd?.dispose();
    super.dispose();
  }

  void restartGame() {
    setState(() {
      showCircle = [false, false, false, false, false];
      changeColors = false;
      colorChangeTime = null;
      tapTime = null;
      reactionTime = null;
      gameInProgress = true;
    });
    startShowingCircles();
  }

  void startShowingCircles() {
    setState(() {
      gameEnded = false;
    });
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

        if (reactionTime! < baseThresholdGameOne) {
          reactionTime = bestReactionTime!;
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
                content: Text(
                    'Please return to the starting grid, incident under review. Scores below 150ms are not accepted.',
                    textAlign: TextAlign.center),
                actions: [
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          setState(() {
                            gameInProgress = false; // End the game
                          });
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
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
          if (bestReactionTime == 0 || reactionTime! < bestReactionTime!) {
            bestReactionTime = reactionTime;
            storeBestReactionTime(
                bestReactionTime!); // Store the best time in shared preferences
            widget.updateBestReactionTime(bestReactionTime!);
            //print(bestReactionTime);
          }
        }
      });
    } else if (mounted && changeColors == false && colorChangeTime == null) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            title: Text('FALSE START', textAlign: TextAlign.center),
            content: Text(
                'Wait for the lights to change color. Incident under review.',
                textAlign: TextAlign.center),
            actions: [
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        gameInProgress = false; // End the game
                      });
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
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
    if (reactionTime != null) {
      setState(() {
        gameEnded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // double screenHeight = MediaQuery.of(context).size.height;
    // double screenWidth = MediaQuery.of(context).size.width;
    // ;

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: (_bannerAd != null)
            ? SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              )
            : Text(""),
        appBar: AppBar(
          leading: BackButton(
            color: Colors.black,
          ),
          title: Text(
            'LIGHTS',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              color: Colors.black,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            info_screen(initialPageIndex: 0)));
              },
              icon: Icon(Icons.info_outline),
              iconSize: 40,
            )
          ],
        ),
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: handleTap,
          onLongPress: () {},
          child: Stack(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(top: 16.0),
              //   child: Container(
              //     // height: screenHeight * 0.23,
              //     // width: screenWidth,
              //     padding: EdgeInsets.all(16.0),
              //     child: const Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         SizedBox(height: 16.0),
              //         Text(
              //           '1. Wait for the lights to change color',
              //           style: TextStyle(
              //             color: Colors.grey,
              //             fontSize: 22,
              //             fontWeight: FontWeight.bold,
              //           ),
              //           textAlign: TextAlign.left,
              //         ),
              //         SizedBox(height: 10.0),
              //         Text(
              //           '2. Tap the screen as quickly as possible',
              //           style: TextStyle(
              //             color: Colors.grey,
              //             fontSize: 22,
              //             fontWeight: FontWeight.bold,
              //           ),
              //           //textAlign: TextAlign.center,
              //         ),
              //         SizedBox(height: 10.0),
              //         Text(
              //           '3. Your reaction time will be displayed below',
              //           style: TextStyle(
              //             color: Colors.grey,
              //             fontSize: 22,
              //             fontWeight: FontWeight.bold,
              //           ),
              //           //textAlign: TextAlign.center,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (showCircle[0]) _buildCircle(changeColors),
                        if (showCircle[1]) _buildCircle(changeColors),
                        if (showCircle[2]) _buildCircle(changeColors),
                        if (showCircle[3]) _buildCircle(changeColors),
                        if (showCircle[4]) _buildCircle(changeColors),
                      ],
                    ),
                    if (reactionTime != null)
                      Text(
                        'Reaction Time: ${reactionTime} ms',
                        style: TextStyle(fontSize: 20),
                      ),
                    const SizedBox(
                      height: 20.0,
                    ),
                  ],
                ),
              ),
              if (gameEnded)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 80,
                  child: IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: restartGame,
                    tooltip: 'Restart Game',
                    iconSize: 40,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircle(bool changeColors) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: screenWidth * 0.15,
      height: screenHeight * 0.1,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: changeColors ? Colors.white : Colors.red,
        border: Border.all(
            color: changeColors ? Colors.black : Colors.transparent, width: 1),
      ),
      margin: EdgeInsets.all(screenWidth * 0.02),
    );
  }
}
