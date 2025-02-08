import 'package:app/providers/provider_models/user_model.dart';

class Comment {
  const Comment({
    required this.id,
    required this.user,
    required this.text,
    required this.createdAt,
  });

  final int id;
  final UserInfo user;
  final String text;
  final DateTime createdAt;

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      user: UserInfo.fromJson(json['user']),
      text: json['text'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
