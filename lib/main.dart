import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exp/provider/theme_provider.dart';
import 'screens/landing_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
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
      home: const LandingPage(),
    );
  }
}
