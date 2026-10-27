import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/course.dart';

// Identitas Mahasiswa Praktikan
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

class CourseApiService {
  final String baseUrl;

  CourseApiService(this.baseUrl);

  // Mengambil daftar course dari REST API
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
}
