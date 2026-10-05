import 'package:flutter/material.dart';

const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

void main() {
  runApp(const TahapSembilanApp());
}

class TahapSembilanApp extends StatelessWidget {
  const TahapSembilanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tahap 9 - Returning Data',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E88E5)),
        useMaterial3: true,
      ),
      home: const CourseSelectionPage(),
    );
  }
}

// -------------------------------------------------------------
// 1. HALAMAN UTAMA (Menunggu dan Menerima Hasil Kembalian)
// -------------------------------------------------------------
class CourseSelectionPage extends StatefulWidget {
  const CourseSelectionPage({super.key});

  @override
  State<CourseSelectionPage> createState() => _CourseSelectionPageState();
}

class _CourseSelectionPageState extends State<CourseSelectionPage> {
  String _selectedStatus = 'Belum ada kursus yang dipilih sebagai favorit.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 9: Returning Data'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Identitas Mahasiswa
              Container(
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
                      'Praktikum Pertemuan 05: Await Navigator.push & pop(result)',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Status Tampilan Hasil Balik
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.sync_alt,
                        size: 48,
                        color: Color(0xFF1E88E5),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Status Kursus Favorit Terkini:',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _selectedStatus,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),

              // Tombol Buka Halaman Detail Kursus
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E88E5),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.open_in_new),
                label: const Text(
                  'Buka Detail Kursus (Pilih)',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  // Menunggu kembalian nilai boolean dari DetailPage
                  final result = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailSelectionPage(
                        courseTitle: 'Responsive Layout & Navigation',
                      ),
                    ),
                  );

                  // Jika user menekan tombol 'Pilih / Favorite' (result == true)
                  if (!mounted) return;
                  if (result == true) {
                    setState(() {
                      _selectedStatus = 'Kursus "Responsive Layout & Navigation" berhasil dijadikan FAVORIT!';
                    });

                    // Menampilkan SnackBar umpan balik
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Berhasil! Kursus telah ditambahkan ke favorit.',
                        ),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 2. HALAMAN DETAIL (Mengembalikan Data via pop)
// -------------------------------------------------------------
class DetailSelectionPage extends StatelessWidget {
  final String courseTitle;

  const DetailSelectionPage({super.key, required this.courseTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail & Pemilihan'),
        backgroundColor: const Color(0xFF1E88E5),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
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
              const SizedBox(height: 24),
              Text(
                courseTitle,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Mata kuliah ini membahas implementasi antarmuka yang adaptif terhadap berbagai form factor perangkat bergerak serta pola navigasi multi-screen.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),

              // Tombol Pilih/Favorite (Mengembalikan true)
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.favorite),
                label: const Text(
                  'Pilih sebagai Favorit',
                  style: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  // Kembali ke screen sebelumnya sambil mengirim data true
                  Navigator.pop(context, true);
                },
              ),
              const SizedBox(height: 12),

              // Tombol Batal / Kembali Biasa (Mengembalikan null / false)
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Batal / Kembali Tanpa Memilih'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
