import 'package:flutter/material.dart';

class CustomNavigationBottom extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomNavigationBottom({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavBarItem(
              icon: Icons.person,
              label: 'پروفایل',
              onTap: () => onTap(3),
              isActive: currentIndex == 3,
            ),
            NavBarItem(
              icon: Icons.settings,
              label: 'تنظیمات',
              onTap: () => onTap(2),
              isActive: currentIndex == 2,
            ),
            NavBarItem(
              icon: Icons.help,
              label: 'سوالات',
              onTap: () => onTap(1),
              isActive: currentIndex == 1,
            ),
            NavBarItem(
              icon: Icons.home,
              label: 'خانه',
              onTap: () => onTap(0),
              isActive: currentIndex == 0,
            ),
          ],
        ),
      ),
    );
  }
}

class NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;

  const NavBarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF2962FF) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? const Color(0xFF2962FF) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}