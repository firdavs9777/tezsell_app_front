import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_root/comments_providers.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateComment extends ConsumerStatefulWidget {
  // Callback when a comment is added
  // final FocusNode focusNode;
  final String id;
  final VoidCallback onCommentAdded;

  // final VoidCallback onCommentAdded;
  const CreateComment({
    super.key,
    required this.id,
    required this.onCommentAdded,
    // Pass the callback here
  });

  @override
  ConsumerState<CreateComment> createState() => _CreateCommentState();
}

class _CreateCommentState extends ConsumerState<CreateComment> {
  TextEditingController commentController = TextEditingController();
  void submitComment() async {
    String commentText = commentController.text.trim();
    if (commentText.isNotEmpty) {
      final commentProvider = ref.watch(commentsServiceProvider).createComment(
          title: commentText, id: widget.id); // Use ref to read the provider
      // commentProvider.submitComment(commentText);
      ref.refresh(commentsServiceProvider);
      ref.invalidate(commentsProvider(widget.id));
      // ref.refresh(momentsServiceProvider).getSingleMoment(id: widget.id);
      // Clear the text field after submission
      commentController.clear();

      await ref
          .read(serviceMainProvider)
          .getSingleService(serviceId: widget.id.toString());
      // Optionally, you can update the UI to reflect the new comment
      // setState(() {
      //   // Upddfsaate any state variables or provider data if needed
      // });
      widget.onCommentAdded();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(
          top: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      commentController.text = value;
                    });
                  },
                  // focusNode: widget.focusNode,
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          if (commentController.text.trim().isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.send, color: Colors.white),
                onPressed: submitComment,
              ),
            ),
        ],
      ),
    );
  }
}
