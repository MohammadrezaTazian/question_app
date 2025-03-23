import 'package:flutter/material.dart';
import 'package:question_app/models/question.dart';
import 'package:question_app/providers/user_provider.dart';
import 'package:question_app/services/question_service.dart';
import 'package:question_app/widgets/custom_navigation_bottom.dart';
import 'package:question_app/pages/comment_page.dart';

class QuestionListPage extends StatefulWidget {
  final String courseId;
  final String courseName;

  const QuestionListPage({
    Key? key,
    required this.courseId,
    required this.courseName,
  }) : super(key: key);

  @override
  State<QuestionListPage> createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage> {
  List<Question> _questions = [];
  bool _isLoading = true;
  String _errorMessage = '';
  int _currentIndex = 2; // Questions tab is selected

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      
      final questions = await QuestionService.getQuestionsByCourse(widget.courseId);
      
      setState(() {
        _questions = questions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'خطا در بارگذاری سوالات: $e';
        _isLoading = false;
      });
    }
  }

  void _toggleAnswerVisibility(int index) {
    setState(() {
      _questions[index].isAnswerVisible = !_questions[index].isAnswerVisible;
    });
  }

  void _onNavItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      
      // Handle navigation based on index
      if (index == 0) { // Profile
        Navigator.pushReplacementNamed(context, '/profile');
      } else if (index == 1) { // Notifications
        // Navigate to notifications page
      } else if (index == 2) { // Questions
        // Already on questions page
      } else if (index == 3) { // Home
        Navigator.pushReplacementNamed(context, '/field_selection');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          // Blue header with title and back button
          Container(
            width: double.infinity,
            color: const Color(0xFF2962FF),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const Text(
                    'سوالات',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Questions list
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
                : ListView.builder(
                    itemCount: _questions.length,
                    itemBuilder: (context, index) {
                      return _buildQuestionItem(_questions[index], index);
                    },
                  ),
          ),
          
          // Use CustomNavigationBottom
          CustomNavigationBottom(
            currentIndex: _currentIndex,
            onTap: _onNavItemTapped,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionItem(Question question, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Question text
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              question.text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          
          // Question likes, comments and time ago
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  question.timeAgo + ' پیش',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                // Inside the _buildQuestionItem method, update the comment icon to be clickable
                GestureDetector(
                  onTap: () {
                    // Get current username from UserProvider
                    final currentUsername = UserProvider.getUserData()?['username'] ?? 'guest';
                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentPage(
                          questionId: question.id,
                          questionText: question.text,
                          currentUsername: currentUsername, // Add this parameter
                        ),
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Text(
                        question.comments.toString(),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.comment_outlined,
                        color: Colors.grey[600],
                        size: 18,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    Text(
                      question.likes.toString(),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.favorite_border,
                      color: Colors.grey[600],
                      size: 18,
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Show/Hide answer button
          InkWell(
            onTap: () => _toggleAnswerVisibility(index),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2962FF),
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                question.isAnswerVisible ? 'پنهان کردن پاسخ' : 'نمایش پاسخ',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          
          // Answers (if visible)
          if (question.isAnswerVisible)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var answer in question.answers)
                  _buildAnswerItem(answer),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildAnswerItem(Answer answer) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Answer text
          Text(
            answer.text,
            style: const TextStyle(fontSize: 14),
            textAlign: TextAlign.right,
          ),
          
          const SizedBox(height: 12),
          
          // Likes, comments and time ago
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                answer.timeAgo + ' پیش',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              // Inside the _buildAnswerItem method
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Get current username from UserProvider
                      final currentUsername = UserProvider.getUserData()?['username'] ?? 'guest';
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentPage(
                            questionId: answer.id,
                            questionText: answer.text.length > 50 ? answer.text.substring(0, 50) + '...' : answer.text,
                            currentUsername: currentUsername, // Add this parameter
                          ),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Text(
                          answer.comments.toString(),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.comment_outlined,
                          color: Colors.grey[600],
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Row(
                    children: [
                      Text(
                        answer.likes.toString(),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.favorite_border,
                        color: Colors.grey[600],
                        size: 18,
                      ),
                    ],
                ),
              ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}