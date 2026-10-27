import '../models/course.dart';

// Identitas Mahasiswa Praktikan
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

/// Kontrak abstrak sumber data course.
/// Setiap data source (REST API, Supabase, Mock, dsb.) wajib menerapkan kontrak ini.
abstract class CourseDataSource {
  Future<List<Course>> getCourses();
  Future<Course> createCourse(Course course);
  Future<void> updateCourse(int id, Course course);
  Future<void> deleteCourse(int id);
}
