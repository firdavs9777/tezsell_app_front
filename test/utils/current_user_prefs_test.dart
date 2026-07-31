import 'package:app/utils/current_user_prefs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('returns null when no userId has been persisted', () async {
    SharedPreferences.setMockInitialValues({});
    expect(await loadCurrentUserIdFromPrefs(), isNull);
  });

  test('parses the persisted userId string into an int', () async {
    SharedPreferences.setMockInitialValues({'userId': '42'});
    expect(await loadCurrentUserIdFromPrefs(), 42);
  });

  test('returns null for a non-numeric persisted value', () async {
    SharedPreferences.setMockInitialValues({'userId': 'not-a-number'});
    expect(await loadCurrentUserIdFromPrefs(), isNull);
  });
}
