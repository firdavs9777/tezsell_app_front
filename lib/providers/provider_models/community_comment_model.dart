class CommunityComment {
  final int id;
  final int userId;
  final String text;
  final String userName;
  final DateTime createdAt;
  final int likeCount;
  final bool isLiked;
  final int replyCount;

  /// Nested replies to this (top-level) comment, one level deep, in
  /// chronological order. Always empty for a reply itself.
  final List<CommunityComment> replies;

  CommunityComment({
    required this.id,
    required this.text,
    required this.userName,
    required this.createdAt,
    this.userId = 0,
    this.likeCount = 0,
    this.isLiked = false,
    this.replyCount = 0,
    this.replies = const [],
  });

  factory CommunityComment.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? const {};
    final repliesJson = (json['replies'] as List?) ?? const [];
    final replies = repliesJson
        .map((e) => CommunityComment.fromJson(e as Map<String, dynamic>))
        .toList();
    return CommunityComment(
      id: json['id'] as int,
      userId: user['id'] as int? ?? 0,
      text: json['text'] as String? ?? '',
      userName: user['username'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      likeCount: json['like_count'] as int? ?? 0,
      isLiked: json['is_liked'] as bool? ?? false,
      replyCount: json['reply_count'] as int? ?? replies.length,
      replies: replies,
    );
  }

  CommunityComment copyWith({
    int? likeCount,
    bool? isLiked,
    int? replyCount,
    List<CommunityComment>? replies,
  }) {
    return CommunityComment(
      id: id,
      userId: userId,
      text: text,
      userName: userName,
      createdAt: createdAt,
      likeCount: likeCount ?? this.likeCount,
      isLiked: isLiked ?? this.isLiked,
      replyCount: replyCount ?? this.replyCount,
      replies: replies ?? this.replies,
    );
  }
}
