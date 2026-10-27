import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/course.dart';
import 'services/course_api_service.dart';
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';
import 'widgets/error_view.dart';
import 'screens/course_form_page.dart';

// Identitas Mahasiswa Praktikan
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

void main() {
  const String apiBaseUrl = 'https://course-api-pearl.vercel.app';
  final apiService = CourseApiService(apiBaseUrl);
  final repository = CourseRepository(apiService);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(repository)..loadCourses(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 8 - HTTP DELETE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const CourseListPage(),
    );
  }
}

class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key});

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green.shade100;
      case 'done':
        return Colors.blue.shade100;
      case 'planned':
      default:
        return Colors.orange.shade100;
    }
  }

  // Fungsi memunculkan konfirmasi dialog sebelum menghapus data
  Future<void> _confirmDelete(BuildContext context, Course course) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Course'),
        content: Text(
          'Apakah Anda yakin ingin menghapus course "${course.title}" (${course.code})?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    if (!context.mounted) return;

    try {
      await context.read<CourseProvider>().deleteCourse(course);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Course "${course.title}" berhasil dihapus!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus course: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 8: HTTP DELETE Course'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => context.read<CourseProvider>().loadCourses(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CourseFormPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Tambah Course'),
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
            Expanded(
              child: Builder(
                builder: (_) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.error != null) {
                    return ErrorView(
                      message: provider.error!,
                      onRetry: () =>
                          context.read<CourseProvider>().loadCourses(),
                    );
                  }

                  if (provider.courses.isEmpty) {
                    return const Center(
                      child: Text('Data course belum tersedia'),
                    );
                  }

                  return ListView.builder(
                    itemCount: provider.courses.length,
                    itemBuilder: (context, index) {
                      final Course course = provider.courses[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Text('${course.credits}'),
                          ),
                          title: Text(
                            course.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Kode: ${course.code} • ${course.credits} SKS',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(course.status),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  course.status,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              // Tombol Edit
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.blue,
                                ),
                                tooltip: 'Edit',
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CourseFormPage(course: course),
                                    ),
                                  );
                                },
                              ),
                              // Tombol Delete
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                tooltip: 'Hapus',
                                onPressed: () =>
                                    _confirmDelete(context, course),
                              ),
                            ],
                          ),
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
