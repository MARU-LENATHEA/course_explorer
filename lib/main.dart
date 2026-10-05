import 'package:flutter/material.dart';

const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

void main() {
  runApp(const TahapTigaApp());
}

class TahapTigaApp extends StatelessWidget {
  const TahapTigaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 3 - LayoutBuilder & Breakpoint',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: const BreakpointShellPage(),
    );
  }
}

class BreakpointShellPage extends StatelessWidget {
  const BreakpointShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 3: LayoutBuilder & Breakpoint'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Breakpoint Praktikum: Compact (<600), Medium (600-839), Expanded (>=840)
          if (constraints.maxWidth < 600) {
            return CompactLayout(maxWidth: constraints.maxWidth);
          } else if (constraints.maxWidth < 840) {
            return MediumLayout(maxWidth: constraints.maxWidth);
          } else {
            return ExpandedLayout(maxWidth: constraints.maxWidth);
          }
        },
      ),
    );
  }
}

// 1. Tampilan Compact (< 600 px) -> 1 Kolom Vertikal Phone
class CompactLayout extends StatelessWidget {
  final double maxWidth;
  const CompactLayout({super.key, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildIdentityHeader('Compact (< 600 px)', Colors.orange[700]!),
          const SizedBox(height: 12),
          Text(
            'Lebar Constraints Parent: ${maxWidth.toStringAsFixed(1)} px',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          _buildFeatureCard(
            'Fitur A',
            'Tampilan 1 Kolom Phone',
            Colors.blue[100]!,
          ),
          const SizedBox(height: 10),
          _buildFeatureCard(
            'Fitur B',
            'Tata letak vertikal untuk layar ramping',
            Colors.green[100]!,
          ),
          const SizedBox(height: 10),
          _buildFeatureCard(
            'Fitur C',
            'Dioptimalkan untuk navigasi satu tangan',
            Colors.purple[100]!,
          ),
        ],
      ),
    );
  }
}

// 2. Tampilan Medium (600 - 839 px) -> Grid 2 Kolom Tablet
class MediumLayout extends StatelessWidget {
  final double maxWidth;
  const MediumLayout({super.key, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildIdentityHeader('Medium (600 - 839 px)', Colors.teal[700]!),
          const SizedBox(height: 12),
          Text(
            'Lebar Constraints Parent: ${maxWidth.toStringAsFixed(1)} px',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildFeatureCard(
                  'Panel 1',
                  'Grid 2 Kolom (Tablet Portrait)',
                  Colors.teal[100]!,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFeatureCard(
                  'Panel 2',
                  'Pemanfaatan ruang horizontal samping',
                  Colors.cyan[100]!,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// 3. Tampilan Expanded (>= 840 px) -> 3 Panel Berdampingan Desktop
class ExpandedLayout extends StatelessWidget {
  final double maxWidth;
  const ExpandedLayout({super.key, required this.maxWidth});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildIdentityHeader('Expanded (>= 840 px)', Colors.indigo[700]!),
          const SizedBox(height: 12),
          Text(
            'Lebar Constraints Parent: ${maxWidth.toStringAsFixed(1)} px',
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildFeatureCard(
                    'Sidebar Kiri',
                    'Menu Navigasi Desktop',
                    Colors.indigo[100]!,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildFeatureCard(
                    'Konten Utama',
                    'Ruang Konten Lebar Multi-Kolom',
                    Colors.amber[100]!,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: _buildFeatureCard(
                    'Panel Detail',
                    'Panel Informasi Tambahan',
                    Colors.pink[100]!,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Header Identitas Aman Bebas Overflow
Widget _buildIdentityHeader(String category, Color badgeColor) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    decoration: BoxDecoration(
      color: Colors.blue[50],
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.blue.shade200),
    ),
    child: Row(
      children: [
        // Menggunakan Expanded agar kolom teks menyesuaikan sisa ruang dan tidak menabrak badge
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '$studentId - $studentName',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D47A1),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4),
              Text(
                'Praktikum Mobile - Pertemuan 05',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: badgeColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            category,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ),
      ],
    ),
  );
}

// Widget Card Fitur
Widget _buildFeatureCard(String title, String desc, Color color) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Text(desc, style: const TextStyle(fontSize: 13, color: Colors.black87)),
      ],
    ),
  );
}
