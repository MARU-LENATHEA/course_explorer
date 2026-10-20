import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import 'course_detail_screen.dart';
import 'favorites_screen.dart';

// Identitas Mahasiswa Praktikan
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // Memuat data course secara otomatis saat halaman pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().loadCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer v2 - Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          // Tombol navigasi menuju ke halaman Favorites
          IconButton(
            icon: const Icon(Icons.bookmarks),
            tooltip: 'Lihat Favorites',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Identitas Mahasiswa
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '$studentId • $studentName',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Daftar Seluruh Mata Kuliah:',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Consumer<CourseProvider>(
                builder: (context, provider, child) {
                  // Kondisi Async State: Loading
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Kondisi Async State: Error
                  if (provider.error != null) {
                    return Center(
                      child: Text(
                        'Terjadi Kesalahan:\n${provider.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  // Kondisi Data Kosong
                  if (provider.courses.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada data course tersedia.'),
                    );
                  }

                  // Kondisi Success: Menampilkan List Course
                  return ListView.builder(
                    itemCount: provider.courses.length,
                    itemBuilder: (context, index) {
                      final Course course = provider.courses[index];
                      final isFav = provider.isFavorite(course.code);

                      return InkWell(
                        // Navigasi ke halaman detail saat kartu diklik
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CourseDetailScreen(course: course),
                            ),
                          );
                        },
                        child: CourseCard(
                          course: course,
                          isFavorite: isFav,
                          onFavoriteToggle: () {
                            provider.toggleFavorite(course.code);
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
