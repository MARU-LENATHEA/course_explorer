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
      title: 'Tahap 16 - Debugging Challenge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const DebuggingChallengePage(),
    );
  }
}

class DebuggingChallengePage extends StatefulWidget {
  const DebuggingChallengePage({super.key});

  @override
  State<DebuggingChallengePage> createState() => _DebuggingChallengePageState();
}

class _DebuggingChallengePageState extends State<DebuggingChallengePage> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> cases = [
      const CaseAFix(),
      const CaseBFix(),
      const CaseCFix(),
      const CaseDFix(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 16: Debugging Challenge'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          // Header Identitas Mahasiswa
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: Colors.blue.shade50,
            child: Row(
              children: [
                const Icon(Icons.bug_report, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Praktikan: $studentName ($studentId)',
                    style: TextStyle(
                      color: Colors.blue.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: cases[_currentTab]),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab,
        onDestinationSelected: (idx) => setState(() => _currentTab = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.text_fields),
            label: 'Kasus A',
          ),
          NavigationDestination(icon: Icon(Icons.view_list), label: 'Kasus B'),
          NavigationDestination(icon: Icon(Icons.keyboard), label: 'Kasus C'),
          NavigationDestination(icon: Icon(Icons.navigation), label: 'Kasus D'),
        ],
      ),
    );
  }
}

// ==========================================
// KASUS A: RenderFlex Overflow pada Row
// ==========================================
class CaseAFix extends StatelessWidget {
  const CaseAFix({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kasus A: Perbaikan RenderFlex Overflow',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text('Solusi: Membungkus widget Text ke dalam Expanded.'),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Icon(Icons.info, color: Colors.blue),
                  const SizedBox(width: 8),
                  // SOLUSI: Expanded membatasi constraints teks agar tidak melebihi sisa ruang Row
                  Expanded(
                    child: Text(
                      '$studentId - $studentName - Teks ini sangat panjang untuk mendemonstrasikan bahwa dengan membungkus Text ke dalam Expanded, overflow garis kuning-hitam berhasil dicegah dan teks otomatis turun ke baris berikutnya.',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// KASUS B: Vertical Viewport Unbounded Height
// ==========================================
class CaseBFix extends StatelessWidget {
  const CaseBFix({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kasus B: ListView di dalam Column',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Solusi: Membungkus ListView dengan Expanded agar bounded.',
          ),
          const SizedBox(height: 16),
          // SOLUSI: ListView dibungkus Expanded agar mengambil sisa ruang Column yang terbatas
          Expanded(
            child: ListView.builder(
              itemCount: 8,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text('Item Course ${index + 1}'),
                  subtitle: Text('ID Mahasiswa: $studentId'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// KASUS C: Keyboard Overflow pada Form Bawah
// ==========================================
class CaseCFix extends StatelessWidget {
  const CaseCFix({super.key});

  @override
  Widget build(BuildContext context) {
    // SOLUSI: SingleChildScrollView mencegah overflow saat keyboard virtual aktif
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kasus C: Keyboard Overflow Protection',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text('Solusi: Bungkus dengan SingleChildScrollView.'),
          const SizedBox(height: 100), // Simulasi konten tinggi
          const Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text('Konten statis di atas form input...'),
            ),
          ),
          const SizedBox(height: 80),
          TextField(
            decoration: InputDecoration(
              labelText: 'Ketik sesuatu untuk memunculkan keyboard',
              hintText: 'Praktikan: $studentName',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// KASUS D: Pencegahan Navigasi Ganda (Double Push)
// ==========================================
class CaseDFix extends StatefulWidget {
  const CaseDFix({super.key});

  @override
  State<CaseDFix> createState() => _CaseDFixState();
}

class _CaseDFixState extends State<CaseDFix> {
  bool _isNavigating = false;

  void _navigateToDetail() async {
    // SOLUSI: Guard flag untuk mencegah navigasi ganda akibat klik cepat berturut-turut
    if (_isNavigating) return;

    setState(() => _isNavigating = true);

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: const Text('Halaman Target')),
          body: Center(
            child: Text(
              'Detail Terbuka Sekali\nOleh: $studentName ($studentId)',
            ),
          ),
        ),
      ),
    );

    // Reset flag setelah kembali ke halaman asal
    if (mounted) {
      setState(() => _isNavigating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kasus D: Guard Action Navigasi Ganda',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          const Text(
            'Solusi: Flag boolean _isNavigating mencegah eksekusi berulang.',
          ),
          const SizedBox(height: 24),
          Center(
            child: ElevatedButton.icon(
              onPressed: _isNavigating ? null : _navigateToDetail,
              icon: const Icon(Icons.arrow_forward),
              label: Text(
                _isNavigating ? 'Membuka...' : 'Buka Halaman (Aman Multi-tap)',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
