import 'package:flutter_test/flutter_test.dart';
// Sesuaikan import path project Anda jika berbeda
import 'package:course_explorer/providers/course_provider.dart';
import 'package:course_explorer/repositories/course_repository.dart';
import 'package:course_explorer/services/course_api_service.dart';

// Identitas Mahasiswa Praktikan
const String studentName = 'I Kadek Dimas Pradana';
const String studentId = '2415051046';

void main() {
  group('CourseProvider Unit Tests ($studentId - $studentName)', () {
    late CourseProvider courseProvider;
    late CourseRepository courseRepository;

    setUp(() {
      courseRepository = CourseRepository(CourseApiService());
      courseProvider = CourseProvider(courseRepository);
    });

    test('Initial favorites set should be empty', () {
      expect(courseProvider.favorites.isEmpty, true);
    });

    test(
      'Toggle favorite should add and remove course id from favorites set',
      () {
        const testCourseCode = 'MOB06';

        // Uji penambahan ke favorite
        courseProvider.toggleFavorite(testCourseCode);
        expect(courseProvider.isFavorite(testCourseCode), true);
        expect(courseProvider.favorites.contains(testCourseCode), true);

        // Uji penghapusan dari favorite
        courseProvider.toggleFavorite(testCourseCode);
        expect(courseProvider.isFavorite(testCourseCode), false);
        expect(courseProvider.favorites.contains(testCourseCode), false);
      },
    );
  });
}
