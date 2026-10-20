import 'package:flutter/material.dart';

// Identitas Mahasiswa Praktikan
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
      title: 'Tahap 3 - Lifting State Up',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const LiftingStatePage(),
    );
  }
}

// =========================================================================
// PARENT WIDGET: Single Source of Truth
// =========================================================================
class LiftingStatePage extends StatefulWidget {
  const LiftingStatePage({super.key});

  @override
  State<LiftingStatePage> createState() => _LiftingStatePageState();
}

class _LiftingStatePageState extends State<LiftingStatePage> {
  // SINGLE SOURCE OF TRUTH: Satu sumber state menjadi acuan bersama
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 3: Lifting State Up'),
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

            // WIDGET 1: Menampilkan status favorit dari parent state
            FavoriteStatusBanner(isFavorite: favorite),
            const SizedBox(height: 16),

            Text(
              'Course Card (Child menerima state & mengirim aksi lewat callback):',
              style: Theme.of(context).textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            // WIDGET 2: Sesuai contoh worksheet Tahap 3
            CourseCard(
              title: 'State Management & Architecture',
              code: 'MOB06',
              isFavorite: favorite,
              onFavoriteChanged: () {
                setState(() {
                  favorite = !favorite;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

// =========================================================================
// CHILD WIDGET 1: Banner Konsistensi Status
// =========================================================================
class FavoriteStatusBanner extends StatelessWidget {
  final bool isFavorite;

  const FavoriteStatusBanner({super.key, required this.isFavorite});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isFavorite ? Colors.red.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isFavorite ? Colors.red.shade300 : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey.shade700,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isFavorite
                  ? 'Single Source of Truth: FAVORITE AKTIF (true)'
                  : 'Single Source of Truth: BELUM FAVORIT (false)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isFavorite ? Colors.red.shade900 : Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =========================================================================
// CHILD WIDGET 2: CourseCard (Stateless, tidak menyimpan salinan state)
// =========================================================================
class CourseCard extends StatelessWidget {
  final String title;
  final String code;
  final bool isFavorite;
  final VoidCallback onFavoriteChanged;

  const CourseCard({
    super.key,
    required this.title,
    required this.code,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: const Icon(Icons.school, color: Colors.blue),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Kode: $code • Praktikan: $studentId'),
        trailing: IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : Colors.grey,
          ),
          onPressed: onFavoriteChanged, // Memanggil callback milik parent
        ),
      ),
    );
  }
}
