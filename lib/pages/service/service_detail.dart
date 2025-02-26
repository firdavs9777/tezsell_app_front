import 'package:app/constants/constants.dart';
import 'package:app/pages/comments/comments.dart';
import 'package:app/pages/comments/create_comment.dart';
import 'package:app/pages/service/services_list.dart';
import 'package:app/providers/provider_models/favorite_items.dart';
import 'package:app/providers/provider_models/service_model.dart';
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

  void _likeService() async {
    try {
      final service = await ref
          .watch(profileServiceProvider)
          .likeSingleService(serviceId: widget.service.id.toString());
      print(service);

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
          _serviceData = service; // Update state with new service data
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
          _serviceData = service; // Update state with new service data
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
                              curve:
                                  Curves.elasticInOut, // Adds a bounce effect
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: IconButton(
                                    icon: Icon(
                                      isLiked
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.red,
                                      size: 24.0, // Make the icon bigger
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
                  ),
                  RecommendedServicesSection(
                      recommendedServices: _recommendedServices),
                ],
              ),
            ),
      bottomNavigationBar: CreateComment(
        id: widget.service.id.toString(),
        onCommentAdded: _refreshServiceDetail, // Refresh after adding a comment
      ),
    );
  }
}

// -----------------------
// IMAGE SLIDER WIDGET
// -----------------------
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
            .map((image) => NetworkImage('${baseUrl}/services${image.image}')
                as ImageProvider)
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
                radius: 21,
                backgroundImage: service.userName.profileImage.image.isNotEmpty
                    ? NetworkImage(
                        '${baseUrl}${service.userName.profileImage.image}')
                    : null,
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.userName.username,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(
                    '${service.userName.location.region}, ${service.userName.location.district}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          Text(service.category.name,
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

// -----------------------
// RECOMMENDED SERVICES WIDGET
// -----------------------
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
          const Text('Recommended Products',
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
