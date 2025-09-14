import 'package:app/pages/change_city/change_city.dart';
import 'package:app/pages/messages/messages.dart';
import 'package:app/pages/products/product_search.dart';
import 'package:app/pages/service/main_service.dart';
import 'package:app/pages/products/products_list.dart';
import 'package:app/pages/service/service_search.dart';
import 'package:app/pages/real_estate/real_estate_main.dart';
import 'package:app/pages/real_estate/real_estate_search.dart';
import 'package:app/pages/shaxsiy/shaxsiy.dart';
import 'package:app/providers/provider_root/product_provider.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:app/providers/provider_root/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  // Method to handle location change navigation
  Future<void> _navigateToLocationChange() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyHomeTown()),
    );

    // If the location was updated (result is true), refresh the profile provider
    if (result == true) {
      ref.invalidate(profileServiceProvider);
      // Also refresh other providers that might depend on location
      ref.invalidate(productsProvider);
      ref.invalidate(servicesProvider);
      // ref.invalidate(realEstateProvider); // Uncomment when you create this
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Consumer(
      builder: (context, ref, child) {
        // Watch user info to get current location
        final userInfoAsync = ref.watch(profileServiceProvider.select(
          (provider) => provider.getUserInfo(),
        ));

        return FutureBuilder<UserInfo>(
          future: userInfoAsync,
          builder: (context, snapshot) {
            // Extract location data
            String regionName = '';
            String districtName = '';

            if (snapshot.hasData && snapshot.data!.location != null) {
              regionName = snapshot.data!.location!.region ?? '';
              districtName = snapshot.data!.location!.district ?? '';
            }

            // Updated page titles and widgets for 5 tabs
            String activePageTitle;
            Widget activePage;

            switch (_selectedPageIndex) {
              case 0:
                activePageTitle = localizations?.productsTitle ?? 'Products';
                activePage = ProductsList(
                  regionName: regionName!,
                  districtName: districtName!,
                );
                break;
              case 1:
                activePageTitle = localizations?.servicesTitle ?? 'Services';
                activePage = ServiceMain(
                  regionName: regionName!,
                  districtName: districtName!,
                );
                break;
              case 2:
                activePageTitle = localizations?.realEstate ?? 'Real Estate';
                activePage = RealEstateMain(
                    regionName: regionName!, districtName: districtName!);
                break;
              case 3:
                activePageTitle = localizations?.chat ?? 'Habarlar';
                activePage = Messages();
                break;
              case 4:
                activePageTitle = localizations?.profile ?? 'Shaxsiy Hisob';
                activePage = const ShaxsiyPage();
                break;
              default:
                activePageTitle = localizations?.productsTitle ?? 'Products';
                activePage = ProductsList(
                  regionName: regionName!,
                  districtName: districtName!,
                );
            }

            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                leading: Builder(builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: _navigateToLocationChange,
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width *
                            0.4, // Max 40% of screen width
                        minWidth: 80, // Minimum width to ensure readability
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize.min, // Take only needed space
                        children: [
                          // Use Consumer to watch for profile changes
                          Flexible(
                            // Allow text to shrink if needed
                            child: Consumer(
                              builder: (context, ref, child) {
                                final userInfoAsync =
                                    ref.watch(profileServiceProvider.select(
                                  (provider) => provider.getUserInfo(),
                                ));

                                return FutureBuilder<UserInfo>(
                                  future: userInfoAsync,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          localizations?.error ?? 'Error',
                                          style: const TextStyle(fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      );
                                    } else if (!snapshot.hasData) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Text(
                                          localizations?.loading ??
                                              'Loading...',
                                          style: const TextStyle(fontSize: 14),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      );
                                    }
                                    final user = snapshot.data!;
                                    final district = user.location?.district ??
                                        (localizations?.searchLocation ??
                                            'Location');

                                    // Better text truncation logic
                                    String displayedText;
                                    if (district.length <= 8) {
                                      displayedText = district;
                                    } else if (district.contains(' ')) {
                                      final firstPart = district.split(' ')[0];
                                      displayedText = firstPart.length > 8
                                          ? '${firstPart.substring(0, 6)}...'
                                          : firstPart;
                                    } else {
                                      displayedText =
                                          '${district.substring(0, 6)}...';
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(left: 4.0),
                                      child: Text(
                                        displayedText,
                                        style: const TextStyle(fontSize: 14),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 4), // Small spacing
                          Icon(
                            Icons.keyboard_arrow_down_sharp,
                            size: 20, // Slightly smaller icon
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                actions: [
                  // Show search icon for Products, Services, and Real Estate
                  if (_selectedPageIndex == 0 ||
                      _selectedPageIndex == 1 ||
                      _selectedPageIndex == 2)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        onPressed: () {
                          // Navigate to appropriate search page
                          if (_selectedPageIndex == 0) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => const ProductSearch(),
                              ),
                            );
                          } else if (_selectedPageIndex == 1) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => const ServiceSearch(),
                              ),
                            );
                          } else if (_selectedPageIndex == 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => const RealEstateSearch(),
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.search,
                          size: 24,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                ],
                title: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(activePageTitle),
                ),
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
                  selectedItemColor: Colors.blue,
                  unselectedItemColor: Colors.grey,
                  selectedFontSize: 12,
                  unselectedFontSize: 10,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: localizations?.main ?? 'Asosiy',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.post_add),
                      label: localizations?.servicesTitle ?? 'Services',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.apartment),
                      label: localizations?.realEstate ?? 'Ko\'chmas',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat),
                      label: localizations?.chat ?? 'Habarlar',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: localizations?.profile ?? 'Shaxsiy',
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
