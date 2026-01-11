import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/comments_model.dart';
import 'package:app/providers/provider_models/replies_model.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:app/widgets/image_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommentsMain extends ConsumerStatefulWidget {
  const CommentsMain({
    Key? key,
    required this.id,
    required this.comments,
    required this.onEditComment,
    required this.onDeleteComment,
    required this.onReplyComment,
    this.onEditReply,
    this.onDeleteReply,
  }) : super(key: key);

  final List<Comments> comments;
  final String id;
  final Function(Comments) onEditComment;
  final Function(Comments) onDeleteComment;
  final Function(Comments) onReplyComment;
  final Function(Reply)? onEditReply;
  final Function(Reply)? onDeleteReply;

  @override
  ConsumerState<CommentsMain> createState() => _CommentsMainState();
}

class _CommentsMainState extends ConsumerState<CommentsMain> {
  String? currentUserId;
  Set<int> expandedComments = {};

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  String _formatLocalTime(String utcTimeString, BuildContext context) {
    try {
      DateTime utcTime = DateTime.parse(utcTimeString);
      DateTime localTime = utcTime.toLocal();
      return DateFormat('M/d/yyyy, h:mm:ss a').format(localTime);
    } catch (e) {
      return AppLocalizations.of(context)?.unknown_date ?? 'Unknown Date';
    }
  }

