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
    );
  }

  CommunityPost copyWith({int? likeCount, bool? isLiked, int? commentCount}) {
    return CommunityPost(
      id: id,
      category: category,
      body: body,
      authorId: authorId,
      authorName: authorName,
      regionName: regionName,
      imageUrls: imageUrls,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt,
    );
  }
}
