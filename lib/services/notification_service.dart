import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  // Singleton pattern agar service ini cuma dibuat 1 kali
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Fungsi untuk meminta izin notifikasi ke user
  Future<void> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notifikasi: User MEMBERIKAN izin.');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('Notifikasi: User memberikan izin SEMENTARA.');
    } else {
      print('Notifikasi: User MENOLAK izin.');
    }
  }
}
