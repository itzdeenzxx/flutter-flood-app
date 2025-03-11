import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // ตั้งค่าไทม์โซน
    tz_data.initializeTimeZones();

    // กำหนดรูปแบบการแจ้งเตือนสำหรับ Android
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // กำหนดรูปแบบการแจ้งเตือนสำหรับ iOS
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // กำหนดค่าเริ่มต้นรวม
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    // เริ่มต้นปลั๊กอิน
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // ตรวจสอบ payload และนำทางไปยังหน้าที่เกี่ยวข้อง
        final String? payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          // ทำกับ payload ต่อไปนี้ (เช่น นำทางไปยังหน้าเฉพาะ)
        }
      },
    );
  }

  // แสดงการแจ้งเตือนทันที
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'flood_alerts_channel',
      'การแจ้งเตือนน้ำท่วม',
      channelDescription: 'ช่องทางสำหรับแจ้งเตือนเกี่ยวกับน้ำท่วมและภัยพิบัติ',
      importance: Importance.high,
      priority: Priority.high,
      sound: RawResourceAndroidNotificationSound('warning_siren'),
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 500, 500, 500]),
      icon: '@mipmap/ic_launcher',
    );

    final DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'warning_siren.aiff',
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // กำหนดการแจ้งเตือนในอนาคต
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'flood_scheduled_channel',
      'การแจ้งเตือนล่วงหน้า',
      channelDescription: 'ช่องทางสำหรับการแจ้งเตือนกำหนดการตรวจสอบและการเตรียมความพร้อม',
      importance: Importance.high,
      priority: Priority.high,
    );

    final DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDateTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  // แสดงการแจ้งเตือนฉุกเฉินสำคัญที่ต้องการความสนใจทันที
  Future<void> showEmergencyAlert({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'flood_emergency_channel',
      'การแจ้งเตือนฉุกเฉิน',
      channelDescription: 'ช่องทางสำหรับการแจ้งเตือนภัยพิบัติฉุกเฉินที่เร่งด่วน',
      importance: Importance.max,
      priority: Priority.max,
      fullScreenIntent: true, // เปิดหน้าจอเต็มแม้อุปกรณ์จะล็อก
      sound: RawResourceAndroidNotificationSound('emergency_alert'),
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      color: const Color(0xFFFF0000), // สีแดง
      colorized: true,
    );

    final DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: 'emergency_alert.aiff',
      interruptionLevel: InterruptionLevel.critical, // เปลี่ยนจาก criticalAlert เป็น critical
    );

    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  // ยกเลิกการแจ้งเตือนเฉพาะ
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // ยกเลิกการแจ้งเตือนทั้งหมด
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
