import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/transaction_model.dart';
import 'dart:math' as math;

class TransactionDetailScreen extends StatelessWidget {
  const TransactionDetailScreen({super.key, required this.transaction});

  final Transaction transaction;

  Color _getRandomColor(double alpha) {
    final random = math.Random();
    final baseColor = Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1,
    );
    return baseColor.withOpacity(alpha);
  }

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final randomColor = _getRandomColor(1);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.neutral300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 12),

                // Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Transaction Details',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        color:
                            AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.15,
                      ),
                    ),
                   
                    const SizedBox(height: 8),
                    Text(
                      '${isIncome ? '+ ' : '- '}\$${transaction.amount.toStringAsFixed(2)}',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: 36,
                        color: isIncome ? AppColors.success : AppColors.error,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          transaction.payeeName ?? transaction.source,
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: 14,
                            color: AppColors.neutral700,
                            fontWeight: FontWeight.normal,
                            letterSpacing: -0.15,
                          ),
                        ),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: AppColors.neutral400,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        if (transaction.tags.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: randomColor.withAlpha(20),
                              borderRadius: BorderRadius.circular(80),
                            ),
                            child: Text(
                              '${transaction.tags.first.emoji} ${transaction.tags.first.name}',
                              style: GoogleFonts.spaceGrotesk(
                                fontSize: 14,
                                color: randomColor,
                                fontWeight: FontWeight.normal,
                                letterSpacing: -0.15,
                              ),
                            ),
                          ),
                        if (transaction.mood != null) ...[
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: AppColors.neutral400,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          Text(
                            transaction.mood!.emoji,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 14,
                              color: AppColors.neutral700,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),

                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date and Time
                        _buildInfoRow(
                          icon: Icons.calendar_today,
                          title: 'Date & Time',
                          content: '${transaction.date} • ${transaction.time}',
                        ),
                        const SizedBox(height: 20),

                        // Categories
                        if (transaction.category.isNotEmpty) ...[
                          _buildInfoRow(
                            icon: Icons.category,
                            title: 'Categories',
                            content: transaction.category,
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Payment Method
                        if (transaction.paymentMethod != null) ...[
                          _buildInfoRow(
                            icon: Icons.payment,
                            title: 'Payment Method',
                            content: transaction.paymentMethod!,
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Description
                        if (transaction.description.isNotEmpty) ...[
                          _buildInfoRow(
                            icon: Icons.description,
                            title: 'Description',
                            content: transaction.description,
                          ),
                          const SizedBox(height: 20),
                        ],

                        // Notes
                        if (transaction.notes != null &&
                            transaction.notes!.isNotEmpty)
                          _buildInfoRow(
                            icon: Icons.note,
                            title: 'Notes',
                            content: transaction.notes!,
                          ),
                      ],
                    ),
                  ),
                ),

                // Actions
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: AppColors.borderLight, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement edit functionality
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.edit, size: 20),
                          label: Text(
                            'Edit',
                            style: GoogleFonts.spaceGrotesk(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: BorderSide(color: AppColors.primary500),
                            foregroundColor: AppColors.primary500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement delete functionality
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.delete, size: 20),
                          label: Text(
                            'Delete',
                            style: GoogleFonts.spaceGrotesk(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: AppColors.error,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary500.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary500, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  color: AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 16,
                  color: AppColors.textPrimaryDark,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
