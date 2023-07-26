import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  static Future<void> configureFirebaseMessaging() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received notification: ${message.notification?.title}");
      // Tambahkan logika untuk menampilkan notifikasi pada UI atau melakukan tindakan tertentu sesuai kebutuhan
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification clicked: ${message.notification?.title}");
      // Tambahkan logika untuk menangani tindakan pengguna saat mengklik notifikasi saat aplikasi terbuka
    });

    // Mendapatkan token FCM untuk penggunaan selanjutnya
    String? token = await _firebaseMessaging.getToken();
    print("FCM Token: $token");
  }
}
