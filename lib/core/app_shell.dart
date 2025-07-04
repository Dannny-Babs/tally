

import '../utils/utils.dart';
import 'widgets/custom_tab_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;
  final _stackKey = GlobalKey();

  final List<Widget> _screens = [
    const DashboardScreen(),
    const IncomeScreen(), // Income screen
    const ExpenseScreen(), // Expenses screen
    const SettingsScreen(), // Settings screen
  ];

  final List<String> _iconPaths = [
    'assets/icons/home.png',
    'assets/icons/income.png',
    'assets/icons/expenses.png',
    'assets/icons/settings.png',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransactionBloc, TransactionState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            key: _stackKey,
            index: _selectedIndex,
            children: _screens,
          ),
          bottomNavigationBar: CustomTabBar(
            iconPaths: _iconPaths,
            currentIndex: _selectedIndex,
            onTabSelected: (index) {
              setState(() => _selectedIndex = index);
              // Load appropriate data when switching tabs
              if (index == 1) { // Income tab
                context.read<TransactionBloc>().add(IncomeLoaded());
              } else if (index == 2) { // Expense tab
                context.read<TransactionBloc>().add(ExpensesLoaded());
              }
            },
          ),
        );
      },
    );
  }
} 