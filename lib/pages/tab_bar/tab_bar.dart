import 'package:app/pages/change_city/change_city.dart';
import 'package:app/pages/habar/habar.dart';
import 'package:app/pages/products/product_search.dart';
import 'package:app/pages/service/main_service.dart';
import 'package:app/pages/products/products_list.dart';
import 'package:app/pages/service/service_search.dart';
// Add these imports for real estate
import 'package:app/pages/real_estate/real_estate_main.dart';
import 'package:app/pages/real_estate/real_estate_search.dart';
import 'package:app/pages/shaxsiy/shaxsiy.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
// Add real estate provider import
// import 'package:app/providers/provider_root/real_estate_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_models/user_model.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  late int _selectedPageIndex = 0;

  @override
  void initState() {
    _selectedPageIndex = widget.initialIndex;
    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      // Only refresh providers when switching to avoid unnecessary reloads
      if (index != _selectedPageIndex) {
        switch (index) {
          case 0:
            ref.invalidate(productsProvider);
            break;
          case 1:
            ref.invalidate(servicesProvider);
            break;
          case 2:
            // Add real estate provider refresh when you create it
            // ref.invalidate(realEstateProvider);
            break;
          // case 3 is Habarlar - no need to refresh
          // case 4 is Profile - refreshed when needed
        }
      }
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Updated page titles and widgets for 5 tabs
    String activePageTitle;
    Widget activePage;

    switch (_selectedPageIndex) {
      case 0:
        activePageTitle = 'Products';
        activePage = const ProductsList();
        break;
      case 1:
        activePageTitle = 'Services';
        activePage = const ServiceMain();
        break;
      case 2:
        activePageTitle = 'Real Estate';
        activePage = const RealEstateMain(); // You'll need to create this
        break;
      case 3:
        activePageTitle = 'Habarlar';
        activePage = const HabarMain();
        break;
      case 4:
        activePageTitle = 'Shaxsiy Hisob';
        activePage = const ShaxsiyPage();
        break;
      default:
        activePageTitle = 'Products';
        activePage = const ProductsList();
    }

    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomeTown()),
              );
            },
            child: SizedBox(
              width: 140,
              child: Row(
                children: [
                  FutureBuilder<UserInfo>(
                    future: ref.watch(profileServiceProvider).getUserInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(child: Text('Error'));
                      } else if (!snapshot.hasData) {
                        return const Center(child: Text('Loading...'));
                      }
                      final user = snapshot.data!;
                      final district = user.location?.district ?? 'Location';
                      final firstPart = district.contains(' ')
                          ? district.split(' ')[0]
                          : district;
                      final displayedText = firstPart.length > 7
                          ? '${firstPart.substring(0, 4)}...'
                          : firstPart;
                      return Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          displayedText,
                          style: const TextStyle(fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ),
                  const Expanded(
                    child: Icon(Icons.keyboard_arrow_down_sharp),
                  ),
                ],
              ),
            ),
          );
        }),
        actions: [
          // Show search icon for Products, Services, and Real Estate
          if (activePageTitle == 'Products' ||
              activePageTitle == 'Services' ||
              activePageTitle == 'Real Estate')
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  // Navigate to appropriate search page
                  if (activePageTitle == 'Products') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const ProductSearch(),
                      ),
                    );
                  } else if (activePageTitle == 'Services') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => const ServiceSearch(),
                      ),
                    );
                  } else if (activePageTitle == 'Real Estate') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) =>
                            const RealEstateSearch(), // You'll need to create this
                      ),
                    );
                  }
                },
                icon: const Icon(
                  Icons.search,
                  size: 34,
                ),
              ),
            ),
        ],
        title: Text(activePageTitle),
        automaticallyImplyLeading: false,
      ),
      body: activePage,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          selectedItemColor:
              Colors.blue, // This makes active icon and label blue
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          unselectedFontSize: 10,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Asosiy',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.post_add),
              label: 'Services',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apartment),
              label: 'Ko\'chmas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Habarlar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Shaxsiy',
            ),
          ],
        ),
      ),
    );
  }
}
