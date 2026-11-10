import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/course_provider.dart';
import '../widgets/course_card.dart';
import '../widgets/error_view.dart';
import 'course_detail_page.dart';
import 'course_form_page.dart';

// --- IMPORT AUTH & PROFILE SERVICES ---
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../pages/login_page.dart';

// --------------------------------------

// UBAHAN PRAKTIK 3: Mengubah menjadi StatefulWidget untuk load profil
class CourseListPage extends StatefulWidget {
  const CourseListPage({super.key});

  @override
  State<CourseListPage> createState() => _CourseListPageState();
}

class _CourseListPageState extends State<CourseListPage> {
  UserProfile? _profile;
  bool _isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Fungsi untuk menarik data profil dari Supabase
  Future<void> _loadProfile() async {
    try {
      final profile = await ProfileService().getMyProfile();
      if (mounted) {
        setState(() {
          _profile = profile;
          _isLoadingProfile = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingProfile = false);
    }
  }

  Future<void> _confirmDelete(BuildContext context, Course course) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus course "${course.title}" (${course.code}) dari database?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    if (!context.mounted) return;

    try {
      await context.read<CourseProvider>().deleteCourse(course);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Course "${course.title}" berhasil dihapus!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus course: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    // Cek apakah user yang sedang login memiliki role 'owner'
    final bool isOwner = _profile?.isOwner ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Data Manager'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
            onPressed: () {
              context.read<CourseProvider>().loadCourses();
              _loadProfile(); // Refresh profil juga
            },
          ),
          IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await AuthService.instance.logout();
            },
          ),
        ],
      ),

      // Tampilkan FAB Tambah Course HANYA jika dia Owner
      floatingActionButton: isOwner
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CourseFormPage()),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Course'),
            )
          : null,

      body: Column(
        children: [
          // Header Profil Dinamis
          if (!_isLoadingProfile && _profile != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person_pin, color: Colors.blue, size: 36),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_profile!.name} (${_profile!.role.toUpperCase()})',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _profile!.email,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.blueGrey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          Expanded(
            child: Builder(
              builder: (_) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.error != null) {
                  return ErrorView(
                    message: provider.error!,
                    onRetry: () => context.read<CourseProvider>().loadCourses(),
                  );
                }
                if (provider.courses.isEmpty) {
                  return const Center(
                    child: Text('Data course belum tersedia di database'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: provider.courses.length,
                  itemBuilder: (context, index) {
                    final Course course = provider.courses[index];
                    return CourseCard(
                      course: course,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CourseDetailPage(course: course),
                          ),
                        );
                      },
                      // Kirim fungsi edit/delete HANYA jika dia Owner
                      // Jika seeker, berikan null agar tombol di-disable/disembunyikan oleh Card
                      onEdit: isOwner
                          ? () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      CourseFormPage(course: course),
                                ),
                              );
                            }
                          : null,
                      onDelete: isOwner
                          ? () => _confirmDelete(context, course)
                          : null,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
