import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class MultiSelector extends StatelessWidget {
  final List<String> items;
  final List<String> selectedItems;
  final Function(List<String>) onChanged;

  const MultiSelector({
    required this.items,
    required this.selectedItems,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final isSelected = selectedItems.contains(item);
        return InkWell(
          onTap: () {
            final updatedSelection = List<String>.from(selectedItems);
            if (isSelected) {
              updatedSelection.remove(item);
            } else {
              updatedSelection.add(item);
            }
            onChanged(updatedSelection);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary500 : AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary700 : AppColors.neutral700,
              ),
            ),
            child: Text(
              item,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected ? AppColors.textPrimaryLight : AppColors.neutral800,
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    letterSpacing: -0.1,
                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }
} 