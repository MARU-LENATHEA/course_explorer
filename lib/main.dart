import 'package:flutter/material.dart';

// Identitas Mahasiswa Praktikan
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

void main() {
  runApp(const CourseExplorerApp());
}

class CourseExplorerApp extends StatelessWidget {
  const CourseExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const ResponsiveShell(),
    );
  }
}

// Model Data Course
class CourseItem {
  final String id;
  final String code;
  final String title;
  final String status;
  final String description;
  bool isFavorite;

  CourseItem({
    required this.id,
    required this.code,
    required this.title,
    required this.status,
    required this.description,
    this.isFavorite = false,
  });
}

// Master Shell Adaptif: NavigationBar (< 840 px) vs NavigationRail (>= 840 px)
class ResponsiveShell extends StatefulWidget {
  const ResponsiveShell({super.key});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _selectedIndex = 0;

  // Koleksi Data Course (Minimal 5 item)
  final List<CourseItem> _courses = [
    CourseItem(
      id: '1',
      code: 'MOB01',
      title: 'Flutter Environment & Setup',
      status: 'Completed',
      description: 'Pengenalan SDK Flutter, konfigurasi simulator, dan mental model widget tree.',
    ),
    CourseItem(
      id: '2',
      code: 'MOB02',
      title: 'Basic Widgets & Layouts',
      status: 'Completed',
      description: 'Menguasai penggunaan Container, Row, Column, Expanded, dan penataan padding dasar.',
    ),
    CourseItem(
      id: '3',
      code: 'MOB04',
      title: 'Responsive Layout',
      status: 'Active',
      description: 'Menerapkan constraints, MediaQuery, LayoutBuilder, dan breakpoint compact/medium/expanded.',
    ),
    CourseItem(
      id: '4',
      code: 'MOB05',
      title: 'Multi-Screen Navigation',
      status: 'Planned',
      description: 'Navigasi stack push & pop, passing data via constructor, dan adaptive navigation rail.',
    ),
    CourseItem(
      id: '5',
      code: 'MOB06',
      title: 'User Interaction & Forms',
      status: 'Planned',
      description: 'Menangani tap, efek InkWell, form validation, dialog konfirmasi, dan snackbar feedback.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isExpanded = constraints.maxWidth >= 840;

        final List<Widget> pages = [
          HomePage(courses: _courses),
          CoursesPage(
            courses: _courses,
            isExpanded: isExpanded,
            onFavoriteToggle: (course) {
              setState(() {
                course.isFavorite = !course.isFavorite;
              });
            },
          ),
          const ProfilePage(),
        ];

        if (isExpanded) {
          // Layout Layar Lebar: NavigationRail di sebelah kiri
          return Scaffold(
            appBar: AppBar(
              title: const Text('Course Explorer — Expanded Layout'),
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() => _selectedIndex = index);
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
                Expanded(child: pages[_selectedIndex]),
              ],
            ),
          );
        }

