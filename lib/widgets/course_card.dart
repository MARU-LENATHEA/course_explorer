import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../screens/course_detail_screen.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final bool? isFavorite;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.course,
    this.isFavorite,
    this.onFavoriteToggle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, provider, child) {
        final isFav = isFavorite ?? provider.isFavorite(course.code);

        return Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.blue.shade100, width: 1.5),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap ??
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CourseDetailScreen(course: course),
                    ),
                  );
                },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          course.status,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: course.status.toLowerCase() == 'active'
                                ? Colors.teal.shade700
                                : Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey.shade400,
                    ),
                    onPressed: onFavoriteToggle ??
                        () {
                          provider.toggleFavorite(course.code);
                        },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
