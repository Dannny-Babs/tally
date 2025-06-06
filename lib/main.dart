import '../../../../utils/utils.dart';
import 'core/app_shell.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/not_found_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DashboardBloc>(
          create: (context) {
            final bloc = DashboardBloc();
            // Use compute for heavy initialization
            Future.microtask(() {
              bloc.add(DashboardLoaded());
            });
            return bloc;
          },
        ),
        BlocProvider<TransactionBloc>(
          create: (context) {
            final bloc = TransactionBloc();
            // Initialize with expenses data
            Future.microtask(() {
              bloc.add(ExpensesLoaded());
            });
            return bloc;
          },
        ),
        BlocProvider<SettingsBloc>(
          create: (context) => SettingsBloc(),
        ),
        BlocProvider<CategoryBloc>(
          create: (context) => CategoryBloc(),
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
