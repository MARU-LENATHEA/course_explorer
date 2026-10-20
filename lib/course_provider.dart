import 'package:flutter/foundation.dart';

// Identitas Mahasiswa Praktikan
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

class CourseProvider extends ChangeNotifier {
  // Collection untuk menyimpan daftar kode course yang difavoritkan
  final Set<String> favorites = {};

  // Helper untuk mengecek apakah course tertentu sudah favorit
  bool isFavorite(String id) => favorites.contains(id);

  // Method untuk mengubah state favorit dan memberi tahu listener
  void toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
    } else {
      favorites.add(id);
    }
    // Wajib dipanggil agar UI yang mendengarkan ikut diperbarui
    notifyListeners();
  }
}