  Future<void> _loadCurrentUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      if (mounted) {
        setState(() {
          currentUserId = userId;
        });
      }
    } catch (e) {
    }
  }

  void _toggleReplies(int commentId) {
    setState(() {
      if (expandedComments.contains(commentId)) {
        expandedComments.remove(commentId);
      } else {
        expandedComments.add(commentId);
      }
    });
  }

  Widget _buildReply(Reply reply) {
    final isCurrentUserReply = currentUserId == reply.user.id.toString();
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(left: 40, top: 8, bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reply avatar - tap to navigate to user profile
          GestureDetector(
            onTap: () => context.push('/user/${reply.user.id}'),
            child: reply.user.profileImage != null
                ? CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                        reply.user.profileImage!.image.startsWith('http://') ||
                                reply.user.profileImage!.image.startsWith('https://')
                            ? reply.user.profileImage!.image
                            : '${baseUrl}${reply.user.profileImage!.image}'),
                    backgroundColor: colorScheme.surfaceContainerHighest,
                  )
                : CircleAvatar(
                    radius: 18,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    child: Icon(Icons.person, color: colorScheme.onSurfaceVariant, size: 18),
                  ),
          ),
          const SizedBox(width: 12),
          // Reply content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reply header
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: GestureDetector(
                              onTap: () => context.push('/user/${reply.user.id}'),
                              child: Text(
                                reply.user.username,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: colorScheme.onSurface,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          if (isCurrentUserReply) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: Colors.blue.withOpacity(0.3)),
                              ),
                              child: Text(
                                AppLocalizations.of(context)?.you_label ?? 'You',
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatLocalTime(reply.createdAt, context),
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    // Three dots menu for current user's replies
                    if (isCurrentUserReply &&
                        (widget.onEditReply != null ||
                            widget.onDeleteReply != null))
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert,
                            size: 18, color: colorScheme.onSurfaceVariant),
                        padding: EdgeInsets.zero,
                        onSelected: (String value) {
                          switch (value) {
                            case 'edit':
                              if (widget.onEditReply != null) {
                                widget.onEditReply!(reply);
                              }
                              break;
                            case 'delete':
                              if (widget.onDeleteReply != null) {
                                _confirmDeleteReply(reply);
                              }
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          if (widget.onEditReply != null)
                            PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(
                                children: [
                                  const Icon(Icons.edit,
                                      color: Colors.blue, size: 16),
                                  const SizedBox(width: 8),
                                  Text(AppLocalizations.of(context)?.editLabel ?? 'Edit',
                                      style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          if (widget.onDeleteReply != null)
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  const Icon(Icons.delete,
                                      color: Colors.red, size: 16),
                                  const SizedBox(width: 8),
                                  Text(AppLocalizations.of(context)?.deleteLabel ?? 'Delete',
                                      style: const TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
                // Location
                if (reply.user.location != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${reply.user.location.region}, ${reply.user.location.district}',
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                // Reply text
                Text(
                  reply.text,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteReply(Reply reply) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.delete_reply_title),
          content: Text(l10n.replyDeleteConfirmation),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (widget.onDeleteReply != null) {
                  widget.onDeleteReply!(reply);
                }
              },
              child: Text(
                l10n.deleteLabel,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  bool _canModifyComment(Comments comment) {
    if (currentUserId == null) return false;
    return currentUserId == comment.user.id.toString();
  }

  void _editComment(BuildContext context, Comments comment) {
    widget.onEditComment(comment);
  }

  void _deleteComment(BuildContext context, Comments comment) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(l10n.delete_comment_title),
          content: Text(l10n.deleteConfirmationMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDeleteComment(comment);
              },
              child: Text(
                l10n.deleteLabel,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    if (widget.comments.isEmpty) {
      return Card(
        color: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              l10n.noComments,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    }

    return Card(
      color: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.all(16.0),
      child: ExpansionTile(
        initiallyExpanded: true,
        expandedAlignment: Alignment.centerLeft,
        collapsedIconColor: colorScheme.primary,
        iconColor: colorScheme.primary,
        title: Text(
          l10n.comments_title(widget.comments.length),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: colorScheme.onSurface,
          ),
        ),
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.comments.length,
            separatorBuilder: (context, index) => Divider(
              color: colorScheme.outlineVariant,
              thickness: 1,
              height: 1,
            ),
            itemBuilder: (context, index) {
              final comment = widget.comments[index];
              final replies = comment.replies ?? [];
              final isExpanded = expandedComments.contains(comment.id);
              final hasReplies = replies.isNotEmpty;
              final repliesCount = comment.repliesCount;

              return Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main comment
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Comment avatar - tap to navigate to user profile
                        GestureDetector(
                          onTap: () => context.push('/user/${comment.user.id}'),
                          child: comment.user.profileImage != null
                              ? CircleAvatar(
                                  radius: 22,
                                  backgroundImage: NetworkImage(
                                      comment.user.profileImage!.image.startsWith('http://') ||
                                              comment.user.profileImage!.image.startsWith('https://')
                                          ? comment.user.profileImage!.image
                                          : '${baseUrl}${comment.user.profileImage!.image}'),
                                  backgroundColor: colorScheme.surfaceContainerHighest,
                                )
                              : CircleAvatar(
                                  radius: 22,
                                  backgroundColor: colorScheme.surfaceContainerHighest,
                                  child: Icon(Icons.person,
                                      color: colorScheme.onSurfaceVariant, size: 22),
                                ),
                        ),
                        const SizedBox(width: 12),
                        // Comment content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Comment header
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => context.push('/user/${comment.user.id}'),
                                      child: Text(
                                        comment.user.username ?? l10n.anonymous,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: colorScheme.onSurface,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    comment.created_at != null
                                        ? _formatLocalTime(
                                            comment.created_at.toString(), context)
                                        : l10n.unknown_date,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  if (_canModifyComment(comment))
                                    PopupMenuButton<String>(
                                      icon: Icon(Icons.more_vert,
                                          color: colorScheme.onSurfaceVariant, size: 20),
                                      padding: EdgeInsets.zero,
                                      onSelected: (String value) {
                                        switch (value) {
                                          case 'edit':
                                            _editComment(context, comment);
                                            break;
                                          case 'delete':
                                            _deleteComment(context, comment);
                                            break;
                                        }
                                      },
                                      itemBuilder: (BuildContext context) {
                                        final l10n = AppLocalizations.of(context)!;
                                        return [
                                          PopupMenuItem<String>(
                                            value: 'edit',
                                            child: Row(
                                              children: [
                                                const Icon(Icons.edit,
                                                    color: Colors.blue, size: 18),
                                                const SizedBox(width: 8),
                                                Text(l10n.editLabel),
                                              ],
                                            ),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'delete',
                                            child: Row(
                                              children: [
                                                const Icon(Icons.delete,
                                                    color: Colors.red, size: 18),
                                                const SizedBox(width: 8),
                                                Text(l10n.deleteLabel),
                                              ],
                                            ),
                                          ),
                                        ];
                                      },
                                    ),
                                ],
                              ),
                              // User location
                              if (comment.user.location != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  '${comment.user.location!.region}, ${comment.user.location!.district}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              // Comment text
                              Text(
                                comment.text.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 12),
                              // Action buttons
                              Row(
                                children: [
                                  // Like button
                                  InkWell(
                                    onTap: () {
                                      // TODO: Implement like functionality
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.thumb_up,
                                              color: Colors.white, size: 14),
                                          const SizedBox(width: 4),
                                          Text(
                                            l10n.likeLabel,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // Reply button
                                  InkWell(
                                    onTap: () {
                                      widget.onReplyComment(comment);
                                    },
                                    child: Text(
                                      l10n.reply_button,
                                      style: TextStyle(
                                        color: colorScheme.onSurfaceVariant,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  // Only show view replies if there are replies
                                  if (repliesCount > 0) ...[
                                    const SizedBox(width: 12),
                                    InkWell(
                                      onTap: () => _toggleReplies(comment.id),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            l10n.replies_count(repliesCount),
                                            style: TextStyle(
                                              color: colorScheme.onSurfaceVariant,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            isExpanded
                                                ? Icons.expand_less
                                                : Icons.expand_more,
                                            color: colorScheme.onSurfaceVariant,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Replies section - only show if expanded and has replies
                    if (isExpanded && hasReplies) ...[
                      const SizedBox(height: 12),
                      ...replies.map((reply) => _buildReply(reply)).toList(),
                    ],
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
