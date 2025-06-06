import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../settings/bloc/accounts_bloc.dart';
import '../settings/bloc/accounts_state.dart';
import '../settings/bloc/accounts_event.dart';

class GiftsScreen extends StatelessWidget {
  const GiftsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accountsBloc = context.read<AccountsBloc>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
        title: Text('Gifts', style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimaryLight,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        )),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: BlocBuilder<AccountsBloc, AccountsState>(
            builder: (context, state) {
              final giftsList = state.giftsList;
              if (giftsList.isNotEmpty) {
                return Column(
                  children: [
                    for (final gift in giftsList) ...[
                      GestureDetector(
                        onTap: () => accountsBloc.add(GiftSelected(gift.id)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surfaceLight,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.shadowLight,
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(gift.name, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimaryLight)),
                                const SizedBox(height: 6),
                                Text('4${gift.amount.toStringAsFixed(2)} • ${gift.dateFormatted}', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondaryLight)),
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
                      Text('No gifts yet', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondaryLight)),
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
                          onPressed: () => accountsBloc.add(AddGiftRequested()),
                          child: Text('Add Gift', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white)),
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