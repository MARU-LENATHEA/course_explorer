import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseDetailScreen extends StatelessWidget {
  final Course course;

  const CourseDetailScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
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
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
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
            Text(
              'Jumlah SKS: ${course.credits}',
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              'Status: ${course.status}',
              style: const TextStyle(fontSize: 16),
            ),
            const Spacer(),

            // Tombol Toggle Favorite yang tersinkronisasi lintas screen
            Consumer<CourseProvider>(
              builder: (context, provider, child) {
                final isFav = provider.isFavorite(course.code);
                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isFav ? Colors.red.shade50 : Colors.blue.shade50,
                    foregroundColor: isFav ? Colors.red : Colors.blue,
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  onPressed: () {
                    provider.toggleFavorite(course.code);
                  },
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                  label: Text(
                    isFav ? 'Hapus dari Favorites' : 'Tambah ke Favorites',
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
