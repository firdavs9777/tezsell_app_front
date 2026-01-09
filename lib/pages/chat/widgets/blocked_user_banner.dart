import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';

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
                Builder(
                  builder: (context) {
                    final l = AppLocalizations.of(context)!;
                    return Text(
                      isBlockedByUser ? l.you_are_blocked : l.block_user,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[900],
                      ),
                    );
                  },
                ),
                Builder(
                  builder: (context) {
                    final l = AppLocalizations.of(context)!;
                    return Text(
                      isBlockedByUser
                          ? l.user_blocked_you(username)
                          : l.you_blocked_user(username),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[800],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

