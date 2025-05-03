import 'package:flutter/material.dart';

// TODO: Import Rating BLoC, Events, States

class RatingScreen extends StatefulWidget {
  final String rideId;
  // TODO: Pass driver details if needed for display

  const RatingScreen({super.key, required this.rideId});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  // State variables to hold answers
  bool? _isDriverPolite;
  bool? _isCarClean;
  bool? _didFeelSafe;
  final TextEditingController _commentController = TextEditingController();

  // Structure for questions and answers
  final List<Map<String, dynamic>> _questions = [
    {
      'id': 'politeness',
      'question_en': 'Was the driver polite?',
      'question_ar': 'هل كان تعامل السائق لطيفًا؟',
      'answer': null, // Will hold true (Yes) or false (No)
    },
    {
      'id': 'cleanliness',
      'question_en': 'Was the vehicle clean?',
      'question_ar': 'هل كانت المركبة نظيفة؟',
      'answer': null,
    },
    {
      'id': 'safety',
      'question_en': 'Did you feel safe during the ride?',
      'question_ar': 'هل شعرت بالأمان خلال الرحلة؟',
      'answer': null,
    },
    // Add more questions as needed
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _updateAnswer(String questionId, bool answer) {
    setState(() {
      final questionIndex = _questions.indexWhere((q) => q['id'] == questionId);
      if (questionIndex != -1) {
        _questions[questionIndex]['answer'] = answer;
      }
      // Update individual state variables if needed (though using the list is cleaner)
      // if (questionId == 'politeness') _isDriverPolite = answer;
      // else if (questionId == 'cleanliness') _isCarClean = answer;
      // else if (questionId == 'safety') _didFeelSafe = answer;
    });
  }

  void _submitRating() {
    // Check if all questions are answered
    bool allAnswered = _questions.every((q) => q['answer'] != null);

    if (!allAnswered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please answer all questions. / يرجى الإجابة على جميع الأسئلة.'), backgroundColor: Colors.orangeAccent),
      );
      return;
    }

    // Prepare rating data
    Map<String, dynamic> ratingData = {
      'rideId': widget.rideId,
      'ratings': { for (var q in _questions) q['id'] : q['answer'] },
      'comment': _commentController.text.trim(),
    };

    // TODO: Dispatch SubmitRating event to RatingBloc
    print("Submitting rating: $ratingData");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thank you for your feedback! / شكراً لملاحظاتك!'), backgroundColor: Colors.green),
    );

    // TODO: Navigate back to home screen or show completion message
    // For now, just pop
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  Widget _buildQuestionWidget(Map<String, dynamic> questionData) {
    String questionId = questionData['id'];
    String questionText = "${questionData['question_ar']} / ${questionData['question_en']}";
    bool? currentAnswer = questionData['answer'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            questionText,
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAnswerButton(questionId, true, currentAnswer == true, Icons.thumb_up_alt, "Yes / نعم", Colors.greenAccent[700]!),
              _buildAnswerButton(questionId, false, currentAnswer == false, Icons.thumb_down_alt, "No / لا", Colors.redAccent[700]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(String questionId, bool answerValue, bool isSelected, IconData icon, String label, Color selectedColor) {
    return ElevatedButton.icon(
      onPressed: () => _updateAnswer(questionId, answerValue),
      icon: Icon(icon, color: isSelected ? Colors.black : Colors.white70),
      label: Text(label, style: TextStyle(color: isSelected ? Colors.black : Colors.white70)),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? selectedColor : Colors.grey[800],
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: isSelected ? BorderSide.none : BorderSide(color: Colors.grey[700]!),
        elevation: isSelected ? 4 : 1,
      ),
      // TODO: Add animation on tap (Knowledge ID: user_47)
    );
  }

  @override
  Widget build(BuildContext context) {
    // Apply Black/Gold theme (Knowledge ID: user_19, user_41)
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Your Ride / قيّم رحلتك'),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.amber[700]),
        titleTextStyle: TextStyle(color: Colors.amber[700], fontSize: 20),
        automaticallyImplyLeading: false, // Prevent going back easily
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // TODO: Optionally display driver info here
            const Text(
              'How was your trip? / كيف كانت رحلتك؟',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),

            // Interactive Questions (Knowledge ID: user_24)
            ..._questions.map((q) => _buildQuestionWidget(q)).toList(),

            const SizedBox(height: 20),
            Divider(color: Colors.grey[800]),
            const SizedBox(height: 20),

            // Optional Comment
            TextField(
              controller: _commentController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Additional Comments (Optional) / تعليقات إضافية (اختياري)',
                labelStyle: TextStyle(color: Colors.amber[700]),
                hintText: 'Share more details... / شارك المزيد من التفاصيل...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.grey[850],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 30),

            // Submit Button
            ElevatedButton(
              onPressed: _submitRating,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[700],
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 15),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              child: const Text('Submit Feedback / إرسال التقييم'),
              // TODO: Add animation on tap (Knowledge ID: user_47)
            ),
          ],
        ),
      ),
    );
  }
}

