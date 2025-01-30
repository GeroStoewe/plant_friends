import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    try {
    await _firebaseMessaging.requestPermission(
     // alert: true,
     // badge: true,
     // sound: true,
    );

    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
  } catch (e) {
      print('Error initializing Firebase Messaging: $e');
    }
  }
}

//TODO: fix issue with iphone. (No worries, Android works fine)
/// While initializing the app, there is a permission question asking for notifications.
/// If you click "allow" on Iphone, the app does not work anymore. If you "deny", the app works as expected.