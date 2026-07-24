/// One option within a [CommunityPoll], with its current vote tally.
///
/// `percent` is served pre-computed by the backend (as an int, may sum to
/// <100 across options due to rounding) — rendered as given, never
/// renormalized client-side.
class CommunityPollOption {
  final int id;
  final String text;
  final int voteCount;
  final int percent;

  const CommunityPollOption({
    required this.id,
    required this.text,
    required this.voteCount,
    required this.percent,
  });

  factory CommunityPollOption.fromJson(Map<String, dynamic> json) {
    return CommunityPollOption(
      id: json['id'] as int,
      text: json['text'] as String? ?? '',
      voteCount: json['vote_count'] as int? ?? 0,
      percent: json['percent'] as int? ?? 0,
    );
  }

  CommunityPollOption copyWith({int? voteCount, int? percent}) {
    return CommunityPollOption(
      id: id,
      text: text,
      voteCount: voteCount ?? this.voteCount,
      percent: percent ?? this.percent,
    );
  }
}

/// A poll attached to a [CommunityPost]. `myOptionId` is null when the
/// signed-in user hasn't voted yet; voting (or revoting, which simply
/// changes the option) always returns a full, fresh [CommunityPoll].
class CommunityPoll {
  final String question;
  final int totalVotes;
  final int? myOptionId;
  final List<CommunityPollOption> options;

  const CommunityPoll({
    required this.question,
    required this.totalVotes,
    required this.myOptionId,
    required this.options,
  });

  factory CommunityPoll.fromJson(Map<String, dynamic> json) {
    final options = (json['options'] as List?) ?? const [];
    return CommunityPoll(
      question: json['question'] as String? ?? '',
      totalVotes: json['total_votes'] as int? ?? 0,
      myOptionId: json['my_option_id'] as int?,
      options: options
          .map((e) => CommunityPollOption.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  CommunityPoll copyWith({
    int? totalVotes,
    int? myOptionId,
    List<CommunityPollOption>? options,
  }) {
    return CommunityPoll(
      question: question,
      totalVotes: totalVotes ?? this.totalVotes,
      myOptionId: myOptionId ?? this.myOptionId,
      options: options ?? this.options,
    );
  }

  /// Pure math for an optimistic vote/revote: builds a locally-adjusted
  /// poll so the UI can reflect a new vote immediately, without waiting on
  /// the network round-trip. Percents are recomputed from the adjusted
  /// counts; the server's response (which wins once it lands) is the
  /// source of truth.
  ///
  /// - First vote (no prior [myOptionId]): total votes +1, the chosen
  ///   option's count +1.
  /// - Switched vote (prior [myOptionId] differs from [optionId]): total
  ///   votes unchanged, old option's count -1, new option's count +1.
  /// - Same option tapped again: returns `this` unchanged.
  CommunityPoll optimisticVote(int optionId) {
    final previousOptionId = myOptionId;
    if (previousOptionId == optionId) return this;

    final addedFirstVote = previousOptionId == null;
    final newTotal = addedFirstVote ? totalVotes + 1 : totalVotes;

    final adjustedOptions = options.map((o) {
      var count = o.voteCount;
      if (o.id == previousOptionId) count -= 1;
      if (o.id == optionId) count += 1;
      final percent = newTotal > 0 ? ((count * 100) / newTotal).round() : 0;
      return o.copyWith(voteCount: count, percent: percent);
    }).toList();

    return copyWith(
      totalVotes: newTotal,
      myOptionId: optionId,
      options: adjustedOptions,
    );
  }
}

class CommunityPost {
  final int id;
  final String category;
  final String body;
  final int authorId;
  final String authorName;
  final String? regionName;
  final List<String> imageUrls;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final DateTime createdAt;
  final int viewCount;
  final bool isEdited;

  /// The post's poll, if any — question, per-option tallies/percents, and
  /// the signed-in user's current vote (`null` when they haven't voted).
  final CommunityPoll? poll;

  CommunityPost({
    required this.id,
    required this.category,
    required this.body,
    required this.authorId,
    required this.authorName,
    required this.regionName,
    required this.imageUrls,
    required this.likeCount,
    required this.commentCount,
    required this.isLiked,
    required this.createdAt,
    this.viewCount = 0,
    this.isEdited = false,
    this.poll,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) {
    final author = json['author'] as Map<String, dynamic>? ?? const {};
    final images = (json['images'] as List?) ?? const [];
    return CommunityPost(
      id: json['id'] as int,
      category: json['category'] as String? ?? 'general',
      body: json['body'] as String? ?? '',
      authorId: author['id'] as int? ?? 0,
      authorName: author['username'] as String? ?? '',
      regionName: json['region_name'] as String?,
      imageUrls: images
          .map((e) => (e as Map<String, dynamic>)['image'] as String?)
          .whereType<String>()
          .toList(),
      likeCount: json['like_count'] as int? ?? 0,
      commentCount: json['comment_count'] as int? ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      viewCount: json['view_count'] as int? ?? 0,
      isEdited: json['is_edited'] as bool? ?? false,
      poll: json['poll'] != null
          ? CommunityPoll.fromJson(json['poll'] as Map<String, dynamic>)
          : null,
    );
  }

  CommunityPost copyWith({
    String? category,
    String? body,
    int? likeCount,
    bool? isLiked,
    int? commentCount,
    int? viewCount,
    bool? isEdited,
    CommunityPoll? poll,
  }) {
    return CommunityPost(
      id: id,
      category: category ?? this.category,
      body: body ?? this.body,
      authorId: authorId,
      authorName: authorName,
      regionName: regionName,
      imageUrls: imageUrls,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt,
      viewCount: viewCount ?? this.viewCount,
      isEdited: isEdited ?? this.isEdited,
      poll: poll ?? this.poll,
    );
  }
}
