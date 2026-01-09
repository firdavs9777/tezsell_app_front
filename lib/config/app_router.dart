import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';

// Pages
import '../pages/tab_bar/splash_screen.dart';
import '../pages/language/language_selection.dart';
import '../pages/authentication/login.dart';
import '../pages/home.dart';
import '../pages/tab_bar/tab_bar.dart';
import '../pages/products/product_detail.dart';
import '../pages/products/product_new.dart';
import '../pages/products/product_search.dart';
import '../pages/products/products_list.dart';
import '../pages/service/details/service_detail.dart';
import '../pages/service/new/service_new.dart';
import '../pages/service/main/service_search.dart';
import '../pages/service/main/main_service.dart';
import '../pages/real_estate/real_estate_detail.dart';
import '../pages/real_estate/real_estate_main.dart';
import '../pages/real_estate/real_estate_search.dart';
import '../pages/real_estate/property_create_page.dart';
import '../pages/chat/chat_list.dart';
import '../pages/chat/chat_room.dart';
import '../providers/provider_models/message_model.dart';
import '../pages/shaxsiy/shaxsiy.dart';
import '../pages/shaxsiy/main_profile/profile_edit.dart';
import '../pages/shaxsiy/favorite_items/favorite_products.dart';
import '../pages/shaxsiy/favorite_items/favorite_services.dart';
import '../pages/shaxsiy/my-products/my_products.dart';
import '../pages/shaxsiy/my-services/my_services.dart';
import '../pages/shaxsiy/properties/saved_properties.dart';
import '../pages/change_city/change_city.dart';
import '../pages/admin/admin_dashboard.dart';

// Providers
import '../service/authentication_service.dart';
import '../providers/provider_root/product_provider.dart';
import '../providers/provider_root/service_provider.dart';
import '../providers/provider_root/chat_provider.dart';
import '../providers/provider_root/profile_provider.dart';
import '../providers/provider_models/product_model.dart';
import '../providers/provider_models/service_model.dart';
import '../providers/provider_models/message_model.dart';
import '../constants/constants.dart';

