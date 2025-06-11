import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import '../../../../core/theme/app_colors.dart';
import '../models/transaction_model.dart';

class TransactionDetailScreen extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onClose;

  const TransactionDetailScreen({
    super.key,
    required this.transaction,
    this.onEdit,
    this.onDelete,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final amountColor = isIncome ? AppColors.success : AppColors.error;
    final tag = transaction.tags.isNotEmpty ? transaction.tags.first : null;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Material(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // HEADER
                _HeaderSection(onClose: onClose),
                const SizedBox(height: 16),
                // AMOUNT, PAYEE, DATE, TAG
                _AmountSection(
                  transaction: transaction,
                  amountColor: amountColor,
                  tag: tag,
                ),
                const SizedBox(height: 16),
                // DIVIDER
                const Divider(color: AppColors.borderLight, thickness: 1, height: 1),
                // DETAILS
                _DetailRowsSection(transaction: transaction),
                // FOOTER
                _FooterActions(onEdit: onEdit, onDelete: onDelete),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
  final VoidCallback? onClose;
  const _HeaderSection({this.onClose});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Transaction Details',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimaryLight,
            letterSpacing: -0.25,
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: onClose ?? () => Navigator.of(context).maybePop(),
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.all(4),
            child: const Icon(
              HugeIconsStroke.cancel01,
              size: 20,
              color: AppColors.neutral600,
            ),
          ),
        ),
      ],
    );
  }
}

class _AmountSection extends StatelessWidget {
  final Transaction transaction;
  final Color amountColor;
  final Tag? tag;
  const _AmountSection({
    required this.transaction,
    required this.amountColor,
    this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    final amountStr =
        '${isIncome ? '+ ' : '- '}\$${transaction.amount.toStringAsFixed(2)}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              amountStr,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: amountColor,
              ),
            ),
            if (transaction.mood != null) ...[
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.neutral200,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.borderLight),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: Text(
                  transaction.mood!.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ],
          ],
        ),
        if (transaction.payeeName != null && transaction.payeeName!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              transaction.payeeName!,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimaryLight,
                letterSpacing: -0.25,
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            // You may want to format date/time for locale
            '${transaction.date} at ${transaction.time}',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondaryLight,
              letterSpacing: -0.15,
            ),
          ),
        ),
        if (tag != null && !isIncome)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.neutral200,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '${tag!.emoji} ${tag!.name}',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimaryLight,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _DetailRowsSection extends StatelessWidget {
  final Transaction transaction;
  const _DetailRowsSection({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final rows = <_DetailRow>[];
    if (transaction.category.isNotEmpty) {
      rows.add(_DetailRow(label: 'Category', value: transaction.category));
    }
    if (transaction.paymentMethod != null &&
        transaction.paymentMethod!.isNotEmpty) {
      rows.add(
        _DetailRow(label: 'Payment Method', value: transaction.paymentMethod!),
      );
    }
    if (transaction.description.isNotEmpty) {
      rows.add(
        _DetailRow(label: 'Description', value: transaction.description),
      );
    }
    if (transaction.notes != null && transaction.notes!.isNotEmpty) {
      rows.add(_DetailRow(label: 'Notes', value: transaction.notes!));
    }
    if (transaction.tags.isNotEmpty) {
      rows.add(
        _DetailRow(
          label: 'Tags',
          value: transaction.tags.map((tag) => tag.name).join(', '),
        ),
      );
    }
    if (transaction.taxable && transaction.isIncome) {
      rows.add(_DetailRow(label: 'Taxable', value: transaction.taxable.toString()));
    }
    if (transaction.recurring) {
      rows.add(_DetailRow(label: 'Recurring', value: transaction.frequency.toString()));
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: rows,
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.neutral700,
              letterSpacing: -0.15,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: AppColors.textPrimaryLight,
              letterSpacing: -0.15,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterActions extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const _FooterActions({this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.borderLight, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: onEdit,
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.neutral200,
                  foregroundColor: AppColors.textPrimaryLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide.none,
                  textStyle: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.textPrimaryLight,
                  ),
                ),
                child: const Text('Edit Transaction'),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: onDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  textStyle: GoogleFonts.spaceGrotesk(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: AppColors.neutral50,
                  ),
                ),
                child: const Text('Delete'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
