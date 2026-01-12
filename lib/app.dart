import 'package:flutter/material.dart';
import 'src/features/splash/splash_page.dart';
import 'src/core/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: AppTheme.light,
      home: const SplashPage(), 
    );
  }
}
