import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import 'course_form_page.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // Ambil data versi terbaru dari provider berdasarkan kode
    final currentCourse = context.select<CourseProvider, Course>(
      (p) => p.courses.firstWhere(
        (c) => c.code == course.code,
        orElse: () => course,
      ),
    );
    final isFav = context.watch<CourseProvider>().isFavorite(
      currentCourse.code,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(currentCourse.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : null,
            ),
            onPressed: () {
              context.read<CourseProvider>().toggleFavorite(currentCourse.code);
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CourseFormPage(course: currentCourse),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        currentCourse.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text('ID Database: ${currentCourse.id ?? "-"}'),
                    ),
                    const Divider(),
                    _buildRow('Kode Mata Kuliah', currentCourse.code),
                    _buildRow('Bobot Kredit', '${currentCourse.credits} SKS'),
                    _buildRow('Status', currentCourse.status.toUpperCase()),
                    _buildRow('Tersimpan di Favorit', isFav ? 'Ya' : 'Tidak'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 14)),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
