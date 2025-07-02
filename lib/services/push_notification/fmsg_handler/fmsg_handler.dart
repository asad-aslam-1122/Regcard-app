import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../../../utils/widgets/no_internet_screen.dart';

final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

FirebaseMessaging messaging = FirebaseMessaging.instance;

class Application extends StatefulWidget {
  final Widget page;
  const Application({super.key, required this.page});
  @override
  State<StatefulWidget> createState() => _Application();
}

class _Application extends State<Application> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    switch (result.first) {
      case ConnectivityResult.wifi:
        {
          log(result.toString());
        }
        break;
      case ConnectivityResult.mobile:
        {
          log(result.toString());
        }
        break;
      case ConnectivityResult.none:
        {
          Get.to(() => const NoInternetScreen());
        }
        break;
      default:
        log('Failed to get connectivity.');
        break;
    }
    log(result.toString());
  }

  Future<void> startConnectionStream() async {
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    log("stream running");
  }

  Future<void> requestPermissions() async {
    await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    await messaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    await initLocalNotification();
  }

  Future<void> initLocalNotification() async {
    AndroidInitializationSettings android =
        const AndroidInitializationSettings('@mipmap/launcher_icon');

    DarwinInitializationSettings ios = const DarwinInitializationSettings();

    InitializationSettings initSettings =
        InitializationSettings(android: android, iOS: ios);

    await _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {},
      onDidReceiveBackgroundNotificationResponse: (details) {},
    );
  }

  Future<void> showNotification(RemoteMessage? message) async {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.high,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
      // sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    RemoteNotification? notification =
        message?.notification ?? const RemoteNotification();

    if (!Platform.isIOS) {
      await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title ?? "",
        notification.body ?? "",
        notificationDetails,
      );
    }
  }

  Future<void> initFirebaseMessage() async {
    // when receive new notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await showNotification(message);
    });

    await messaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    // when app in foreground
    FirebaseMessaging.onMessageOpenedApp
        .listen((RemoteMessage message) async {});

    startConnectionStream();
  }

  Future<void> onInit() async {
    await requestPermissions();
    await initFirebaseMessage();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      onInit();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.page;
  }
}
