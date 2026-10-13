import 'package:flutter/material.dart';

import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'app/theme/theme_controller.dart';
import 'core/di/injection.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const DharmikApp());
}

class DharmikApp extends StatefulWidget {
  const DharmikApp({super.key});
  @override
  State<DharmikApp> createState() => _DharmikAppState();
}

class _DharmikAppState extends State<DharmikApp> {
  final ThemeController themeController = ThemeController();

  @override
  void initState() {
    super.initState();
    themeController.addListener(_onThemeChanged);
  }

  void _onThemeChanged() {setState(() {});}

  @override
  void dispose() {
    themeController..removeListener(_onThemeChanged)..dispose();
    super.dispose();
  }

ThemeData get currentTheme {
  switch (themeController.themeMode) {
    case AppThemeMode.light: return AppTheme.lightTheme;
    case AppThemeMode.dark: return AppTheme.darkTheme;
    case AppThemeMode.orange:return AppTheme.orangeTheme;
    // case AppThemeMode.red:return AppTheme.redTheme;
  }
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Hindu App',
      theme: AppTheme.lightTheme,
      darkTheme: currentTheme,// AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
