import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'shimmer_wrapper.dart';

class ShimmerList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsetsGeometry itemPadding;
  final BorderRadius? itemBorderRadius;

  const ShimmerList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 60,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.itemBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Container(
            height: itemHeight,
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: itemBorderRadius ?? BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                ShimmerWrapper(
                  isLoading: true,
                  child: Container(
                    width: 48,
                    height: 48,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerWrapper(
                        isLoading: true,
                        child: Container(
                          height: 16,
                          width: 120,
                          decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),),
                      ),
                      const SizedBox(height: 8),
                      ShimmerWrapper(
                        isLoading: true,
                        child: Container(
                          height: 12,
                          width: 80,
                          decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),),
                    ],
                  ),
                ),
                ShimmerWrapper(
                  isLoading: true,
                  child: Container(
                    width: 80,
                    height: 24,
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 