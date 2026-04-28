import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_budget/core/config/injection.dart';
import 'package:smart_budget/core/theme/app_theme.dart';
import 'package:smart_budget/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:smart_budget/features/authentication/presentation/pages/auth_wrapper.dart';
import 'package:smart_budget/features/expenses/presentation/bloc/expense_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/analytics/presentation/bloc/analytics_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://hjoyjogottrhwhbbveyc.supabase.co',
    anonKey: 'sb_publishable_PPrC4ctAz0vazJSkBOdcZA_bStz3OCT',
  );

  // Initialize dependency injection
  await configureDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthBloc>()),
      BlocProvider(
        create: (context) =>getIt<ExpenseBloc>(),
      ),
      BlocProvider(
        create: (_) => getIt<AnalyticsBloc>(),
      ),
      ],
      child: MaterialApp(
        title: 'Smart Budget',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        home:const AuthWrapper(),
      ),
    );
  }
}
