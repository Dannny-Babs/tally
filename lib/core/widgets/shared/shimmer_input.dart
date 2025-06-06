import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import 'shimmer_wrapper.dart';

class ShimmerInput extends StatelessWidget {
  final String label;
  final double height;
  final double? width;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;

  const ShimmerInput({
    super.key,
    required this.label,
    this.height = 48,
    this.width,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      isLoading: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 16,
            width: 80,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Container(
            height: height,
            width: width,
            padding: padding,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: borderRadius ?? BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 