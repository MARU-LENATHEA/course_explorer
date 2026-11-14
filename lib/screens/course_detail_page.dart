import 'package:flutter/material.dart';

import '../models/course.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';
import '../widgets/role_guard.dart';
import 'course_form_page.dart';

class CourseDetailPage extends StatelessWidget {
  final Course course;

  const CourseDetailPage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    // Ambil UID user yang sedang login saat ini
    final String? currentUserId = AuthService.instance.currentUser?.id;
    // Cek kepemilikan
    final bool isMine = course.ownerId == currentUserId;

    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fitur favorit belum diimplementasikan'),
                ),
              );
            },
          ),
          // Ikon Edit dilindungi RoleGuard DAN logika isMine
          FutureBuilder<UserProfile?>(
            future: ProfileService().getMyProfile(),
            builder: (context, snapshot) {
              final role = snapshot.data?.role ?? 'seeker';

              // Jika role-nya owner/admin tapi course ini bukan miliknya,
              // paksa anggap sebagai seeker agar tombolnya hilang
              final effectiveRole = (isMine) ? role : 'seeker';

              return RoleGuard(
                role: effectiveRole,
                allowed: const ['owner', 'admin'],
                child: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CourseFormPage(course: course),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'ID Database: ${course.id ?? '-'}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Divider(),
                ),
                _buildDetailRow('Kode Kos', course.code),
                const SizedBox(height: 16),
                _buildDetailRow('Kapasitas Kamar', '${course.credits} Kamar'),
                const SizedBox(height: 16),
                _buildDetailRow('Status', course.status.toUpperCase()),
                const SizedBox(height: 16),
                _buildDetailRow('Tersimpan di Favorit', 'Tidak'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, color: Colors.grey)),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
