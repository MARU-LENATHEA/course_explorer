import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../app_keys.dart'; // Wajib ada untuk menampilkan SnackBar

// Handler untuk background message WAJIB berada di luar class (top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
    "🔔 Notifikasi masuk saat aplikasi di Background: ${message.messageId}",
  );
}

class NotificationService {
  // Singleton pattern agar service ini cuma dibuat 1 kali
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

  // PRAKTIK 8: Meminta Izin Notifikasi
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

  // PRAKTIK 9 & 10: Dapatkan Token dan Simpan ke Supabase
  Future<void> _getToken() async {
    try {
      // Mendapatkan FCM Token khusus untuk perangkat ini
      String? token = await _messaging.getToken();

      if (token != null) {
        print('\n====================================');
        print('🔑 FCM TOKEN PERANGKAT INI:');
        print(token);
        print('====================================\n');

        // Simpan token ke Supabase
        await _saveTokenToDatabase(token);
      }

      // Dengarkan jika suatu saat token diperbarui oleh Firebase (Refresh Token)
      _messaging.onTokenRefresh.listen((newToken) {
        print('🔄 Token FCM diperbarui secara otomatis!');
        _saveTokenToDatabase(newToken);
      });
    } catch (e) {
      print('Gagal mendapatkan FCM token: $e');
    }
  }

  // PRAKTIK 10: Fungsi untuk menyimpan token ke database Supabase
  Future<void> _saveTokenToDatabase(String token) async {
    // Ambil UID user yang sedang login
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      print('⏳ User belum login, token batal disimpan ke database.');
      return;
    }

    try {
      // Pastikan '.from' diisi dengan nama tabel yang benar!
      final response = await Supabase.instance.client
          .from('profiles') // <-- CEK INI
          .update({'fcm_token': token})
          .eq('id', user.id)
          .select(); // Tambahkan .select() untuk memaksa Supabase mengembalikan data

      if (response.isEmpty) {
        print(
          '❌ Gagal: UID ${user.id} tidak ditemukan di tabel, ATAU terblokir RLS!',
        );
      } else {
        print('✅ Mantap: Token beneran masuk ke database!');
      }
    } catch (e) {
      print('❌ Gagal menyimpan token ke database: $e');
    }
  }

  // PRAKTIK 9: Menangkap pesan notifikasi
  void _setupMessageHandlers() {
    // 1. Saat aplikasi SEDANG DIBUKA di layar utama (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Menerima pesan di Foreground!');

      if (message.notification != null) {
        // Tampilkan pop-up SnackBar menggunakan messengerKey
        messengerKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(
              '🔔 ${message.notification!.title ?? ''}\n${message.notification!.body ?? ''}',
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
