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
      title: 'Tahap 1 - Local vs Shared State',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const StateIdentificationScreen(),
    );
  }
}

class StateIdentificationScreen extends StatelessWidget {
  const StateIdentificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer - Tahap 1'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
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
            Text(
              'Implementasi Local State (setState)',
              style: Theme.of(context).textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Widget dengan Local State (Expandable Card)
            const CourseLocalStateCard(
              code: 'MOB04',
              title: 'Responsive Layout',
              status: 'active',
              description: 'Materi ini mencakup teknik adaptasi ukuran layar, penggunaan MediaQuery, LayoutBuilder, dan penyusunan breakpoint aplikasi multi-screen.',
            ),
            const CourseLocalStateCard(
              code: 'MOB05',
              title: 'State Management & Architecture',
              status: 'active',
              description: 'Membahas pemisahan local state dan shared state, penggunaan ChangeNotifier, Provider, serta refactoring folder architecture.',
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Stateful untuk menangani Local State sementara (Expand/Collapse)
class CourseLocalStateCard extends StatefulWidget {
  final String code;
  final String title;
  final String status;
  final String description;

  const CourseLocalStateCard({
    super.key,
    required this.code,
    required this.title,
    required this.status,
    required this.description,
  });

  @override
  State<CourseLocalStateCard> createState() => _CourseLocalStateCardState();
}

class _CourseLocalStateCardState extends State<CourseLocalStateCard> {
  // LOCAL STATE: Hanya dibutuhkan oleh kartu ini sendiri
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.code} • ${widget.status}',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                // Tombol aksi yang mengubah local state via setState()
                IconButton(
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ],
            ),
            // Tampilan conditional rendering berbasis local state
            if (_isExpanded) ...[
              const Divider(height: 16),
              Text(
                widget.description,
                style: const TextStyle(fontSize: 14, height: 1.3),
              ),
              const SizedBox(height: 4),
              const Text(
                'Status: Terbuka via local state (setState)',
                style: TextStyle(fontSize: 12, color: Colors.blueGrey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
