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

  @override
  Future<Course> createCourse(Course course) async {
    final row = await supabase
        .from('courses')
        .insert(course.toJson())
        .select()
        .single();

    return Course.fromJson(row);
  }

  // Implementasi UPDATE ke Database Supabase (Tahap 14)
  @override
  Future<void> updateCourse(int id, Course course) async {
    await supabase.from('courses').update(course.toJson()).eq('id', id);
  }

  // Stub sementara untuk Tahap 15
  @override
  Future<void> deleteCourse(int id) => throw UnimplementedError();
}
