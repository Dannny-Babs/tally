import 'package:tally/core/widgets/platform_back_button.dart';
import '../../utils/utils.dart';
import 'bloc/paybacks/paybacks_bloc.dart';
import 'bloc/paybacks/paybacks_event.dart';
import 'bloc/paybacks/paybacks_state.dart';
import 'models/payback.dart';
import 'package:flutter/material.dart';

class FullWidthIndicator extends Decoration {
  final BoxDecoration decoration;
  const FullWidthIndicator({required this.decoration});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _FullWidthIndicatorPainter(decoration, onChanged);
  }
}

class _FullWidthIndicatorPainter extends BoxPainter {
  final BoxDecoration decoration;
  _FullWidthIndicatorPainter(this.decoration, VoidCallback? onChanged)
      : super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final Rect rect = offset & configuration.size!;
    decoration
        .createBoxPainter()
        .paint(canvas, rect.topLeft, configuration.copyWith(size: rect.size));
  }
}

class PaybackSummaryCard extends StatelessWidget {
  final String title;
  final String leftLabel;
  final String leftValue;
  final Color leftValueColor;
  final String rightLabel;
  final String rightValue;
  final Color rightValueColor;
  final String? bottomLeft;
  final String? bottomRight;
  final Color? bottomRightColor;

