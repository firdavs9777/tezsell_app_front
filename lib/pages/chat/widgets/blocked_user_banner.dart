import 'package:flutter/material.dart';

class BlockedUserBanner extends StatelessWidget {
  final String username;
  final bool isBlockedByUser;

  const BlockedUserBanner({
    super.key,
    required this.username,
    this.isBlockedByUser = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: Colors.orange[50],
      child: Row(
        children: [
          Icon(Icons.block, color: Colors.orange[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBlockedByUser ? 'You are blocked' : 'User blocked',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[900],
                  ),
                ),
                Text(
                  isBlockedByUser
                      ? '$username has blocked you. You cannot send messages.'
                      : 'You have blocked $username',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

