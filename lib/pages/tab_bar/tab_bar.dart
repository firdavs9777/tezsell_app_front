import 'package:app/pages/change_city/change_city.dart';
import 'package:app/pages/habar/habar.dart';
import 'package:app/pages/products/product_search.dart';
import 'package:app/pages/service/main_service.dart';
import 'package:app/pages/products/products_list.dart';
import 'package:app/pages/service/service_search.dart';
import 'package:app/pages/shaxsiy/shaxsiy.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
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
    // final user = ref.watch(profileServiceProvider).getUserInfo();
    // ref.refresh(productsProvider);
    // ref.refresh(servicesProvider);
  }

  void _selectPage(int index) {
    setState(() {
      ref.refresh(productsProvider);
      ref.refresh(servicesProvider);
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var activePageTitle = 'Products';
    Widget activePage = const ProductsList();

    if (_selectedPageIndex == 1) {
      activePageTitle = 'Services';
      activePage = const ServiceMain();
    } else if (_selectedPageIndex == 2) {
      activePageTitle = 'Habarlar';
      activePage = const HabarMain();
    } else if (_selectedPageIndex == 3) {
      activePageTitle = 'Shaxsiy Hisob';
      activePage = const ShaxsiyPage();
    }

    return Scaffold(
      appBar: AppBar(
        leading: Builder(builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MyHomeTown()));
            },
            child: Container(
              width: 120,
              child: Row(
                children: [
                  FutureBuilder<UserInfo>(
                    future: ref.watch(profileServiceProvider).getUserInfo(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData) {
                        return const Center(
                            child: Text('No user data available.'));
                      }
                      final user = snapshot.data!;
                      final district = user.location.district;
                      final firstPart = district.contains(' ')
                          ? district.split(' ')[0]
                          : district;
                      final displayedText = firstPart.length > 10
                          ? firstPart.substring(0, 5) + '...'
                          : firstPart;
                      return Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(displayedText),
                      );
                    },
                  ),
                  Expanded(
                    child: Icon(Icons.keyboard_arrow_down_sharp),
                  ),
                ],
              ),
            ),
          );
        }),
        actions: [
          if (activePageTitle == 'Products' ||
              activePageTitle ==
                  'Services') // Check if the title is either 'Products' or 'Services'
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    onPressed: () {
                      // Check if the active page is Products or Services
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
                            builder: (ctx) =>
                                const ServiceSearch(), // Replace with your ServiceSearch screen
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
            ),
        ],
        title: Text(activePageTitle),
        automaticallyImplyLeading: false,
      ),
      body: activePage,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey, // Set your desired border color
              width: 1.0, // Set the width of the border
            ),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          onTap: _selectPage,
          currentIndex: _selectedPageIndex,
          selectedItemColor: Colors.blue,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Asosiy'),
            BottomNavigationBarItem(
                icon: Icon(Icons.post_add), label: 'Services'),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.not_listed_location), label: 'Atrofimda'),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Habarlar'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Shaxsiy'),
          ],
        ),
      ),
    );
  }
}
