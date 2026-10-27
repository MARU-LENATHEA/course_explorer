import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:course_explorer/main.dart';
import 'package:course_explorer/providers/course_provider.dart';
import 'package:course_explorer/repositories/course_repository.dart';
import 'package:course_explorer/services/course_api_service.dart';

void main() {
  testWidgets('Course Explorer smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<CourseApiService>(create: (_) => CourseApiService()),
          ProxyProvider<CourseApiService, CourseRepository>(
            update: (_, service, _) => CourseRepository(service),
          ),
          ChangeNotifierProxyProvider<CourseRepository, CourseProvider>(
            create: (context) =>
                CourseProvider(context.read<CourseRepository>()),
            update: (_, repository, provider) =>
                provider ?? CourseProvider(repository),
          ),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.textContaining('Course Data Manager'), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.textContaining('2415051046'), findsOneWidget);
  });
}
