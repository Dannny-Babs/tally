import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_colors.dart';

class CustomTabBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;

  const CustomTabBar({super.key, required this.selectedIndex, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _TabBarItem(
        icon: '🏠',
        label: 'Home',
        selected: selectedIndex == 0,
        onTap: () => onTabSelected(0),
      ),
      _TabBarItem(
        icon: '➕',
        label: 'Add',
        selected: selectedIndex == 1,
        onTap: () => onTabSelected(1),
      ),
      _TabBarItem(
        icon: '⚙️',
        label: 'Settings',
        selected: selectedIndex == 2,
        onTap: () => onTabSelected(2),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(
          top: BorderSide(color: AppColors.primaryLight.withOpacity(0.3)),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: tabs,
      ),
    );
  }
}

class _TabBarItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabBarItem({required this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.ease,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: selected ? AppColors.primary.withOpacity(0.15) : Colors.transparent,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                icon,
                style: TextStyle(fontSize: 28, fontFamily: GoogleFonts.spaceGrotesk().fontFamily),
                semanticsLabel: label,
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  color: selected ? AppColors.accent : AppColors.primary,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                  fontSize: 13,
                ),
                child: Text(label),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(top: 4),
                height: 3,
                width: selected ? 24 : 0,
                decoration: BoxDecoration(
                  color: selected ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 