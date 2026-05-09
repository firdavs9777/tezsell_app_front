import 'package:app/providers/provider_root/radius_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('default radius is 3km', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(radiusProvider), 3.0);
  });

  test('setRadius persists', () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    await c.read(radiusProvider.notifier).set(5.0);
    expect(c.read(radiusProvider), 5.0);

    final c2 = ProviderContainer();
    addTearDown(c2.dispose);
    await c2.read(radiusProvider.notifier).hydrate();
    expect(c2.read(radiusProvider), 5.0);
  });

  test('city = double.infinity sentinel', () async {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    await c.read(radiusProvider.notifier).set(double.infinity);
    expect(c.read(radiusProvider), double.infinity);
  });
}
