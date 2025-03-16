// lib/config/routes.dart
import 'package:flutter/material.dart';

// นำเข้าหน้าต่าง ๆ
import 'package:flood_survival_app/screens/home_screen.dart';
import 'package:flood_survival_app/screens/survival_guide_screen.dart';
import 'package:flood_survival_app/screens/health_check_screen.dart';
import 'package:flood_survival_app/screens/emergency_contacts_screen.dart';
import 'package:flood_survival_app/screens/auth/login_screen.dart';
import 'package:flood_survival_app/screens/auth/register_screen.dart';
import 'package:flood_survival_app/screens/settings_screen.dart';
import 'package:flood_survival_app/screens/news/news_screen.dart';
import 'package:flood_survival_app/screens/news/news_detail_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String survivalGuide = '/survival-guide';
  static const String healthCheck = '/health-check';
  static const String emergencyContacts = '/emergency-contacts';
  static const String login = '/login';
  static const String register = '/register';
  static const String settings = '/settings';

  // เพิ่ม route ของ news
  static const String news = '/news';
  static const String newsDetail = '/news-detail';

  // Routes ที่ไม่ต้องมี arguments
  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomeScreen(),
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        survivalGuide: (context) => const SurvivalGuideScreen(),
        healthCheck: (context) => const DiseaseAnalyzerScreen(),
        emergencyContacts: (context) => const EmergencyContactsScreen(),
        settings: (context) => const SettingsScreen(),
        news: (context) => const NewsScreen(),
      };

  // onGenerateRoute สำหรับหน้าที่ต้องส่ง arguments
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case newsDetail:
      if (settings.arguments is String) {
        return MaterialPageRoute(
          builder: (context) => NewsDetailScreen(newsId: settings.arguments as String),
        );
      } else {
        // ถ้า arguments ไม่มีหรือผิดพลาด ให้ไปหน้า Home
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      }

    default:
      return MaterialPageRoute(
        builder: (context) => const HomeScreen(),
      );
  }
}

}
