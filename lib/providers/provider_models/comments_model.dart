import 'package:app/providers/provider_models/replies_model.dart';
import 'package:app/providers/provider_models/user_model.dart';

class Comments {
  const Comments({
    required this.id,
    required this.text,
    required this.serviceId,
    required this.user,
    required this.createdAt,
    this.repliesCount = 0,
    this.replies,
  });

  final int id;
  final String text;
  final UserInfo user;
  final int serviceId;
  final String createdAt;
  final int repliesCount;
  final List<Reply>? replies;

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
      id: json['id'] ?? 0,
      text: json['text'] ?? '',
      user: UserInfo.fromJson(json['user'] ?? {}),
      serviceId: json['service_id'] != null
          ? int.tryParse(json['service_id'].toString()) ?? 0
          : 0,
      createdAt: json['created_at'] ?? '',
      repliesCount: json['replies_count'] ?? 0, // Add this
      replies: json['replies'] != null
          ? (json['replies'] as List)
              .map((reply) => Reply.fromJson(reply))
              .toList()
          : null,
    );
  }
}
