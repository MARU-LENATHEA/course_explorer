import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:course_explorer/course_provider.dart';
import 'package:course_explorer/main.dart';

void main() {
  testWidgets('ProviderSetupDemoPage smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => CourseProvider(),
        child: const MyApp(),
      ),
    );

    expect(find.text('Tahap 6: Provider Setup'), findsOneWidget);
    expect(find.textContaining('Praktikan:'), findsOneWidget);
  });
}
