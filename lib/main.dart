import 'package:flutter/material.dart';

const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

void main() {
  runApp(const TahapDelapanApp());
}

class TahapDelapanApp extends StatelessWidget {
  const TahapDelapanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 8 - Passing Data',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: const CourseListPage(),
    );
  }
}

// -------------------------------------------------------------
// 1. LIST SCREEN (Pengirim Data)
// -------------------------------------------------------------
class CourseListPage extends StatelessWidget {
  const CourseListPage({super.key});

  // Koleksi data kursus (Map<String, dynamic>) sesuai materi Tahap 8
  final List<Map<String, dynamic>> courses = const [
    {
      'id': '1',
      'title': 'Responsive Layout',
      'code': 'MOB04',
      'status': 'Active',
      'credits': 3,
      'description': 'Mempelajari cara membangun tata letak Flutter yang adaptif terhadap berbagai ukuran layar menggunakan MediaQuery dan LayoutBuilder.',
    },
    {
      'id': '2',
      'title': 'Navigation & Routing',
      'code': 'MOB05',
      'status': 'Planned',
      'credits': 3,
      'description': 'Konsep stack navigasi, pengiriman parameter antar screen, serta BottomNavigationBar dan NavigationRail.',
    },
    {
      'id': '3',
      'title': 'User Interaction',
      'code': 'MOB06',
      'status': 'Planned',
      'credits': 2,
      'description': 'Menangani interaksi sentuhan, gesture, tombol dinamis, dan dialog feedback bagi pengguna.',
    },
    {
      'id': '4',
      'title': 'Form & Validation',
      'code': 'MOB07',
      'status': 'Planned',
      'credits': 3,
      'description': 'Validasi formulir input pengguna secara terstruktur menggunakan Form, TextFormField, dan GlobalKey.',
    },
    {
      'id': '5',
      'title': 'State Management Basic',
      'code': 'MOB08',
      'status': 'Planned',
      'credits': 3,
      'description': 'Pengenalan siklus hidup widget dan pembaruan antarmuka secara reaktif.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 8: Daftar Kursus'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Identitas Mahasiswa
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
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
                      'Praktikum Pertemuan 05: Passing Data via Constructor',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Pilih salah satu kursus untuk melihat detail:',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 10),

              // Daftar Kursus (ListTile)
              Expanded(
                child: ListView.separated(
                  itemCount: courses.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Card(
                      elevation: 1.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: course['status'] == 'Active'
                              ? Colors.green[100]
                              : Colors.blueGrey[100],
                          child: Icon(
                            Icons.menu_book,
                            color: course['status'] == 'Active'
                                ? Colors.green[800]
                                : Colors.blueGrey[800],
                          ),
                        ),
                        title: Text(
                          course['title'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${course['code']} • ${course['credits']} SKS',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Mengirim data Map course ke CourseDetailPage melalui constructor
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CourseDetailPage(course: course),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 2. DETAIL SCREEN (Penerima Data via Constructor)
// -------------------------------------------------------------
class CourseDetailPage extends StatelessWidget {
  final Map<String, dynamic> course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course['title']),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Identitas Mahasiswa di Detail Page
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Praktikan: $studentName ($studentId)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D47A1),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Detail Course yang Diterima
              Text(
                '${course['code']} - ${course['title']}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Chip(
                    avatar: const Icon(Icons.credit_card, size: 16),
                    label: Text('${course['credits']} SKS'),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    backgroundColor: course['status'] == 'Active'
                        ? Colors.green[100]
                        : Colors.grey[200],
                    label: Text(
                      course['status'],
                      style: TextStyle(
                        color: course['status'] == 'Active'
                            ? Colors.green[900]
                            : Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 32),
              const Text(
                'Deskripsi Mata Kuliah:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                course['description'] ?? 'Tidak ada deskripsi tersedia.',
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
