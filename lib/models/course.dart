class Course {
  final String? id;
  final String title;
  final String code;
  final String status;
  final String? description;
  final int credits;
  bool isFavorite;

  Course({
    this.id,
    required this.title,
    required this.code,
    required this.status,
    this.description,
    required this.credits,
    this.isFavorite = false,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id']?.toString(),
      title: json['title'] as String,
      code: json['code'] as String,
      status: json['status'] as String,
      description: json['description'] as String?,
      credits: json['credits'] as int,
      isFavorite: json['isFavorite'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'code': code,
      'status': status,
      if (description != null) 'description': description,
      'credits': credits,
      'isFavorite': isFavorite,
    };
  }
}
