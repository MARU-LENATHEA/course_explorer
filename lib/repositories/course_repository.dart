import '../models/course.dart';
import '../services/course_service.dart';

// Identitas Mahasiswa Praktikan
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

class CourseRepository {
  final CourseService service;

  // Menerima CourseService melalui constructor (Dependency Injection sederhana)
  CourseRepository(this.service);

  // Method abstraksi untuk menyediakan data course
  Future<List<Course>> getCourses() {
    return service.loadCourses();
  }
}
