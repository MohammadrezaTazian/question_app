import 'package:flutter/material.dart';
import 'package:question_app/widgets/custom_navigation_bottom.dart';
import 'package:question_app/models/course.dart';
import 'package:question_app/services/course_service.dart';
import 'package:question_app/pages/question_list_page.dart';

class CourseSelectionPage extends StatefulWidget {
  final String fieldName;
  final String year;

  const CourseSelectionPage({
    super.key,
    required this.fieldName,
    required this.year,
  });

  @override
  State<CourseSelectionPage> createState() => _CourseSelectionPageState();
}

class _CourseSelectionPageState extends State<CourseSelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Course> _courses = [];
  List<Course> _filteredCourses = [];
  int _currentIndex = -1; // No item selected by default
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadCourses();
    _searchController.addListener(_filterCourses);
  }

  Future<void> _loadCourses() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      
      final courses = await CourseService.getCourses();
      
      setState(() {
        _courses = courses;
        _filteredCourses = List.from(courses);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'خطا در بارگذاری دروس: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCourses() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCourses = List.from(_courses);
      } else {
        _filteredCourses = _courses
            .where((course) => course.name.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _onNavItemTapped(int index) {
    // Handle navigation based on index
    if (index == 0) { // Home
      Navigator.pushReplacementNamed(context, '/field_selection');
    } else if (index == 1) { // Courses
      // Already on courses page
    } else if (index == 2) { // Questions
      print('Navigate to questions page');
    } else if (index == 3) { // Profile
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    'انتخاب دروس',
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
          
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                textAlign: TextAlign.right,
                decoration: const InputDecoration(
                  hintText: 'جستجوی درس...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ),
          
          // Courses list
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
                : ListView.builder(
                    itemCount: _filteredCourses.length,
                    itemBuilder: (context, index) {
                      return _buildCourseItem(_filteredCourses[index]);
                    },
                  ),
          ),
          
          // Use CustomNavigationBottom with no item selected
          CustomNavigationBottom(
            currentIndex: _currentIndex,
            onTap: _onNavItemTapped,
          ),
        ],
      ),
    );
  }

  // In the _buildCourseItem method of CourseSelectionPage
  Widget _buildCourseItem(Course course) {
    return InkWell(
      onTap: () {
        // Navigate to QuestionListPage when a course is selected
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuestionListPage(
              courseId: course.id,
              courseName: course.name,
            ),
          ),
        );
      },
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.chevron_left,
                color: Colors.grey,
              ),
              Text(
                course.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}