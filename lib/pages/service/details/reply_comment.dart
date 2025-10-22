// New widget for replying to comments
import 'package:app/constants/constants.dart';
import 'package:app/providers/provider_models/comments_model.dart';
import 'package:flutter/material.dart';

class ReplyCommentWidget extends StatefulWidget {
  final Comments parentComment;
  final String replyText;
  final Function(String) onTextChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const ReplyCommentWidget({
    Key? key,
    required this.parentComment,
    required this.replyText,
    required this.onTextChanged,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  _ReplyCommentWidgetState createState() => _ReplyCommentWidgetState();
}

class _ReplyCommentWidgetState extends State<ReplyCommentWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.replyText);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header showing who we're replying to
            Row(
              children: [
                const Icon(Icons.reply, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Replying to ${widget.parentComment.user.username}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                ),
              ],
            ),
            // Show parent comment preview
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundImage: widget.parentComment.user.profileImage !=
                            null
                        ? NetworkImage(
                            '${baseUrl}${widget.parentComment.user.profileImage!.image}')
                        : null,
                    backgroundColor: Colors.grey[300],
                    child: widget.parentComment.user.profileImage == null
                        ? const Icon(Icons.person, size: 16, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.parentComment.user.username ?? 'Anonymous',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          widget.parentComment.text.toString(),
                          style: const TextStyle(fontSize: 12),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Reply text input
            TextField(
              controller: _controller,
              onChanged: widget.onTextChanged,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Write your reply...',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Post Reply',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
