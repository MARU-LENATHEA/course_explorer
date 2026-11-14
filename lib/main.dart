import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Tambahan untuk background handler di main

import 'firebase_options.dart';
import 'app_keys.dart';
import 'constants/supabase_constants.dart';
import 'services/notification_service.dart';
import 'services/auth_service.dart';
import 'services/course_data_source.dart';
import 'services/course_supabase_service.dart';
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';
import 'screens/responsive_shell.dart';
import 'pages/login_page.dart';

// Identitas Mahasiswa Praktikan
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

// Handler background notifikasi WAJIB di luar class (top-level)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("🔔 [BACKGROUND] Notifikasi masuk: ${message.notification?.title}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. INISIALISASI FIREBASE & BACKGROUND HANDLER
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // 2. INISIALISASI SUPABASE
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseAnonKey);

  // 3. INISIALISASI NOTIFIKASI (Minta Izin & Simpan FCM Token)
  await NotificationService.instance.initialize();

  // 4. LOGIKA SESSION (Otomatis ke login kalau token expired/logout)
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    if (data.event == AuthChangeEvent.signedOut) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  });

  // 5. SETUP PROVIDER & REPOSITORY
  final CourseDataSource dataSource = CourseSupabaseService();
  final repository = CourseRepository(dataSource);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(repository)..loadCourses(),
      child: const KosFinderApp(),
    ),
  );
}

class KosFinderApp extends StatelessWidget {
  const KosFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KosFinder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo),

      // Global keys untuk navigasi dan notifikasi
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: messengerKey,

      // Cek Session -> Login / Home
      home: AuthService.instance.isLoggedIn
          ? const ResponsiveShell()
          : const LoginPage(),
    );
  }
}
