import 'package:flutter/material.dart';
import 'package:flood_survival_app/config/routes.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigation({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'หน้าหลัก',
                index: 0,
                route: AppRoutes.home,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.menu_book_outlined,
                selectedIcon: Icons.menu_book,
                label: 'คู่มือรับมือ',
                index: 1,
                route: AppRoutes.survivalGuide,
              ),
              _buildEmergencyButton(context),
              _buildNavItem(
                context: context,
                icon: Icons.medical_services_outlined,
                selectedIcon: Icons.medical_services,
                label: 'สุขภาพ',
                index: 2,
                route: AppRoutes.healthCheck,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.call_outlined,
                selectedIcon: Icons.call,
                label: 'ติดต่อฉุกเฉิน',
                index: 3,
                route: AppRoutes.emergencyContacts,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
    required String route,
  }) {
    final isSelected = index == currentIndex;
    final color = isSelected
        ? Theme.of(context).primaryColor
        : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5);

    return InkWell(
      onTap: () {
        if (!isSelected) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? selectedIcon : icon,
            color: color,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyButton(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B6B),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B6B).withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(
          Icons.sos,
          color: Colors.white,
          size: 30,
        ),
        onPressed: () {
          _showEmergencyDialog(context);
        },
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ขอความช่วยเหลือฉุกเฉิน'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.call, color: Colors.red),
                title: Text('โทร 191 - แจ้งเหตุด่วนเหตุร้าย'),
              ),
              ListTile(
                leading: Icon(Icons.local_hospital, color: Colors.red),
                title: Text('โทร 1669 - บริการการแพทย์ฉุกเฉิน'),
              ),
              ListTile(
                leading: Icon(Icons.water, color: Colors.blue),
                title: Text('โทร 1784 - ศูนย์ป้องกันน้ำท่วม'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ปิด'),
            ),
          ],
        );
      },
    );
  }
}