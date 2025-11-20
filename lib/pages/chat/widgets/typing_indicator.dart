import 'package:app/providers/provider_models/message_model.dart';
import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  final Map<int, bool> typingUsers;
  final List<User> participants;
  final int currentUserId;

  const TypingIndicator({
    super.key,
    required this.typingUsers,
    required this.participants,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final activeTypers = typingUsers.entries
        .where((e) => e.key != currentUserId && e.value)
        .toList();

    if (activeTypers.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          ...activeTypers.map((e) {
            final user = participants.firstWhere(
              (p) => p.id == e.key,
              orElse: () => User(id: e.key, username: 'User'),
            );
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                '${user.username} is typing...',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

