import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import 'course_detail_page.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();
    final favoriteCourses = provider.courses
        .where((c) => provider.isFavorite(c.code))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mata Kuliah Favorit'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: favoriteCourses.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text(
                    'Belum ada mata kuliah favorit.',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: favoriteCourses.length,
              itemBuilder: (context, index) {
                final Course course = favoriteCourses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.red.shade100,
                      child: const Icon(Icons.favorite, color: Colors.red),
                    ),
                    title: Text(
                      course.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${course.code} • ${course.credits} SKS'),
                    trailing: IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      tooltip: 'Hapus dari Favorit',
                      onPressed: () {
                        context.read<CourseProvider>().toggleFavorite(
                          course.code,
                        );
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CourseDetailPage(course: course),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
