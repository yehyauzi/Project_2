import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(PhishingQuizApp());

class PhishingQuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phishing Awareness Quiz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: QuizScreen(),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> _questions = [];
  int _currentIndex = 0;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    final url =
        Uri.parse('http://myfirstproject1.atwebpages.com/get_questions.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _questions = json.decode(response.body);
      });
    } else {
      print('Failed to load questions');
    }
  }

  void checkAnswer(String answer) {
    if (_questions[_currentIndex]['correct_answer'] == answer) {
      setState(() {
        _score++;
      });
    }

    setState(() {
      _currentIndex++;
    });
  }

  void restartQuiz() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Phishing Awareness Quiz')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_currentIndex >= _questions.length) {
      return Scaffold(
        appBar: AppBar(title: Text('Quiz Complete')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Your Score: $_score/${_questions.length}',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: restartQuiz,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Restart Quiz'),
              ),
            ],
          ),
        ),
      );
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Phishing Awareness Quiz'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Score: $_score/${_questions.length}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              elevation: 5,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  question['question_text'],
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => checkAnswer('Phishing'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Phishing'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => checkAnswer('Legitimate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text('Legitimate'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
