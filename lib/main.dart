import 'package:flutter/material.dart';
import 'package:quiz_app/screens/match_questions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MatchQuestion(), // Set the QuizScreen as the home screen
    );
  }
}
