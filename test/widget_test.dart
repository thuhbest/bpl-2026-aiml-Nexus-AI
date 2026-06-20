import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nexus_ai/main.dart';

void main() {
  testWidgets('Counter value smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const NexusAiApp());

    // Verify that our navigation items exist.
    expect(find.byIcon(Icons.explore_outlined), findsOneWidget);
    expect(find.byIcon(Icons.psychology_outlined), findsOneWidget);
    expect(find.byIcon(Icons.school_outlined), findsOneWidget);
  });
}