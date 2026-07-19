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

  /// Raw poll payload (question/options/votes shape TBD) — parsed as-is for
  /// now; Task C9 builds the typed poll model + voting UI on top of this.
  final Map<String, dynamic>? poll;

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
      poll: json['poll'] as Map<String, dynamic>?,
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
    Map<String, dynamic>? poll,
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
