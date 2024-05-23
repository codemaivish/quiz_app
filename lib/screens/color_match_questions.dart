import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:quiz_app/screens/translate_questions.dart'; // Ensure this is the correct path

class ColorMatchQuestion extends StatefulWidget {
  @override
  _ColorMatchQuestionState createState() => _ColorMatchQuestionState();
}

class _ColorMatchQuestionState extends State<ColorMatchQuestion>
    with SingleTickerProviderStateMixin {
  List<String> fruits = ["Banana", "Tomato", "Eggplant"];
  List<String> colors = ["Red", "Purple", "Yellow"];
  String? selectedFruit;
  String? selectedColor;
  Map<String, String> matchedPairs = {};
  bool showFeedback = false;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void checkMatch() {
    if (selectedFruit != null && selectedColor != null) {
      if ((selectedFruit == "Banana" && selectedColor == "Yellow") ||
          (selectedFruit == "Tomato" && selectedColor == "Red") ||
          (selectedFruit == "Eggplant" && selectedColor == "Purple")) {
        setState(() {
          matchedPairs[selectedFruit!] = selectedColor!;
          _confettiController.play();
        });
        showFeedbackPopup(context,
            isCorrect: true); // Show correct feedback popup
      } else {
        showFeedbackPopup(context,
            isCorrect: false); // Show incorrect feedback popup
      }
      resetSelection();
    }
  }

  void resetSelection() {
    setState(() {
      selectedFruit = null;
      selectedColor = null;
    });
  }

  void navigateToNextQuestion() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TranslateQuestion()),
    );
  }

  void showFeedbackPopup(BuildContext context, {required bool isCorrect}) {
    int matches = matchedPairs.length;
    String message;

    if (isCorrect) {
      if (matches == 3) {
        message = 'Amazing!';
      } else if (matches == 2) {
        message = 'Good!';
      } else {
        message = 'Acceptable!';
      }
    } else {
      message = 'Wrong!';
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 1), () {
          Navigator.of(context).pop();
          if (isCorrect && matches == 3) {
            navigateToNextQuestion();
          }
        });
        return Stack(
          children: [
            if (isCorrect)
              ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ],
              ),
            AlertDialog(
              backgroundColor: Colors.white,
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: Text(
                isCorrect ? message : 'Wrong!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isCorrect ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              content: Icon(
                isCorrect ? Icons.check_circle : Icons.cancel,
                color: isCorrect ? Colors.green : Colors.red,
                size: 100,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double containerHeight = MediaQuery.of(context).size.height * 0.2;
    double buttonHeight = 60;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Match the Fruits with Their Colors',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: fruits.length,
                  itemBuilder: (context, index) {
                    String fruit = fruits[index];
                    String color = colors[index];
                    bool isMatchedFruit = matchedPairs.containsKey(fruit);
                    bool isMatchedColor = matchedPairs.containsValue(color);

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (!isMatchedFruit) {
                              setState(() {
                                selectedFruit = fruit;
                                checkMatch();
                              });
                            }
                          },
                          child: Stack(
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                height: containerHeight,
                                width: MediaQuery.of(context).size.width * 0.3,
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  gradient: isMatchedFruit
                                      ? null
                                      : LinearGradient(
                                          colors: selectedFruit == fruit
                                              ? [
                                                  Colors.blueAccent,
                                                  Colors.lightBlueAccent,
                                                ]
                                              : [
                                                  Colors.white,
                                                  Colors.white.withOpacity(0.5)
                                                ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: Offset(
                                          2, 2), // changes position of shadow
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.blue.withOpacity(0.6),
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    fruit,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              if (isMatchedFruit)
                                Positioned.fill(
                                  child: ConfettiWidget(
                                    confettiController: _confettiController,
                                    blastDirectionality:
                                        BlastDirectionality.explosive,
                                    shouldLoop: false,
                                    colors: const [
                                      Colors.green,
                                      Colors.blue,
                                      Colors.pink,
                                      Colors.orange,
                                      Colors.purple
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!isMatchedColor) {
                              setState(() {
                                selectedColor = color;
                                checkMatch();
                              });
                            }
                          },
                          child: Stack(
                            children: [
                              AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                height: containerHeight,
                                width: MediaQuery.of(context).size.width * 0.3,
                                padding: EdgeInsets.all(20),
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  gradient: isMatchedColor
                                      ? null
                                      : LinearGradient(
                                          colors: selectedColor == color
                                              ? [
                                                  Colors.blueAccent,
                                                  Colors.lightBlueAccent,
                                                ]
                                              : [
                                                  Colors.white,
                                                  Colors.white.withOpacity(0.5)
                                                ],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: Offset(
                                          2, 2), // changes position of shadow
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.blue.withOpacity(0.6),
                                    width: 2,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    color,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              if (isMatchedColor)
                                Positioned.fill(
                                  child: ConfettiWidget(
                                    confettiController: _confettiController,
                                    blastDirectionality:
                                        BlastDirectionality.explosive,
                                    shouldLoop: false,
                                    colors: const [
                                      Colors.green,
                                      Colors.blue,
                                      Colors.pink,
                                      Colors.orange,
                                      Colors.purple
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(
                height: buttonHeight,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: navigateToNextQuestion,
                  child: Text(
                    'CHECK',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
