import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/foundation.dart';

class TranslateQuestion extends StatefulWidget {
  @override
  _TranslateQuestionState createState() => _TranslateQuestionState();
}

class _TranslateQuestionState extends State<TranslateQuestion> {
  final List<String> options = ["दुरुस्त", "भली", "आए", "देर", "भला", "आए"];
  final Set<int> selectedOptions = {};
  final FlutterTts flutterTts = FlutterTts();
  final double buttonHeight = 60.0; // Define the button height here
  final List<String> correctAnswer = ["देर", "आए", "दुरुस्त", "आए"];

  void playSound() async {
    await flutterTts.speak("Better late than never");
  }

  void navigateToThirdScreen(bool isCorrect) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            isCorrect ? 'Correct!' : 'Wrong!',
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
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Translate this Question',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/download.jpeg',
            height: 300,
            width: 300,
          ),
          SizedBox(height: 20),
          QuestionHeader(onPlaySound: playSound),
          SizedBox(height: 20),
          WordSelection(
            options: options,
            selectedOptions: selectedOptions,
            onOptionSelected: (index) {
              setState(() {
                if (selectedOptions.contains(index)) {
                  selectedOptions.remove(index);
                } else {
                  selectedOptions.add(index);
                }
              });
            },
          ),
          SizedBox(height: 20),
          SelectedWordsDisplay(
            options: options,
            selectedOptions: selectedOptions,
          ),
          SizedBox(
            height: 18,
            width: double.infinity,
          ),
          SizedBox(
            height: buttonHeight,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                List<String> selectedAnswer =
                    selectedOptions.map((index) => options[index]).toList();
                bool isCorrect = listEquals(selectedAnswer, correctAnswer);
                navigateToThirdScreen(isCorrect);
              },
              icon: Icon(Icons.check),
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'CHECK',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Color.fromARGB(255, 73, 65, 151),
                backgroundColor: Colors.white, // Text color
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuestionHeader extends StatelessWidget {
  final VoidCallback onPlaySound;

  const QuestionHeader({Key? key, required this.onPlaySound}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Better late than never",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: onPlaySound,
            child: Icon(Icons.volume_up, size: 30),
          ),
        ],
      ),
    );
  }
}

class WordSelection extends StatelessWidget {
  final List<String> options;
  final Set<int> selectedOptions;
  final Function(int) onOptionSelected;

  const WordSelection({
    Key? key,
    required this.options,
    required this.selectedOptions,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: options.asMap().entries.map((entry) {
        int index = entry.key;
        String option = entry.value;
        return ChoiceChip(
          label: Text(option),
          selected: selectedOptions.contains(index),
          onSelected: (selected) => onOptionSelected(index),
        );
      }).toList(),
    );
  }
}

class SelectedWordsDisplay extends StatelessWidget {
  final List<String> options;
  final Set<int> selectedOptions;

  const SelectedWordsDisplay({
    Key? key,
    required this.options,
    required this.selectedOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      selectedOptions.map((index) => options[index]).join(" "),
      style: TextStyle(fontSize: 24),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TranslateQuestion(),
  ));
}
