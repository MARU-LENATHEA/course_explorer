import 'package:flutter/material.dart';

const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

void main() {
  runApp(const TahapLimaApp());
}

class TahapLimaApp extends StatelessWidget {
  const TahapLimaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 5 - Responsive GridView',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: const ResponsiveGridPage(),
    );
  }
}

// Model data kursus
class CourseItem {
  final String title;
  final String code;
  final String status;
  final int credits;

  const CourseItem({
    required this.title,
    required this.code,
    required this.status,
    required this.credits,
  });
}

class ResponsiveGridPage extends StatelessWidget {
  const ResponsiveGridPage({super.key});

  // Koleksi data kursus minimal 5 item
  final List<CourseItem> courses = const [
    CourseItem(
      title: 'Responsive Layout',
      code: 'MOB04',
      status: 'Active',
      credits: 3,
    ),
    CourseItem(
      title: 'Navigation & Routing',
      code: 'MOB05',
      status: 'Planned',
      credits: 3,
    ),
    CourseItem(
      title: 'User Interaction',
      code: 'MOB06',
      status: 'Planned',
      credits: 2,
    ),
    CourseItem(
      title: 'Form & Validation',
      code: 'MOB07',
      status: 'Planned',
      credits: 3,
    ),
    CourseItem(
      title: 'State Management',
      code: 'MOB08',
      status: 'Planned',
      credits: 3,
    ),
  ];

  // Logika penentuan jumlah kolom sesuai instruksi praktikum
  int _columnsFor(double width) {
    if (width < 600) return 1;
    if (width < 840) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 5: GridView Responsif'),
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
                      'Praktikum Pertemuan 05: Dynamic Column GridView',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // LayoutBuilder untuk membaca lebar ruang parent secara lokal
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final int cols = _columnsFor(constraints.maxWidth);
                    final String layoutCategory = constraints.maxWidth < 600
                        ? 'Compact ($cols Kolom)'
                        : (constraints.maxWidth < 840
                              ? 'Medium ($cols Kolom)'
                              : 'Expanded ($cols Kolom)');

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kategori Tampilan: $layoutCategory (Lebar: ${constraints.maxWidth.toStringAsFixed(1)} px)',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: cols,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  // Rasio aspek disesuaikan agar card proporsional di setiap ukuran
                                  childAspectRatio: cols == 1
                                      ? 2.8
                                      : (cols == 2 ? 2.0 : 1.7),
                                ),
                            itemCount: courses.length,
                            itemBuilder: (context, index) {
                              final course = courses[index];
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(14.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              course.title,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF0D47A1),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          const Icon(
                                            Icons.school_outlined,
                                            color: Colors.blueAccent,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            '${course.code} • ${course.credits} SKS',
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: course.status == 'Active'
                                                  ? Colors.green[50]
                                                  : Colors.blueGrey[50],
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              course.status,
                                              style: TextStyle(
                                                color: course.status == 'Active'
                                                    ? Colors.green[700]
                                                    : Colors.blueGrey[700],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
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
