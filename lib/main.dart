import 'package:flutter/material.dart';

import 'course_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 5 - ChangeNotifier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const ChangeNotifierDemoPage(),
    );
  }
}

class ChangeNotifierDemoPage extends StatefulWidget {
  const ChangeNotifierDemoPage({super.key});

  @override
  State<ChangeNotifierDemoPage> createState() => _ChangeNotifierDemoPageState();
}

class _ChangeNotifierDemoPageState extends State<ChangeNotifierDemoPage> {
  // Instansiasi objek ChangeNotifier
  final CourseProvider _courseProvider = CourseProvider();

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
  void dispose() {
    _courseProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 5: ChangeNotifier'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // ListenableBuilder mendengarkan notifyListeners() dari _courseProvider
      body: ListenableBuilder(
        listenable: _courseProvider,
        builder: (context, child) {
          return Padding(
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

                // Ringkasan Jumlah Favorit dari CourseProvider
                Card(
                  color: Colors.red.shade50,
                  child: ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.red),
                    title: const Text(
                      'Total Favorites (ChangeNotifier)',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Text(
                      '${_courseProvider.favorites.length}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Text(
                  'Daftar Course:',
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),

                // Daftar Course yang terhubung ke CourseProvider
                Expanded(
                  child: ListView.builder(
                    itemCount: _courses.length,
                    itemBuilder: (context, index) {
                      final course = _courses[index];
                      final code = course['code']!;
                      final isFav = _courseProvider.isFavorite(code);

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
                              _courseProvider.toggleFavorite(code);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
