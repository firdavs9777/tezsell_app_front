import 'package:app/providers/provider_models/transaction_model.dart';
import 'package:flutter_test/flutter_test.dart';

/// `Transaction.isBuyerFor` drives the pending-reviews nudge on the own
/// profile page (E4): it decides whether a tapped transaction routes the
/// current user into the write-review screen as the buyer or the seller.
void main() {
  Transaction buildTransaction({int seller = 3, int buyer = 2}) {
    return Transaction(
      id: 1,
      seller: seller,
      sellerName: 'Alice',
      buyer: buyer,
      buyerName: 'Bob',
      itemType: 'product',
      itemTitle: 'Bike',
      status: 'completed',
      canReview: true,
      createdAt: DateTime(2026, 1, 1),
    );
  }

  group('Transaction.isBuyerFor', () {
    test('returns true when the given id is the buyer', () {
      final t = buildTransaction();
      expect(t.isBuyerFor(2), isTrue);
    });

    test('returns false when the given id is the seller', () {
      final t = buildTransaction();
      expect(t.isBuyerFor(3), isFalse);
    });

    test('returns null for an id that is neither party', () {
      final t = buildTransaction();
      expect(t.isBuyerFor(999), isNull);
    });

    test('returns null when the id is null', () {
      final t = buildTransaction();
      expect(t.isBuyerFor(null), isNull);
    });
  });
}
