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
      title: 'Course Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // State untuk melacak tab/destinasi yang sedang aktif
  int _currentIndex = 0;

  // Daftar halaman yang akan ditampilkan sesuai index
  final List<Widget> _pages = const [
    HomeScreen(),
    CoursesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Explorer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // Konten berubah otomatis berdasarkan _currentIndex
      body: _pages[_currentIndex],
      // Implementasi NavigationBar (Material 3)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Courses',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// 1. Tampilan Halaman Home
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Course Explorer Dashboard',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_circle, color: Colors.blue),
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
          const SizedBox(height: 16),
          const Card(
            child: ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('Tahap 10: Navigasi Utama'),
              subtitle: Text(
                'Bilah navigasi di bawah berpindah halaman tanpa memicu route stack baru.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 2. Tampilan Halaman Courses
class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> sampleCourses = [
      {'code': 'MOB04', 'name': 'Responsive Layout', 'status': 'Active'},
      {'code': 'MOB05', 'name': 'Navigation', 'status': 'Planned'},
      {'code': 'MOB06', 'name': 'Interaction', 'status': 'Planned'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: sampleCourses.length,
      itemBuilder: (context, index) {
        final course = sampleCourses[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Text('${index + 1}'),
            ),
            title: Text(course['name']!),
            subtitle: Text('Kode: ${course['code']}'),
            trailing: Chip(label: Text(course['status']!)),
          ),
        );
      },
    );
  }
}

// 3. Tampilan Halaman Profile
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.person, size: 50, color: Colors.blue),
            ),
            const SizedBox(height: 16),
            Text(
              studentName,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              'NIM: $studentId',
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 16),
            const Chip(
              avatar: Icon(Icons.school, size: 16),
              label: Text('Teknik Informatika'),
            ),
          ],
        ),
      ),
    );
  }
}
