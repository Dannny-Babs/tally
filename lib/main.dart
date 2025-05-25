import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/app_shell.dart';
import 'features/dashboard/bloc/dashboard_bloc.dart';
import 'features/dashboard/bloc/dashboard_event.dart';
import 'features/transactions/bloc/transaction_bloc.dart';
import 'features/settings/bloc/settings_bloc.dart';
import 'core/widgets/not_found_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DashboardBloc()..add(DashboardLoaded()),
        ),
        BlocProvider(
          create: (context) => TransactionBloc(),
        ),
        BlocProvider(
          create: (context) => SettingsBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Tally',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        onUnknownRoute: (settings) => MaterialPageRoute(
          builder: (context) => const NotFoundScreen(),
        ),
        home: const AppShell(),
      ),
    );
  }
}