  const PaybackSummaryCard({
    super.key,
    required this.title,
    required this.leftLabel,
    required this.leftValue,
    required this.leftValueColor,
    required this.rightLabel,
    required this.rightValue,
    required this.rightValueColor,
    this.bottomLeft,
    this.bottomRight,
    this.bottomRightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppColors.textPrimaryLight,
                  letterSpacing: -0.3),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(leftLabel,
                        style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 13,
                            color: AppColors.neutral800,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3)),
                    const SizedBox(height: 2),
                    Text(leftValue,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: leftValueColor)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rightLabel,
                        style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 13,
                            color: AppColors.neutral800,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3)),
                    const SizedBox(height: 2),
                    Text(rightValue,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: rightValueColor)),
                  ],
                ),
                const SizedBox(width: 32),
              ],
            ),
            if (bottomLeft != null || bottomRight != null) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  if (bottomLeft != null)
                    Text(bottomLeft!,
                        style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 13,
                            color: AppColors.textPrimaryLight,
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.3)),
                  if (bottomLeft != null && bottomRight != null)
                    const SizedBox(width: 16),
                  if (bottomRight != null)
                    Text(
                      bottomRight!,
                      style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 13,
                          color: bottomRightColor ?? AppColors.textPrimaryLight,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class PaybacksScreen extends StatefulWidget {
  const PaybacksScreen({super.key});

  @override
  State<PaybacksScreen> createState() => _PaybacksScreenState();
}

class _PaybacksScreenState extends State<PaybacksScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
            letterSpacing: -0.3,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.neutral200,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.neutral300),
            ),
            height: 44,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final tabWidth = constraints.maxWidth / 2;
                return TabBar(
                  controller: _tabController,
                  isScrollable: false,
                  indicator: FullWidthIndicator(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary500.withAlpha(105),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  indicatorPadding: EdgeInsets.zero,
                  dividerColor: Colors.transparent,
                  labelColor: AppColors.primary800,
                  unselectedLabelColor: AppColors.textPrimaryLight,
                  indicatorColor: Colors.transparent,
                  labelStyle: AppTextStyles.bodySmall.copyWith(
                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.15,
                  ),
                  unselectedLabelStyle: AppTextStyles.bodySmall.copyWith(
                    fontFamily: GoogleFonts.spaceGrotesk().fontFamily,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.15,
                  ),
                  tabs: [
                    Tab(
                        child: SizedBox(
                            width: tabWidth,
                            child: Center(child: Text('Personal')))),
                    Tab(
                        child: SizedBox(
                            width: tabWidth,
                            child: Center(child: Text('Credit')))),
                    Tab(
                        child: SizedBox(
                            width: tabWidth,
                            child: Center(child: Text('Debt')))),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<PaybacksBloc, PaybacksState>(
          builder: (context, state) {
            final paybacks = state.paybacks;
            if (paybacks.isNotEmpty) {
              return Column(
                children: [
                  _buildSummaryCard(_tabController.index),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Personal tab
                        ListView(
                          children: [
                            buildPersonalPaybackCard(
                              icon: Icons.account_circle,
                              name: 'Sarah Chen',
                              started: 'May 31',
                              due: 'Jun 14',
                              status: 'Due',
                              amount: '\$4750',
                              ofAmount: '\$4500',
                              amountColor: Colors.green,
                              isOverdue: false,
                            ),
                            buildPersonalPaybackCard(
                              icon: Icons.account_circle,
                              name: 'Mike Johnson',
                              started: 'May 19',
                              due: '',
                              status: 'Overdue',
                              amount: '\$4250',
                              ofAmount: '\$4500',
                              amountColor: Colors.red,
                              isOverdue: true,
                            ),
                          ],
                        ),
                        // Credit tab
                        ListView(
                          children: [
                            buildCreditCard(
                              icon: Icons.credit_card,
                              name: 'Chase Sapphire Preferred',
                              type: 'Credit Card',
                              started: 'Dec 31',
                              status: 'Active',
                              interest: '18.99%',
                              utilization: 0.54,
                              utilizationText: '54.0%',
                              amount: '\$42,300',
                              ofAmount: '\$45,000',
                            ),
                          ],
                        ),
                        // Debt tab
                        ListView(
                          children: [
                            buildDebtCard(
                              icon: Icons.account_balance,
                              name: 'Personal Loan - Marcus',
                              type: 'Personal Loan',
                              started: 'Aug 14',
                              status: 'Active',
                              interest: '6.99%',
                              progress: 0.83,
                              amount: '\$412,500',
                              ofAmount: '\$415,000',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                            id: DateTime.now()
                                .millisecondsSinceEpoch
                                .toString(),
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
    );
  }

  Widget _buildSummaryCard(int tabIndex) {
    switch (tabIndex) {
      case 0: // Personal
        return const PaybackSummaryCard(
          title: 'Personal Paybacks',
          leftLabel: 'Owed To Me',
          leftValue: '\$6,000',
          leftValueColor: Colors.green,
          rightLabel: 'I Owe',
          rightValue: '\$300',
          rightValueColor: Colors.red,
          bottomLeft: 'Upcoming: 2',
          bottomRight: 'Overdue: 1',
          bottomRightColor: Colors.red,
        );
      case 1: // Credit
        return const PaybackSummaryCard(
          title: 'Credit Paybacks',
          leftLabel: 'Credit Extended',
          leftValue: '\$3,500',
          leftValueColor: Colors.green,
          rightLabel: 'Credit Owed',
          rightValue: '\$3,150',
          rightValueColor: Colors.red,
          bottomLeft: 'Active: 3',
        );
      case 2: // Debt
        return const PaybackSummaryCard(
          title: 'Debt Paybacks',
          leftLabel: 'Total Owed',
          leftValue: '\$46,850',
          leftValueColor: Colors.red,
          rightLabel: 'Original Amount',
          rightValue: '\$68,000',
          rightValueColor: AppColors.textPrimaryLight,
          bottomLeft: 'Active: 3',
        );
      default:
        return const SizedBox.shrink();
    }
  }

  // --- Payback List Card Widgets ---
  Widget buildPersonalPaybackCard({
    required IconData icon,
    required String name,
    required String started,
    required String due,
    required String status,
    required String amount,
    required String ofAmount,
    required Color amountColor,
    required bool isOverdue,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 36, color: amountColor),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                children: [
                  // Left column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Started $started', style: const TextStyle(fontSize: 13)),
                        Text(
                          isOverdue ? 'Overdue' : 'Due $due',
                          style: TextStyle(
                            fontSize: 13,
                            color: isOverdue ? Colors.red : Colors.grey[700],
                            fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Right column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: amountColor)),
                      Text('of $ofAmount', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCreditCard({
    required IconData icon,
    required String name,
    required String type,
    required String started,
    required String status,
    required String interest,
    required double utilization, // 0.0 - 1.0
    required String utilizationText,
    required String amount,
    required String ofAmount,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 36, color: Colors.blue),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(type, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  Text('Started $started', style: const TextStyle(fontSize: 13)),
                  Text(status, style: const TextStyle(fontSize: 13, color: Colors.green)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('$interest ', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      const Text('Interest', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                  Row(
                    children: [
                      Text(utilizationText, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      const Text(' Utilization', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: utilization,
                    minHeight: 6,
                    backgroundColor: Colors.grey[200],
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.blue)),
                      Text(' of $ofAmount', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDebtCard({
    required IconData icon,
    required String name,
    required String type,
    required String started,
    required String status,
    required String interest,
    required double progress, // 0.0 - 1.0
    required String amount,
    required String ofAmount,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, size: 36, color: Colors.deepPurple),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(type, style: const TextStyle(fontSize: 13, color: Colors.grey)),
                  Text('Started $started', style: const TextStyle(fontSize: 13)),
                  Text(status, style: const TextStyle(fontSize: 13, color: Colors.green)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text('$interest ', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      const Text('Interest', style: TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.grey[200],
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.deepPurple)),
                      Text(' of $ofAmount', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
