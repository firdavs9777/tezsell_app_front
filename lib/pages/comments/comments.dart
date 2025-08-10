import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/comments_model.dart';
import 'package:app/store/providers/authentication_provider.dart';
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
  }) : super(key: key);

  final List<Comments> comments;
  final String id;
  final Function(Comments) onEditComment;
  final Function(Comments) onDeleteComment;

  @override
  ConsumerState<CommentsMain> createState() => _CommentsMainState();
}

class _CommentsMainState extends ConsumerState<CommentsMain> {
  String? currentUserId;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId();
  }

  // Helper method to format time in local timezone
  String _formatLocalTime(String utcTimeString) {
    try {
      // Parse the UTC time from server (handles format like "2025-08-10T08:26:35.011760Z")
      DateTime utcTime = DateTime.parse(utcTimeString);

      // Convert to local time
      DateTime localTime = utcTime.toLocal();

      // Get current time for relative formatting
      DateTime now = DateTime.now();
      Duration difference = now.difference(localTime);

      // Show relative time for recent comments
      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays}d ago';
      } else {
        // For older comments, show the actual local date
        return DateFormat('MMM dd, yyyy HH:mm').format(localTime);
      }
    } catch (e) {
      print('Error formatting time: $e');
      print('Original time string: $utcTimeString');
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

  // Function to handle edit action
  void _editComment(BuildContext context, Comments comment) {
    widget.onEditComment(comment);
  }

  // Function to handle delete action
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

  // Function to check if current user can edit/delete the comment
  bool _canModifyComment(Comments comment) {
    if (currentUserId == null) return false;

    // Compare current user ID with comment user ID
    return currentUserId == comment.user.id.toString();
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
            'Comments (${widget.comments.length})',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          children: widget.comments
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
                            child: comment.user.profileImage == null
                                ? const Icon(Icons.person, color: Colors.grey)
                                : null,
                          ),
                          title: Row(
                            children: [
                              Text(
                                comment.user.username ?? 'Anonymous',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              // Show "You" indicator for current user's comments
                              if (_canModifyComment(comment)) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.blue.withOpacity(0.3),
                                    ),
                                  ),
                                  child: const Text(
                                    'You',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment.text.toString(),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  comment.created_at != null
                                      ? _formatLocalTime(
                                          comment.created_at.toString())
                                      : 'Unknown Date',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          trailing: _canModifyComment(comment)
                              ? PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                  ),
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
                                )
                              : null, // No menu for other users' comments
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
