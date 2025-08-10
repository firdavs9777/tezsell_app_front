import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/comments_model.dart';
import 'package:app/providers/provider_models/replies_model.dart'; // Import new model
import 'package:app/providers/provider_models/user_model.dart';
import 'package:app/providers/provider_root/comments_providers.dart';
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
  }) : super(key: key);

  final List<Comments> comments;
  final String id;
  final Function(Comments) onEditComment;
  final Function(Comments) onDeleteComment;
  final Function(Comments) onReplyComment;

  @override
  ConsumerState<CommentsMain> createState() => _CommentsMainState();
}

class _CommentsMainState extends ConsumerState<CommentsMain> {
  String? currentUserId;
  Set<int> expandedComments = {};
  Map<int, List<Reply>> repliesCache = {}; // Changed to List<Reply>
  Map<int, bool> loadingReplies = {};

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  // Helper method to format time like web version
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
      setState(() {
        currentUserId = userId;
      });
    } catch (e) {
      print('Error loading current user ID: $e');
    }
  }

  // Load replies from API using new model
  Future<void> _loadReplies(int commentId) async {
    if (loadingReplies[commentId] == true) return;

    setState(() {
      loadingReplies[commentId] = true;
    });

    try {
      // Use the new getReplies method that returns List<Reply>
      final replies = await ref
          .read(commentsServiceProvider)
          .getReplies(commmentId: commentId.toString());

      setState(() {
        repliesCache[commentId] = replies;
        loadingReplies[commentId] = false;
      });
    } catch (e) {
      print('Error loading replies: $e');
      setState(() {
        loadingReplies[commentId] = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading replies: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _toggleReplies(int commentId) async {
    setState(() {
      if (expandedComments.contains(commentId)) {
        expandedComments.remove(commentId);
      } else {
        expandedComments.add(commentId);
      }
    });

    // Load replies when expanding if not already loaded
    if (expandedComments.contains(commentId) &&
        !repliesCache.containsKey(commentId)) {
      await _loadReplies(commentId);
    }
  }

  // Build reply widget using Reply model
  Widget _buildReply(Reply reply) {
    final isCurrentUserReply = currentUserId == reply.user.id.toString();

    return Container(
      margin: const EdgeInsets.only(left: 40, top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reply avatar
          CircleAvatar(
            radius: 20,
            backgroundImage: reply.user.profileImage != null
                ? NetworkImage('${baseUrl}${reply.user.profileImage!.image}')
                : null,
            backgroundColor: Colors.grey[300],
            child: reply.user.profileImage == null
                ? const Icon(Icons.person, color: Colors.grey, size: 20)
                : null,
          ),
          const SizedBox(width: 12),
          // Reply content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reply header with username and time
                Row(
                  children: [
                    Text(
                      reply.user.username,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    // Show "You" indicator for current user
                    if (isCurrentUserReply) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                          border:
                              Border.all(color: Colors.blue.withOpacity(0.3)),
                        ),
                        child: const Text(
                          'You',
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                    const Spacer(),
                    Text(
                      _formatLocalTime(reply.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    // Three dots menu for current user's replies
                    if (isCurrentUserReply)
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert,
                            size: 18, color: Colors.grey),
                        onSelected: (String value) {
                          switch (value) {
                            case 'edit':
                              // Convert Reply to Comments for compatibility
                              // final commentReply = Comments(
                              //   id: reply.id,
                              //   text: reply.text,
                              //   user: UserInfo(
                              //     id: reply.user.id,
                              //     username: reply.user.username,
                              //     profileImage: reply.user.profileImage != null
                              //         ? ProfileImage(
                              //             image: reply.user.profileImage!.image)
                              //         : null,
                              //     location: Location(
                              //       id: reply.user.location.id,
                              //       country: reply.user.location.country,
                              //       region: reply.user.location.region,
                              //       district: reply.user.location.district,
                              //     ),
                              //   ),
                              //   created_at: reply.createdAt,
                              // );
                              // widget.onEditComment(commentReply);
                              // break;
                              break;
                            case 'delete':
                              // Similar conversion for delete
                              // final commentReply = Comments(
                              //   id: reply.id,
                              //   text: reply.text,
                              //   user: User(
                              //     id: reply.user.id,
                              //     username: reply.user.username,
                              //     profileImage: reply.user.profileImage != null
                              //         ? ProfileImage(
                              //             image: reply.user.profileImage!.image)
                              //         : null,
                              //     location: Location(
                              //       id: reply.user.location.id,
                              //       country: reply.user.location.country,
                              //       region: reply.user.location.region,
                              //       district: reply.user.location.district,
                              //     ),
                              //   ),
                              //   created_at: reply.createdAt,
                              // );
                              // widget.onDeleteComment(commentReply);
                              // break;
                              break;
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem<String>(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, color: Colors.blue, size: 16),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                          const PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red, size: 16),
                                SizedBox(width: 8),
                                Text('Delete'),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                // Location
                Text(
                  '${reply.user.location.region}, ${reply.user.location.district}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                // Reply text
                Text(
                  reply.text,
                  style: const TextStyle(
                    fontSize: 14,
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

  // Function to check if current user can edit/delete the comment
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
    return Card(
      color: Colors.transparent,
      elevation: 0,
      margin: const EdgeInsets.all(16.0),
      child: ExpansionTile(
        expandedAlignment: Alignment.center,
        collapsedIconColor: Colors.red,
        title: Text(
          'Izohlar (${widget.comments.length})',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        children: widget.comments.map((comment) {
          final replies = repliesCache[comment.id] ?? [];
          final isExpanded = expandedComments.contains(comment.id);
          final isLoadingReplies = loadingReplies[comment.id] ?? false;

          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                // Main comment - web style layout
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Comment avatar
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: comment.user.profileImage != null
                            ? NetworkImage(
                                '${baseUrl}${comment.user.profileImage!.image}')
                            : null,
                        backgroundColor: Colors.grey[300],
                        child: comment.user.profileImage == null
                            ? const Icon(Icons.person, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      // Comment content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Comment header with username, location, time, and menu
                            Row(
                              children: [
                                Text(
                                  comment.user.username ?? 'Anonymous',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  comment.created_at != null
                                      ? _formatLocalTime(
                                          comment.created_at.toString())
                                      : 'Unknown Date',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                // Three dots menu for current user's comments
                                if (_canModifyComment(comment))
                                  PopupMenuButton<String>(
                                    icon: const Icon(Icons.more_vert,
                                        color: Colors.grey),
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
                                                color: Colors.blue, size: 20),
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
                                                color: Colors.red, size: 20),
                                            SizedBox(width: 8),
                                            Text('Delete'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            // User location (if available)
                            if (comment.user.location != null) ...[
                              Text(
                                '${comment.user.location!.region}, ${comment.user.location!.district}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                            // Comment text
                            Text(
                              comment.text.toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Action buttons row
                            Row(
                              children: [
                                // Like button (web style)
                                Container(
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
                                          color: Colors.white, size: 16),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // Reply button
                                GestureDetector(
                                  onTap: () {
                                    widget.onReplyComment(comment);
                                  },
                                  child: Text(
                                    'Javob berish',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                // View replies button
                                GestureDetector(
                                  onTap: () => _toggleReplies(comment.id),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${replies.length} javoblar',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      if (isLoadingReplies)
                                        const SizedBox(
                                          width: 12,
                                          height: 12,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        )
                                      else
                                        Icon(
                                          isExpanded
                                              ? Icons.expand_less
                                              : Icons.expand_more,
                                          color: Colors.grey[600],
                                          size: 20,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Show replies if expanded
                if (isExpanded && replies.isNotEmpty)
                  ...replies.map((reply) => _buildReply(reply)).toList(),

                // Show loading indicator if loading replies
                if (isLoadingReplies && isExpanded)
                  Container(
                    margin: const EdgeInsets.only(left: 40, top: 8, bottom: 8),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),

                // Divider between comments
                if (widget.comments.indexOf(comment) <
                    widget.comments.length - 1)
                  Divider(color: Colors.grey[300], thickness: 1),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
