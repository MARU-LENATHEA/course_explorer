import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../app_keys.dart'; // Memanggil global key untuk menampilkan SnackBar

// Handler untuk background message WAJIB berada di luar class (top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
    "🔔 Notifikasi masuk saat aplikasi di Background: ${message.messageId}",
  );
}

class NotificationService {
  static final NotificationService instance = NotificationService._();
  NotificationService._();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Fungsi utama untuk menjalankan semua proses notifikasi sekaligus
  Future<void> initialize() async {
    await requestPermission();
    await _getToken();

    // Daftarkan background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    _setupMessageHandlers();
  }

  Future<void> requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notifikasi: User MEMBERIKAN izin.');
    } else {
      print('Notifikasi: User MENOLAK izin.');
    }
  }

  Future<void> _getToken() async {
    try {
      // Mendapatkan FCM Token khusus untuk perangkat ini
      String? token = await _messaging.getToken();
      print('\n====================================');
      print('🔑 FCM TOKEN PERANGKAT INI:');
      print(token);
      print('====================================\n');

      // Token ini biasanya disimpan ke database (Supabase) agar backend tahu
      // ke mana harus menembak notifikasi. Untuk praktik ini, kita print saja untuk diuji.
    } catch (e) {
      print('Gagal mendapatkan FCM token: $e');
    }
  }

  void _setupMessageHandlers() {
    // 1. Saat aplikasi SEDANG DIBUKA di layar utama (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Menerima pesan di Foreground!');

      if (message.notification != null) {
        // Tampilkan pop-up SnackBar menggunakan messengerKey dari Praktik 2
        messengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(
              '🔔 ${message.notification!.title}\n${message.notification!.body}',
            ),
            backgroundColor: Colors.blue.shade800,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    });

    // 2. Saat aplikasi di Background dan notifikasinya di-klik oleh user
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(
        'Notifikasi di-klik, membuka aplikasi: ${message.notification?.title}',
      );
    });
  }
}
