import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../model/task.dart';
import '../to-do/notified_page.dart';

class NotifyHelper {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initializeNotification() async {
    await _configureLocalTimezone();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('appicon');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        selectNotification(notificationResponse.payload);
      },
    );
  }

  Future<void> scheduleNotificationAtDateTime(
      DateTime scheduledDateTime, Task task) async {
    String payload = "${task.title}|${task.note}|";
    print(
        "Scheduled Notification Payload (Date Time): $payload, Time: $scheduledDateTime");

    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!.toInt(),
      task.title,
      task.note,
      tz.TZDateTime.from(scheduledDateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_manager_channel',
          'Task Manager Notifications',
          priority: Priority.high,
          importance: Importance.max,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  Future<void> scheduledNotification(int hour, int minutes, Task task) async {
    String payload = "${task.title}|${task.note}|";
    print(
        "Scheduled Notification Payload (Time): $payload, Time: $hour:$minutes");

    await flutterLocalNotificationsPlugin.zonedSchedule(
      task.id!.toInt(),
      task.title,
      task.note,
      _convertTime(hour, minutes),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_manager_channel',
          'Task Manager Notifications',
          priority: Priority.high,
          importance: Importance.max,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  tz.TZDateTime _convertTime(int hour, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minutes);
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(const Duration(days: 1));
    }
    return scheduleDate;
  }

  Future<void> _configureLocalTimezone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Lagos'));
  }

  Future<void> displayNotification(
      {required String title, required String body}) async {
    print("Displaying notification: $title, $body");
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'task_manager_channel',
      'Task Manager Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
    DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: title,
    );
  }

  void requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> selectNotification(String? payload) async {
    if (payload != null) {
      print('notification payload: $payload');
    }
    if (payload == "Theme Changed") {
      print("Navigating nowhere for theme change");
    } else if (payload != null && payload.contains("|")) {
      List<String> payloadParts = payload.split("|");
      String? title = payloadParts.isNotEmpty ? payloadParts[0] : null;
      String? body = payloadParts.length > 1 ? payloadParts[1] : null;
      Get.to(
            () => NotifiedPage(
          label: title ?? 'Task Notification',
          body: body,
        ),
        arguments: {'title': title, 'body': body},
      );
    } else {
      Get.to(
            () => const NotifiedPage(label: "Default Label"),
      );
    }
  }
}
