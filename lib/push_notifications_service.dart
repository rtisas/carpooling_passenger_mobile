import 'package:carpooling_passenger/presentation/pages/routes/controller/booking/booking.controller.dart';
import 'package:carpooling_passenger/presentation/pages/routes/controller/booking_detail/booking_detail.controller.dart';
import 'package:carpooling_passenger/presentation/pages/virtual_wallet/controller/virtual_wallet.controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';

class PushNotificationsService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String? token;
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static late AndroidNotificationChannel channel;
  static bool isFlutterLocalNotificationsInitialized = false;

  static Future initializeApp() async {
    //Push notifications

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //grabar en el local storage
    token = await FirebaseMessaging.instance.getToken();
    setupFlutterNotifications();

    //handlers

    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessageHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenApp);

    //Local Notifications
  }

  static Future _onBackgroundHandler(RemoteMessage message) async {
    print('LOG backgroundHandeler ${message.messageId} , ${message}');
    try {
      final ctrlVirtualWallet = Get.find<VirtualWalletController>();
      final ctrlBooking = Get.find<BookingController>();
      // final ctrlDetailBooking = Get.find<BookingDetailController>();
      await ctrlVirtualWallet.getVirtualWalletByPassenger();
      await ctrlVirtualWallet.getHisotoryRecharge();
      await ctrlBooking.loadBookingsActiveByPassenger();
      // ctrlDetailBooking.onInit();
    } catch (e) {
      print('LOG _onBackgroundHandler catch ${message.messageId}, ${message}');
    }

    showFlutterNotification(message);
  }

  static Future _onMessageHandler(RemoteMessage message) async {
    print('LOG onMessageHandler ${message.messageId}, ${message}');
    try {
      final ctrlVirtualWallet = Get.find<VirtualWalletController>();
      final ctrlBooking = Get.find<BookingController>();
      // final ctrlDetailBooking = Get.find<BookingDetailController>();
      await ctrlVirtualWallet.getVirtualWalletByPassenger();
      await ctrlVirtualWallet.getHisotoryRecharge();
      await ctrlBooking.loadBookingsActiveByPassenger();
      // ctrlDetailBooking.onInit();
    } catch (e) {
      print('LOG onMessageHandler catch ${message.messageId}, ${message}');
    }

    showFlutterNotification(message);
  }

  static Future _onMessageOpenApp(RemoteMessage message) async {
    print('LOG onMessageOpenApp ${message.messageId}, ${message}');
    try {
      final ctrlVirtualWallet = Get.find<VirtualWalletController>();
      final ctrlBooking = Get.find<BookingController>();
      // final ctrlDetailBooking = Get.find<BookingDetailController>();
      await ctrlVirtualWallet.getVirtualWalletByPassenger();
      await ctrlVirtualWallet.getHisotoryRecharge();
      await ctrlBooking.loadBookingsActiveByPassenger();
      // ctrlDetailBooking.onInit();
    } catch (e) {
      print('LOG onMessageOpenApp catch ${message.messageId}, ${message}');
    }

    showFlutterNotification(message);
  }

  static Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    //logo de la notificación
    var initializationSettingsAndroid = AndroidInitializationSettings('logo');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  static void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
          ),
        ),
      );
    }
  }

  static Future<void> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
  }
}
