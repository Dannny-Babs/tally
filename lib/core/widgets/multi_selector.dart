import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      spacing: 8.sp,
      runSpacing: 8.sp,
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
            padding: EdgeInsets.symmetric(horizontal: 12.sp, vertical: 4.sp),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary500 : AppColors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary700 : AppColors.grey300,
              ),
            ),
            child: Text(
              item,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected ? AppColors.white : AppColors.neutral500,
                    fontSize: 12.5.sp,
                  ),
            ),
          ),
        );
      }).toList(),
    );
  }
} 