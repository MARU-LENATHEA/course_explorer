import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../models/course.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<CourseProvider>(
        builder: (context, provider, child) {
          // Menyaring course yang kodenya ada di dalam set favorites
          final favoriteCourses = provider.courses
              .where((course) => provider.isFavorite(course.code))
              .toList();

          if (favoriteCourses.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada course favorit.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: favoriteCourses.length,
            itemBuilder: (context, index) {
              final Course course = favoriteCourses[index];
              return CourseCard(
                course: course,
                isFavorite: true,
                onFavoriteToggle: () {
                  provider.toggleFavorite(course.code);
                },
              );
            },
          );
        },
      ),
    );
  }
}
