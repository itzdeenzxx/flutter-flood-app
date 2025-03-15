import 'package:flutter/material.dart';
import 'package:flood_survival_app/screens/home_screen.dart';
import 'package:flood_survival_app/screens/survival_guide_screen.dart';
import 'package:flood_survival_app/screens/health_check_screen.dart';
import 'package:flood_survival_app/screens/emergency_contacts_screen.dart';
import 'package:flood_survival_app/screens/auth/login_screen.dart';
import 'package:flood_survival_app/screens/auth/register_screen.dart';
import 'package:flood_survival_app/screens/settings_screen.dart';


class AppRoutes {
  static const String home = '/';
  static const String survivalGuide = '/survival-guide';
  static const String healthCheck = '/health-check';
  static const String emergencyContacts = '/emergency-contacts';
  static const String login = '/login';
  static const String register = '/register';
  static const String settings = '/settings';
  static const String chatbot = '/chatbot';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomeScreen(),
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        survivalGuide: (context) => const SurvivalGuideScreen(),
        healthCheck: (context) => const DiseaseAnalyzerScreen(),
        emergencyContacts: (context) => const EmergencyContactsScreen(),
        settings: (context) => const SettingsScreen(),

      };
}
