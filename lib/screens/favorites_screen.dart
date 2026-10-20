import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, provider, child) {
        final favoriteCourses = provider.courses
            .where((course) => provider.isFavorite(course.code))
            .toList();

        if (favoriteCourses.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                SizedBox(height: 12),
                Text(
                  'Belum ada course favorit.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
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
    );
  }
}
