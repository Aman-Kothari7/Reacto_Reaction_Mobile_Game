import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:test_game/ReactionGame_2.dart';
import 'package:test_game/ReactionGame_3.dart';
import 'package:test_game/ad_helper.dart';
import 'package:test_game/image_strings.dart';
import 'package:test_game/info_screen.dart';
import 'package:test_game/level_ranges.dart';
import 'ReactionGame_1.dart';
import 'ReactionGame_4.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const GameApp());
}

class GameApp extends StatelessWidget {
  const GameApp({super.key});

  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }


  // Future<InitializationStatus> _initGoogleMobileAds() {
  //   // TODO: Initialize Google Mobile Ads SDK
  // final requestConfiguration = RequestConfiguration(
  //   tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
  //   maxAdContentRating: MaxAdContentRating.g,
  // );

  // return MobileAds.instance.initialize(
  //   RequestConfiguration(
  //     requestConfiguration: <RequestConfiguration>[requestConfiguration],
  //   ),
  // );
  // }

  


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Games App',
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
  late final Function(int) updateBestReactionTime2;
  late final Function(int) updateBestReactionScore3;
  late final Function(int) updateBestReactionTime4;



  int? bestReactionTime;
  int? bestReactionTime2;
  int? bestReactionScore3;
  int? bestReactionTime4;
  int aggregateScore = 0;
  bool showShareBubble = false;
  bool showPlayAllGames = false;
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

    loadBestReactionTime();
    loadBestReactionTime2();
    loadBestReactionScore3();
    loadBestReactionTime4();
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();

    super.dispose();
  }

  final Map<String, Map<String, double>> levelThresholds = {
    "N": {
      "Game 1": 0,
      "Game 2": 0,
      "Game 3": 0,
      "Game 4": 0,
    },
    "F4": {
      "Game 1": 0,
      "Game 2": 0,
      "Game 3": 0,
      "Game 4": 0,
    },
    "F3": {
      "Game 1": 0,
      "Game 2": 0,
      "Game 3": 0,
      "Game 4": 0,
    },
    "F2": {
      "Game 1": 0,
      "Game 2": 0,
      "Game 3": 0,
      "Game 4": 0,
    },
    "F1": {
      "Game 1": 0,
      "Game 2": 0,
      "Game 3": 0,
      "Game 4": 0,
    },
    "C": {
      "Game 1": 0,
      "Game 2": 0,
      "Game 3": 0,
      "Game 4": 0,
    },
  };

  final List<Map<String, dynamic>> levelRanges = [
    {
      'minScore': levelOneMin,
      'maxScore': levelOneMax,
      'imagePath': level_one,
      'title': "N",
    },
    {
      'minScore': levelTwoMin,
      'maxScore': levelTwoMax,
      'imagePath': level_two,
      'title': "F4",
    },
    {
      'minScore': levelThreeMin,
      'maxScore': levelThreeMax,
      'imagePath': level_three,
      'title': "F3",
    },
    {
      'minScore': levelFourMin,
      'maxScore': levelFourMax,
      'imagePath': level_four,
      'title': "F2",
    },
    {
      'minScore': levelFiveMin,
      'maxScore': levelFiveMax,
      'imagePath': level_five,
      'title': "F1",
    },
    {
      'minScore': levelSixMin,
      'maxScore': levelSixMax,
      'imagePath': level_six,
      'title': "W",
    },
  ];

  String getCurrentLevelImagePath() {
    for (var levelRange in levelRanges) {
      int minScore = (levelRange['minScore'] as num).toInt();
      int maxScore = (levelRange['maxScore'] as num).toInt();

      if (aggregateScore >= minScore && aggregateScore <= maxScore) {
        return levelRange['imagePath'];
      }
    }

    // Return a default image path if no level range matches the aggregate score
    return 'assets/images/default.png';
  }

  void _showLevelDescription(BuildContext context) {
    String currentLevelTitle = getLevelTitle(aggregateScore);
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SfRadialGauge(
                  enableLoadingAnimation: true,
                  animationDuration: 4000,
                  axes: <RadialAxis>[
                    RadialAxis(
                      minimum: 0,
                      maximum: 4200,
                      //showLabels: false,
                      labelOffset: 40,
                      labelsPosition: ElementsPosition.inside,
                      ranges: <GaugeRange>[
                        GaugeRange(
                          startValue: levelOneMin,
                          endValue: levelOneMax,
                          color: Colors.red,
                          startWidth: 30,
                          endWidth: 30,
                          label: "N",
                          rangeOffset: 10,
                        ),
                        GaugeRange(
                          startValue: levelTwoMin,
                          endValue: levelTwoMax,
                          color: Colors.orange,
                          startWidth: 30,
                          endWidth: 30,
                          rangeOffset: 10,
                          label: "F4",
                        ),
                        GaugeRange(
                          startValue: levelThreeMin,
                          endValue: levelThreeMax,
                          color: Colors.yellow,
                          startWidth: 30,
                          endWidth: 30,
                          rangeOffset: 10,
                          label: "F3",
                        ),
                        GaugeRange(
                          startValue: levelFourMin,
                          endValue: levelFourMax,
                          color: Colors.lightGreen,
                          startWidth: 30,
                          endWidth: 30,
                          rangeOffset: 10,
                          label: "F2",
                        ),
                        GaugeRange(
                          startValue: levelFiveMin,
                          endValue: levelFiveMax,
                          color: Colors.green,
                          startWidth: 30,
                          endWidth: 30,
                          rangeOffset: 10,
                          label: "F1",
                        ),
                        GaugeRange(
                          startValue: levelSixMin,
                          endValue: levelSixMax,
                          color: Colors.purple,
                          startWidth: 30,
                          endWidth: 30,
                          rangeOffset: 10,
                          label: "W",
                        ),
                      ],
                      pointers: <GaugePointer>[
                        NeedlePointer(
                          value:
                              showShareBubble ? aggregateScore.toDouble() : 0,
                          enableAnimation: true,
                          animationDuration: 2000,
                          animationType: AnimationType.bounceOut,
                          knobStyle: const KnobStyle(knobRadius: 0.05),
                          needleStartWidth: 2,
                          needleEndWidth: 6,
                        )
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            widget: Text(currentLevelTitle,
                                style: const TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.bold)),
                            angle: 90,
                            positionFactor: 0.5)
                      ],
                    )
                  ],
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Every millisecond counts..",
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    Text(
                      "Practice to be your fastest self.",
                      style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'RANKINGS DESCRIPTION',
                      style: TextStyle(
                        fontSize: 18,
                        //fontStyle: FontStyle.italic,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),

                //level 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      levelOneNoTitle,
                      width: 75,
                      height: 75,
                    ),
                    const Text('N'),
                    const Text('0000 - 1999'),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                //Level 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      levelTwoNoTitle,
                      width: 75,
                      height: 75,
                    ),
                    const Text('F4'),
                    const Text('2000 - 2699'),
                  ],
                ),
                //Level 3
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      levelThreeNoTitle,
                      width: 75,
                      height: 75,
                    ),
                    const Text('F3'),
                    const Text('2700 - 3299'),
                  ],
                ),
                //Level 4
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      levelFourNoTitle,
                      width: 75,
                      height: 75,
                    ),
                    const Text('F2'),
                    const Text('3300 - 3799'),
                  ],
                ),
                //Level 4
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      levelFiveNoTitle,
                      width: 75,
                      height: 75,
                    ),
                    const Text('F1'),
                    const Text('3800 - 3999'),
                  ],
                ),
                //Level 3
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      levelSixNoTitle,
                      width: 75,
                      height: 75,
                    ),
                    const Text('W'),
                    const Text('4000 - 6000'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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

  void loadBestReactionTime4() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      bestReactionTime4 = prefs.getInt('bestReactionTime4') ?? 0;
      updateAggregateScore();
    });
  }

  void updateAggregateScore() {
    bool meetsThreshold = true;
    if (bestReactionTime == 0 ||
        bestReactionTime2 == 0 ||
        bestReactionTime4 == 0 ||
        bestReactionScore3 == 0 ||
        bestReactionTime == null ||
        bestReactionTime2 == null ||
        bestReactionTime4 == null ||
        bestReactionScore3 == null) {
      setState(() {
        aggregateScore = 0;
        showShareBubble = false;
        showPlayAllGames = true;
      });
    } else {
      // Calculate individual game scores
      double gameScore1 = (10000 / bestReactionTime!);
      double gameScore2 = (10000 / bestReactionTime2!);
      double gameScore3 = (bestReactionScore3! as num).toDouble();
      double gameScore4 = (10000 / bestReactionTime4!);

      // double totalScore = ((10000 / bestReactionTime!) +
      //     (10000 / bestReactionTime2!) +
      //     (10000 / bestReactionTime4!) +
      //     bestReactionScore3!);

      // double aggregateScore = (totalScore / 4) * 100;

      // Calculate the aggregate score based on individual game scores
      double totalScore = (gameScore1 + gameScore2 + gameScore4 + gameScore3);
      double aggregateScore = (totalScore / 4) * 100;

      // Get the thresholds for the current level
      String currentLevel = getLevelTitle(aggregateScore.round());
      Map<String, double> thresholdsForCurrentLevel =
          levelThresholds[currentLevel] ?? {};

      // Check if any game score is below its threshold
      if (gameScore1 < (thresholdsForCurrentLevel["Game 1"] ?? 0) ||
          gameScore2 < (thresholdsForCurrentLevel["Game 2"] ?? 0) ||
          gameScore3 < (thresholdsForCurrentLevel["Game 3"] ?? 0) ||
          gameScore4 < (thresholdsForCurrentLevel["Game 4"] ?? 0)) {
        meetsThreshold = false;
        print("false");
      }

      if (!aggregateScore.isNaN && !aggregateScore.isInfinite) {
        setState(() {
          if (meetsThreshold) {
            this.aggregateScore = aggregateScore.round();
            showShareBubble = true;
            showPlayAllGames = false;
          } else {
            print("Going into method if meetsThreshold is false");
            int currentLevelScore = getCurrentLevelScore(gameScore1.round(),
                gameScore2.round(), gameScore3.round(), gameScore4.round());
            print(currentLevelScore);
            this.aggregateScore = currentLevelScore;
            showShareBubble = true;
            showPlayAllGames = true;
          }
        });
      }
    }
  }

  int getCurrentLevelScore(
      int scoreGame1, int scoreGame2, int scoreGame3, int scoreGame4) {
    int currentLevelScore = 0;

    for (var levelRange in levelRanges) {
      String levelTitle = levelRange['title'] as String;
      Map<String, double> thresholds = levelThresholds[levelTitle] ?? {};
      // Check if all game scores meet the threshold for this level
      if (scoreGame1 >= (thresholds['Game 1'] ?? 0) &&
          scoreGame2 >= (thresholds['Game 2'] ?? 0) &&
          scoreGame3 >= (thresholds['Game 3'] ?? 0) &&
          scoreGame4 >= (thresholds['Game 4'] ?? 0)) {
        currentLevelScore = (levelRange['maxScore'] as num).toInt();
        break;
      }
    }

    return currentLevelScore;
  }

  String getLevelTitle(int score) {
    for (var levelRange in levelRanges) {
      int minScore = (levelRange['minScore'] as num).toInt();
      int maxScore = (levelRange['maxScore'] as num).toInt();

      if (score >= minScore && score <= maxScore) {
        return levelRange['title'] as String;
      }
    }

    // Return a default title if no level range matches the aggregate score
    return 'Level';
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    String currentLevelTitle = getLevelTitle(aggregateScore);
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: (_bannerAd != null)
            ? SizedBox(
                width: _bannerAd!.size.width.toDouble(),
                height: _bannerAd!.size.height.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              )
            : Text(""),
        body: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // 1st game
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                  // style: ElevatedButton.styleFrom(
                                  //   backgroundColor: Colors.white,
                                  // ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ReactionGameScreen1(
                                                updateBestReactionTime:
                                                    (newBestReactionTime) {
                                                  setState(() {
                                                    bestReactionTime =
                                                        newBestReactionTime;
                                                    updateAggregateScore();
                                                  });
                                                },
                                              )),
                                    );
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: screenHeight * 0.25,
                                        ),
                                        Text(
                                          'LIGHTS',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        Text(
                                          '1',
                                          style: TextStyle(fontSize: 50),
                                        ),
                                        SizedBox(
                                          height: screenHeight * 0.15,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'PB',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            for (var digit
                                                in (bestReactionTime != 0
                                                        ? bestReactionTime
                                                            .toString()
                                                        : '-')
                                                    .split(''))
                                              Text(
                                                digit,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            Text(
                                              'ms',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                  // const Text(
                                  //   '1',
                                  //   style: TextStyle(
                                  //       fontSize: 50, color: Colors.black),
                                  // ),
                                  ),
                            ),
                          ],
                        ),
                      ),

                      //2nd game
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                  // style: ElevatedButton.styleFrom(
                                  //   backgroundColor: Colors.black,
                                  // ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReactionGameScreen2(
                                          updateBestReactionTime2:
                                              (newBestReactionTime2) {
                                            setState(() {
                                              bestReactionTime2 =
                                                  newBestReactionTime2;
                                              updateAggregateScore();
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    color: Colors.black,
                                    child: Column(
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: screenHeight * 0.25,
                                        ),
                                        Text(
                                          'COLOR',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '2',
                                          style: TextStyle(
                                            fontSize: 50,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(
                                          height: screenHeight * 0.15,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'PB',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            for (var digit
                                                in (bestReactionTime2 != 0
                                                        ? bestReactionTime2
                                                            .toString()
                                                        : '-')
                                                    .split(''))
                                              Text(
                                                digit,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            Text(
                                              'ms',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                  //const Text(
                                  //   '2',
                                  //   style: TextStyle(fontSize: 50),
                                  // ),
                                  ),
                            ),
                          ],
                        ),
                      ),

                      //3rd game
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                  // style: ElevatedButton.styleFrom(
                                  //   backgroundColor: Colors.white,
                                  // ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReactionGameScreen3(
                                          updateBestReactionScore3:
                                              (newBestReactionScore3) {
                                            setState(() {
                                              bestReactionScore3 =
                                                  newBestReactionScore3;
                                              updateAggregateScore();
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    child: Column(
                                      //mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: screenHeight * 0.25,
                                        ),
                                        Text(
                                          'SPEED',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        const Text(
                                          '3',
                                          style: TextStyle(fontSize: 50),
                                        ),
                                        SizedBox(
                                          height: screenHeight * 0.15,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Text(
                                              'PB',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            for (var digit
                                                in (bestReactionScore3 != 0
                                                        ? bestReactionScore3
                                                            .toString()
                                                        : '-')
                                                    .split(''))
                                              Text(
                                                digit,
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            Text(
                                              'taps',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                  // const Text(
                                  //   '3',
                                  //   style:
                                  //       TextStyle(fontSize: 50, color: Colors.black),
                                  // ),
                                  ),
                            ),
                          ],
                        ),
                      ),

                      //4th game
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                  // style: ElevatedButton.styleFrom(
                                  //   backgroundColor: Colors.black,
                                  // ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ReactionGameScreen4(
                                          updateBestReactionTime4:
                                              (newBestReactionTime4) {
                                            setState(() {
                                              bestReactionTime4 =
                                                  newBestReactionTime4;
                                              updateAggregateScore();
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    color: Colors.black,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: screenHeight * 0.25,
                                        ),
                                        Text(
                                          'SOUND',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const Text(
                                          '4',
                                          style: TextStyle(
                                            fontSize: 50,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: screenHeight * 0.15,
                                            ),
                                            const Text(
                                              'PB',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            for (var digit
                                                in (bestReactionTime4 != 0
                                                        ? bestReactionTime4
                                                            .toString()
                                                        : '-')
                                                    .split(''))
                                              Text(
                                                digit,
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            Text(
                                              'ms',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                    ),
                    height: screenHeight * 0.13,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showLevelDescription(context);
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (showPlayAllGames)
                                Container(
                                  //color: Colors.black,
                                  child: Text(
                                    " Play All Games ",
                                    style: TextStyle(color: Colors.black),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'SCORE',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${aggregateScore != 0 ? aggregateScore : '-'}',
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(
                        //   width: screenWidth * 0.10,
                        // ),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (showShareBubble)
                              Container(
                                color: Colors.black,
                                child: Text(
                                  " SHARE SCORE ",
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            IconButton(
                              onPressed: () async {
                                // Get the image file as bytes
                                final ByteData bytes = await rootBundle
                                    .load(getCurrentLevelImagePath());
                                final Uint8List imageBytes =
                                    bytes.buffer.asUint8List();

                                // Save the image to a temporary file
                                final tempDir = await getTemporaryDirectory();
                                final tempFile =
                                    await File('${tempDir.path}/level.jpg')
                                        .create();
                                tempFile.writeAsBytesSync(imageBytes);

                                String shareText =
                                    'Check out my score: $aggregateScore, Get your reaction score now: http://bit.ly/react-now';

                                // Share the image
                                await Share.shareFiles(
                                  [tempFile.path],
                                  text: shareText,
                                  mimeTypes: ['image/jpeg'],
                                  subject:
                                      'Sharing Image', // Optional subject for the sharing dialog
                                );
                              },
                              icon: Icon(Icons.share),
                              color: Colors.black,
                              iconSize: 24,
                              //splashColor: Colors.grey,
                            ),
                          ],
                        ),

                        IconButton(
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
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: screenHeight * 0.15,
                color: Colors.transparent,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.transparent,

                        // First Element
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          _showLevelDescription(context);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 6.0,
                                spreadRadius: 2.0,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),

                          child: SfRadialGauge(
                            enableLoadingAnimation: true,
                            animationDuration: 4000,
                            axes: <RadialAxis>[
                              RadialAxis(
                                minimum: 0,
                                maximum: 4200,
                                showLabels: false,
                                ranges: <GaugeRange>[
                                  GaugeRange(
                                    startValue: levelOneMin,
                                    endValue: levelOneMax,
                                    color: Colors.red,
                                    startWidth: 30,
                                    endWidth: 30,
                                    //label: "N",
                                    rangeOffset: 10,
                                  ),
                                  GaugeRange(
                                    startValue: levelTwoMin,
                                    endValue: levelTwoMax,
                                    color: Colors.orange,
                                    startWidth: 30,
                                    endWidth: 30,
                                    rangeOffset: 10,
                                    //label: "F4",
                                  ),
                                  GaugeRange(
                                    startValue: levelThreeMin,
                                    endValue: levelThreeMax,
                                    color: Colors.yellow,
                                    startWidth: 30,
                                    endWidth: 30,
                                    rangeOffset: 10,
                                    //label: "F3",
                                  ),
                                  GaugeRange(
                                    startValue: levelFourMin,
                                    endValue: levelFourMax,
                                    color: Colors.lightGreen,
                                    startWidth: 30,
                                    endWidth: 30,
                                    rangeOffset: 10,
                                    //label: "F2",
                                  ),
                                  GaugeRange(
                                    startValue: levelFiveMin,
                                    endValue: levelFiveMax,
                                    color: Colors.green,
                                    startWidth: 30,
                                    endWidth: 30,
                                    rangeOffset: 10,
                                    //label: "F1",
                                  ),
                                  GaugeRange(
                                    startValue: levelSixMin,
                                    endValue: levelSixMax,
                                    color: Colors.purple,
                                    startWidth: 30,
                                    endWidth: 30,
                                    rangeOffset: 10,
                                    //label: "W",
                                  ),
                                ],
                                pointers: <GaugePointer>[
                                  NeedlePointer(
                                    value: showShareBubble
                                        ? aggregateScore.toDouble()
                                        : 0,
                                    enableAnimation: true,
                                    animationDuration: 2000,
                                    animationType: AnimationType.bounceOut,
                                    knobStyle: KnobStyle(knobRadius: 0),
                                    needleStartWidth: 1,
                                    needleEndWidth: 3,
                                  )
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                      widget: Container(
                                          child: Text(currentLevelTitle,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight:
                                                      FontWeight.bold))),
                                      angle: 90,
                                      positionFactor: 0.8)
                                ],
                              )
                            ],
                          ),

                          // Middle Element
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        color: Colors.transparent,

                        // Third Element
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
