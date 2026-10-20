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
      title: 'Tahap 4 - ValueNotifier',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const ValueNotifierDemoPage(),
    );
  }
}

class ValueNotifierDemoPage extends StatefulWidget {
  const ValueNotifierDemoPage({super.key});

  @override
  State<ValueNotifierDemoPage> createState() => _ValueNotifierDemoPageState();
}

class _ValueNotifierDemoPageState extends State<ValueNotifierDemoPage> {
  // 1. Deklarasi ValueNotifier<int> untuk memantau jumlah favorit
  final ValueNotifier<int> favoriteCounter = ValueNotifier<int>(0);

  @override
  void dispose() {
    // Wajib dispose ValueNotifier saat widget dihancurkan
    favoriteCounter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Pembuktian: build() utama ini TIDAK dipanggil ulang saat counter berubah
    debugPrint('Building ValueNotifierDemoPage scaffold...');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tahap 4: ValueNotifier'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Identitas Praktikan
            Container(
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
            const SizedBox(height: 20),

            // 2. Menggunakan ValueListenableBuilder agar hanya bagian ini yang di-rebuild
            Card(
              elevation: 2,
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Icon(Icons.favorite, color: Colors.red, size: 42),
                    const SizedBox(height: 8),
                    const Text(
                      'Total Course Favorit Dipantau:',
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    ValueListenableBuilder<int>(
                      valueListenable: favoriteCounter,
                      builder: (context, value, child) {
                        return Text(
                          '$value',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade900,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. Tombol pengubah nilai ValueNotifier tanpa setState()
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      if (favoriteCounter.value > 0) {
                        favoriteCounter.value--;
                      }
                    },
                    icon: const Icon(Icons.remove),
                    label: const Text('Kurangi'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      favoriteCounter.value++;
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Favorit'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () {
                favoriteCounter.value = 0;
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reset ke 0'),
            ),
          ],
        ),
      ),
    );
  }
}
