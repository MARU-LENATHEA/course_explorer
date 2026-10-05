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
      home: const AdaptiveNavigationShell(),
    );
  }
}

class AdaptiveNavigationShell extends StatefulWidget {
  const AdaptiveNavigationShell({super.key});

  @override
  State<AdaptiveNavigationShell> createState() =>
      _AdaptiveNavigationShellState();
}

class _AdaptiveNavigationShellState extends State<AdaptiveNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    CoursesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isExpanded = constraints.maxWidth >= 840;

        if (isExpanded) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Course Explorer (Expanded)'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _currentIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.school_outlined),
                      selectedIcon: Icon(Icons.school),
                      label: Text('Courses'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: Text('Profile'),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: _pages[_currentIndex]),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Course Explorer (Compact)'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: _pages[_currentIndex],
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
      },
    );
  }
}

// 1. Screen Home
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Course Explorer Dashboard',
            style: Theme.of(context).textTheme.headlineSmall,
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
              leading: Icon(Icons.edit_note),
              title: Text('Tahap 13: Form Input & Validasi'),
              subtitle: Text(
                'Buka tab Profile untuk mengisi form feedback dengan validasi karakter minimal.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 2. Screen Courses
class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  final List<Map<String, dynamic>> _courses = [
    {
      'code': 'MOB04',
      'name': 'Responsive Layout',
      'status': 'Active',
      'isFavorite': false,
      'desc': 'Membahas MediaQuery, LayoutBuilder, dan Breakpoint adaptif.',
    },
    {
      'code': 'MOB05',
      'name': 'Navigation',
      'status': 'Planned',
      'isFavorite': false,
      'desc':
          'Mempelajari navigasi stack push/pop dan adaptasi bilah navigasi.',
    },
    {
      'code': 'MOB06',
      'name': 'Interaction',
      'status': 'Planned',
      'isFavorite': false,
      'desc':
          'Eksplorasi InkWell, GestureDetector, tombol, form, dan feedback.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _courses.length,
      itemBuilder: (context, index) {
        final course = _courses[index];
        final bool isFav = course['isFavorite'] as bool;

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 6),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Course diklik: ${course['name']}'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text('${index + 1}'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Kode: ${course['code']} • ${course['status']}',
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        course['isFavorite'] = !isFav;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// 3. Screen Profile dengan Form Input & Validasi Feedback
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _idController;
  final TextEditingController _commentController = TextEditingController();

  String? _submittedFeedback;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan nilai default identitas praktikan
    _nameController = TextEditingController(text: studentName);
    _idController = TextEditingController(text: studentId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Validasi form sebelum memproses data
    if (_formKey.currentState!.validate()) {
      setState(() {
        _submittedFeedback = _commentController.text.trim();
      });
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback berhasil divalidasi dan disimpan!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.blue.shade100,
                  child: const Icon(Icons.person, size: 40, color: Colors.blue),
                ),
                const SizedBox(height: 10),
                Text(
                  studentName,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'NIM: $studentId',
                  style: Theme.of(context).textTheme.bodyMedium
                      ?.copyWith(color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Form Feedback Praktikum',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nama Praktikan',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Nama wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _idController,
                      decoration: const InputDecoration(
                        labelText: 'NIM',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.badge),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'NIM wajib diisi';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _commentController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Komentar / Feedback',
                        hintText:
                            'Tulis komentar praktikum minimal 5 karakter...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.chat),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Komentar wajib diisi';
                        }
                        if (value.trim().length < 5) {
                          return 'Komentar wajib minimal 5 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _submitForm,
                      icon: const Icon(Icons.send),
                      label: const Text('Kirim Feedback'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_submittedFeedback != null) ...[
            const SizedBox(height: 16),
            Card(
              color: Colors.green.shade50,
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('Hasil Feedback Terkirim:'),
                subtitle: Text('"${_submittedFeedback!}"'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
