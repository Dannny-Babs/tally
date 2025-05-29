import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../add_expense_screen.dart';

class ExpenseHeader extends StatelessWidget {
  const ExpenseHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundLight,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Expenses',
                  style: AppTextStyles.displaySmall.copyWith(
                    color: AppColors.neutral900,
                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                    fontSize: 20,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Track your spending',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.neutral700,
                    letterSpacing: -0.15,
                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) => const AddExpenseModal(),
                );
              },
              icon: HeroIcon(
                HeroIcons.plus,
                color: AppColors.neutral900,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 