import '../../../../utils/utils.dart';
enum DateRange {
  thisMonth,
  lastMonth,
  thisYear,
  custom,
  all,
}

class DateFilterWidget extends StatefulWidget {
  final DateRange selectedRange;
  final Function(DateRange) onRangeSelected;

  const DateFilterWidget({
    super.key,
    required this.selectedRange,
    required this.onRangeSelected,
  });

  @override
  State<DateFilterWidget> createState() => _DateFilterWidgetState();
}

class _DateFilterWidgetState extends State<DateFilterWidget> {
  late DateRange _selectedRange;

  @override
  void initState() {
    super.initState();
    _selectedRange = widget.selectedRange;
  }

  @override
  void didUpdateWidget(DateFilterWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedRange != widget.selectedRange) {
      setState(() {
        _selectedRange = widget.selectedRange;
      });
    }
  }

  String _labelFor(DateRange range) {
    switch (range) {
      case DateRange.thisMonth: 
        return 'This Month';
      case DateRange.lastMonth:
        return 'Last Month';
      case DateRange.thisYear:
        return 'This Year';
      case DateRange.custom:
        return 'Custom';
      case DateRange.all:
        return 'All';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.neutral200,
        borderRadius: BorderRadius.circular(8),    
        border: Border.all(color: AppColors.borderLight),
      ),
      height: 40,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: DateRange.values.map((range) {
              final isSelected = range == _selectedRange;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedRange = range;
                  });
                  widget.onRangeSelected(range);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: isSelected ? [
                      BoxShadow(
                        color: AppColors.primary500.withAlpha(105),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: Text(
                    _labelFor(range),
                    style: AppTextStyles.bodySmall.copyWith(
                      fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      letterSpacing: -0.15,
                      color: isSelected ? AppColors.primary800 : AppColors.textPrimaryLight,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
