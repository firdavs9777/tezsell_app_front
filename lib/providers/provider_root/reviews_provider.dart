import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../service/reviews_service.dart';
import '../provider_models/trust_score_model.dart';
import '../provider_models/transaction_model.dart';
import '../provider_models/review_model.dart';

// ==================== Trust Score Provider ====================

class TrustScoreState {
  final TrustScore? trustScore;
  final bool isLoading;
  final String? error;

  TrustScoreState({
    this.trustScore,
    this.isLoading = false,
    this.error,
  });

  TrustScoreState copyWith({
    TrustScore? trustScore,
    bool? isLoading,
    String? error,
  }) {
    return TrustScoreState(
      trustScore: trustScore ?? this.trustScore,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TrustScoreNotifier extends StateNotifier<TrustScoreState> {
  final ReviewsService _service;

  TrustScoreNotifier(this._service) : super(TrustScoreState());

  Future<void> fetchTrustScore(int userId) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final trustScore = await _service.getTrustScore(userId);
      state = state.copyWith(
        trustScore: trustScore,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void clearTrustScore() {
    state = TrustScoreState();
  }
}

// ==================== Transactions Provider ====================

class TransactionsState {
  final List<Transaction> transactions;
  final bool isLoading;
  final String? error;
  final String? roleFilter; // 'buyer' or 'seller'
  final String? statusFilter;

  TransactionsState({
    this.transactions = const [],
    this.isLoading = false,
    this.error,
    this.roleFilter,
    this.statusFilter,
  });

  TransactionsState copyWith({
    List<Transaction>? transactions,
    bool? isLoading,
    String? error,
    String? roleFilter,
    String? statusFilter,
  }) {
    return TransactionsState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      roleFilter: roleFilter ?? this.roleFilter,
      statusFilter: statusFilter ?? this.statusFilter,
    );
  }

  List<Transaction> get filteredTransactions {
    var result = transactions;

    if (roleFilter != null) {
      result = result.where((t) {
        if (roleFilter == 'buyer') return t.buyer != null;
        if (roleFilter == 'seller') return t.seller != null;
        return true;
      }).toList();
    }

    if (statusFilter != null) {
      result = result.where((t) => t.status == statusFilter).toList();
    }

    return result;
  }

  List<Transaction> get pendingTransactions =>
      transactions.where((t) => t.status == TransactionStatus.pending).toList();

  List<Transaction> get completedTransactions =>
      transactions.where((t) => t.status == TransactionStatus.completed).toList();

  List<Transaction> get awaitingReview =>
      transactions.where((t) => t.canReview).toList();
}

class TransactionsNotifier extends StateNotifier<TransactionsState> {
  final ReviewsService _service;

  TransactionsNotifier(this._service) : super(TransactionsState());

  Future<void> fetchTransactions({String? role, String? status}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final transactions = await _service.getMyTransactions(
        role: role,
        status: status,
      );
      state = state.copyWith(
        transactions: transactions,
        isLoading: false,
        roleFilter: role,
        statusFilter: status,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<Transaction?> createTransaction({
    required int sellerId,
    required String itemType,
    required int itemId,
    int? chatRoomId,
  }) async {
    try {
      final transaction = await _service.createTransaction(
        sellerId: sellerId,
        itemType: itemType,
        itemId: itemId,
        chatRoomId: chatRoomId,
      );

      if (transaction != null) {
        state = state.copyWith(
          transactions: [transaction, ...state.transactions],
        );
      }

      return transaction;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  Future<Transaction?> updateTransaction({
    required int transactionId,
    required String status,
    String? agreedPrice,
  }) async {
    try {
      final updated = await _service.updateTransaction(
        transactionId: transactionId,
        status: status,
        agreedPrice: agreedPrice,
      );

      if (updated != null) {
        final updatedList = state.transactions.map((t) {
          return t.id == transactionId ? updated : t;
        }).toList();
        state = state.copyWith(transactions: updatedList);
      }

      return updated;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  void setRoleFilter(String? role) {
    state = state.copyWith(roleFilter: role);
  }

  void setStatusFilter(String? status) {
    state = state.copyWith(statusFilter: status);
  }

  void clearFilters() {
    state = state.copyWith(roleFilter: null, statusFilter: null);
  }
}

// ==================== Reviews Provider ====================

class ReviewsState {
  final List<Review> reviews;
  final ReviewSummary? summary;
  final bool isLoading;
  final String? error;
  final String reviewType; // 'received' or 'given'

  ReviewsState({
    this.reviews = const [],
    this.summary,
    this.isLoading = false,
    this.error,
    this.reviewType = 'received',
  });

  ReviewsState copyWith({
    List<Review>? reviews,
    ReviewSummary? summary,
    bool? isLoading,
    String? error,
    String? reviewType,
  }) {
    return ReviewsState(
      reviews: reviews ?? this.reviews,
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      reviewType: reviewType ?? this.reviewType,
    );
  }

  double get averageRating => summary?.averageRating ?? 0.0;
  int get totalReviews => summary?.totalReviews ?? reviews.length;
}

class ReviewsNotifier extends StateNotifier<ReviewsState> {
  final ReviewsService _service;

  ReviewsNotifier(this._service) : super(ReviewsState());

  Future<void> fetchUserReviews(int userId, {String type = 'received'}) async {
    state = state.copyWith(isLoading: true, error: null, reviewType: type);

    try {
      final result = await _service.getUserReviews(userId, type: type);
      state = state.copyWith(
        reviews: result['reviews'] as List<Review>? ?? [],
        summary: result['summary'] as ReviewSummary?,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<Review?> submitReview({
    required int transactionId,
    required int rating,
    String? reviewText,
    List<String> tags = const [],
  }) async {
    try {
      final review = await _service.submitReview(
        transactionId: transactionId,
        rating: rating,
        reviewText: reviewText,
        tags: tags,
      );

      if (review != null) {
        state = state.copyWith(
          reviews: [review, ...state.reviews],
        );
      }

      return review;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  void setReviewType(String type) {
    state = state.copyWith(reviewType: type);
  }

  void clearReviews() {
    state = ReviewsState();
  }
}

// ==================== Review Tags Provider ====================

class ReviewTagsNotifier extends StateNotifier<List<ReviewTag>> {
  final ReviewsService _service;

  ReviewTagsNotifier(this._service) : super([]);

  Future<void> fetchTags({bool? forBuyer, bool? forSeller}) async {
    try {
      final tags = await _service.getReviewTags(
        forBuyer: forBuyer,
        forSeller: forSeller,
      );
      state = tags;
    } catch (e) {
      // Fallback to predefined tags
      state = ReviewTags.all;
    }
  }

  List<ReviewTag> get positiveTags =>
      state.where((t) => t.isPositive).toList();

  List<ReviewTag> get negativeTags =>
      state.where((t) => !t.isPositive).toList();

  List<ReviewTag> getTagsForRole({required bool isBuyer}) {
    return state.where((t) {
      if (isBuyer) return t.forBuyer;
      return t.forSeller;
    }).toList();
  }
}

// ==================== Badges Provider ====================

class BadgesNotifier extends StateNotifier<List<UserBadge>> {
  final ReviewsService _service;

  BadgesNotifier(this._service) : super([]);

  Future<void> fetchBadges() async {
    try {
      final badges = await _service.getAvailableBadges();
      state = badges;
    } catch (e) {
      // Keep current state on error
    }
  }
}

// ==================== Providers ====================

final reviewsServiceProvider = Provider<ReviewsService>((ref) {
  return ReviewsService();
});

final trustScoreProvider =
    StateNotifierProvider<TrustScoreNotifier, TrustScoreState>((ref) {
  final service = ref.watch(reviewsServiceProvider);
  return TrustScoreNotifier(service);
});

final transactionsProvider =
    StateNotifierProvider<TransactionsNotifier, TransactionsState>((ref) {
  final service = ref.watch(reviewsServiceProvider);
  return TransactionsNotifier(service);
});

final reviewsProvider =
    StateNotifierProvider<ReviewsNotifier, ReviewsState>((ref) {
  final service = ref.watch(reviewsServiceProvider);
  return ReviewsNotifier(service);
});

final reviewTagsProvider =
    StateNotifierProvider<ReviewTagsNotifier, List<ReviewTag>>((ref) {
  final service = ref.watch(reviewsServiceProvider);
  final notifier = ReviewTagsNotifier(service);
  notifier.fetchTags();
  return notifier;
});

final badgesProvider =
    StateNotifierProvider<BadgesNotifier, List<UserBadge>>((ref) {
  final service = ref.watch(reviewsServiceProvider);
  final notifier = BadgesNotifier(service);
  notifier.fetchBadges();
  return notifier;
});

// Family providers for fetching specific user data
final userTrustScoreProvider =
    FutureProvider.family<TrustScore, int>((ref, userId) async {
  final service = ref.watch(reviewsServiceProvider);
  return service.getTrustScore(userId);
});

final userReviewsProvider =
    FutureProvider.family<Map<String, dynamic>, int>((ref, userId) async {
  final service = ref.watch(reviewsServiceProvider);
  return service.getUserReviews(userId);
});
