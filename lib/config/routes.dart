import 'package:flutter/material.dart';
import 'package:flood_survival_app/screens/home_screen.dart';
import 'package:flood_survival_app/screens/survival_guide_screen.dart';
import 'package:flood_survival_app/screens/health_check_screen.dart';
import 'package:flood_survival_app/screens/emergency_contacts_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String survivalGuide = '/survival-guide';
  static const String healthCheck = '/health-check';
  static const String emergencyContacts = '/emergency-contacts';

  static Map<String, WidgetBuilder> get routes => {
        home: (context) => const HomeScreen(),
        survivalGuide: (context) => const SurvivalGuideScreen(),
        healthCheck: (context) => const HealthCheckScreen(),
        emergencyContacts: (context) => const EmergencyContactsScreen(),
      };
}