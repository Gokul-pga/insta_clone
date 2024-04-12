import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    try {
      await _firebaseMessaging.requestPermission();
      final fCMToken = await _firebaseMessaging.getToken();
      print("Token: $fCMToken");

      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );

      print('User granted permission: ${settings.authorizationStatus}');
      //
      // _firebaseMessaging.onMessage.listen((RemoteMessage message) {
      //   print('Foreground message received: ${message.notification?.title}');
      //   // Handle the foreground message here
      //   _handleMessage(message);
      // });
      //
      // _firebaseMessaging
      //     .onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      //
      // Add this block if you want to handle notifications when the app is terminated
      // _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      //   if (message != null) {
      //     print('Terminated message received: ${message.notification?.title}');
      //     // Handle the terminated message here
      //     _handleMessage(message);
      //   }
      // });
    } catch (e) {
      print('Error initializing notifications: $e');
    }
  }

  // Callback to handle background messages
  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    print('Background message received: ${message.notification?.title}');
    // Handle the background message here
    _handleMessage(message);
  }

  // Custom method to handle the received message
  void _handleMessage(RemoteMessage message) {
    // Extract and handle the payload based on your requirements
    final notificationTitle = message.notification?.title;
    final notificationBody = message.notification?.body;

    // Your custom logic to display a notification or update the UI
  }
}
