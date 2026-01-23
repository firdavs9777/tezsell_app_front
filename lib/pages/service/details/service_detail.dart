import 'package:app/pages/chat/chat_room.dart';
import 'package:app/pages/service/comments/comments.dart';
import 'package:app/pages/service/comments/create_comment.dart';
import 'package:app/pages/service/details/edit_comment.dart';
import 'package:app/pages/service/details/recommended_services.dart';
import 'package:app/pages/service/details/reply_comment.dart';
import 'package:app/providers/provider_models/favorite_items.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_models/comments_model.dart';
import 'package:app/providers/provider_root/chat_provider.dart';
import 'package:app/providers/provider_root/comments_providers.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:app/widgets/report_content_dialog.dart';
import 'package:app/widgets/cached_network_image_widget.dart';
import 'package:app/widgets/image_viewer.dart';
import 'package:app/utils/error_handler.dart';
import 'package:app/utils/image_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';

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
  int _currentImageIndex = 0;
  bool _isLiking = false;
  bool? _isLiked;

  // Comment state
  bool isEditingComment = false;
  Comments? editingComment;
  String editingCommentText = '';
  bool isReplyingToComment = false;
  Comments? replyingToComment;
  String replyCommentText = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fetchSingleService();
    _fetchRecommendedServices();
    _loadLikeStatus();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadLikeStatus() async {
    try {
      final favoriteItems = await ref
          .read(profileServiceProvider)
          .getUserFavoriteItems();
      if (mounted) {
        setState(() {
          _isLiked = favoriteItems.likedServices
              .any((item) => item.id == widget.service.id);
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLiked = false);
      }
    }
  }

  Future<void> _fetchSingleService() async {
    try {
      final service = await ref
          .read(serviceMainProvider)
          .getSingleService(serviceId: widget.service.id.toString());
      if (mounted) {
        setState(() => _serviceData = service);
      }
    } catch (e) {
      // Handle error silently
    }
  }

  void _fetchRecommendedServices() {
    _recommendedServices = ref
        .read(serviceMainProvider)
        .getRecommendedServices(serviceId: widget.service.id.toString());
  }

  String getCategoryName() {
    final locale = Localizations.localeOf(context).languageCode;
    switch (locale) {
      case 'uz':
        return widget.service.category?.nameUz ?? '';
      case 'ru':
        return widget.service.category?.nameRu ?? '';
      case 'en':
      default:
        return widget.service.category?.nameEn ?? '';
    }
  }

  String _getTimeAgo(DateTime? date) {
    if (date == null) return '';
    try {
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays > 30) {
        return DateFormat('MMM d').format(date);
      } else if (difference.inDays > 0) {
        return '${difference.inDays}d ago';
      } else if (difference.inHours > 0) {
        return '${difference.inHours}h ago';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes}m ago';
      } else {
        return 'Just now';
      }
    } catch (e) {
      return '';
    }
  }

  void _shareService() {
    HapticFeedback.selectionClick();
    final localizations = AppLocalizations.of(context);
    final shareText =
        '${localizations?.checkOutProfile ?? "Check out"} ${widget.service.name} ${localizations?.onTezsell ?? "on Tezsell"}\nhttps://webtezsell.com/service/${widget.service.id}';

    final box = context.findRenderObject() as RenderBox?;
    Share.share(
      shareText,
      subject: widget.service.name,
      sharePositionOrigin: box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : const Rect.fromLTWH(0, 0, 100, 100),
    );
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

    if (result == true && mounted) {
      final localizations = AppLocalizations.of(context);
      AppErrorHandler.showSuccess(
        context,
        localizations?.reportSubmitted ??
            'Thank you for your report. We will review it within 24 hours.',
      );
    }
  }

  Future<void> _startChat() async {
    final targetUserId = widget.service.userName.id;
    final userName = widget.service.userName.username ?? 'Service Provider';
    final localizations = AppLocalizations.of(context);

    await ref.read(chatProvider.notifier).initialize();

    final chatState = ref.read(chatProvider);
    if (!chatState.isAuthenticated) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations?.chatLoginMessage ?? 'Please log in to start a chat'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
      return;
    }

    if (chatState.currentUserId == targetUserId) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations?.cannot_chat_with_yourself ?? 'You cannot chat with yourself'),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
      return;
    }

    // Show Carrot-style loading bottom sheet
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 48, height: 48, child: CircularProgressIndicator(strokeWidth: 3)),
            const SizedBox(height: 20),
            Text(
              localizations?.opening_chat_with(userName) ?? 'Opening chat with $userName...',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    try {
      final chatRoom = await ref
          .read(chatProvider.notifier)
          .getOrCreateDirectChat(targetUserId);

      if (mounted) Navigator.of(context).pop();

      if (chatRoom != null && mounted) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatRoomScreen(chatRoom: chatRoom)),
        );
      } else {
        throw Exception('Failed to create chat room');
      }
    } catch (e) {
      if (mounted && Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizations?.unable_to_start_chat ?? 'Unable to start chat'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: localizations?.retry ?? 'Retry',
              textColor: Colors.white,
              onPressed: _startChat,
            ),
          ),
        );
      }
    }
  }

  Future<void> _toggleLike() async {
    if (_isLiking) return;

    final currentLikeStatus = _isLiked ?? false;
    setState(() {
      _isLiking = true;
      _isLiked = !currentLikeStatus;
    });

    try {
      if (currentLikeStatus) {
        final service = await ref
            .read(profileServiceProvider)
            .dislikeSingleService(serviceId: widget.service.id.toString());
        if (service != null && mounted) {
          setState(() => _serviceData = service);
        }
      } else {
        final service = await ref
            .read(profileServiceProvider)
            .likeSingleService(serviceId: widget.service.id.toString());
        if (service != null && mounted) {
          setState(() => _serviceData = service);
        }
      }
      ref.invalidate(profileServiceProvider);
    } catch (e) {
      if (mounted) {
        setState(() => _isLiked = currentLikeStatus);
      }
    } finally {
      if (mounted) {
        setState(() => _isLiking = false);
      }
    }
  }

  // Comment handlers
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
          SnackBar(content: Text(l10n.commentUpdatedSuccess), backgroundColor: Colors.green),
        );
        _cancelEditingComment();
        _fetchSingleService();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.errorUpdatingComment}: $e'), backgroundColor: Colors.red),
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
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );

        await ref.read(commentsServiceProvider).replyToComment(
              commentId: replyingToComment!.id.toString(),
              text: replyCommentText,
            );

        if (mounted) Navigator.of(context).pop();
        _cancelReplyingComment();
        ref.invalidate(commentsServiceProvider);
        await _fetchSingleService();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.replyAddedSuccess), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted && Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${l10n.errorAddingReply}: $e'), backgroundColor: Colors.red),
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
        SnackBar(content: Text(l10n.commentDeletedSuccess), backgroundColor: Colors.green),
      );
      _fetchSingleService();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${l10n.errorDeletingComment}: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final service = _serviceData ?? widget.service;

    final List<String> imageUrls = service.images.isNotEmpty
        ? service.images.map((image) => ImageUtils.buildImageUrl(image.image)).toList()
        : [];

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          // Carrot-style SliverAppBar with image
          SliverAppBar(
            expandedHeight: 360,
            pinned: true,
            backgroundColor: colorScheme.surface,
            foregroundColor: colorScheme.onSurface,
            elevation: 0,
            leading: _buildCircularButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Navigator.of(context).pop(),
            ),
            actions: [
              _buildCircularButton(
                icon: Icons.share_outlined,
                onTap: _shareService,
              ),
              _buildCircularButton(
                icon: Icons.more_horiz_rounded,
                onTap: () => _showMoreOptions(context),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: _buildImageSlider(imageUrls),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProviderSection(service),
                _buildDivider(),
                _buildServiceInfo(service),
                _buildDivider(),
                _buildDescription(service),
                _buildDivider(),
                _buildStatsSection(service),
                _buildDivider(),
                // Comments section
                CommentsMain(
                  key: ValueKey(service.comments?.length ?? 0),
                  id: service.id.toString(),
                  comments: service.comments ?? [],
                  onEditComment: _startEditingComment,
                  onDeleteComment: _deleteComment,
                  onReplyComment: _startReplyingToComment,
                ),
                _buildDivider(),
                RecommendedServicesSection(recommendedServices: _recommendedServices),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomWidget(service),
    );
  }

  Widget _buildCircularButton({required IconData icon, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: Icon(Icons.flag_outlined, color: colorScheme.error),
              title: Text(
                localizations?.reportService ?? 'Report',
                style: TextStyle(color: colorScheme.error),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _showReportDialog();
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSlider(List<String> imageUrls) {
    final colorScheme = Theme.of(context).colorScheme;

    if (imageUrls.isEmpty) {
      return Container(
        color: colorScheme.surfaceContainerHighest,
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        PageView.builder(
          controller: _pageController,
          onPageChanged: (index) => setState(() => _currentImageIndex = index),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ImageViewer(
                      imageUrls: imageUrls,
                      initialIndex: index,
                    ),
                  ),
                );
              },
              child: CachedNetworkImageWidget(
                imageUrl: imageUrls[index],
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            );
          },
        ),
        // Carrot-style page indicator
        if (imageUrls.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(imageUrls.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentImageIndex == index ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentImageIndex == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
        // Image counter badge
        if (imageUrls.length > 1)
          Positioned(
            bottom: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentImageIndex + 1}/${imageUrls.length}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildProviderSection(Services service) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);
    final provider = service.userName;
    final providerId = provider.id;

    return InkWell(
      onTap: providerId > 0 ? () => context.push('/user/$providerId') : null,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: ClipOval(
                child: provider.profileImage?.image != null
                    ? CachedNetworkImageWidget(
                        imageUrl: ImageUtils.buildImageUrl(provider.profileImage!.image),
                        width: 48,
                        height: 48,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: Icon(Icons.person, color: colorScheme.onSurfaceVariant, size: 24),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.username ?? (localizations?.service_provider ?? 'Provider'),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    provider.location?.region ?? (localizations?.searchLocation ?? 'Location'),
                    style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: colorScheme.onSurfaceVariant, size: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 8,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
    );
  }

  Widget _buildServiceInfo(Services service) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            service.name ?? (localizations?.newProductTitle ?? 'No Title'),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          // Category + Time ago
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  getCategoryName().isNotEmpty
                      ? getCategoryName()
                      : (localizations?.newProductCategory ?? 'Category'),
                  style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _getTimeAgo(service.createdAt),
                style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Service badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF6F0F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFF6F0F).withOpacity(0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.handyman_rounded, size: 18, color: Color(0xFFFF6F0F)),
                const SizedBox(width: 6),
                Text(
                  localizations?.service_provider ?? 'Service',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFF6F0F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(Services service) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations?.newProductDescription ?? 'Description',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            service.description ?? (localizations?.newProductDescription ?? 'No description'),
            style: TextStyle(
              fontSize: 15,
              color: colorScheme.onSurface.withOpacity(0.85),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(Services service) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.favorite_border, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            '${service.likeCount ?? 0}',
            style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(width: 16),
          Icon(Icons.chat_bubble_outline, size: 16, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(
            '${service.comments?.length ?? 0}',
            style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomWidget(Services service) {
    if (isEditingComment) {
      return EditCommentWidget(
        commentText: editingCommentText,
        onTextChanged: (text) => setState(() => editingCommentText = text),
        onSave: _saveEditedComment,
        onCancel: _cancelEditingComment,
      );
    } else if (isReplyingToComment) {
      return ReplyCommentWidget(
        parentComment: replyingToComment!,
        replyText: replyCommentText,
        onTextChanged: (text) => setState(() => replyCommentText = text),
        onSave: _saveReplyComment,
        onCancel: _cancelReplyingComment,
      );
    } else {
      return _buildCarrotBottomBar(service);
    }
  }

  Widget _buildCarrotBottomBar(Services service) {
    final colorScheme = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);
    final currentLikeStatus = _isLiked ?? false;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            children: [
              // Heart button
              GestureDetector(
                onTap: _isLiking ? null : _toggleLike,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outline.withOpacity(0.3), width: 1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _isLiking
                      ? const Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : Icon(
                          currentLikeStatus ? Icons.favorite : Icons.favorite_border,
                          color: currentLikeStatus ? Colors.red : colorScheme.onSurfaceVariant,
                          size: 24,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Container(width: 1, height: 36, color: colorScheme.outline.withOpacity(0.2)),
              const SizedBox(width: 12),
              // Service label
              Expanded(
                child: Text(
                  localizations?.service_provider ?? 'Service',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Chat button (Carrot orange)
              SizedBox(
                height: 48,
                child: FilledButton(
                  onPressed: _startChat,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6F0F),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: Text(
                    localizations?.chat ?? 'Chat',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
