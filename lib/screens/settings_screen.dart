import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flood_survival_app/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flood_survival_app/providers/theme_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'ไทย';
  final List<String> _languages = ['ไทย', 'English'];

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications') ?? true;
      _selectedLanguage = prefs.getString('language') ?? 'ไทย';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', _notificationsEnabled);
    await prefs.setString('language', _selectedLanguage);
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() {
      _notificationsEnabled = value;
    });
    await _saveSettings();
    if (value) {
      _scheduleTestNotification();
    } else {
      _cancelNotifications();
    }
  }

  Future<void> _scheduleTestNotification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'test_channel_id',
      'Test Notifications',
      channelDescription: 'Channel for test notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'ทดสอบการแจ้งเตือน',
      'การแจ้งเตือนถูกเปิดใช้งาน',
      platformChannelSpecifics,
    );
  }

  Future<void> _cancelNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการออกจากระบบ'),
          content: const Text('คุณต้องการออกจากระบบใช่หรือไม่?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('ยกเลิก'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await _auth.signOut();
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login',
                    (route) => false,
                  );
                } catch (e) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('เกิดข้อผิดพลาด: ${e.toString()}')),
                  );
                }
              },
              child: const Text('ออกจากระบบ'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตั้งค่า'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          if (_auth.currentUser != null)
            ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: Text(
                  _auth.currentUser!.email?.substring(0, 1).toUpperCase() ??
                      'U',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(_auth.currentUser!.email ?? 'ผู้ใช้'),
              subtitle: const Text('บัญชีของคุณ'),
              onTap: () {
                // เปิดหน้าโปรไฟล์ผู้ใช้
              },
            ),
          const Divider(),
          // ธีม (โหมดมืด) ใช้งานผ่าน Provider
          SwitchListTile(
            title: const Text('โหมดมืด'),
            subtitle: const Text('เปลี่ยนรูปแบบธีมของแอปพลิเคชัน'),
            secondary: const Icon(Icons.dark_mode),
            value: themeProvider.isDarkMode,
            onChanged: (bool value) {
              themeProvider.setDarkMode(value);
            },
          ),
          // การแจ้งเตือน
          SwitchListTile(
            title: const Text('การแจ้งเตือน'),
            subtitle: const Text('เปิด/ปิดการแจ้งเตือนจากแอปพลิเคชัน'),
            secondary: const Icon(Icons.notifications),
            value: _notificationsEnabled,
            onChanged: (bool value) {
              _toggleNotifications(value);
            },
          ),
          const Divider(),
          // ข้อมูลแอป
          ListTile(
            title: const Text('เกี่ยวกับแอปพลิเคชัน'),
            subtitle: const Text('เวอร์ชัน 1.0.0'),
            leading: const Icon(Icons.info),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // เปิดหน้าข้อมูลแอป
            },
          ),
          // ช่วยเหลือ
          ListTile(
            title: const Text('ช่วยเหลือและสนับสนุน'),
            subtitle: const Text('คำถามที่พบบ่อยและการติดต่อสนับสนุน'),
            leading: const Icon(Icons.help),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () async {
              final url = Uri.parse('https://github.com/itzdeenzxx');
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('ไม่สามารถเปิดลิงก์ได้')),
                );
              }
            },
          ),
          const SizedBox(height: 20),
          // ปุ่มออกจากระบบ
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('ออกจากระบบ', style: TextStyle(fontSize: 16)),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
