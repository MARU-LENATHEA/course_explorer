import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/course.dart';
import 'course_data_source.dart';

// Identitas Mahasiswa Praktikan
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

class CourseSupabaseService implements CourseDataSource {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Course>> getCourses() async {
    final data = await supabase.from('courses').select().order('id');

    return (data as List)
        .map((e) => Course.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // Implementasi INSERT ke Database Supabase (Tahap 13)
  @override
  Future<Course> createCourse(Course course) async {
    final row = await supabase
        .from('courses')
        .insert(course.toJson())
        .select()
        .single();

    return Course.fromJson(row);
  }

  // Stub sementara untuk tahap berikutnya
  @override
  Future<void> updateCourse(int id, Course course) =>
      throw UnimplementedError();

  @override
  Future<void> deleteCourse(int id) => throw UnimplementedError();
}
