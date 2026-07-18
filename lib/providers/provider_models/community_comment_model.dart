class CommunityComment {
  final int id;
  final String text;
  final String userName;
  final DateTime createdAt;

  CommunityComment({
    required this.id,
    required this.text,
    required this.userName,
    required this.createdAt,
  });

  factory CommunityComment.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>? ?? const {};
    return CommunityComment(
      id: json['id'] as int,
      text: json['text'] as String? ?? '',
      userName: user['username'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}
