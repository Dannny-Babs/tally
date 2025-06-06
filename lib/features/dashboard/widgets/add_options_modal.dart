import '../../../utils/utils.dart';

class AddOptionsModal extends StatefulWidget {
  const AddOptionsModal({super.key});

  @override
  State<AddOptionsModal> createState() => _AddOptionsModalState();
}

class _AddOptionsModalState extends State<AddOptionsModal> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Something New',
                        style: AppTextStyles.displaySmall.copyWith(
                          color: AppColors.textPrimaryLight,
                          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                          fontSize: 20,
                          letterSpacing: -0.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'What do you want to log right now?',
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
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                            color: AppColors.textPrimaryLight,
                  ),
                ],
              ),

              const SizedBox(height: 24),
              Column(
                children: [
                  _OptionCard(
                    icon: HeroIcons.banknotes,
                    label: 'Income',
                    description: 'Record a payment you\'ve received',
                    isSelected: selectedOption == 'Income',
                    onTap: () {
                      setState(() {
                        selectedOption = 'Income';
                      });

                     
                    },
                  ),
                  const SizedBox(height: 8),
                  _OptionCard(
                    icon: HeroIcons.shoppingCart,
                    label: 'Expense',
                    description: 'Log money you\'ve spent',
                    isSelected: selectedOption == 'Expense',
                    onTap: () {
                      setState(() {
                        selectedOption = 'Expense';
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _OptionCard(
                    icon: HeroIcons.gift,
                    label: 'Gift',
                    description: 'Track gifts or money you\'ve given',
                    isSelected: selectedOption == 'Gift',
                    onTap: () {
                      setState(() {
                        selectedOption = 'Gift';
                      });
                    },
                  ),
                  const SizedBox(height: 8),
                  _OptionCard(
                    icon: HeroIcons.banknotes,
                    label: 'Savings',
                    description: 'Move cash into your savings pot',
                    isSelected: selectedOption == 'Savings',
                    onTap: () {
                      setState(() {
                        selectedOption = 'Savings';
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedOption == 'Income') {
                      Navigator.pop(context);
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => const AddIncomeModal(),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textPrimaryLight,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.15,
                      fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  final HeroIcons icon;
  final String label;
  final String description;
  final VoidCallback onTap;
  final bool isSelected;

  const _OptionCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color:
                isSelected
                    ? AppColors.textPrimaryLight.withAlpha((0.1 *255).round())
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color:
                  isSelected
                      ? AppColors.textPrimaryLight
                      : AppColors.borderLight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? AppColors.textPrimaryLight.withAlpha((0.1 *255).round())
                          : AppColors.neutral100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: HeroIcon(
                  icon,
                  style: HeroIconStyle.solid,
                        color: isSelected ? AppColors.textPrimaryLight : AppColors.neutral600,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        letterSpacing: -0.15,
                        fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimaryLight,
                        fontSize: 12,
                        letterSpacing: -0.08,
                        fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
