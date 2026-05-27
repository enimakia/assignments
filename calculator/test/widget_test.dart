import 'package:flutter_test/flutter_test.dart';

import 'package:calculator/main.dart';

void main() {
  testWidgets('Calculator app smoke test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify key UI elements are present.
    expect(find.text('Simple Calculator'), findsOneWidget);
    expect(find.text('First Number'), findsOneWidget);
    expect(find.text('Second Number'), findsOneWidget);
    expect(find.text('+'), findsOneWidget);
  });
}
