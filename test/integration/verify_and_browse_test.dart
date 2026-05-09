// Phase-1 integration: verify-neighborhood flow → products tab gate → list
// reload triggered by activeNeighborhood change.
//
// Doesn't need the integration_test driver — exercises the Riverpod state
// graph + the NeighborhoodGate widget at the test-pump level.

import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_root/active_neighborhood_provider.dart';
import 'package:app/providers/provider_root/radius_provider.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:app/widgets/maps/radius_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

VerifiedNeighborhood _v(String id, {DateTime? at}) {
  return VerifiedNeighborhood(
    neighborhood: Neighborhood(
      id: id,
      name: id,
      displayName: id,
      countryCode: 'UZ',
      region: 'r',
      city: 'c',
      centroidLat: 0,
      centroidLng: 0,
    ),
    verifiedAt: at ?? DateTime.now(),
    gpsAccuracyM: 50,
  );
}

/// Lightweight stand-in for the real NeighborhoodGate in tab_bar.dart —
/// avoids importing the full TabsScreen scaffold for the integration test.
class _TestGate extends ConsumerWidget {
  const _TestGate({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(verifiedNeighborhoodsProvider);
    final allExpired = list.isNotEmpty && list.every((v) => v.isExpired);
    if (list.isEmpty || allExpired) {
      return const Scaffold(
        body: Center(child: Text('Verify your neighborhood')),
      );
    }
    return child;
  }
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('gate blocks until a neighborhood is verified', (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: _TestGate(
            child: Scaffold(body: Center(child: Text('PRODUCTS LIST'))),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Verify your neighborhood'), findsOneWidget);
    expect(find.text('PRODUCTS LIST'), findsNothing);

    // Simulate verification by adding a neighborhood
    await container
        .read(verifiedNeighborhoodsProvider.notifier)
        .add(_v('UZ:1'));
    await tester.pump();

    expect(find.text('Verify your neighborhood'), findsNothing);
    expect(find.text('PRODUCTS LIST'), findsOneWidget);
  });

  testWidgets(
      'all-expired: gate re-blocks; new (fresh) verification re-opens',
      (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // Seed with one expired entry
    await container.read(verifiedNeighborhoodsProvider.notifier).add(
          _v('UZ:1', at: DateTime.now().subtract(const Duration(days: 65))),
        );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: _TestGate(
            child: Scaffold(body: Center(child: Text('PRODUCTS LIST'))),
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Verify your neighborhood'), findsOneWidget);

    // Re-verify (same id replaces with fresh verifiedAt)
    await container
        .read(verifiedNeighborhoodsProvider.notifier)
        .add(_v('UZ:1'));
    await tester.pump();

    expect(find.text('PRODUCTS LIST'), findsOneWidget);
  });

  testWidgets('radius slider drives radiusProvider; chip switches active',
      (tester) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await container
        .read(verifiedNeighborhoodsProvider.notifier)
        .add(_v('UZ:A'));
    await container
        .read(verifiedNeighborhoodsProvider.notifier)
        .add(_v('UZ:B'));

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: Scaffold(body: RadiusSlider()),
        ),
      ),
    );
    await tester.pump();

    expect(container.read(radiusProvider), 3.0); // default
    await tester.tap(find.text('5 km'));
    await tester.pumpAndSettle();
    expect(container.read(radiusProvider), 5.0);

    // Active neighborhood index defaults to 0 → first verified
    final active1 = container.read(activeNeighborhoodProvider);
    expect(active1!.neighborhood.id, 'UZ:A');

    container.read(activeNeighborhoodIndexProvider.notifier).state = 1;
    final active2 = container.read(activeNeighborhoodProvider);
    expect(active2!.neighborhood.id, 'UZ:B');
  });
}
