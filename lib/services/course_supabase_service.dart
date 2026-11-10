import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

// Identitas Mahasiswa Praktikan
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  // Mengambil UID user yang sedang login
  String get _uid => supabase.auth.currentUser!.id;

  @override
  Future<List<Course>> getCourses() async {
    final data = await supabase.from('courses').select().order('id');
    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Course> createCourse(Course course) async {
    // Sisipkan owner_id otomatis saat membuat course baru
    final courseData = course.toJson();
    courseData['owner_id'] = _uid;

    final row = await supabase
        .from('courses')
        .insert(courseData)
        .select()
        .single();

    return Course.fromJson(row);
  }

  @override
  Future<void> updateCourse(int id, Course course) async {
    // Tambahkan .select() di akhir untuk mengecek apakah RLS mengizinkan operasi
    final rows = await supabase
        .from('courses')
        .update(course.toJson())
        .eq('id', id)
        .select();

    // Jika ditolak RLS (karena bukan pemilik), rows akan kosong
    if (rows.isEmpty) {
      throw Exception('Akses ditolak (RLS): Anda bukan pemilik course ini.');
    }
  }

  @override
  Future<void> deleteCourse(int id) async {
    // Sama seperti update, kita validasi penolakan RLS lewat balikan select()
    final rows = await supabase.from('courses').delete().eq('id', id).select();

    if (rows.isEmpty) {
      throw Exception('Akses ditolak (RLS): Anda bukan pemilik course ini.');
    }
  }
}
