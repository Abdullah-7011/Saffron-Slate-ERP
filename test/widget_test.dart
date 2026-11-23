import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:saffron_slate/main.dart';

void main() {
  testWidgets('Saffron & Slate tablet and mobile layout test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const SaffronAndSlateApp());
    await tester.pumpAndSettle();

    expect(find.text('Saffron & Slate'), findsWidgets);
    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Total Orders'), findsWidgets);
    expect(find.text('Total Income'), findsWidgets);
    expect(find.text('Net Profit'), findsWidgets);
  });
}
