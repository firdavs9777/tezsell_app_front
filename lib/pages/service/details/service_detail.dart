import 'package:app/pages/chat/chat_room.dart';
import 'package:app/pages/service/comments/comments.dart';
import 'package:app/pages/service/comments/create_comment.dart';
import 'package:app/pages/service/details/edit_comment.dart';
import 'package:app/pages/service/details/recommended_services.dart';
import 'package:app/pages/service/details/reply_comment.dart';
import 'package:app/pages/service/details/service_image_slider.dart';
import 'package:app/pages/service/details/service_detail_content.dart';
import 'package:app/providers/provider_models/favorite_items.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_models/comments_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/providers/provider_root/comments_providers.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ServiceDetail extends ConsumerStatefulWidget {
  final Services service;

  const ServiceDetail({Key? key, required this.service}) : super(key: key);

  @override
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends ConsumerState<ServiceDetail> {
  late PageController _pageController;
  Services? _serviceData; // Store service details in state
  late Future<List<Services>> _recommendedServices;
  final FocusNode commentFocusNode = FocusNode();
  bool showCommentField = false;

  // Edit state variables
  bool isEditingComment = false;
  Comments? editingComment;
  String editingCommentText = '';

  // Reply state variables
  bool isReplyingToComment = false;
  Comments? replyingToComment;
  String replyCommentText = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fetchSingleService();
    _fetchRecommendedServices();
  }

  Future<void> _fetchSingleService() async {
    try {
      // Force a fresh fetch from the API (not cache)
      final service = await ref
          .read(serviceMainProvider)
          .getSingleService(serviceId: widget.service.id.toString());

      if (mounted) {
        setState(() {
          _serviceData = service;
        });
      }
    } catch (e) {
      print('Error fetching service: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to refresh: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _fetchRecommendedServices() {
    _recommendedServices = ref
        .read(serviceMainProvider)
        .getRecommendedServices(serviceId: widget.service.id.toString());
  }

  void _refreshServiceDetail() async {
    _fetchSingleService();
  }

  // Function to start editing a comment
  void _startEditingComment(Comments comment) {
    setState(() {
      isEditingComment = true;
      editingComment = comment;
      editingCommentText = comment.text.toString();
      // Cancel reply mode if active
      isReplyingToComment = false;
      replyingToComment = null;
    });
  }

  // Function to start replying to a comment
  void _startReplyingToComment(Comments comment) {
    setState(() {
      isReplyingToComment = true;
      replyingToComment = comment;
      replyCommentText = '';
      // Cancel edit mode if active
      isEditingComment = false;
      editingComment = null;
    });
  }

  // Function to cancel editing
  void _cancelEditingComment() {
    setState(() {
      isEditingComment = false;
      editingComment = null;
      editingCommentText = '';
    });
  }

  // Function to cancel replying
  void _cancelReplyingComment() {
    setState(() {
      isReplyingToComment = false;
      replyingToComment = null;
      replyCommentText = '';
    });
  }

  void _saveEditedComment() async {
    if (editingComment != null && editingCommentText.isNotEmpty) {
      final l10n = AppLocalizations.of(context)!; // Add this line

      try {
        await ref.read(commentsServiceProvider).editComment(
              title: editingCommentText,
              serviceId: widget.service.id.toString(),
              commentId: editingComment!.id.toString(),
            );

        ref.refresh(commentsServiceProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.commentUpdatedSuccess), // Use localized string
            backgroundColor: Colors.green,
          ),
        );

        _cancelEditingComment();
        _refreshServiceDetail();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${l10n.errorUpdatingComment}: $e'), // Use localized string with error
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _saveReplyComment() async {
    if (replyingToComment != null && replyCommentText.isNotEmpty) {
      final l10n = AppLocalizations.of(context)!;

      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );

        // Call the API to post reply
        await ref.read(commentsServiceProvider).replyToComment(
              commentId: replyingToComment!.id.toString(),
              text: replyCommentText,
            );
        await _fetchSingleService();

        await ref.refresh(commentsServiceProvider).getReplies(
              commmentId: replyingToComment!.id.toString(),
            );
        // Close loading dialog
        if (mounted) Navigator.of(context).pop();

        // Cancel reply mode
        _cancelReplyingComment();

        // IMPORTANT: Invalidate the provider to force fresh data
        ref.invalidate(commentsServiceProvider);

        // Refresh the service detail to get updated comments with replies
        await _fetchSingleService();

        // Force rebuild by updating state
        if (mounted) {
          setState(() {
            // This ensures the widget rebuilds with fresh data
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.replyAddedSuccess),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        // Close loading dialog if it's still open
        if (mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${l10n.errorAddingReply}: $e'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  void _deleteComment(Comments comment) async {
    try {
      await ref.read(commentsServiceProvider).deleteComment(
            serviceId: widget.service.id.toString(),
            commentId: comment.id.toString(),
          );

      ref.refresh(commentsServiceProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comment deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      _refreshServiceDetail();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting comment: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _likeService() async {
    try {
      final service = await ref
          .watch(profileServiceProvider)
          .likeSingleService(serviceId: widget.service.id.toString());

      if (service != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 1000),
            content: Text('Service liked successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        ref.refresh(profileServiceProvider).getUserFavoriteItems();
        setState(() {
          _serviceData = service;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Text('Error liking service: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _startChat() async {
    final targetUserId = widget.service.userName.id;
    final userName = widget.service.userName.username ?? 'Service Provider';

    // Check authentication first
    final chatState = ref.read(chatProvider);
    if (!chatState.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to start a chat'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF6F0F)),
              ),
              SizedBox(height: 16),
              Text(
                'Opening chat...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      // Get or create chat room
      final chatRoom = await ref
          .read(chatProvider.notifier)
          .getOrCreateDirectChat(targetUserId);

      // Close loading dialog
      if (mounted) Navigator.of(context).pop();

      if (chatRoom != null) {
        if (mounted) {
          // Navigate to chat room with animation
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatRoomScreen(chatRoom: chatRoom),
            ),
          );
        }
      } else {
        throw Exception('Failed to create or retrieve chat room');
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      // Show detailed error
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Chat Error'),
            content: Text(
              'Unable to start chat with $userName.\n\nError: ${e.toString()}',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _startChat(); // Retry
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }
    }
  }

  void _dislikeService() async {
    try {
      final service = await ref
          .watch(profileServiceProvider)
          .dislikeSingleService(serviceId: widget.service.id.toString());

      if (service != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 1000),
            content: Text('Service disliked successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        ref.refresh(profileServiceProvider).getUserFavoriteItems();
        setState(() {
          _serviceData = service;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(milliseconds: 1000),
          content: Text('Error liking product: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Detail')),
      body: _serviceData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ServiceImageSlider(
                      service: _serviceData!, pageController: _pageController),
                  ServiceDetailsSection(
                    service: _serviceData!,
                    onChatPressed: _startChat,
                  ),
                  FutureBuilder<FavoriteItems>(
                    future: ref
                        .watch(profileServiceProvider)
                        .getUserFavoriteItems(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Error loading favorite items'));
                      }

                      if (snapshot.hasData) {
                        final likedItems = snapshot.data!;
                        bool isLiked = likedItems.likedServices
                            .any((item) => item.id == widget.service.id);

                        return Row(
                          children: [
                            TweenAnimationBuilder<double>(
                              duration: Duration(milliseconds: 300),
                              tween: Tween<double>(
                                  begin: 1.0, end: isLiked ? 1.1 : 1.0),
                              curve: Curves.elasticInOut,
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: IconButton(
                                    icon: Icon(
                                      isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.red,
                                      size: 24.0,
                                    ),
                                    onPressed: isLiked
                                        ? _dislikeService
                                        : _likeService,
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                  _serviceData?.likeCount?.toString() ?? '0'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const Icon(Icons.comment),
                            ),
                            Text(_serviceData?.comments?.length.toString() ??
                                '0'),
                          ],
                        );
                      }

                      return const Center(
                          child: Text('No favorite items found.'));
                    },
                  ),
                  CommentsMain(
                    key: ValueKey(_serviceData!.comments?.length ?? 0),
                    id: _serviceData!.id.toString(),
                    comments: _serviceData!.comments,
                    onEditComment: _startEditingComment,
                    onDeleteComment: _deleteComment,
                    onReplyComment: _startReplyingToComment, // Added this line
                  ),
                  RecommendedServicesSection(
                      recommendedServices: _recommendedServices),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomWidget(),
    );
  }

  // Helper method to determine which bottom widget to show
  Widget _buildBottomWidget() {
    if (isEditingComment) {
      return EditCommentWidget(
        commentText: editingCommentText,
        onTextChanged: (text) {
          setState(() {
            editingCommentText = text;
          });
        },
        onSave: _saveEditedComment,
        onCancel: _cancelEditingComment,
      );
    } else if (isReplyingToComment) {
      return ReplyCommentWidget(
        parentComment: replyingToComment!,
        replyText: replyCommentText,
        onTextChanged: (text) {
          setState(() {
            replyCommentText = text;
          });
        },
        onSave: _saveReplyComment,
        onCancel: _cancelReplyingComment,
      );
    } else {
      return CreateComment(
        id: widget.service.id.toString(),
        onCommentAdded: _refreshServiceDetail,
      );
    }
  }
}
