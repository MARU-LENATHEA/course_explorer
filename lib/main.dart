import 'package:flutter/material.dart';

// Identitas Mahasiswa Praktikan (Wajib ditampilkan)
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahap 2 - Keterbatasan setState & Prop Drilling',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const ParentStateDemoPage(),
    );
  }
}

// =========================================================================
// PARENT WIDGET: Pemilik State (State Owner)
// =========================================================================
class ParentStateDemoPage extends StatefulWidget {
  const ParentStateDemoPage({super.key});

  @override
  State<ParentStateDemoPage> createState() => _ParentStateDemoPageState();
}

class _ParentStateDemoPageState extends State<ParentStateDemoPage> {
  // STATE OWNER: Disimpan di parent karena dibutuhkan oleh dua child berbeda
  final Set<String> _favoriteCourseCodes = {};

  final List<Map<String, String>> _courses = const [
    {'code': 'MOB04', 'name': 'Responsive Layout', 'status': 'done'},
    {'code': 'MOB05', 'name': 'Dart Fundamentals', 'status': 'done'},
    {'code': 'MOB06', 'name': 'State Management', 'status': 'active'},
  ];

  // Callback action untuk toggle favorit
  void _toggleFavorite(String code) {
    setState(() {
      if (_favoriteCourseCodes.contains(code)) {
        _favoriteCourseCodes.remove(code);
      } else {
        _favoriteCourseCodes.add(code);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 2: Masalah setState'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Identitas Mahasiswa
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

            // CHILD 1: Menerima count via constructor (Prop Drilling)
            CoursesSummary(
              totalCourses: _courses.length,
              totalFavorites: _favoriteCourseCodes.length,
            ),
            const SizedBox(height: 16),

            Text(
              'Daftar Course (Meneruskan callback ke child bertingkat):',
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // CHILD 2: Menerima list data, set favorit, dan callback function
            CourseList(
              courses: _courses,
              favoriteCodes: _favoriteCourseCodes,
              onToggleFavorite: _toggleFavorite,
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// CHILD 1: Widget Ringkasan (Hanya membaca state)
// =========================================================================
class CoursesSummary extends StatelessWidget {
  final int totalCourses;
  final int totalFavorites;

  const CoursesSummary({
    super.key,
    required this.totalCourses,
    required this.totalFavorites,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Courses',
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalCourses',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text(
                    'Favorites',
                    style: TextStyle(color: Colors.redAccent),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalFavorites',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =========================================================================
// CHILD 2: List Widget (Meneruskan props ke level kartu / item)
// =========================================================================
class CourseList extends StatelessWidget {
  final List<Map<String, String>> courses;
  final Set<String> favoriteCodes;
  final Function(String) onToggleFavorite;

  const CourseList({
    super.key,
    required this.courses,
    required this.favoriteCodes,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: courses.map((course) {
        final String code = course['code']!;
        final bool isFav = favoriteCodes.contains(code);

        // Prop drilling berlanjut ke CourseItemRow
        return CourseItemRow(
          code: code,
          name: course['name']!,
          status: course['status']!,
          isFavorite: isFav,
          onTapFavorite: () => onToggleFavorite(code),
        );
      }).toList(),
    );
  }
}

// CHILD DARI CHILD: Menerima callback dari CourseList yang diteruskan dari Parent
class CourseItemRow extends StatelessWidget {
  final String code;
  final String name;
  final String status;
  final bool isFavorite;
  final VoidCallback onTapFavorite;

  const CourseItemRow({
    super.key,
    required this.code,
    required this.name,
    required this.status,
    required this.isFavorite,
    required this.onTapFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$code • $status'),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: onTapFavorite, // Menembak callback ke atas
        ),
      ),
    );
  }
}
