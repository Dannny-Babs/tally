
import '../../../../utils/utils.dart';


class CategoryCard extends StatelessWidget {
  final String category;
  final double amount;
  final Color color;

  const CategoryCard({
    super.key,
    required this.category,
    required this.amount,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withAlpha(100),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: HeroIcon(
                _getIconForCategory(category),
                color: color,
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimaryLight,
                  fontWeight: FontWeight.w500,
                  fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                  fontSize: 14,
                  letterSpacing: -0.15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '\$${amount.toStringAsFixed(2)}',
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
        ],
      ),
    );
  }

  HeroIcons _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'food & dining':
        return HeroIcons.cake;
      case 'transportation':
        return HeroIcons.truck;
      case 'housing':
        return HeroIcons.home;
      case 'entertainment':
        return HeroIcons.tv;
      case 'shopping':
        return HeroIcons.shoppingBag;
      default:
        return HeroIcons.tag;
    }
  }
} 