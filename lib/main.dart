import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/course_service.dart';
import 'repositories/course_repository.dart';
import 'course_provider.dart' hide studentName, studentId;
import 'models/course.dart';

// Identitas Mahasiswa Praktikan
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<CourseService>(create: (_) => CourseService()),
        ProxyProvider<CourseService, CourseRepository>(
          update: (_, service, __) => CourseRepository(service),
        ),
        ChangeNotifierProxyProvider<CourseRepository, CourseProvider>(
          create: (context) => CourseProvider(context.read<CourseRepository>()),
          update: (_, repository, provider) =>
              provider ?? CourseProvider(repository),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 11 - Async State',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const AsyncStatePage(),
    );
  }
}

class AsyncStatePage extends StatefulWidget {
  const AsyncStatePage({super.key});

  @override
  State<AsyncStatePage> createState() => _AsyncStatePageState();
}

class _AsyncStatePageState extends State<AsyncStatePage> {
  @override
  void initState() {
    super.initState();
    // Memuat data course secara otomatis saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().loadCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 11: Async State Provider'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Identitas Praktikan
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
              'Manajemen Async State (Loading, Success, Error):',
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Consumer<CourseProvider>(
                builder: (context, provider, child) {
                  // 1. Kondisi Loading
                  if (provider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // 2. Kondisi Error
                  if (provider.error != null) {
                    return Center(
                      child: Text(
                        'Terjadi Kesalahan:\n${provider.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  // 3. Kondisi Data Kosong
                  if (provider.courses.isEmpty) {
                    return const Center(child: Text('Tidak ada data course.'));
                  }

                  // 4. Kondisi Success (Menampilkan List Course)
                  return ListView.builder(
                    itemCount: provider.courses.length,
                    itemBuilder: (context, index) {
                      final Course course = provider.courses[index];
                      final isFav = provider.isFavorite(course.code);

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
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
