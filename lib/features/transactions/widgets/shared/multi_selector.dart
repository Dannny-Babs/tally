
import '../../../../utils/utils.dart';

class MultiSelector extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final ValueChanged<String> onOptionSelected;
  final ValueChanged<String> onOptionDeselected;

  const MultiSelector({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onOptionSelected,
    required this.onOptionDeselected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((item) {
        final isSelected = selectedOption == item;
        return InkWell(
          onTap: () {
            if (isSelected) {
              onOptionDeselected(item);
            } else {
              onOptionSelected(item);
            }
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