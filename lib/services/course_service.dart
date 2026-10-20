import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/course.dart';

// Identitas Mahasiswa Praktikan
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

class CourseService {
  // Method untuk memuat data course dari file JSON asset
  Future<List<Course>> loadCourses() async {
    // Membaca file string dari assets
    final jsonString = await rootBundle.loadString(
      'assets/data/student_data.json',
    );

    // Mendecode JSON string menjadi Map
    final data = jsonDecode(jsonString) as Map<String, dynamic>;

    // Mengambil list dinamis dari key 'courses'
    final list = data['courses'] as List<dynamic>;

    // Memetakan setiap item ke object model Course
    return list.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }
}
