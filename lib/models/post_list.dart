import 'package:flutter/material.dart';

class Post {
  const Post(
      {required this.id,
      required this.title,
      required this.description,
      required this.city,
      required this.town,
      required this.price,
      required this.image,
      required this.category});

  final String id;
  final String title;
  final String description;
  final String image;
  final double price;
  final String city;
  final String town;
  final String category;
}
