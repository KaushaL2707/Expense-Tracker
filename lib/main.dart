import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exp/provider/theme_provider.dart';
import 'package:exp/providers/user_provider.dart';
import 'screens/landing_page.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Expense Analyzer',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.theme,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Check session on startup
    Future.microtask(
        () => Provider.of<UserProvider>(context, listen: false).checkSession());
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (userProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userProvider.isAuthenticated) {
      return const MainScreen();
    } else {
      return const LandingPage();
    }
  }
}
