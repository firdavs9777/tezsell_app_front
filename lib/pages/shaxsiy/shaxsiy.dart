import 'package:app/pages/shaxsiy/favorite_products.dart';
import 'package:app/pages/shaxsiy/favorite_services.dart';
import 'package:app/pages/shaxsiy/my_products.dart';
import 'package:app/pages/shaxsiy/my_services.dart';
import 'package:app/pages/shaxsiy/product_edit.dart';
import 'package:app/providers/provider_models/favorite_items.dart';
import 'package:app/providers/provider_models/product_model.dart';
import 'package:app/providers/provider_models/service_model.dart';
import 'package:app/providers/provider_models/user_model.dart';
import 'package:app/providers/provider_root/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShaxsiyPage extends ConsumerStatefulWidget {
  const ShaxsiyPage({super.key});

  @override
  _ShaxsiyPageState createState() => _ShaxsiyPageState();
}

class _ShaxsiyPageState extends ConsumerState<ShaxsiyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          ref.watch(profileServiceProvider).getUserInfo(),
          ref.watch(profileServiceProvider).getUserProducts(),
          ref.watch(profileServiceProvider).getUserServices(),
          ref.watch(profileServiceProvider).getUserFavoriteItems(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No user data available.'));
          }

          final user = snapshot.data![0] as UserInfo;
          final products = snapshot.data![1] as List<Products>;
          final services = snapshot.data![2] as List<Services>;
          final favorite_items = snapshot.data![3] as FavoriteItems;

          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'About Me',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  elevation: 1,
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      child: const Icon(
                        Icons.person,
                        color: Colors.blue,
                      ),
                    ),
                    title: Text(
                      'My name',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      user.username, // Dynamic name
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 22,
                      color: Colors.grey[600],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'My Page',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                Card(
                  color: Colors.white,
                  elevation: 1,
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      child: const Icon(
                        Icons.inventory_2,
                        color: Colors.blue,
                      ),
                    ),
                    title: Text(
                      'My products',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      products.length.toString(), // Dynamic MBTI
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 22,
                      color: Colors.grey[600],
                    ),
                    onTap: () {
                      // products.map((product) => ListTile(
                      //       title: Text(product.title),
                      //       subtitle: Text('${product.price} ${product.currency}'),
                      //     )),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyProducts(products: products)),
                      );
                    },
                  ),
                ),
                Card(
                  color: Colors.white,
                  elevation: 1,
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      child: const Icon(
                        Icons.room_service,
                        color: Colors.blue,
                      ),
                    ),
                    title: Text(
                      'My services',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      services.length.toString(), // Dynamic MBTI
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 22,
                      color: Colors.grey[600],
                    ),
                    onTap: () {
                      // products.map((product) => ListTile(
                      //       title: Text(product.title),
                      //       subtitle: Text('${product.price} ${product.currency}'),
                      //     )),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                MyServices(services: services)),
                      );
                    },
                  ),
                ),
                Card(
                  color: Colors.white,
                  elevation: 1,
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.blue,
                      ),
                    ),
                    title: Text(
                      'Favorite products',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      favorite_items.likedProducts.length
                          .toString(), // Dynamic MBTI
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 22,
                      color: Colors.grey[600],
                    ),
                    onTap: () {
                      // products.map((product) => ListTile(
                      //       title: Text(product.title),
                      //       subtitle: Text('${product.price} ${product.currency}'),
                      //     )),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavoriteProducts(
                                products: favorite_items.likedProducts)),
                      );
                    },
                  ),
                ),
                Card(
                  color: Colors.white,
                  elevation: 1,
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.blue,
                      ),
                    ),
                    title: Text(
                      'Favorite services',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      favorite_items.likedServices.length
                          .toString(), // Dynamic MBTI
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 22,
                      color: Colors.grey[600],
                    ),
                    onTap: () {
                      // products.map((product) => ListTile(
                      //       title: Text(product.title),
                      //       subtitle: Text('${product.price} ${product.currency}'),
                      //     )),
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FavoriteServices(
                                services: favorite_items.likedServices)),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Customer Support',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                // Customer Support Section
                Card(
                  color: Colors.white,
                  elevation: 1,
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(
                      Icons.phone_in_talk, // Icon for Customer Center
                      color: Colors.blue,
                    ),
                    title: Text(
                      'Customer Center',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 22,
                      color:
                          Colors.grey[600], // Subtle gray color for the arrow
                    ),
                    onTap: () {
                      // Navigate to Customer Center page
                    },
                  ),
                ),
                Card(
                  color: Colors.white,
                  elevation: 1,
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(
                      Icons.help_outline, // Icon for Inquiries
                      color: Colors.blue,
                    ),
                    title: Text(
                      'Inquiries',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 22,
                      color:
                          Colors.grey[600], // Subtle gray color for the arrow
                    ),
                    onTap: () {
                      // Navigate to Inquiries page
                    },
                  ),
                ),
                Card(
                  color: Colors.white,
                  elevation: 1,
                  margin:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(
                      Icons.article, // Icon for Terms and Conditions
                      color: Colors.blue,
                    ),
                    title: Text(
                      'Terms and Conditions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 22,
                      color:
                          Colors.grey[600], // Subtle gray color for the arrow
                    ),
                    onTap: () {
                      // Navigate to Terms and Conditions page
                    },
                  ),
                )
                // More cards can follow with dynamic values
              ],
            ),
          );
        },
      ),
    );
  }
}
