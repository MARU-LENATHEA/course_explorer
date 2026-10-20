import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../screens/course_detail_page.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;

  const CourseCard({
    super.key,
    required this.course,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CourseProvider>(
      builder: (context, provider, child) {
        final isFav = provider.isFavorite(course.code);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            onTap: onTap ??
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CourseDetailPage(course: course),
                    ),
                  );
                },
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text('${course.credits}'),
            ),
            title: Text(
              course.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${course.code} • ${course.credits} SKS • Status: ${course.status}',
            ),
            trailing: IconButton(
              icon: Icon(
                isFav ? Icons.favorite : Icons.favorite_border,
                color: isFav ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                provider.toggleFavorite(course.code);
              },
            ),
          ),
        );
      },
    );
  }
}
