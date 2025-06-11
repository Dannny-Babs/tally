import 'package:intl/intl.dart';
import 'package:tally/utils/packages.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/empty_state_placeholder.dart';
import '../../core/widgets/platform_back_button.dart';
import 'bloc/savings/savings_bloc.dart';
import 'bloc/savings/savings_event.dart';
import 'bloc/savings/savings_state.dart';
import 'widgets/add_savings_goal_modal.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const PlatformBackButton(
          color: AppColors.textPrimaryLight,
        ),
        title: Text(
          'Savings',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimaryLight,
            letterSpacing: -0.5,
            fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ),
      body: BlocBuilder<SavingsBloc, SavingsState>(
        builder: (context, state) {
          if (state.status == SavingsStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == SavingsStatus.error) {
            return Center(
              child: Text(
                state.errorMessage ?? 'An error occurred',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error,
                ),
              ),
            );
          }

          final goals = state.goals;
          if (goals.isEmpty) {
            return EmptyStatePlaceholder(
              imagePath: 'assets/images/no_savings.png',
              message: 'No savings goals yet. Tap + to create one.',
              onActionPressed: () => _openAddGoalModal(context),
              actionLabel: 'Add Goal',
              title: 'No Savings Goals',
            );
          }

          // Calculate totals
          final totalSaved = goals.fold<double>(
            0,
            (sum, g) => sum + g.currentAmount,
          );
          final totalTargets = goals.fold<double>(
            0,
            (sum, g) => sum + g.targetAmount,
          );

          return ListView(
            padding: const EdgeInsets.all(8),
            children: [
              // Summary Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: AppColors.borderLight),
                ),
                color: Colors.white,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Saved',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimaryLight,
                          letterSpacing: -0.5,
                          fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(width: 2),
                          Text(
                            '\$${totalSaved.toStringAsFixed(2)}',
                            textAlign: TextAlign.end,
                            style: AppTextStyles.displayMedium.copyWith(
                              fontSize: 28,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.15,
                              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                            ),
                          ),
                          Text(
                            ' /${totalTargets.toStringAsFixed(0)}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Progress',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.neutral700,
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.15,
                              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                            ),
                          ),
                          Text(
                            '${((totalSaved / totalTargets) * 100).round()}%',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          borderRadius: BorderRadius.circular(4),
                          value: (totalSaved / totalTargets).clamp(0, 1.0),
                          backgroundColor: AppColors.neutral200,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.textPrimaryLight,
                          ),
                          minHeight: 20,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(
                        color: AppColors.neutral200,
                        thickness: 1,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Saving Goals',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimaryLight,
                              letterSpacing: -0.5,
                              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${goals.length} goals',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary900,
                              letterSpacing: -0.25,
                              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                              fontWeight: FontWeight.w600,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _openAddGoalModal(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.textPrimaryLight,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Text(
                            'Add Goal',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.neutral200,
                              fontSize: 14,
                              letterSpacing: -0.35,
                              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Goals List
                      ...goals
                          .map((goal) => _SavingsGoalCard(goal: goal))
                          .toList(),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary500,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _openAddGoalModal(context),
      ),
    );
  }

  void _openAddGoalModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const AddSavingsGoalModal(),
    );
  }
}

class _SavingsGoalCard extends StatelessWidget {
  final SavingsGoal goal;

  const _SavingsGoalCard({required this.goal});

  @override
  Widget build(BuildContext context) {
    final percent =
        (goal.currentAmount / goal.targetAmount).clamp(0, 1.0).toDouble();
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.borderLight),
      ),
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    goal.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.neutral800,
                      letterSpacing: -0.15,
                      fontSize: 16,
                      fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(
                    HugeIconsSolid.moreVertical,
                    color: AppColors.neutral700,
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  constraints: const BoxConstraints(
                    minWidth: 20,
                    minHeight: 20,
                  ),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  style: ButtonStyle(
                    padding: WidgetStateProperty.all(EdgeInsets.zero),
                    backgroundColor:
                        WidgetStateProperty.all(AppColors.neutral100),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  onSelected: (value) {
                    if (value == 'edit') {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => AddSavingsGoalModal(existing: goal),
                      );
                    } else if (value == 'delete') {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: AppColors.neutral50,
                          titleTextStyle: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.neutral800,
                            letterSpacing: -0.15,
                            fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: AppColors.neutral200),
                          ),
                          title: const Text('Delete Goal'),
                          content: Text(
                            'Are you sure you want to delete "${goal.name}"?',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.neutral700,
                              letterSpacing: -0.15,
                              fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<SavingsBloc>().add(
                                      DeleteSavingsGoal(goal.id),
                                    );
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: AppColors.error),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'edit',
                      child: Text(
                        'Edit',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.neutral800,
                          letterSpacing: -0.15,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Delete',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.error,
                          letterSpacing: -0.15,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${goal.currentAmount.toStringAsFixed(2)}',
                  style: AppTextStyles.displaySmall.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.15,
                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                  ),
                ),
                Text(
                  ' /${goal.targetAmount.toStringAsFixed(0)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.neutral700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progress',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.neutral700,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.15,
                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                  ),
                ),
                Text(
                  '${(percent * 100).round()}%',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(4),
                value: percent,
                backgroundColor: AppColors.neutral200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.textPrimaryLight,
                ),
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Target by ${DateFormat.yMMMd().format(goal.targetDate)}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.neutral700,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.15,
                fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
