// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/supabase_config.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/auth_cubit.dart';
import 'screens/categories/category_cubit.dart';
import 'screens/home/transaction_cubit.dart';
import 'screens/reports/report_cubit.dart';
import 'services/auth_service.dart';
import 'services/category_service.dart';
import 'services/transaction_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi Supabase menggunakan config
  await SupabaseConfig.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Global AuthCubit for authentication state
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(AuthService()),
        ),
        // Global CategoryCubit - shared across all screens
        BlocProvider<CategoryCubit>(
          create: (context) => CategoryCubit(CategoryService()),
          lazy: false, // Load immediately
        ),
        // Global TransactionCubit - shared across all screens
        BlocProvider<TransactionCubit>(
          create: (context) => TransactionCubit(TransactionService()),
          lazy: false, // Load immediately
        ),
        // Global ReportCubit - shared across all screens
        BlocProvider<ReportCubit>(
          create: (context) => ReportCubit(TransactionService()),
          lazy: false, // Load immediately
        ),
      ],
      child: MaterialApp(
        title: 'Kasflow - Personal Finance Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.teal,
          primaryColor: Colors.teal,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.light,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            elevation: 2,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
          ),
          cardTheme: const CardThemeData(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          useMaterial3: true,
        ),
        home: const LoginScreen(), 
      ),
    );
  }
}