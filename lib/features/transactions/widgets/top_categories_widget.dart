import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'segmented_bar.dart';


class TopCategoriesWidget extends StatelessWidget {
  final Map<String, double> categoryTotals;
  final int maxSegments;
  final int showLabelsCount;

  const TopCategoriesWidget({
    Key? key,
    required this.categoryTotals,
    this.maxSegments = 9,
    this.showLabelsCount = 5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totals = categoryTotals;
    final grandTotal = totals.values.fold<double>(0, (a, b) => a + b);
    final colors = [
      AppColors.primary500,
      AppColors.success,
      AppColors.warning,
      AppColors.primary900,
      AppColors.error,
      AppColors.neutral400,
      Colors.purple,
      Colors.orange,
      Colors.blue,
      Colors.pink,
      Colors.grey,
      Colors.teal,
    ];

    // Sort entries by value in descending order and take top entries
    final topEntries = totals.entries
        .toList()
        ..sort((a, b) => b.value.compareTo(a.value)); // Sort in descending order
    final sortedEntries = topEntries.take(maxSegments).toList();

    // Create segments from sorted entries
    final segments = sortedEntries.map((e) {
      final idx = sortedEntries.indexOf(e); // Use index in sorted list for color
      return Segment(
        color: colors[idx % colors.length],
        fraction: grandTotal > 0 ? e.value / grandTotal : 0,
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Categories',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.neutral800,
            fontWeight: FontWeight.w600,
            fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
            fontSize: 14,
            letterSpacing: -0.15,
          ),
        ),
        const SizedBox(height: 8),
        PercentageSegmentBar(
          segments: segments,
          height: 20,
          separator: Container(
            width: 1,
            height: 20,
            color: AppColors.neutral100,
          ),
        ),
        const SizedBox(height: 12),
        // Show top labels with dots
        ...sortedEntries.take(showLabelsCount).map((entry) {
          final idx = sortedEntries.indexOf(entry); // Use index in sorted list for color
          final dotColor = colors[idx % colors.length];
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                // colored dot
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    entry.key,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimaryLight,
                      fontWeight: FontWeight.w500,
                      fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                      fontSize: 14,
                      letterSpacing: -0.15,
                    ),
                  ),
                ),
                Text(
                  '\$${entry.value.toStringAsFixed(2)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary700,
                    fontWeight: FontWeight.w600,
                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                    fontSize: 14,
                    letterSpacing: -0.15,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}