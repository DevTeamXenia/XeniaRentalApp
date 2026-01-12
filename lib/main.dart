import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'src/core/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppTheme.light.primaryColor,
      statusBarIconBrightness: Brightness.light,    
    ),
  );

  runApp(const App());
}
