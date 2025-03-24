import 'package:flutter/material.dart';
import 'package:question_app/widgets/custom_navigation_bottom.dart';
import 'package:question_app/models/year.dart';
import 'package:question_app/services/year_service.dart';

class YearSelectionPage extends StatefulWidget {
  final String fieldName;

  const YearSelectionPage({
    super.key,
    required this.fieldName,
  });

  @override
  State<YearSelectionPage> createState() => _YearSelectionPageState();
}

class _YearSelectionPageState extends State<YearSelectionPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Year> _years = [];
  List<Year> _filteredYears = [];
  final int _currentIndex = -1; // No item selected by default
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadYears();
    _searchController.addListener(_filterYears);
  }

  Future<void> _loadYears() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });
      
      final years = await YearService.getYears();
      
      setState(() {
        _years = years;
        _filteredYears = List.from(years);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'خطا در بارگذاری سال‌ها: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterYears() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredYears = List.from(_years);
      } else {
        _filteredYears = _years
            .where((year) => year.year.toLowerCase().contains(query) || 
                            year.description.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _onNavItemTapped(int index) {
    // Handle navigation based on index
    if (index == 0) { // Home
      Navigator.pushReplacementNamed(context, '/field_selection');
    } else if (index == 1) { // Questions
      print('Navigate to questions page');
    } else if (index == 2) { // Settings
      Navigator.pushReplacementNamed(context, '/settings');
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
                    'لیست سال‌ها',
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
                  hintText: 'جستجوی سال',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ),
          
          // Years list
          Expanded(
            child: _isLoading 
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
                ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
                : ListView.builder(
                    itemCount: _filteredYears.length,
                    itemBuilder: (context, index) {
                      return _buildYearItem(_filteredYears[index]);
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

  Widget _buildYearItem(Year year) {
    return InkWell(
      onTap: () {
        // Navigate to course selection page with the field name and year
        Navigator.pushNamed(
          context,
          '/course_selection',
          arguments: {
            'fieldName': widget.fieldName,
            'year': year.year,
          },
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    year.year,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    year.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}