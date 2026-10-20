import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

// Identitas Mahasiswa
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Identitas Mahasiswa
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: const Text(
                '2415051046 • I Kadek Dimas Pradana',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              course.title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Kode Mata Kuliah: ${course.code}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Jumlah SKS: ${course.credits}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              'Status: ${course.status}',
              style: const TextStyle(fontSize: 16),
            ),
            if (course.description != null &&
                course.description!.isNotEmpty) ...[
              const Divider(height: 28),
              const Text(
                'Deskripsi:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              Text(
                course.description!,
                style: const TextStyle(fontSize: 14, height: 1.5),
              ),
            ],
            const SizedBox(height: 32),

            // Tombol Toggle Favorite yang tersinkronisasi lintas screen
            Consumer<CourseProvider>(
              builder: (context, provider, child) {
                final isFav = provider.isFavorite(course.code);
                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isFav ? Colors.red.shade50 : Colors.blue.shade50,
                    foregroundColor: isFav ? Colors.red : Colors.blue.shade800,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color:
                            isFav ? Colors.red.shade200 : Colors.blue.shade200,
                      ),
                    ),
                  ),
                  onPressed: () {
                    provider.toggleFavorite(course.code);
                  },
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                  label: Text(
                    isFav ? 'Hapus dari Favorites' : 'Tambah ke Favorites',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
