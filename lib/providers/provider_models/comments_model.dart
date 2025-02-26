import 'package:app/providers/provider_models/user_model.dart';

class Comments {
  const Comments(
      {required this.id,
      required this.text,
      required this.service_id,
      required this.user,
      required this.created_at});

  final int id;
  final String text;
  final UserInfo user;
  final int service_id;
  final String created_at;

  factory Comments.fromJson(Map<String, dynamic> json) {
    return Comments(
        id: json['id'],
        text: json['text'],
        user: UserInfo.fromJson(json['user']),
        service_id: json['service_id'] != null
            ? int.tryParse(json['service_id'].toString()) ?? 0
            : 0,
        created_at: json['created_at']);
  }
}