// Router provider
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      final authService = ref.read(authenticationServiceProvider);
      final isLoggedIn = await authService.isLoggedIn();
      final isLoggingIn = state.matchedLocation == '/login';
      final isLanguageSelection = state.matchedLocation == '/language';
      final isSplash = state.matchedLocation == '/';
      final isHome = state.matchedLocation == '/home';

      // Allow splash, language selection, and login without auth
      if (isSplash || isLanguageSelection || isLoggingIn) {
        return null;
      }

      // If not logged in and trying to access protected route
      if (!isLoggedIn && !isHome) {
        // Check if trying to access public routes (products, services, real estate)
        final publicRoutes = ['/products', '/services', '/real-estate'];
        final isPublicRoute = publicRoutes.any((route) => 
          state.matchedLocation.startsWith(route) && 
          !state.matchedLocation.contains('/new') &&
          !state.matchedLocation.contains('/edit')
        );
        
        if (isPublicRoute) {
          return null; // Allow public viewing
        }
        
        return '/login';
      }

      // If logged in and on login page, redirect to tabs
      if (isLoggedIn && isLoggingIn) {
        return '/tabs';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/language',
        name: 'language',
        builder: (context, state) => const LanguageSelectionScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const Login(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const Home(),
      ),
      GoRoute(
        path: '/tabs',
        name: 'tabs',
        builder: (context, state) {
          final index = int.tryParse(state.uri.queryParameters['index'] ?? '0') ?? 0;
          return TabsScreen(initialIndex: index);
        },
      ),
      // Product routes
      GoRoute(
        path: '/products',
        name: 'products',
        builder: (context, state) {
          final regionName = state.uri.queryParameters['region'] ?? '';
          final districtName = state.uri.queryParameters['district'] ?? '';
          return ProductsList(regionName: regionName, districtName: districtName);
        },
      ),
      GoRoute(
        path: '/product/:id',
        name: 'product-detail',
        builder: (context, state) {
          final productId = state.pathParameters['id']!;
          return _ProductDetailWrapper(productId: productId);
        },
      ),
      GoRoute(
        path: '/product/new',
        name: 'product-new',
        builder: (context, state) => const ProductNew(),
      ),
      GoRoute(
        path: '/product/search',
        name: 'product-search',
        builder: (context, state) {
          final regionName = state.uri.queryParameters['region'] ?? '';
          final districtName = state.uri.queryParameters['district'] ?? '';
          return ProductSearch(regionName: regionName, districtName: districtName);
        },
      ),
      // Service routes
      GoRoute(
        path: '/services',
        name: 'services',
        builder: (context, state) {
          final regionName = state.uri.queryParameters['region'] ?? '';
          final districtName = state.uri.queryParameters['district'] ?? '';
          return ServiceMain(regionName: regionName, districtName: districtName);
        },
      ),
      GoRoute(
        path: '/service/:id',
        name: 'service-detail',
        builder: (context, state) {
          final serviceId = state.pathParameters['id']!;
          return _ServiceDetailWrapper(serviceId: serviceId);
        },
      ),
      GoRoute(
        path: '/service/new',
        name: 'service-new',
        builder: (context, state) => const ServiceNew(),
      ),
      GoRoute(
        path: '/service/search',
        name: 'service-search',
        builder: (context, state) {
          final regionName = state.uri.queryParameters['region'] ?? '';
          final districtName = state.uri.queryParameters['district'] ?? '';
          return ServiceSearch(regionName: regionName, districtName: districtName);
        },
      ),
      // Real Estate routes
      GoRoute(
        path: '/real-estate',
        name: 'real-estate',
        builder: (context, state) {
          final regionName = state.uri.queryParameters['region'] ?? '';
          final districtName = state.uri.queryParameters['district'] ?? '';
          return RealEstateMain(regionName: regionName, districtName: districtName);
        },
      ),
      GoRoute(
        path: '/real-estate/:id',
        name: 'real-estate-detail',
        builder: (context, state) {
          final propertyId = state.pathParameters['id']!;
          return PropertyDetail(propertyId: propertyId);
        },
      ),
      GoRoute(
        path: '/real-estate/new',
        name: 'real-estate-new',
        builder: (context, state) => const PropertyCreatePage(),
      ),
      GoRoute(
        path: '/real-estate/search',
        name: 'real-estate-search',
        builder: (context, state) => const RealEstateSearch(),
      ),
      // Chat routes
      GoRoute(
        path: '/chat',
        name: 'chat-list',
        builder: (context, state) => const MessagesList(),
      ),
      GoRoute(
        path: '/chat/:id',
        name: 'chat-room',
        builder: (context, state) {
          final chatId = state.pathParameters['id']!;
          return _ChatRoomWrapper(chatId: chatId);
        },
      ),
      // Profile routes
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ShaxsiyPage(),
      ),
      GoRoute(
        path: '/profile/edit',
        name: 'profile-edit',
        builder: (context, state) => const ProfileEditScreen(),
      ),
      GoRoute(
        path: '/profile/favorites/products',
        name: 'favorite-products',
        builder: (context, state) => _FavoriteProductsWrapper(),
      ),
      GoRoute(
        path: '/profile/favorites/services',
        name: 'favorite-services',
        builder: (context, state) => _FavoriteServicesWrapper(),
      ),
      GoRoute(
        path: '/profile/my-products',
        name: 'my-products',
        builder: (context, state) => const MyProducts(),
      ),
      GoRoute(
        path: '/profile/my-services',
        name: 'my-services',
        builder: (context, state) => const MyServices(),
      ),
      GoRoute(
        path: '/profile/properties',
        name: 'saved-properties',
        builder: (context, state) => const SavedProperties(),
      ),
      // Other routes
      GoRoute(
        path: '/change-city',
        name: 'change-city',
        builder: (context, state) => const MyHomeTown(),
      ),
      GoRoute(
        path: '/admin',
        name: 'admin-dashboard',
        builder: (context, state) => const AdminDashboard(),
      ),
    ],
  );
});

