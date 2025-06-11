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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSummaryCard(_tabController.index),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'Transactions',
                      style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                          letterSpacing: -0.25),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.neutral100),
                      ),
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Personal tab
                          ListView(
                            children: [
                              buildPersonalPaybackCard(
                                icon: HugeIconsStroke.userCircle02,
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
                                icon: HugeIconsStroke.userCircle02,
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
                                icon: HugeIconsStroke.creditCard,
                                name: 'TD Cashback Card',
                                type: 'Credit Card',
                                started: 'Dec 31',
                                status: 'Due',
                                interest: '18.99%',
                                utilization: 0.90,
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
                  ),
                ],
              )
              ;
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
    floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary500,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => {},
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
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.neutral100),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: amountColor.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(icon, size: 24, color: amountColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Row(
                children: [
                  // Left column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                letterSpacing: -0.2)),
                        Row(
                          children: [
                            Text('Started $started',
                                style: AppTextStyles.bodySmall.copyWith(
                                    fontSize: 13,
                                    color: AppColors.neutral700,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: -0.15)),
                            const SizedBox(width: 4),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.neutral300,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 2),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isOverdue ? 'Overdue' : 'Due $due',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isOverdue
                                    ? AppColors.error
                                    : AppColors.neutral700,
                                fontWeight: isOverdue
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Right column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(amount,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: amountColor)),
                      Text('of $ofAmount',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.grey)),
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
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.neutral200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(icon, size: 24, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name,
                        style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            letterSpacing: -0.2)),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.neutral200,
                        borderRadius: BorderRadius.circular(90),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      child: Text(
                        type,
                        style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 12,
                            color: AppColors.neutral800,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Started $started',
                      style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 13,
                          color: AppColors.neutral700,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 6, right: 6),
                      decoration: BoxDecoration(
                        color: AppColors.neutral400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                    ),
                    Text(
                      status,
                      style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 13,
                          color: Colors.blue,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 6, right: 6),
                      decoration: BoxDecoration(
                        color: AppColors.neutral400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                    ),
                    Text(
                      interest,
                      style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 13,
                          color: AppColors.neutral700,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text(' Utilization',
                        style: AppTextStyles.bodySmall
                            .copyWith(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.normal)),
                    Text(utilizationText,
                        style: AppTextStyles.bodySmall
                            .copyWith(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600 )),
                    
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: utilization,
                  minHeight: 6,
                  backgroundColor: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.blue,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(amount,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blue)),
                    Text(' of $ofAmount',
                        style: const TextStyle(
                            fontSize: 13, color: Colors.grey)),
                  ],
                ),
              ],
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
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.neutral200),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple.withAlpha(20),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(icon, size: 24, color: Colors.deepPurple),
            ),
            const SizedBox(height: 16),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 Row(
                  children: [
                    Text(name,
                        style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            letterSpacing: -0.2)),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.neutral200,
                        borderRadius: BorderRadius.circular(90),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Text(type,
                          style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 12,
                              color: AppColors.neutral800,
                              fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('Started $started',
                        style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 13, 
                            color: AppColors.neutral700,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: 4),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.neutral400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    ),
                    const SizedBox(width: 4),
                    Text(status,  
                        style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 13,
                            color: Colors.green,
                            fontWeight: FontWeight.w600)),
                    const SizedBox(width: 4),
                    Container(  
                      decoration: BoxDecoration(
                        color: AppColors.neutral400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                    ),
                    const SizedBox(width: 4),
                    Text(interest,
                        style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 13,
                            color: AppColors.neutral700,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
                  const SizedBox(height:10),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(amount,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.deepPurple)),
                      Text(' of $ofAmount',
                          style: const TextStyle(
                              fontSize: 13, color: Colors.grey)),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
