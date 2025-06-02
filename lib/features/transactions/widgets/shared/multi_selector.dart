
import '../../../../utils/utils.dart';

class MultiSelector extends StatelessWidget {
  final List<String> options;
  final List<String> selectedOptions;
  final ValueChanged<String> onOptionSelected;
  final ValueChanged<String> onOptionDeselected;

  const MultiSelector({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.onOptionSelected,
    required this.onOptionDeselected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((option) {
        final isSelected = selectedOptions.contains(option);
        return FilterChip(
          label: Text(
            option,
            style: AppTextStyles.bodySmall.copyWith(
              color: isSelected ? Colors.white : AppColors.neutral700,
              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
              fontSize: 12,
            ),
          ),
          selected: isSelected,
          onSelected: (selected) {
            if (selected) {
              onOptionSelected(option);
            } else {
              onOptionDeselected(option);
            }
          },
          backgroundColor: Colors.white,
          selectedColor: AppColors.primary500,
          checkmarkColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: isSelected ? AppColors.primary500 : AppColors.borderLight,
            ),
          ),
        );
      }).toList(),
    );
  }
} 