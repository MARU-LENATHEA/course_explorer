import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/course.dart';
import 'services/course_api_service.dart';
import 'repositories/course_repository.dart';
import 'providers/course_provider.dart';

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
      title: 'Tahap 4 - Service Layer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const ServiceLayerTestPage(),
    );
  }
}

class ServiceLayerTestPage extends StatelessWidget {
  const ServiceLayerTestPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 4: HTTP di Service Layer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => context.read<CourseProvider>().loadCourses(),
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
                  const Expanded(
                    child: Text(
                      '$studentId • $studentName',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Arsitektur: UI -> Provider -> Repository -> CourseApiService',
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Builder(
                builder: (_) {
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (provider.error != null) {
                    return Center(
                      child: Text(
                        'Error: ${provider.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (provider.courses.isEmpty) {
                    return const Center(child: Text('Data course kosong'));
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
                          trailing: Container(
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
