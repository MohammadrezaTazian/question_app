import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:question_app/widgets/custom_navigation_bottom.dart';
import 'package:question_app/providers/theme_provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _currentIndex = 2; // Settings tab is selected
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'فارسی';

  void _onNavItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      
      // Handle navigation based on index
      if (index == 0) { // Home
        Navigator.pushReplacementNamed(context, '/field_selection');
      } else if (index == 1) { // Questions
        print('Navigate to questions page');
      } else if (index == 3) { // Profile
        Navigator.pushReplacementNamed(context, '/profile');
      }
      // No need to navigate if index is 2 (settings) as we're already there
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
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
                    'تنظیمات',
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
          
          // Settings content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Notifications section
                    _buildSectionTitle('اعلان‌ها'),
                    const SizedBox(height: 10),
                    _buildSettingCard(
                      title: 'اعلان‌های برنامه',
                      subtitle: 'دریافت اعلان‌های مربوط به آزمون‌ها و تکالیف',
                      trailing: Switch(
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                        activeColor: const Color(0xFF2962FF),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Appearance section
                    _buildSectionTitle('ظاهر برنامه'),
                    const SizedBox(height: 10),
                    _buildSettingCard(
                      title: 'حالت تاریک',
                      subtitle: 'استفاده از تم تاریک برای برنامه',
                      trailing: Switch(
                        value: isDarkMode,
                        onChanged: (value) {
                          themeProvider.setDarkMode(value);
                        },
                        activeColor: const Color(0xFF2962FF),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Language section
                    _buildSectionTitle('زبان'),
                    const SizedBox(height: 10),
                    _buildSettingCard(
                      title: 'زبان برنامه',
                      subtitle: 'انتخاب زبان مورد نظر برای برنامه',
                      trailing: DropdownButton<String>(
                        value: _selectedLanguage,
                        icon: const Icon(Icons.arrow_drop_down),
                        elevation: 16,
                        style: const TextStyle(color: Color(0xFF2962FF)),
                        underline: Container(
                          height: 2,
                          color: const Color(0xFF2962FF),
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedLanguage = newValue!;
                          });
                        },
                        items: <String>['فارسی', 'English']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // About section
                    _buildSectionTitle('درباره برنامه'),
                    const SizedBox(height: 10),
                    _buildSettingCard(
                      title: 'نسخه برنامه',
                      subtitle: '1.0.0',
                      trailing: const Icon(Icons.info_outline, color: Color(0xFF2962FF)),
                      onTap: () {
                        // Show app info
                      },
                    ),
                    
                    const SizedBox(height: 10),
                    _buildSettingCard(
                      title: 'تماس با ما',
                      subtitle: 'ارسال بازخورد یا گزارش مشکل',
                      trailing: const Icon(Icons.mail_outline, color: Color(0xFF2962FF)),
                      onTap: () {
                        // Open contact form
                      },
                    ),
                    
                    const SizedBox(height: 10),
                    _buildSettingCard(
                      title: 'قوانین و مقررات',
                      subtitle: 'مشاهده قوانین استفاده از برنامه',
                      trailing: const Icon(Icons.description_outlined, color: Color(0xFF2962FF)),
                      onTap: () {
                        // Show terms and conditions
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Custom navigation bottom
          CustomNavigationBottom(
            currentIndex: _currentIndex,
            onTap: _onNavItemTapped,
          ),
        ],
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF2962FF),
      ),
      textAlign: TextAlign.right,
    );
  }
  
  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.right,
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade700,
          ),
          textAlign: TextAlign.right,
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}