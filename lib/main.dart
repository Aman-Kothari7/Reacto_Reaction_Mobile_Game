import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:test_game/ReactionGame_2.dart';
import 'package:test_game/ReactionGame_3.dart';
import 'package:test_game/image_strings.dart';
import 'package:test_game/info_screen.dart';
import 'package:test_game/level_ranges.dart';
import 'ReactionGame_1.dart';
import 'ReactionGame_4.dart';

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
      home: const MenuScreen(),
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

  @override
  void initState() {
    super.initState();
    loadBestReactionTime();
    loadBestReactionTime2();
    loadBestReactionScore3();
    loadBestReactionTime4();
  }

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
      int minScore = levelRange['minScore'];
      int maxScore = levelRange['maxScore'];

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
            padding: EdgeInsets.all(16),
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
                          knobStyle: KnobStyle(knobRadius: 0.05),
                          needleStartWidth: 2,
                          needleEndWidth: 6,
                        )
                      ],
                      annotations: <GaugeAnnotation>[
                        GaugeAnnotation(
                            widget: Container(
                                child: Text(currentLevelTitle,
                                    style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold))),
                            angle: 90,
                            positionFactor: 0.5)
                      ],
                    )
                  ],
                ),

                //level 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      level_one,
                      width: 50,
                      height: 50,
                    ),
                    Text('Level 1'),
                    Text('0 - 100'),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                //Level 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      level_two,
                      width: 50,
                      height: 50,
                    ),
                    Text('Level 2'),
                    Text('101-5999'),
                  ],
                ),
                //Level 3
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      level_three,
                      width: 50,
                      height: 50,
                    ),
                    Text('Level 3'),
                    Text('6000-9999'),
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
    double totalScore = ((10000 / (bestReactionTime ?? 1)) +
        (10000 / (bestReactionTime2 ?? 1)) +
        (10000 / (bestReactionTime4 ?? 1)) +
        (bestReactionScore3 ?? 0));

    double aggregateScore = (totalScore / 4) * 100;
    if (!aggregateScore.isNaN && !aggregateScore.isInfinite) {
      setState(() {
        this.aggregateScore = aggregateScore.round();
        showShareBubble = true;
      });
    }
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
                                              'Taps',
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
                    height: screenHeight * 0.10,
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
                                    'Check out my score: $aggregateScore!';

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
                                    builder: (context) => info_screen()));
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
