import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final List<String> iconPaths;
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const CustomTabBar({
    super.key,
    required this.iconPaths,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            iconPaths.length,
            (index) => _buildTabItem(context, index),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, int index) {
    final isSelected = index == currentIndex;
    const baseSize = 40.0;
    const selectedSize = 54.0;

    return GestureDetector(
      onTap: () => onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only( left: 12, right: 12),
        width: 48,
        height: 48,
        alignment: Alignment.bottomCenter,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          scale: isSelected ? selectedSize / baseSize : 1.0,
          child: Image.asset(
            iconPaths[index],
            width: baseSize,
            height: baseSize,
            
          ),
        ),
      ),
    );
  }
} 