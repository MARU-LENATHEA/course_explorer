class Course {
  final String id;
  final String title;
  final String code;
  final String status;
  final String description;
  final int credits;
  bool isFavorite;

  Course({
    required this.id,
    required this.title,
    required this.code,
    required this.status,
    required this.description,
    required this.credits,
    this.isFavorite = false,
  });
}
