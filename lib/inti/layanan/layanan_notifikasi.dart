import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );
    
    _isInitialized = true;
  }

  Future<void> requestPermissions() async {
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
  }

  Future<void> scheduleReminderNotification() async {
    await init(); // Pastikan selalu terinisialisasi sebelum menjadwalkan notifikasi
    
    final prefs = await SharedPreferences.getInstance();
    final bool notifAktif = prefs.getBool('pengaturan_notifikasi') ?? true;
    
    if (!notifAktif) return; // Jika dimatikan dari pengaturan

    // Batalkan notifikasi sebelumnya jika ada
    await cancelAllNotifications();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'daily_reminder_channel',
      'Daily Reminder',
      channelDescription: 'Notifikasi pengingat untuk membuka aplikasi dan belajar',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(
        'Sudah 24 jam nih kamu nggak main Quiz. Jangan biarkan otakmu bersantai terlalu lama, ayo pecahkan rekor hari ini! 🏆',
        htmlFormatBigText: true,
        contentTitle: 'Halo, Sobat Jenius! 🌟',
        htmlFormatContentTitle: true,
      ),
    );
    
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    // Notifikasi dijadwalkan muncul 24 jam setelah aplikasi ditutup
    final jadwalNotif = tz.TZDateTime.now(tz.local).add(const Duration(hours: 24));

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: 0, // ID notifikasi
      title: 'Halo, Sobat Jenius! 🌟',
      body: 'Sudah 24 jam nih kamu nggak main Quiz. Jangan biarkan otakmu bersantai terlalu lama, ayo pecahkan rekor hari ini! 🏆',
      scheduledDate: jadwalNotif,
      notificationDetails: platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
