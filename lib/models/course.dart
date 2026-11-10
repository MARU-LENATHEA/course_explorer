// Identitas Mahasiswa Praktikan
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;
  // TAMBAHAN PRAKTIK 5: Menyimpan ID pemilik data
  final String? ownerId;

  const Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    this.status = 'planned',
    this.ownerId,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      code: json['code'] as String,
      title: json['title'] as String,
      credits: json['credits'] as int,
      status: (json['status'] as String?) ?? 'planned',
      ownerId: json['owner_id'] as String?, // Ambil dari database
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    'code': code,
    'title': title,
    'credits': credits,
    'status': status,
    if (ownerId != null) 'owner_id': ownerId, // Kirim ke database
  };
}
