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

  static Future<void> scheduleNotificationNews() async {
    await initialize();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      8,
      0,
    ).add(Duration(days: 2));

    await _notifications.zonedSchedule(
      0,
      'Arrahmah Boarding School Bogor',
      'Assalamuaikum Ayah Bunda Kami Menyediakan Update Top Berita Setiap Harinya Secara Realtime Dan Yang Pasti nya AntiHoax 👍',
      scheduledDate,
      await _notificationDetails(
          'Assalamuaikum Ayah Bunda Kami Menyediakan Update Top Berita Setiap Harinya Secara Realtime Dan Yang Pasti nya AntiHoax 👍'),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: 'test payload',
    );
  }

  static Future<void> scheduleNotification() async {
    await initialize();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month < 12 ? now.month + 1 : 1,
      10,
      0,
    );

    await _notifications.zonedSchedule(
      0,
      'Arrahmah Boarding School Bogor',
      'Assalamualaikum Ayah Bunda, Kami Ingin Mengingatkan Jangan Lupa Untuk Melakukan Pembayaran Setiap Bulannya 😊 ',
      scheduledDate,
      await _notificationDetails(
          'Assalamualaikum Ayah Bunda, Kami Ingin Mengingatkan Jangan Lupa Untuk Melakukan Pembayaran Setiap Bulannya 😊'),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: 'test payload',
    );
  }
}
