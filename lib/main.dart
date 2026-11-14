import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// --- TAMBAHAN PRAKTIK 7, 8, 9, 10: FIREBASE & NOTIFIKASI ---
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'services/notification_service.dart';
// -----------------------------------------------------------

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

  // 1. PRAKTIK 7: INISIALISASI FIREBASE (Wajib paling awal)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 2. INISIALISASI SUPABASE (Wajib sebelum Notification Service)
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseAnonKey);

  // 3. PRAKTIK 9 & 10: INISIALISASI NOTIFIKASI (Minta izin & simpan token)
  await NotificationService.instance.initialize();

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

      // PRAKTIK 2: Tambahkan key global untuk SnackBar Notifikasi
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: messengerKey,

      // PRAKTIK 2: Cek apakah user sudah login atau belum
      home: AuthService.instance.isLoggedIn
          ? const ResponsiveShell()
          : const LoginPage(),
    );
  }
}
