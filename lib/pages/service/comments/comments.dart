import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/comments_model.dart';
import 'package:app/providers/provider_models/replies_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  String _formatLocalTime(String utcTimeString) {
    try {
      DateTime utcTime = DateTime.parse(utcTimeString);
      DateTime localTime = utcTime.toLocal();
      return DateFormat('M/d/yyyy, h:mm:ss a').format(localTime);
    } catch (e) {
      print('Error formatting time: $e');
      return 'Unknown Date';
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
      print('Error loading current user ID: $e');
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

    return Container(
      margin: const EdgeInsets.only(left: 40, top: 8, bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reply avatar
          CircleAvatar(
            radius: 18,
            backgroundImage: reply.user.profileImage != null
                ? NetworkImage('${baseUrl}${reply.user.profileImage!.image}')
                : null,
            backgroundColor: Colors.grey[300],
            child: reply.user.profileImage == null
                ? const Icon(Icons.person, color: Colors.grey, size: 18)
                : null,
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
                            child: Text(
                              reply.user.username,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
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
                              child: const Text(
                                'You',
                                style: TextStyle(
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
                      _formatLocalTime(reply.createdAt),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[600],
                      ),
                    ),
                    // Three dots menu for current user's replies
                    if (isCurrentUserReply &&
                        (widget.onEditReply != null ||
                            widget.onDeleteReply != null))
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert,
                            size: 18, color: Colors.grey[600]),
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
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit,
                                      color: Colors.blue, size: 16),
                                  SizedBox(width: 8),
                                  Text('Edit', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          if (widget.onDeleteReply != null)
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete,
                                      color: Colors.red, size: 16),
                                  SizedBox(width: 8),
                                  Text('Delete',
                                      style: TextStyle(fontSize: 13)),
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
                      color: Colors.grey[600],
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                // Reply text
                Text(
                  reply.text,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Reply'),
          content: const Text('Are you sure you want to delete this reply?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (widget.onDeleteReply != null) {
                  widget.onDeleteReply!(reply);
                }
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Comment'),
          content: const Text('Are you sure you want to delete this comment?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onDeleteComment(comment);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.comments.isEmpty) {
      return Card(
        color: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.all(16.0),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'No comments yet. Be the first to comment!',
              style: TextStyle(
                color: Colors.grey,
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
        collapsedIconColor: Colors.red,
        iconColor: Colors.red,
        title: Text(
          'Izohlar (${widget.comments.length})',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.comments.length,
            separatorBuilder: (context, index) => Divider(
              color: Colors.grey[300],
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
                        // Comment avatar
                        CircleAvatar(
                          radius: 22,
                          backgroundImage: comment.user.profileImage != null
                              ? NetworkImage(
                                  '${baseUrl}${comment.user.profileImage!.image}')
                              : null,
                          backgroundColor: Colors.grey[300],
                          child: comment.user.profileImage == null
                              ? const Icon(Icons.person,
                                  color: Colors.grey, size: 22)
                              : null,
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
                                    child: Text(
                                      comment.user.username ?? 'Anonymous',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.black87,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    comment.created_at != null
                                        ? _formatLocalTime(
                                            comment.created_at.toString())
                                        : 'Unknown Date',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  if (_canModifyComment(comment))
                                    PopupMenuButton<String>(
                                      icon: Icon(Icons.more_vert,
                                          color: Colors.grey[600], size: 20),
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
                                      itemBuilder: (BuildContext context) => [
                                        const PopupMenuItem<String>(
                                          value: 'edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit,
                                                  color: Colors.blue, size: 18),
                                              SizedBox(width: 8),
                                              Text('Edit'),
                                            ],
                                          ),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: 'delete',
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete,
                                                  color: Colors.red, size: 18),
                                              SizedBox(width: 8),
                                              Text('Delete'),
                                            ],
                                          ),
                                        ),
                                      ],
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
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              // Comment text
                              Text(
                                comment.text.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
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
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.thumb_up,
                                              color: Colors.white, size: 14),
                                          SizedBox(width: 4),
                                          Text(
                                            'Like',
                                            style: TextStyle(
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
                                      'Javob berish',
                                      style: TextStyle(
                                        color: Colors.grey[700],
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
                                            '$repliesCount javoblar',
                                            style: TextStyle(
                                              color: Colors.grey[700],
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Icon(
                                            isExpanded
                                                ? Icons.expand_less
                                                : Icons.expand_more,
                                            color: Colors.grey[700],
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
