import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/service/block_users_service.dart';
import 'package:app/providers/provider_models/block_user_model.dart';

/// Provider for the BlockUsersService instance
final blockUsersServiceProvider = Provider<BlockUsersService>((ref) {
  return BlockUsersService();
});

/// State class for blocked users
class BlockedUsersState {
  final List<BlockedUser> blockedUsers;
  final Set<int> blockedUserIds;
  final bool isLoading;
  final String? error;

  const BlockedUsersState({
    this.blockedUsers = const [],
    this.blockedUserIds = const {},
    this.isLoading = false,
    this.error,
  });

  BlockedUsersState copyWith({
    List<BlockedUser>? blockedUsers,
    Set<int>? blockedUserIds,
    bool? isLoading,
    String? error,
  }) {
    return BlockedUsersState(
      blockedUsers: blockedUsers ?? this.blockedUsers,
      blockedUserIds: blockedUserIds ?? this.blockedUserIds,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  /// Check if a user is blocked (locally cached)
  bool isBlocked(int userId) => blockedUserIds.contains(userId);

  /// Get blocked users count
  int get count => blockedUsers.length;
}

/// StateNotifier for managing blocked users
class BlockedUsersNotifier extends StateNotifier<BlockedUsersState> {
  final BlockUsersService _service;

  BlockedUsersNotifier(this._service) : super(const BlockedUsersState());

  /// Load blocked users
  Future<void> loadBlockedUsers() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final blockedUsers = await _service.getBlockedUsers();
      final blockedIds = blockedUsers.map((u) => u.blockedUser.id).toSet();

      state = state.copyWith(
        blockedUsers: blockedUsers,
        blockedUserIds: blockedIds,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Block a user
  Future<void> blockUser(int userId) async {
    try {
      await _service.blockUser(userId);

      // Optimistically update the state
      state = state.copyWith(
        blockedUserIds: {...state.blockedUserIds, userId},
      );

      // Refresh the full list
      await loadBlockedUsers();
    } catch (e) {
      rethrow;
    }
  }

  /// Unblock a user
  Future<void> unblockUser(int userId) async {
    try {
      await _service.unblockUser(userId);

      // Optimistically update the state
      final newIds = Set<int>.from(state.blockedUserIds)..remove(userId);
      state = state.copyWith(
        blockedUserIds: newIds,
        blockedUsers: state.blockedUsers
            .where((u) => u.blockedUser.id != userId)
            .toList(),
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Check if user is blocked (with API call if not in cache)
  Future<bool> isUserBlocked(int userId) async {
    // First check local cache
    if (state.blockedUserIds.contains(userId)) {
      return true;
    }

    // If not loaded yet, check via API
    if (state.blockedUsers.isEmpty && !state.isLoading) {
      return _service.isUserBlocked(userId);
    }

    return false;
  }

  /// Refresh blocked users
  Future<void> refresh() async {
    await loadBlockedUsers();
  }
}

/// Provider for blocked users state
final blockedUsersProvider =
    StateNotifierProvider<BlockedUsersNotifier, BlockedUsersState>((ref) {
  final service = ref.watch(blockUsersServiceProvider);
  return BlockedUsersNotifier(service);
});

/// Provider to check if a specific user is blocked
final isUserBlockedProvider = FutureProvider.family<bool, int>((ref, userId) async {
  final service = ref.watch(blockUsersServiceProvider);
  return service.isUserBlocked(userId);
});

/// Provider for blocked users count
final blockedUsersCountProvider = Provider<int>((ref) {
  return ref.watch(blockedUsersProvider).count;
});
