import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuizPage extends ConsumerStatefulWidget {
  final String subjectId;
  const QuizPage({super.key, required this.subjectId});

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _showResults = false;

  final List<Map<String, dynamic>> _dummyQuestions = [
    {
      'question': 'What is the SI unit of Force?',
      'options': ['Newton', 'Watt', 'Joule', 'Pascal'],
      'answer': 'Newton',
    },
    {
      'question': 'Which of these is a scalar quantity?',
      'options': ['Velocity', 'Acceleration', 'Mass', 'Displacement'],
      'answer': 'Mass',
    },
    {
      'question': 'Sound waves travel fastest through:',
      'options': ['Vacuum', 'Air', 'Water', 'Steel'],
      'answer': 'Steel',
    },
  ];

  void _answerQuestion(String selectedOption) {
    if (selectedOption == _dummyQuestions[_currentQuestionIndex]['answer']) {
      setState(() {
        _score++;
      });
    }

    if (_currentQuestionIndex < _dummyQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      setState(() {
        _showResults = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subject Quiz')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: _showResults ? _buildResults() : _buildQuiz(),
      ),
    );
  }

  Widget _buildQuiz() {
    final question = _dummyQuestions[_currentQuestionIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _dummyQuestions.length,
          backgroundColor: Colors.grey.shade200,
        ),
        const SizedBox(height: 32),
        Text(
          'Question ${_currentQuestionIndex + 1}/${_dummyQuestions.length}',
          style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Text(
          question['question'],
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        ...(question['options'] as List<String>).map((option) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: OutlinedButton(
              onPressed: () => _answerQuestion(option),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(option, style: const TextStyle(fontSize: 16)),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, size: 80, color: Colors.orange),
          const SizedBox(height: 24),
          const Text(
            'Quiz Completed!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Your Score: $_score / ${_dummyQuestions.length}',
            style: const TextStyle(fontSize: 18, color: Colors.blue),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Back to Course'),
          ),
        ],
      ),
    );
  }
}
