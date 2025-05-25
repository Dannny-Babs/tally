import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../features/dashboard/views/dashboard_screen.dart';
import '../features/transactions/views/income_screen.dart';
import 'widgets/custom_tab_bar.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const IncomeScreen(), // Income screen
    const Placeholder(), // Expenses screen
    const Placeholder(), // Settings screen
  ];

  final List<String> _iconPaths = [
    'assets/icons/home.png',
    'assets/icons/income.png',
    'assets/icons/expenses.png',
    'assets/icons/settings.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: CustomTabBar(
        iconPaths: _iconPaths,
        currentIndex: _selectedIndex,
        onTabSelected: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
} 