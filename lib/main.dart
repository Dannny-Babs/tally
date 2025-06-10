import '../../../../utils/utils.dart';
import 'core/app_shell.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/not_found_screen.dart';
import 'features/settings/repositories/repositories.dart';
import 'features/transactions/repositories/income_repository.dart';
import 'features/transactions/repositories/expense_repository.dart';
import 'features/settings/bloc/savings/savings_bloc.dart';
import 'features/settings/bloc/savings/savings_event.dart';
import 'features/settings/bloc/paybacks/paybacks_bloc.dart';
import 'features/settings/bloc/paybacks/paybacks_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(MyApp(prefs: prefs));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  
  const MyApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => ProfileRepository(),
        ),
        RepositoryProvider(
          create: (context) => PreferencesRepository(),
        ),
        RepositoryProvider(
          create: (context) => AccountsRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ProfileBloc(
              context.read<ProfileRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => PreferencesBloc(
              context.read<PreferencesRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => AccountsBloc(
              context.read<AccountsRepository>(),
            )..add(AccountsLoaded()),
          ),
          BlocProvider(
            create: (context) => TransactionBloc(
              incomeRepository: IncomeRepository(),
              expenseRepository: ExpenseRepository(),
            ),
          ),
          BlocProvider(
            create: (context) => AuthBloc(),
          ),
          BlocProvider(
            create: (context) => DashboardBloc(),
          ),
          BlocProvider(
            create: (context) => SavingsBloc(
              prefs: prefs,
            )..add(const LoadSavings()),
          ),
          BlocProvider(
            create: (context) => PaybacksBloc(
              prefs: prefs,
            )..add(LoadPaybacks()),
          ),
        ],
        child: MaterialApp(
          title: 'Tally',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          routes: {
            '/savings': (context) => const SavingsScreen(),
            '/paybacks': (context) => const PaybacksScreen(),
            '/edit_profile': (context) => const EditProfileScreen(),
          },
          initialRoute: '/',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/savings':
                return MaterialPageRoute(
                  builder: (context) => const SavingsScreen(),
                );
              case '/paybacks':
                return MaterialPageRoute(
                  builder: (context) => const PaybacksScreen(),
                );
              case '/edit_profile':
                return MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                );
              default:
                return MaterialPageRoute(
                  builder: (context) => const NotFoundScreen(),
                );
            }
          },
          onUnknownRoute: (settings) => MaterialPageRoute(
            builder: (context) => const NotFoundScreen(),
          ),
          home: const AppShell(),
        ),
      ),
    );
  }
}
