import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flood_survival_app/config/routes.dart';
import 'package:flood_survival_app/config/theme.dart';
import 'package:flood_survival_app/screens/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flood_survival_app/firebase_options.dart';
import 'package:flood_survival_app/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const FloodSurvivalApp(),
    ),
  );
}

class FloodSurvivalApp extends StatelessWidget {
  const FloodSurvivalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'รับมือน้ำท่วม',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          initialRoute: AppRoutes.login,
          routes: AppRoutes.routes,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
