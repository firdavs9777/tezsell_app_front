import 'package:app/providers/provider_models/neighborhood.dart';
import 'package:app/providers/provider_root/verified_neighborhoods_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

VerifiedNeighborhood _v(String id, {DateTime? at, bool low = false}) {
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
    lowConfidence: low,
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('starts empty', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final state = container.read(verifiedNeighborhoodsProvider);
    expect(state, isEmpty);
  });

  test('add() appends a neighborhood, persists', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier =
        container.read(verifiedNeighborhoodsProvider.notifier);
    await notifier.add(_v('UZ:1'));
    expect(container.read(verifiedNeighborhoodsProvider), hasLength(1));

    final container2 = ProviderContainer();
    addTearDown(container2.dispose);
    await container2.read(verifiedNeighborhoodsProvider.notifier).hydrate();
    expect(container2.read(verifiedNeighborhoodsProvider), hasLength(1));
  });

  test('add() enforces max 2', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier =
        container.read(verifiedNeighborhoodsProvider.notifier);
    await notifier.add(_v('UZ:1'));
    await notifier.add(_v('UZ:2'));
    expect(
      () => notifier.add(_v('UZ:3')),
      throwsA(isA<TooManyNeighborhoodsException>()),
    );
    expect(container.read(verifiedNeighborhoodsProvider), hasLength(2));
  });

  test('add() replaces existing entry by id', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier =
        container.read(verifiedNeighborhoodsProvider.notifier);
    final first =
        _v('UZ:1', at: DateTime.now().subtract(const Duration(days: 30)));
    await notifier.add(first);
    final second = _v('UZ:1');
    await notifier.add(second);
    final state = container.read(verifiedNeighborhoodsProvider);
    expect(state, hasLength(1));
    expect(state.first.verifiedAt.isAfter(first.verifiedAt), true);
  });

  test('remove(id) drops entry', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier =
        container.read(verifiedNeighborhoodsProvider.notifier);
    await notifier.add(_v('UZ:1'));
    await notifier.add(_v('UZ:2'));
    await notifier.remove('UZ:1');
    final state = container.read(verifiedNeighborhoodsProvider);
    expect(state, hasLength(1));
    expect(state.first.neighborhood.id, 'UZ:2');
  });

  test('hasExpired returns true if any entry past 60 days', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier =
        container.read(verifiedNeighborhoodsProvider.notifier);
    await notifier
        .add(_v('UZ:1', at: DateTime.now().subtract(const Duration(days: 65))));
    final state = container.read(verifiedNeighborhoodsProvider);
    expect(state.any((v) => v.isExpired), true);
  });
}
