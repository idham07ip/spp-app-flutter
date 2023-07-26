// ignore_for_file: deprecated_member_use, unused_import

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationLocal {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    final androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    final initializationSettings =
        InitializationSettings(android: androidInit, iOS: null);
    await _notifications.initialize(initializationSettings);
    tz.initializeTimeZones();
  }

  static Future<NotificationDetails> _notificationDetails(String body) async {
    final androidDetails = AndroidNotificationDetails(
      'channel id',
      'channel name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
      enableLights: true,
//      color: const Color.fromARGB(255, 255, 255, 255), // Putih
      styleInformation: BigTextStyleInformation(
        body,
        htmlFormatBigText: true,
        htmlFormatContentTitle: true,
      ),
    );

    return NotificationDetails(android: androidDetails);
  }

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await initialize();
    await _notifications.show(
      id,
      title,
      body,
      await _notificationDetails(body),
      payload: payload,
    );
  }

  static Future<void> selectNotification(
      void Function(int id, String? payload) callback) async {
    await _notifications.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('app_icon'),
      ),
    );
  }

  Future<void> scheduleRepeatingNotifications() async {
    final FlutterLocalNotificationsPlugin notifications =
        FlutterLocalNotificationsPlugin();

    await notifications.zonedSchedule(
      0,
      'Arrahmah Boarding School Bogor',
      'Periksa grafik performa kamu di bagian profil untuk melihat perkembangan terbaru.',
      _nextNotificationTime(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weekly_channel',
          'Weekly Channel'
              'Channel for weekly notifications',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: 'weekly_notification',
    );
  }

  tz.TZDateTime _nextNotificationTime() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      8,
      0,
    );

    while (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 7));
    }

    return scheduledDate;
  }

  Future<void> notificationAlert() async {
    final FlutterLocalNotificationsPlugin notifications =
        FlutterLocalNotificationsPlugin();

    await notifications.zonedSchedule(
      0,
      'Arrahmah Boarding School Bogor',
      'Kami mengingatkan kamu untuk selalu membayar SPP tepat waktu. Terima kasih atas perhatiannya. 😊 ',
      _nextNotificationMonth(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weekly_channel',
          'Weekly Channel'
              'Channel for weekly notifications',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: 'weekly_notification',
    );
  }

  tz.TZDateTime _nextNotificationMonth() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      8,
      0,
    );

    while (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 20));
    }

    return scheduledDate;
  }
}
