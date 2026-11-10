import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'constants/supabase_constants.dart';
import 'services/course_data_source.dart';
import 'services/course_supabase_service.dart';
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';

// --- TAMBAHAN WORKSHEET 9: PRAKTIK 1 ---
import 'pages/login_page.dart';

// ---------------------------------------

// Identitas Mahasiswa Praktikan
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Supabase SDK (menggunakan variabel dari file constants bawaanmu)
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseAnonKey);

  // Sumber Data Aktif: Database PostgreSQL Supabase
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

      // --- UBAHAN WORKSHEET 9: PRAKTIK 1 ---
      // Arahkan halaman pertama kali dibuka ke LoginPage
      home: const LoginPage(),
      // ---------------------------------------
    );
  }
}
