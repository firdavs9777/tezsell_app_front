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
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

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

  // 🔥 Add phone reveal state
  bool _phoneNumberRevealed = false;

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

  // 🔥 Add phone masking helper
  String _maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) return '';

    final cleaned = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    if (cleaned.length <= 4) return cleaned;

    if (cleaned.startsWith('+')) {
      if (cleaned.length > 7) {
        final countryCode = cleaned.substring(0, 4);
        final firstDigits = cleaned.substring(4, 6);
        final lastDigits = cleaned.substring(cleaned.length - 2);
        return '$countryCode $firstDigits *** ** $lastDigits';
      }
    }

    final first = cleaned.substring(0, 2);
    final last = cleaned.substring(cleaned.length - 2);
    final maskLength = cleaned.length - 4;
    return '$first${'*' * maskLength}$last';
  }

  // 🔥 Add display phone helper
  String _getDisplayPhoneNumber() {
    if (_phoneNumberRevealed) {
      return widget.service.userName.phoneNumber;
    }
    return _maskPhoneNumber(widget.service.userName.phoneNumber);
  }

  // 🔥 Add phone call handler
  Future<void> _makePhoneCall() async {
    final phoneNumber = widget.service.userName.phoneNumber;

    // Reveal the number first
    setState(() {
      _phoneNumberRevealed = true;
    });

    // Small delay to show revealed number
    await Future.delayed(const Duration(milliseconds: 500));

    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    try {
      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        throw Exception('Could not launch phone dialer');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open phone dialer'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
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

    return Scaffold(
      appBar: AppBar(
          title: Text(localizations?.serviceDetailTitle ?? 'Service Detail')),
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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations?.contactSeller ?? 'Contact Seller',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.phone, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _getDisplayPhoneNumber(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (!_phoneNumberRevealed)
                      Text(
                        localizations?.callToReveal ?? 'Tap "Call" to reveal',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.blue[600],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _startChat,
                icon: const Icon(Icons.chat_bubble_outline, size: 20),
                label: Text(localizations?.chat ?? 'Chat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _makePhoneCall,
                icon: const Icon(Icons.phone, size: 20),
                label: Text('Call'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
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
