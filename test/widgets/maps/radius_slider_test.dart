import 'package:app/providers/provider_root/radius_provider.dart';
import 'package:app/widgets/maps/radius_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('renders preset chips and city option', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: RadiusSlider())),
      ),
    );
    await tester.pump();
    expect(find.text('1 km'), findsOneWidget);
    expect(find.text('3 km'), findsOneWidget);
    expect(find.text('5 km'), findsOneWidget);
    expect(find.text('10 km'), findsOneWidget);
    expect(find.text('City'), findsOneWidget);
  });

  testWidgets('tap chip updates radiusProvider', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: RadiusSlider())),
      ),
    );
    await tester.tap(find.text('5 km'));
    await tester.pumpAndSettle();
    expect(container.read(radiusProvider), 5.0);
  });
}
