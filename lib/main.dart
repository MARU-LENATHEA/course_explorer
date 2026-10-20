import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'course_provider.dart';

void main() {
  runApp(
    // Membungkus aplikasi dengan ChangeNotifierProvider pada root widget tree
    ChangeNotifierProvider(
      create: (_) => CourseProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 6 - Provider Setup',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const ProviderSetupDemoPage(),
    );
  }
}

class ProviderSetupDemoPage extends StatelessWidget {
  const ProviderSetupDemoPage({super.key});

  final List<Map<String, String>> _courses = const [
    {'code': 'MOB04', 'title': 'Responsive Layout', 'status': 'done'},
    {'code': 'MOB05', 'title': 'Multi-Screen Navigation', 'status': 'done'},
    {
      'code': 'MOB06',
      'title': 'State Management & Architecture',
      'status': 'active',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Mengakses CourseProvider yang sudah disediakan di atas widget tree
    final courseProvider = Provider.of<CourseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 6: Provider Setup'),
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
                      'Praktikan: $studentName ($studentId)',
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

            // Kartu Status Provider
            Card(
              color: Colors.green.shade50,
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text(
                  'ChangeNotifierProvider Aktif',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Jumlah Course Favorit: ${courseProvider.favorites.length}',
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Daftar Course (Diakses dari Provider):',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  final course = _courses[index];
                  final code = course['code']!;
                  final isFav = courseProvider.isFavorite(code);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade100,
                        child: Text('${index + 1}'),
                      ),
                      title: Text(
                        course['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('$code • ${course['status']}'),
                      trailing: IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: isFav ? Colors.red : Colors.grey,
                        ),
                        onPressed: () {
                          courseProvider.toggleFavorite(code);
                        },
                      ),
                    ),
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
