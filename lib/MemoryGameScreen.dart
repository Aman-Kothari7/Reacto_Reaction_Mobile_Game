import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';

class MemoryGameScreen extends StatefulWidget {
  final Function(int) updateBestMemoryScore;
  const MemoryGameScreen({Key? key, required this.updateBestMemoryScore})
      : super(key: key);

  @override
  _MemoryGameScreenState createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen>
    with TickerProviderStateMixin {
  int level = 1;
  int currentNumber = 0;
  int userNumber = 0;
  bool showNumber = true;
  int highestLevel = 0;

  Timer? timer;
  AnimationController? animationController;
  Animation<double>? progressAnimation;
  int countdownDuration = 3;

  @override
  void initState() {
    super.initState();
    startGame();
    loadHighestMemoryLevel();
  }

  @override
  void dispose() {
    timer?.cancel();
    animationController?.dispose();
    super.dispose();
  }

  void startGame() {
    setState(() {
      currentNumber = generateRandomNumber(level);
      showNumber = true;
      countdownDuration = 3; // Reset countdown duration
    });

    animationController?.dispose(); // Dispose previous controller if exists

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: countdownDuration),
    );

    progressAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(animationController!)
          ..addListener(() {
            setState(() {});
          });

    animationController!.forward();

    timer = Timer(Duration(seconds: countdownDuration), () {
      setState(() {
        showNumber = false;
      });
    });
  }

  void loadHighestMemoryLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      highestLevel = prefs.getInt('highestLevel') ?? 0;
    });
  }

  void checkAnswer() {
    if (userNumber == currentNumber) {
      setState(() {
        level++;
        userNumber = 0;
      });
      if (level > highestLevel) {
        setState(() {
          highestLevel = level - 1;
        });
        saveHighestLevel(); // Save the highest level to shared preferences
        widget.updateBestMemoryScore(highestLevel);
      }
      startGame();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Wrong Answer'),
            content: Text('Try Again!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void saveHighestLevel() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highestLevel', highestLevel);
  }

  int generateRandomNumber(int digits) {
    final random = Random();
    final buffer = StringBuffer();
    for (int i = 0; i < digits; i++) {
      final digit = random.nextInt(10);
      buffer.write(digit);
    }
    print(buffer);
    return int.parse(buffer.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Number Memory Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //SizedBox(height: 50),
            Text(
              'Level: $level',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 50),
            if (showNumber)
              Text(
                currentNumber.toString(),
                style: TextStyle(fontSize: calculateFontSize(currentNumber)),
              ),
            if (!showNumber)
              TextField(
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    userNumber = int.tryParse(value) ?? 0;
                  });
                },
                onSubmitted: (value) {
                  checkAnswer();
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 48),
                decoration: InputDecoration(
                  hintText: 'Enter the number',
                ),
              ),
            SizedBox(height: 20),
            LinearProgressIndicator(
              value: progressAnimation?.value ?? 1.0,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back),
            ),
          ],
        ),
      ),
    );
  }

  calculateFontSize(int number) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxLength = number.toString().length;

    // Calculate the optimal font size based on the screen width and number of digits
    final fontSize = min(screenWidth / maxLength, 48);

    return fontSize;
  }
}
