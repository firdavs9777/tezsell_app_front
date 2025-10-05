import 'package:app/constants/constants.dart';
import 'package:app/pages/comments/comments.dart';
import 'package:app/pages/comments/create_comment.dart';
import 'package:app/pages/service/services_list.dart';
import 'package:app/providers/provider_models/favorite_items.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_models/comments_model.dart';
import 'package:app/providers/provider_root/comments_providers.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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

  /// Fetches the service details and updates the state
  void _fetchSingleService() async {
    final service = await ref
        .read(serviceMainProvider)
        .getSingleService(serviceId: widget.service.id.toString());

    setState(() {
      _serviceData = service; // Update state with new service data
    });
  }

  /// Fetches recommended services
  void _fetchRecommendedServices() {
    _recommendedServices = ref
        .read(serviceMainProvider)
        .getRecommendedServices(serviceId: widget.service.id.toString());
  }

  void _refreshServiceDetail() {
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

  // Function to save edited comment
  void _saveEditedComment() async {
    if (editingComment != null && editingCommentText.isNotEmpty) {
      try {
        await ref.read(commentsServiceProvider).editComment(
              title: editingCommentText,
              serviceId: widget.service.id.toString(),
              commentId: editingComment!.id.toString(),
            );

        ref.refresh(commentsServiceProvider);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comment updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        _cancelEditingComment();
        _refreshServiceDetail();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating comment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Function to save reply comment
  void _saveReplyComment() async {
    if (replyingToComment != null && replyCommentText.isNotEmpty) {
      try {
        // TODO: Implement your reply comment API call here
        // await ref.read(commentsServiceProvider).replyToComment(
        //   parentCommentId: replyingToComment!.id.toString(),
        //   text: replyCommentText,
        // );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reply added successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        _cancelReplyingComment();
        _refreshServiceDetail();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding reply: $e'),
            backgroundColor: Colors.red,
          ),
        );
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
                  ServiceDetailsSection(service: _serviceData!),
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

// New widget for replying to comments
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

// Existing edit comment widget
class EditCommentWidget extends StatefulWidget {
  final String commentText;
  final Function(String) onTextChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const EditCommentWidget({
    Key? key,
    required this.commentText,
    required this.onTextChanged,
    required this.onSave,
    required this.onCancel,
  }) : super(key: key);

  @override
  _EditCommentWidgetState createState() => _EditCommentWidgetState();
}

class _EditCommentWidgetState extends State<EditCommentWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.commentText);
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
            Row(
              children: [
                const Icon(Icons.edit, color: Colors.blue),
                const SizedBox(width: 8),
                const Text(
                  'Edit Comment',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              onChanged: widget.onTextChanged,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Edit your comment...',
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
                  'Save Changes',
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

// Keep the existing classes (ServiceImageSlider, ServiceDetailsSection, RecommendedServicesSection)
class ServiceImageSlider extends StatelessWidget {
  const ServiceImageSlider({
    super.key,
    required this.service,
    required this.pageController,
  });

  final Services service;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    List<ImageProvider> images = service.images.isNotEmpty
        ? service.images
            .map((image) =>
                NetworkImage('${baseUrl}${image.image}') as ImageProvider)
            .toList()
        : [
            const AssetImage('assets/logo/logo_no_background.png')
                as ImageProvider
          ];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            height: 250,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.0)),
            child: Stack(
              children: [
                PageView.builder(
                  controller: pageController,
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Image(image: images[index], fit: BoxFit.cover);
                  },
                ),
                Positioned(
                  left: 10,
                  top: 100,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      if (pageController.page!.toInt() > 0) {
                        pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 100,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      if (pageController.page!.toInt() < images.length - 1) {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SmoothPageIndicator(
          controller: pageController,
          count: images.length,
          effect: const WormEffect(
              dotWidth: 8.0,
              dotHeight: 8.0,
              dotColor: Colors.grey,
              activeDotColor: Colors.blue),
        ),
      ],
    );
  }
}

class ServiceDetailsSection extends StatelessWidget {
  const ServiceDetailsSection({super.key, required this.service});

  final Services service;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.green[100],
                child: Icon(Icons.home, color: Colors.green[600]),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Property Owner',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${service.userName.location.region}, ${service.userName.location.district}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      service!.userName.phoneNumber,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.phone, color: Colors.green),
              ),
            ],
          ),
          Text(service.category.nameEn,
              style: const TextStyle(
                  fontSize: 14, decoration: TextDecoration.underline)),
          const SizedBox(height: 10),
          Text(service.name!,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(service.description!, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

class RecommendedServicesSection extends StatelessWidget {
  const RecommendedServicesSection(
      {super.key, required this.recommendedServices});

  final Future<List<Services>> recommendedServices;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Recommended Services',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          FutureBuilder<List<Services>>(
            future: recommendedServices,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading products'));
              }
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ServiceList(
                      service: snapshot.data![index],
                      refresh: () {},
                    );
                  },
                );
              }
              return const Center(
                  child: Text('No recommended products found.'));
            },
          ),
        ],
      ),
    );
  }
}
