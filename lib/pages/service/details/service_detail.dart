import 'package:app/pages/chat/chat_room.dart';
import 'package:app/pages/service/comments/comments.dart';
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
import 'package:app/widgets/report_content_dialog.dart';
import 'package:app/utils/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';

class ServiceDetail extends ConsumerStatefulWidget {
  final Services service;

  const ServiceDetail({Key? key, required this.service}) : super(key: key);

  @override
  _ServiceDetailState createState() => _ServiceDetailState();
}

class _ServiceDetailState extends ConsumerState<ServiceDetail> {
  late PageController _pageController;
  Services? _serviceData;
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

  Future<void> _showReportDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ReportContentDialog(
        contentType: 'service',
        contentId: widget.service.id,
        contentTitle: widget.service.name,
      ),
    );
    
    // Show success message if report was successful
    if (result == true && mounted) {
      final localizations = AppLocalizations.of(context);
      AppErrorHandler.showSuccess(
        context,
        localizations?.reportSubmitted ??
            'Thank you for your report. We will review it within 24 hours.',
      );
    }
  }


  Future<void> _fetchSingleService() async {
    try {
      final service = await ref
          .read(serviceMainProvider)
          .getSingleService(serviceId: widget.service.id.toString());

      if (mounted) {
        setState(() {
          _serviceData = service;
        });
      }
    } catch (e) {
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

  void _startEditingComment(Comments comment) {
    setState(() {
      isEditingComment = true;
      editingComment = comment;
      editingCommentText = comment.text.toString();
      isReplyingToComment = false;
      replyingToComment = null;
    });
  }

  void _startReplyingToComment(Comments comment) {
    setState(() {
      isReplyingToComment = true;
      replyingToComment = comment;
      replyCommentText = '';
      isEditingComment = false;
      editingComment = null;
    });
  }

  void _cancelEditingComment() {
    setState(() {
      isEditingComment = false;
      editingComment = null;
      editingCommentText = '';
    });
  }

  void _cancelReplyingComment() {
    setState(() {
      isReplyingToComment = false;
      replyingToComment = null;
      replyCommentText = '';
    });
  }

  void _saveEditedComment() async {
    if (editingComment != null && editingCommentText.isNotEmpty) {
      final l10n = AppLocalizations.of(context)!;

      try {
        await ref.read(commentsServiceProvider).editComment(
              title: editingCommentText,
              serviceId: widget.service.id.toString(),
              commentId: editingComment!.id.toString(),
            );

        ref.refresh(commentsServiceProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.commentUpdatedSuccess),
            backgroundColor: Colors.green,
          ),
        );

        _cancelEditingComment();
        _refreshServiceDetail();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${l10n.errorUpdatingComment}: $e'),
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
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );

        await ref.read(commentsServiceProvider).replyToComment(
              commentId: replyingToComment!.id.toString(),
              text: replyCommentText,
            );
        await _fetchSingleService();

        await ref.refresh(commentsServiceProvider).getReplies(
              commmentId: replyingToComment!.id.toString(),
            );

        if (mounted) Navigator.of(context).pop();
        _cancelReplyingComment();
        ref.invalidate(commentsServiceProvider);
        await _fetchSingleService();

        if (mounted) {
          setState(() {});

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.replyAddedSuccess),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
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
    final l10n = AppLocalizations.of(context)!;
    try {
      await ref.read(commentsServiceProvider).deleteComment(
            serviceId: widget.service.id.toString(),
            commentId: comment.id.toString(),
          );

      ref.refresh(commentsServiceProvider);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.commentDeletedSuccess),
          backgroundColor: Colors.green,
        ),
      );

      _refreshServiceDetail();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.errorDeletingComment}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _likeService() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final service = await ref
          .watch(profileServiceProvider)
          .likeSingleService(serviceId: widget.service.id.toString());

      if (service != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 1000),
            content: Text(l10n.serviceLikedSuccess),
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
          content: Text('${l10n.errorLikingService}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _startChat() async {
    final targetUserId = widget.service.userName.id;
    final userName = widget.service.userName.username ?? 'Service Provider';
    final localizations = AppLocalizations.of(context);

    // Initialize chat provider if not already initialized
    await ref.read(chatProvider.notifier).initialize();

    // Check authentication after initialization
    final chatState = ref.read(chatProvider);
    if (!chatState.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizations?.chatLoginMessage ??
              'Please log in to start a chat'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 🔥 NEW: Prevent chatting with yourself
    if (chatState.currentUserId == targetUserId) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You cannot chat with yourself'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
      return;
    }

    // Show modern loading bottom sheet
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Opening chat with $userName...',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'This will only take a moment',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );

    try {
      final chatRoom = await ref
          .read(chatProvider.notifier)
          .getOrCreateDirectChat(targetUserId);

      if (mounted) Navigator.of(context).pop(); // Close bottom sheet

      if (chatRoom != null && mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoomScreen(chatRoom: chatRoom),
          ),
        );
      } else {
        throw Exception('Failed to create or retrieve chat room');
      }
    } catch (e) {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to start chat. Please try again.'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
              onPressed: _startChat,
            ),
          ),
        );
      }
    }
  }

  void _dislikeService() async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final service = await ref
          .watch(profileServiceProvider)
          .dislikeSingleService(serviceId: widget.service.id.toString());

      if (service != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            duration: Duration(milliseconds: 1000),
            content: Text(l10n.serviceDislikedSuccess),
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
          content: Text('${l10n.errorDislikingService}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: colorScheme.onSurface,
        title: Text(
          localizations?.serviceDetailTitle ?? 'Service Detail',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert_rounded,
              color: colorScheme.onSurface,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              if (value == 'report') {
                _showReportDialog();
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'report',
                child: Row(
                  children: [
                    Icon(
                      Icons.flag_rounded,
                      color: colorScheme.error,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      localizations?.reportService ?? 'Report Service',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
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
                        return Center(
                            child: Text(localizations?.errorLoadingFavorites ??
                                'Error loading favorite items'));
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

                      return Center(
                          child: Text(localizations?.noFavoritesFound ??
                              'No favorite items found.'));
                    },
                  ),
                  CommentsMain(
                    key: ValueKey(_serviceData!.comments?.length ?? 0),
                    id: _serviceData!.id.toString(),
                    comments: _serviceData!.comments,
                    onEditComment: _startEditingComment,
                    onDeleteComment: _deleteComment,
                    onReplyComment: _startReplyingToComment,
                  ),
                  RecommendedServicesSection(
                      recommendedServices: _recommendedServices),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomWidget(),
    );
  }

  // 🔥 Updated bottom widget handler
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
      // 🔥 Show contact bar instead of just comment field
      return _buildContactBottomBar();
    }
  }

  // 🔥 Add contact bottom bar
  Widget _buildContactBottomBar() {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            color: colorScheme.outline.withOpacity(0.08),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: Row(
            children: [
              // Chat button - expanded to take full width
              Expanded(
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: _startChat,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: colorScheme.onPrimary,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            localizations?.chat ?? 'Chat',
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
