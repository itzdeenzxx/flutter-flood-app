import 'package:flutter/material.dart';
import 'package:flood_survival_app/config/routes.dart';
import 'package:flood_survival_app/config/theme.dart';

void main() {
  runApp(const FloodSurvivalApp());
}

class FloodSurvivalApp extends StatelessWidget {
  const FloodSurvivalApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'รับมือน้ำท่วม',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routes: AppRoutes.routes, // ใช้ routes สำหรับหน้าทั้งหมด
      initialRoute: AppRoutes.home, // กำหนดเส้นทางเริ่มต้นให้เป็น HomeScreen
      debugShowCheckedModeBanner: false,
    );
  }
}
