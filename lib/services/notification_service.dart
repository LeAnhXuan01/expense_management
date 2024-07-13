import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';

import '../model/enum.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  NotificationService() {
    _init();
  }

  void _init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('notification_icon');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    tz.initializeTimeZones();

    // Initialize plugin and print the result
    bool? initialized = await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    if (initialized == null || initialized == false) {
      print('Failed to initialize notifications plugin');
    } else {
      print('Notification plugin initialized successfully');
    }

    // Check and request notification permission
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    } else {
      print('Notification permission granted');
    }

    // Check and request SCHEDULE_EXACT_ALARM permission
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    } else {
      print('Schedule exact alarm permission granted');
    }
  }

  Future<void> scheduleNotification(
      int id, String title, String body, DateTime date, TimeOfDay time, Repeat repeat) async {
    tz.TZDateTime scheduledDate = _nextInstanceOfTime(date, time, repeat);
    print('Scheduling notification at: $scheduledDate');

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'notification_channel',
          'Notifications',
          channelDescription: 'Notifications for bills',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: _getDateTimeComponents(repeat), // Match both date and time
    );

    // Nếu là lặp lại hàng quý, lên lịch lại sau mỗi 3 tháng
    if (repeat == Repeat.Quarterly) {
      _scheduleQuarterlyNotification(id, title, body, scheduledDate, time);
    }

    print('Notification scheduled successfully');
  }

  tz.TZDateTime _nextInstanceOfTime(DateTime date, TimeOfDay time, Repeat repeat) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, date.year, date.month, date.day, time.hour, time.minute);

    if (scheduledDate.isBefore(now)) {
      switch (repeat) {
        case Repeat.Daily:
          scheduledDate = scheduledDate.add(const Duration(days: 1));
          break;
        case Repeat.Weekly:
          scheduledDate = scheduledDate.add(const Duration(days: 7));
          break;
        case Repeat.Monthly:
          scheduledDate = tz.TZDateTime(tz.local, scheduledDate.year, scheduledDate.month + 1, date.day, time.hour, time.minute);
          break;
        case Repeat.Quarterly:
          scheduledDate = _nextQuarterlyDate(scheduledDate, date.day, time);
          break;
        case Repeat.Yearly:
          scheduledDate = tz.TZDateTime(tz.local, scheduledDate.year + 1, date.month, date.day, time.hour, time.minute);
          break;
      }
    }

    return scheduledDate;
  }

  tz.TZDateTime _nextQuarterlyDate(tz.TZDateTime scheduledDate, int day, TimeOfDay time) {
    int month = scheduledDate.month + 3;
    int year = scheduledDate.year;
    if (month > 12) {
      month -= 12;
      year += 1;
    }

    int maxDayOfMonth = DateTime(year, month + 1, 0).day;
    int adjustedDay = day <= maxDayOfMonth ? day : maxDayOfMonth;

    return tz.TZDateTime(tz.local, year, month, adjustedDay, time.hour, time.minute);
  }

  DateTimeComponents _getDateTimeComponents(Repeat repeat) {
    switch (repeat) {
      case Repeat.Daily:
        return DateTimeComponents.time;
      case Repeat.Weekly:
        return DateTimeComponents.dayOfWeekAndTime;
      case Repeat.Monthly:
        return DateTimeComponents.dayOfMonthAndTime;
      case Repeat.Quarterly:
      // Không có trực tiếp cho hàng quý, cần tính toán riêng
        return DateTimeComponents.dateAndTime;
      case Repeat.Yearly:
        return DateTimeComponents.dateAndTime;
      default:
        return DateTimeComponents.dateAndTime;
    }
  }

  void _scheduleQuarterlyNotification(int id, String title, String body, tz.TZDateTime scheduledDate, TimeOfDay time) {
    Timer(
      scheduledDate.difference(tz.TZDateTime.now(tz.local)),
          () async {
        DateTime nextQuarterlyDate = DateTime(
          scheduledDate.year,
          scheduledDate.month + 3,
          scheduledDate.day,
          time.hour,
          time.minute,
        );

        await scheduleNotification(id, title, body, nextQuarterlyDate, time, Repeat.Quarterly);
      },
    );
  }

  // Convert string to int for notification ID
  int _convertStringToInt(String str) {
    return str.hashCode;
  }

  // Cancel specific notification
  Future<void> cancelNotification(String id) async {
    try {
      int notificationId = _convertStringToInt(id);
      await flutterLocalNotificationsPlugin.cancel(notificationId);
      print('Notification with id $id canceled');
    } catch (e) {
      print('Error canceling notification: $e');
    }
  }
}
