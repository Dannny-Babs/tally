import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tally/core/widgets/platform_back_button.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'bloc/paybacks/paybacks_bloc.dart';
import 'bloc/paybacks/paybacks_event.dart';
import 'bloc/paybacks/paybacks_state.dart';
import 'models/payback.dart';

class PaybacksScreen extends StatelessWidget {
  const PaybacksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final paybacksBloc = context.read<PaybacksBloc>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: const PlatformBackButton(),
        title: Text(
          'Paybacks',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimaryLight,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: BlocBuilder<PaybacksBloc, PaybacksState>(
            builder: (context, state) {
              final paybacks = state.paybacks;
              if (paybacks.isNotEmpty) {
                return Column(
                  children: [
                    for (final payback in paybacks) ...[
                      GestureDetector(
                        onTap: () => paybacksBloc.add(UpdatePayback(payback)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadowLight,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  payback.counterparty,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: AppColors.textPrimaryLight,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  '${payback.remaining.toStringAsFixed(2)}',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondaryLight,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  payback.status.displayName,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: payback.status.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ],
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No paybacks yet',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.neutral900,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () => paybacksBloc.add(AddPayback(
                            Payback(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              counterparty: 'New Payback',
                              amount: 0.0,
                              remaining: 0.0,
                              startDate: DateTime.now(),
                              status: PaybackStatus.pending,
                              type: PaybackType.owedToMe,
                              category: PaybackCategory.personal,
                            ),
                          )),
                          child: Text(
                            'Add Payback',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
} 