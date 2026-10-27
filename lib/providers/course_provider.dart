import 'package:flutter/foundation.dart';

import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;

  CourseProvider(this.repository);

  List<Course> courses = [];
  Set<String> favorites = {};
  bool isLoading = false;
  String? error;

  Future<void> loadCourses() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      courses = await repository.getCourses();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCourse(Course course) async {
    await repository.createCourse(course);
    await loadCourses();
  }

  Future<void> updateCourse(int id, Course course) async {
    await repository.updateCourse(id, course);
    await loadCourses();
  }

  // Menghapus course dari API & membersihkan data favorit yatim
  Future<void> deleteCourse(Course course) async {
    if (course.id == null) {
      throw Exception('ID course tidak valid untuk operasi delete');
    }

    await repository.deleteCourse(course.id!);

    // Hapus dari Set favorites jika tersimpan agar tidak menjadi data yatim
    if (favorites.contains(course.code)) {
      favorites.remove(course.code);
    }

    await loadCourses();
  }

  bool isFavorite(String code) => favorites.contains(code);

  void toggleFavorite(String code) {
    if (favorites.contains(code)) {
      favorites.remove(code);
    } else {
      favorites.add(code);
    }
    notifyListeners();
  }
}
