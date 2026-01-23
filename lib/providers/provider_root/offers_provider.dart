import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/service/offers_service.dart';
import 'package:app/providers/provider_models/offer_model.dart';

/// Provider for the OffersService instance
final offersServiceProvider = Provider<OffersService>((ref) {
  return OffersService();
});

/// State class for offers
class OffersState {
  final List<Offer> offers;
  final List<Offer> buyerOffers;
  final List<Offer> sellerOffers;
  final bool isLoading;
  final String? error;
  final int pendingCount;

  const OffersState({
    this.offers = const [],
    this.buyerOffers = const [],
    this.sellerOffers = const [],
    this.isLoading = false,
    this.error,
    this.pendingCount = 0,
  });

  OffersState copyWith({
    List<Offer>? offers,
    List<Offer>? buyerOffers,
    List<Offer>? sellerOffers,
    bool? isLoading,
    String? error,
    int? pendingCount,
  }) {
    return OffersState(
      offers: offers ?? this.offers,
      buyerOffers: buyerOffers ?? this.buyerOffers,
      sellerOffers: sellerOffers ?? this.sellerOffers,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      pendingCount: pendingCount ?? this.pendingCount,
    );
  }

  /// Get pending offers for seller
  List<Offer> get pendingSellerOffers =>
      sellerOffers.where((o) => o.status == OfferStatus.pending).toList();

  /// Get countered offers for buyer
  List<Offer> get counteredBuyerOffers =>
      buyerOffers.where((o) => o.status == OfferStatus.countered).toList();
}

/// StateNotifier for managing offers
class OffersNotifier extends StateNotifier<OffersState> {
  final OffersService _service;

  OffersNotifier(this._service) : super(const OffersState());

  /// Load all offers
  Future<void> loadOffers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final offers = await _service.getOffers();
      final buyerOffers = await _service.getOffers(role: 'buyer');
      final sellerOffers = await _service.getOffers(role: 'seller');
      final pendingCount = await _service.getPendingOffersCount();

      state = state.copyWith(
        offers: offers,
        buyerOffers: buyerOffers,
        sellerOffers: sellerOffers,
        pendingCount: pendingCount,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Create a new offer
  Future<Offer> createOffer(CreateOfferRequest request) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final offer = await _service.createOffer(request);
      await loadOffers(); // Refresh the list
      return offer;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  /// Accept an offer (seller)
  Future<Offer> acceptOffer(int offerId) async {
    final request = const OfferResponseRequest(action: 'accept');
    final offer = await _service.respondToOffer(offerId, request);
    await loadOffers();
    return offer;
  }

  /// Decline an offer (seller)
  Future<Offer> declineOffer(int offerId, {String? reason}) async {
    final request = OfferResponseRequest(
      action: 'decline',
      declineReason: reason,
    );
    final offer = await _service.respondToOffer(offerId, request);
    await loadOffers();
    return offer;
  }

  /// Counter an offer (seller)
  Future<Offer> counterOffer(
    int offerId, {
    required double counterAmount,
    String? message,
  }) async {
    final request = OfferResponseRequest(
      action: 'counter',
      counterAmount: counterAmount,
      counterMessage: message,
    );
    final offer = await _service.respondToOffer(offerId, request);
    await loadOffers();
    return offer;
  }

  /// Accept a counter offer (buyer)
  Future<Offer> acceptCounterOffer(int offerId) async {
    final offer = await _service.acceptCounterOffer(offerId);
    await loadOffers();
    return offer;
  }

  /// Cancel an offer (buyer)
  Future<void> cancelOffer(int offerId) async {
    await _service.cancelOffer(offerId);
    await loadOffers();
  }

  /// Refresh offers
  Future<void> refresh() async {
    await loadOffers();
  }
}

/// Provider for offers state
final offersProvider = StateNotifierProvider<OffersNotifier, OffersState>((ref) {
  final service = ref.watch(offersServiceProvider);
  return OffersNotifier(service);
});

/// Provider for pending offers count
final pendingOffersCountProvider = Provider<int>((ref) {
  return ref.watch(offersProvider).pendingCount;
});

/// Provider for a specific offer by ID
final offerDetailsProvider = FutureProvider.family<Offer, int>((ref, offerId) async {
  final service = ref.watch(offersServiceProvider);
  return service.getOfferDetails(offerId);
});
