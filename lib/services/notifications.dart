import 'package:cool_todo/views/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class Notifications {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeNotification() async {
    tz.initializeTimeZones();
    const initializationSettingsAndroid =
        AndroidInitializationSettings("app_icon");

    final initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    Get.dialog(const Text("Welcome to flutter"));
  }

  void onDidReceiveNotificationResponse(
      NotificationResponse notificationResponse) async {
    Get.to(() => const HomeScreen());
  }

  void requestIOSPermissions() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void displayImmediateNotification(
      {required String title, String body = ""}) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iOSPlatformChannelSpecifics = DarwinNotificationDetails();

    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'Default_Sound',
    );
  }

  void displayScheduledNotification(
      {required String title,
      required DateTime datetime,
      String body = "",
      int? id}) async {
    if (datetime.month <= DateTime.now().month &&
        datetime.day < DateTime.now().day) {
      return;
    } else {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id ?? 0,
        title,
        body,
        tz.TZDateTime.from(datetime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your channel id',
            'your channel name',
          ),
        ),
        androidAllowWhileIdle: true,
        payload: id.toString(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
  }

  void cancelNotificationWithID({required int id}) async =>
      await flutterLocalNotificationsPlugin.cancel(id);

  void cancelAllNotifications() async =>
      await flutterLocalNotificationsPlugin.cancelAll();
}