        // Layout Smartphone / Compact: NavigationBar di bawah
        return Scaffold(
          appBar: AppBar(
            title: const Text('Course Explorer'),
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          ),
          body: pages[_selectedIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() => _selectedIndex = index);
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

// Reusable Widget 1: Header Identitas Praktikan
class IdentityHeaderCard extends StatelessWidget {
  const IdentityHeaderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: const Icon(Icons.badge, color: Colors.blue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                    fontSize: 15,
                  ),
                ),
                Text(
                  'NIM: $studentId • TI Undiksha',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 1. Tampilan Halaman Home
class HomePage extends StatelessWidget {
  final List<CourseItem> courses;
  const HomePage({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    final favCount = courses.where((c) => c.isFavorite).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IdentityHeaderCard(),
          const SizedBox(height: 16),
          Text(
            'Ringkasan Perkuliahan',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.menu_book,
                          color: Colors.blue,
                          size: 30,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${courses.length}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Total Materi'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  color: Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.favorite, color: Colors.red, size: 30),
                        const SizedBox(height: 8),
                        Text(
                          '$favCount',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Favorit'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Card(
            child: ListTile(
              leading: Icon(Icons.touch_app),
              title: Text('Petunjuk Eksplorasi'),
              subtitle: Text(
                'Buka tab Courses untuk melihat adaptive layout (List pada smartphone, Grid pada tablet/landscape), klik item untuk membuka detail dan toggle favorit.',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Reusable Widget 2: Kartu Course dengan Efek Ripple InkWell & Tombol Favorite
class CourseCardItem extends StatelessWidget {
  final CourseItem course;
  final VoidCallback onTap;
  final VoidCallback onFavoritePressed;

  const CourseCardItem({
    super.key,
    required this.course,
    required this.onTap,
    required this.onFavoritePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      course.code.substring(0, 3),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          course.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          course.code,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      course.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: course.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: onFavoritePressed,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(
                      course.status,
                      style: const TextStyle(fontSize: 11),
                    ),
                    padding: EdgeInsets.zero,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const Row(
                    children: [
                      Text(
                        'Detail',
                        style: TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                      Icon(Icons.chevron_right, size: 16, color: Colors.blue),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 2. Tampilan Halaman Courses (Adaptif: List 1 Kolom vs Grid 2 Kolom)
class CoursesPage extends StatelessWidget {
  final List<CourseItem> courses;
  final bool isExpanded;
  final Function(CourseItem) onFavoriteToggle;

  const CoursesPage({
    super.key,
    required this.courses,
    required this.isExpanded,
    required this.onFavoriteToggle,
  });

  void _openDetail(BuildContext context, CourseItem course) async {
    // Navigasi ke halaman detail dengan passing data melalui constructor
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => CourseDetailPage(course: course)),
    );

    // Menerima nilai pop(result) dari halaman detail
    if (result == true) {
      onFavoriteToggle(course);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isExpanded) {
      // Tampilan Grid (Expanded Layout)
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.2,
        ),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return CourseCardItem(
            course: course,
            onTap: () => _openDetail(context, course),
            onFavoritePressed: () => onFavoriteToggle(course),
          );
        },
      );
    }

    // Tampilan List (Compact Layout)
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: SizedBox(
            height: 125,
            child: CourseCardItem(
              course: course,
              onTap: () => _openDetail(context, course),
              onFavoritePressed: () => onFavoriteToggle(course),
            ),
          ),
        );
      },
    );
  }
}

// Halaman Detail Course (Menerima Data via Constructor & Return Data via Navigator.pop)
class CourseDetailPage extends StatelessWidget {
  final CourseItem course;
  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const IdentityHeaderCard(),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kode: ${course.code}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Chip(label: Text(course.status)),
                      ],
                    ),
                    const Divider(height: 24),
                    const Text(
                      'Deskripsi Materi:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      course.description,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton.icon(
                        icon: Icon(
                          course.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        label: Text(
                          course.isFavorite
                              ? 'Hapus dari Favorit'
                              : 'Tandai Favorit',
                        ),
                        onPressed: () {
                          // Mengembalikan nilai true ke halaman sebelumnya
                          Navigator.pop(context, true);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. Tampilan Halaman Profile dengan Form Validasi, Loading, dan Dialog Konfirmasi
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = false;
  String? _submittedText;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _confirmSubmit() {
    if (!_formKey.currentState!.validate()) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kirim Umpan Balik'),
        content: Text(
          'Kirim feedback praktikum atas nama $studentName ($studentId)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              _simulateSubmit();
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  Future<void> _simulateSubmit() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _submittedText = _commentController.text.trim();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Feedback berhasil dikirim oleh $studentName!'),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const IdentityHeaderCard(),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Evaluasi Praktikum Course Explorer',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _commentController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Tulis Komentar / Masukan',
                        hintText: 'Minimal 5 karakter...',
                        border: OutlineInputBorder(),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty)
                          return 'Komentar tidak boleh kosong';
                        if (v.trim().length < 5) return 'Minimal 5 karakter';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    FilledButton(
                      onPressed: _isLoading ? null : _confirmSubmit,
                      child: _isLoading
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Simpan Feedback'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_submittedText != null) ...[
            const SizedBox(height: 16),
            Card(
              color: Colors.green.shade50,
              child: ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: const Text('Tanggapan Berhasil Tersimpan:'),
                subtitle: Text('"${_submittedText!}"'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
