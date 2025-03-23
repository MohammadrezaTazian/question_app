import 'package:flutter/material.dart';
import 'package:question_app/widgets/custom_navigation_bottom.dart';
import 'package:question_app/services/field_service.dart';
import 'package:question_app/models/field.dart';

class FieldSelectionPage extends StatefulWidget {
  const FieldSelectionPage({super.key});

  @override
  State<FieldSelectionPage> createState() => _FieldSelectionPageState();
}

class _FieldSelectionPageState extends State<FieldSelectionPage> {
  int _currentIndex = 0; // Home is selected by default
  final FieldService _fieldService = FieldService();
  List<Field> _fields = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadFields();
  }

  Future<void> _loadFields() async {
    try {
      final fields = await _fieldService.getFields();
      setState(() {
        _fields = fields;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'خطا در بارگذاری دوره‌ها: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  // In the _onNavItemTapped method in _FieldSelectionPageState
  void _onNavItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      
      // Handle navigation based on index
      if (index == 3) { // Profile
        Navigator.pushReplacementNamed(context, '/profile');
      } else if (index == 1) { // Questions
        print('Navigate to questions page');
      } else if (index == 2) { // Settings
        Navigator.pushReplacementNamed(context, '/settings');
      }
      // No need to navigate if index is 0 (home) as we're already there
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Blue app bar with title
          Container(
            width: double.infinity,
            color: const Color(0xFF2962FF),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: const SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Konkur',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'انتخاب دوره',
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
          
          // Main content with field selection cards
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                  ? Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)))
                  : ListView.builder(
                      itemCount: _fields.length,
                      itemBuilder: (context, index) {
                        final field = _fields[index];
                        // Determine color based on index
                        Color backgroundColor;
                        Color iconBackgroundColor;
                        IconData icon;
                        
                        switch (index % 3) {
                          case 0:
                            backgroundColor = Colors.blue.shade50;
                            iconBackgroundColor = Colors.blue.shade100;
                            icon = Icons.functions;
                            break;
                          case 1:
                            backgroundColor = Colors.green.shade50;
                            iconBackgroundColor = Colors.green.shade100;
                            icon = Icons.science;
                            break;
                          default:
                            backgroundColor = Colors.yellow.shade50;
                            iconBackgroundColor = Colors.yellow.shade100;
                            icon = Icons.menu_book;
                        }
                        
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: FieldCard(
                            title: field.field,
                            subtitle: field.description,
                            icon: icon,
                            backgroundColor: backgroundColor,
                            iconBackgroundColor: iconBackgroundColor,
                            onTap: () {
                              // Navigate to year selection page with the field name
                              Navigator.pushNamed(
                                context,
                                '/year_selection',
                                arguments: {'fieldName': field.field},
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ),
          
          // Use our custom navigation bottom with the proper currentIndex
          CustomNavigationBottom(
            currentIndex: _currentIndex,
            onTap: _onNavItemTapped,
          ),
        ],
      ),
    );
  }
}

class FieldCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;
  final Color iconBackgroundColor;
  final VoidCallback onTap;

  const FieldCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
    required this.iconBackgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: iconBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 30,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.right,
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