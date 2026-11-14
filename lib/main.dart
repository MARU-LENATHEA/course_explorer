import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'services/notification_service.dart';

// --- TAMBAHAN PRAKTIK 7: FIREBASE ---
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
// ------------------------------------

import 'constants/supabase_constants.dart';
import 'services/course_data_source.dart';
import 'services/course_supabase_service.dart';
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';
import 'screens/responsive_shell.dart';

// --- TAMBAHAN PRAKTIK 2 ---
import 'services/auth_service.dart';
import 'pages/login_page.dart';
import 'app_keys.dart';

// --------------------------

// Identitas Mahasiswa Praktikan
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // --- PRAKTIK 7: INISIALISASI FIREBASE ---
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // ----------------------------------------

  // --- PRAKTIK 8: MINTA IZIN NOTIFIKASI ---
  await NotificationService.instance.requestPermission();
  // ----------------------------------------

  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseAnonKey);

  // PRAKTIK 2: Logika Session (Otomatis ke login kalau logout)
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    if (data.event == AuthChangeEvent.signedOut) {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  });

  final CourseDataSource dataSource = CourseSupabaseService();
  final repository = CourseRepository(dataSource);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(repository)..loadCourses(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Data Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),

      // PRAKTIK 2: Tambahkan key global
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: messengerKey,

      // PRAKTIK 2: Cek apakah user sudah login atau belum
      home: AuthService.instance.isLoggedIn
          ? const ResponsiveShell()
          : const LoginPage(),
    );
  }
}
