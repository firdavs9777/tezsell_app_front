import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/comments_model.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class CommentsMain extends ConsumerWidget {
  const CommentsMain({Key? key, required this.id, required this.comments})
      : super(key: key);
  final List<Comments> comments;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        color: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.all(16.0),
        child: ExpansionTile(
          expandedAlignment: Alignment.center,
          collapsedIconColor: Colors.red,
          title: Text(
            'Comments (${comments.length})',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          children: comments
              .map(
                (comment) => Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundImage: comment.user.profileImage != null
                                ? NetworkImage(
                                    '${baseUrl}${comment.user.profileImage.image}')
                                : null,
                            backgroundColor: Colors.grey[200],
                          ),
                          title: Text(
                            comment.user.username ?? 'Anonymous',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              comment.text.toString(),
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          trailing: Text(
                            comment.created_at != null
                                ? DateFormat('yyyy-MM-dd').format(
                                    DateTime.parse(
                                        comment.created_at.toString()))
                                : 'Unknown Date',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ));
  }
}
