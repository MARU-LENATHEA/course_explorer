import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course.dart';

// Identitas Mahasiswa Praktikan
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

class CourseApiService {
  final String baseUrl;

  CourseApiService(this.baseUrl);

  // Method GET (Tahap 4)
  Future<List<Course>> getCourses() async {
    final response = await http.get(Uri.parse('$baseUrl/courses'));

    if (response.statusCode != 200) {
      throw Exception(
        'Gagal mengambil data course (Status: ${response.statusCode})',
      );
    }

    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => Course.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Method POST (Tahap 6)
  Future<Course> createCourse(Course course) async {
    final response = await http.post(
      Uri.parse('$baseUrl/courses'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Course.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }

    throw Exception('Gagal membuat course (Status: ${response.statusCode})');
  }

  // Method PUT (Tahap 7)
  Future<void> updateCourse(int id, Course course) async {
    final response = await http.put(
      Uri.parse('$baseUrl/courses/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(course.toJson()),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception(
        'Gagal memperbarui course (Status: ${response.statusCode})',
      );
    }
  }
}
