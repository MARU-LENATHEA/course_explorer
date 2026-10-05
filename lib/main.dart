import 'package:flutter/material.dart';

const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

void main() {
  runApp(const TahapEmpatApp());
}

class TahapEmpatApp extends StatelessWidget {
  const TahapEmpatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 4 - Expanded, Flexible & Wrap',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: const FlexWrapPage(),
    );
  }
}

class FlexWrapPage extends StatelessWidget {
  const FlexWrapPage({super.key});

  Widget _buildBox(String label, Color color) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Minimal 6 Chip keterampilan sesuai instruksi lembar kerja
    final List<String> skills = [
      'Flutter UI',
      'Dart Fundamental',
      'Responsive Design',
      'LayoutBuilder',
      'State Management',
      'Git Workflow',
      'REST API',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 4: Expanded & Wrap'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Identitas Mahasiswa
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '$studentId - $studentName',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Praktikum Pertemuan 05: Komposisi Flex & Wrap',
                    style: TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 1. Uji Coba Expanded dengan Rasio Flex 2 : 1
            const Text(
              '1. Pembagian Ruang Row (Expanded Flex 2 : 1)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Panel A mengambil 2 bagian (66.7%) dan Panel B mengambil 1 bagian (33.3%) dari sisa lebar layar secara proporsional.',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: _buildBox('Panel A (Flex: 2)', Colors.indigo.shade600),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: _buildBox('Panel B (Flex: 1)', Colors.amber.shade700),
                ),
              ],
            ),
            const SizedBox(height: 28),

            // 2. Uji Coba Wrap dengan Chip Minimal 6 Item
            const Text(
              '2. Komposisi Multi-Baris Dinamis (Wrap)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Jika elemen melampaui lebar layar, Wrap otomatis memindahkan item ke baris berikutnya (mencegah overflow yang biasa terjadi pada Row).',
              style: TextStyle(fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8.0, // Jarak horizontal antar chip
              runSpacing: 8.0, // Jarak vertikal antar baris chip
              children: skills.map((skill) {
                return Chip(
                  avatar: const CircleAvatar(
                    backgroundColor: Color(0xFF1E88E5),
                    child: Icon(Icons.check, size: 14, color: Colors.white),
                  ),
                  label: Text(skill),
                  backgroundColor: Colors.grey.shade100,
                  side: BorderSide(color: Colors.grey.shade300),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
