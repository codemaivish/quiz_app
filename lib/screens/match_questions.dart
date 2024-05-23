import 'package:flutter/material.dart';
import 'package:quiz_app/screens/translate_questions.dart';
import 'package:confetti/confetti.dart';

class MatchQuestion extends StatefulWidget {
  @override
  _MatchQuestionState createState() => _MatchQuestionState();
}

class _MatchQuestionState extends State<MatchQuestion>
    with SingleTickerProviderStateMixin {
  List<int> numbers = [1, 2, 3, 4];
  List<String> words = ["Four", "Three", "Two", "One"];
  int? selectedNumber;
  String? selectedWord;
  Map<int, String> matchedPairs = {};
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
    if (selectedNumber != null && selectedWord != null) {
      if ((selectedNumber == 1 && selectedWord == "One") ||
          (selectedNumber == 2 && selectedWord == "Two") ||
          (selectedNumber == 3 && selectedWord == "Three") ||
          (selectedNumber == 4 && selectedWord == "Four")) {
        setState(() {
          matchedPairs[selectedNumber!] = selectedWord!;
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
      selectedNumber = null;
      selectedWord = null;
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
      if (matches == 4) {
        message = 'Amazing!';
      } else if (matches == 3) {
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
          if (isCorrect && matches == 4) {
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
          'Tap the matching pairs',
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
                  itemCount: numbers.length,
                  itemBuilder: (context, index) {
                    int number = numbers[index];
                    String word = words[index];
                    bool isMatchedNumber = matchedPairs.containsKey(number);
                    bool isMatchedWord = matchedPairs.containsValue(word);

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (!isMatchedNumber) {
                              setState(() {
                                selectedNumber = number;
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
                                  gradient: isMatchedNumber
                                      ? null
                                      : LinearGradient(
                                          colors: selectedNumber == number
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
                                    '$number',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              if (isMatchedNumber)
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
                            if (!isMatchedWord) {
                              setState(() {
                                selectedWord = word;
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
                                  gradient: isMatchedWord
                                      ? null
                                      : LinearGradient(
                                          colors: selectedWord == word
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
                                    word,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              if (isMatchedWord)
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
                  onPressed: () => navigateToNextQuestion(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'CHECK',
                      style: TextStyle(fontSize: 20),
                    ),
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
