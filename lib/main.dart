import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'course_provider.dart';

// Identitas Mahasiswa Praktikan
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

void main() {
  runApp(
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
      title: 'Tahap 7 - watch, read, dan Consumer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const WatchReadDemoPage(),
    );
  }
}

class WatchReadDemoPage extends StatelessWidget {
  const WatchReadDemoPage({super.key});

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 7: watch, read & Consumer'),
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

            // 1. WIDGET DENGAN context.watch(): Hanya widget kecil ini yang rebuild
            const FavoriteCountHeader(),
            const SizedBox(height: 16),

            Text(
              'Daftar Course (Menggunakan Consumer & context.read):',
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Expanded(
              child: ListView.builder(
                itemCount: _courses.length,
                itemBuilder: (context, index) {
                  final course = _courses[index];
                  final code = course['code']!;

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
                      // 2. MENGGUNAKAN CONSUMER: Membatasi area rebuild hanya pada IconButton
                      trailing: Consumer<CourseProvider>(
                        builder: (context, provider, child) {
                          final isFav = provider.isFavorite(code);
                          return IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: isFav ? Colors.red : Colors.grey,
                            ),
                            // 3. MENGGUNAKAN context.read(): Memanggil aksi tanpa listen di callback
                            onPressed: () {
                              context.read<CourseProvider>().toggleFavorite(
                                code,
                              );
                            },
                          );
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

// Widget khusus yang menggunakan context.watch() untuk menampilkan jumlah favorit
class FavoriteCountHeader extends StatelessWidget {
  const FavoriteCountHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // context.watch() mendengarkan perubahan dan memicu rebuild pada widget ini
    final provider = context.watch<CourseProvider>();

    return Card(
      color: Colors.red.shade50,
      child: ListTile(
        leading: const Icon(Icons.favorite, color: Colors.red),
        title: const Text(
          'Total Course Favorit (context.watch)',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Dipantau oleh: $studentName'),
        trailing: Text(
          '${provider.favorites.length}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
