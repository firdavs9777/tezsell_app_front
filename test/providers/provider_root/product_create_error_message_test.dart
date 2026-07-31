import 'package:flutter_test/flutter_test.dart';
import 'package:app/providers/provider_root/product_provider.dart';

/// Covers the product-create error path fixed alongside the condition
/// selector: `createProduct` used to only read `List` values out of the
/// backend's `errors` map, silently dropping messages the backend sends as
/// a bare `String` (e.g. `APIResponse.validation_error({'images': str(e)})`
/// for bad image count/size/type). `extractValidationErrorMessage` is the
/// extracted, testable piece of that parsing.
void main() {
  group('extractValidationErrorMessage', () {
    test('extracts the first message from a DRF-style List field', () {
      final message = extractValidationErrorMessage({
        'title': ['This field is required.'],
      });
      expect(message, 'This field is required.');
    });

    test('extracts a bare String field (e.g. image validation errors)', () {
      final message = extractValidationErrorMessage({
        'images': 'You can upload a maximum of 10 images.',
      });
      expect(message, 'You can upload a maximum of 10 images.');
    });

    test('joins messages from multiple fields, List and String mixed', () {
      final message = extractValidationErrorMessage({
        'title': ['This field is required.'],
        'images': 'Image is too large.',
      });
      expect(message, contains('This field is required.'));
      expect(message, contains('Image is too large.'));
    });

    test('falls back when the errors map has no usable messages', () {
      final message = extractValidationErrorMessage({
        'title': <String>[],
      }, fallback: 'Failed to create product');
      expect(message, 'Failed to create product');
    });

    test('ignores an empty String field rather than emitting a blank line', () {
      final message = extractValidationErrorMessage({
        'title': '',
      }, fallback: 'Failed to create product');
      expect(message, 'Failed to create product');
    });
  });
}
