import 'package:app/providers/provider_root/auto_translate_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('autoTranslateProvider', () {
    test('defaults to off', () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(autoTranslateProvider(1)), isFalse);
    });

    test('persists the preference under a per-user key', () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(autoTranslateProvider(7).notifier).set(true);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('chat_auto_translate_7'), isTrue);
    });

    test('restores a stored preference on read', () async {
      SharedPreferences.setMockInitialValues({'chat_auto_translate_7': true});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(autoTranslateProvider(7));
      await Future<void>.delayed(Duration.zero); // let the async load settle

      expect(container.read(autoTranslateProvider(7)), isTrue);
    });

    test('one account does not inherit another account\'s setting', () async {
      SharedPreferences.setMockInitialValues({'chat_auto_translate_7': true});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(autoTranslateProvider(7));
      container.read(autoTranslateProvider(8));
      await Future<void>.delayed(Duration.zero);

      expect(container.read(autoTranslateProvider(7)), isTrue);
      expect(container.read(autoTranslateProvider(8)), isFalse);
    });

    test('toggle flips and persists', () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await container.read(autoTranslateProvider(3).notifier).toggle();
      expect(container.read(autoTranslateProvider(3)), isTrue);

      await container.read(autoTranslateProvider(3).notifier).toggle();
      expect(container.read(autoTranslateProvider(3)), isFalse);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('chat_auto_translate_3'), isFalse);
    });
  });
}