// Wrapper widgets to fetch data before showing detail pages
class _ProductDetailWrapper extends ConsumerStatefulWidget {
  final String productId;

  const _ProductDetailWrapper({required this.productId});

  @override
  ConsumerState<_ProductDetailWrapper> createState() => _ProductDetailWrapperState();
}

class _ProductDetailWrapperState extends ConsumerState<_ProductDetailWrapper> {
  Products? _product;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      final dio = Dio(BaseOptions(baseUrl: baseUrl));
      final response = await dio.get('$PRODUCTS_URL/${widget.productId}/');
      
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        Products product;
        if (data['product'] != null) {
          product = Products.fromJson(data['product']);
        } else {
          product = Products.fromJson(data);
        }
        
        if (mounted) {
          setState(() {
            _product = product;
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Failed to load product: $_error'),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return ProductDetail(product: _product!);
  }
}

class _ServiceDetailWrapper extends ConsumerStatefulWidget {
  final String serviceId;

  const _ServiceDetailWrapper({required this.serviceId});

  @override
  ConsumerState<_ServiceDetailWrapper> createState() => _ServiceDetailWrapperState();
}

class _ServiceDetailWrapperState extends ConsumerState<_ServiceDetailWrapper> {
  Services? _service;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadService();
  }

  Future<void> _loadService() async {
    try {
      final service = await ref.read(serviceMainProvider)
          .getSingleService(serviceId: widget.serviceId);
      
      if (mounted) {
        setState(() {
          _service = service;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _service == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Failed to load service: $_error'),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return ServiceDetail(service: _service!);
  }
}

class _ChatRoomWrapper extends ConsumerStatefulWidget {
  final String chatId;

  const _ChatRoomWrapper({required this.chatId});

  @override
  ConsumerState<_ChatRoomWrapper> createState() => _ChatRoomWrapperState();
}

class _ChatRoomWrapperState extends ConsumerState<_ChatRoomWrapper> {
  ChatRoom? _chatRoom;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadChatRoom();
  }

  Future<void> _loadChatRoom() async {
    try {
      final chatState = ref.read(chatProvider);
      final chatRooms = chatState.chatRooms;
      
      // Try to find the chat room by ID
      final chatIdInt = int.tryParse(widget.chatId);
      if (chatIdInt != null) {
        final room = chatRooms.firstWhere(
          (room) => room.id == chatIdInt,
          orElse: () => ChatRoom(
            id: chatIdInt,
            name: 'Chat',
            participants: [],
            unreadCount: 0,
          ),
        );
        
        if (mounted) {
          setState(() {
            _chatRoom = room;
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Invalid chat ID: ${widget.chatId}');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _chatRoom == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Failed to load chat: $_error'),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return ChatRoomScreen(chatRoom: _chatRoom!);
  }
}

class _FavoriteProductsWrapper extends ConsumerWidget {
  const _FavoriteProductsWrapper();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteItemsAsync = ref.watch(profileServiceProvider.select(
      (provider) => provider.getUserFavoriteItems(),
    ));

    return FutureBuilder(
      future: favoriteItemsAsync,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load favorite products: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        }

        return FavoriteProducts(products: snapshot.data!.likedProducts);
      },
    );
  }
}

class _FavoriteServicesWrapper extends ConsumerWidget {
  const _FavoriteServicesWrapper();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteItemsAsync = ref.watch(profileServiceProvider.select(
      (provider) => provider.getUserFavoriteItems(),
    ));

    return FutureBuilder(
      future: favoriteItemsAsync,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Failed to load favorite services: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: () => context.pop(),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          );
        }

        return FavoriteServices(services: snapshot.data!.likedServices);
      },
    );
  }
}

