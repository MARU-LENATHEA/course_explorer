import 'package:flutter_test/flutter_test.dart';

import 'package:course_explorer/main.dart';

void main() {
  testWidgets('ServiceDemoPage smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Tahap 8: Course Service'), findsOneWidget);
    expect(find.textContaining('2415051046'), findsOneWidget);
  });
}
