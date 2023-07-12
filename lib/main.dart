import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_game/ReactionGame_2.dart';
import 'package:test_game/ReactionGame_3.dart';
import 'package:test_game/image_strings.dart';
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
      'minScore': 0,
      'maxScore': 1,
      'imagePath': level_one,
    },
    {
      'minScore': 2,
      'maxScore': 5999,
      'imagePath': level_two,
    },
    {
      'minScore': 6000,
      'maxScore': 9999,
      'imagePath': level_three,
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
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
                                      builder: (context) => ReactionGameScreen1(
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
                                      height: 350.0,
                                    ),
                                    Text(
                                      '1',
                                      style: TextStyle(fontSize: 50),
                                    ),
                                    SizedBox(
                                      height: 150.0,
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
                                        for (var digit in (bestReactionTime != 0
                                                ? bestReactionTime.toString()
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
                                    builder: (context) => ReactionGameScreen2(
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
                                      height: 350.0,
                                    ),
                                    Text(
                                      '2',
                                      style: TextStyle(
                                        fontSize: 50,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 150.0,
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
                                        for (var digit in (bestReactionTime2 !=
                                                    0
                                                ? bestReactionTime2.toString()
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
                                    builder: (context) => ReactionGameScreen3(
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
                                      height: 350.0,
                                    ),
                                    const Text(
                                      '3',
                                      style: TextStyle(fontSize: 50),
                                    ),
                                    SizedBox(
                                      height: 150.0,
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
                                        for (var digit in (bestReactionScore3 !=
                                                    0
                                                ? bestReactionScore3.toString()
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
                                    builder: (context) => ReactionGameScreen4(
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
                                      height: 350.0,
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
                                          height: 150.0,
                                        ),
                                        const Text(
                                          'PB',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        for (var digit in (bestReactionTime4 !=
                                                    0
                                                ? bestReactionTime4.toString()
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
                    border: Border.all(color: Colors.black)),
                height: 75,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'SCORE',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '${aggregateScore != 0 ? aggregateScore : '-'}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Image.asset(
                      getCurrentLevelImagePath(),
                      width: 50,
                      height: 30,
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

// Column(
//           //mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => ReactionGameScreen1(
//                             updateBestReactionTime: (newBestReactionTime) {
//                               setState(() {
//                                 bestReactionTime = newBestReactionTime;
//                                 updateAggregateScore();
//                               });
//                             },
//                           )),
//                 );
//               },
//               child: Text('Reaction Game 1'),
//             ),
//             Text(
//               'Best: ${bestReactionTime.toString()} ms',
//               style: TextStyle(fontSize: 16),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ReactionGameScreen2(
//                       updateBestReactionTime2: (newBestReactionTime2) {
//                         setState(() {
//                           bestReactionTime2 = newBestReactionTime2;
//                           updateAggregateScore();
//                         });
//                       },
//                     ),
//                   ),
//                 );
//               },
//               child: const Text('Reaction Game 2'),
//             ),
//             Text(
//               'Best: ${bestReactionTime2.toString()} ms',
//               style: TextStyle(fontSize: 16),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ReactionGameScreen3(
//                       updateBestReactionScore3: (newBestReactionScore3) {
//                         setState(() {
//                           bestReactionScore3 = newBestReactionScore3;
//                           updateAggregateScore();
//                         });
//                       },
//                     ),
//                   ),
//                 );
//               },
//               child: const Text('Reaction Game 3'),
//             ),
//             Text(
//               'Best: ${bestReactionScore3.toString()} score',
//               style: TextStyle(fontSize: 16),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ReactionGameScreen4(
//                       updateBestReactionTime4: (newBestReactionTime4) {
//                         setState(() {
//                           bestReactionTime4 = newBestReactionTime4;
//                           updateAggregateScore();
//                         });
//                       },
//                     ),
//                   ),
//                 );
//               },
//               child: const Text('Reaction Game 4'),
//             ),
//             Text(
//               'Best: ${bestReactionTime4.toString()} ms',
//               style: TextStyle(fontSize: 16),
//             ),
//             SizedBox(height: 50.0),
            // Text(
            //   'Aggregate Score: $aggregateScore',
            //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            // ),
//           ],
//         ),
