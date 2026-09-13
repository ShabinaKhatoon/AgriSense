import 'package:flutter_test/flutter_test.dart';

import 'package:agrisense/main.dart';

void main() {
  testWidgets('AgriSense app starts at farmer login', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const AgriSenseApp());

    expect(find.byType(AgriSenseApp), findsOneWidget);
    expect(find.text('Farmer Login'), findsOneWidget);
    expect(find.text('AgriSense'), findsOneWidget);
  });
}
