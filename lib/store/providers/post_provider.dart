import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:app/models/post_list.dart';
import 'package:http/http.dart' as http;

class PostNotifier extends ChangeNotifier {
  List<Post> posts = [];
  Future<void> fetchPosts() async {
    final response =
        await http.get(Uri.parse('http://localhost:5002/api/v1/posts'));
    if (response.statusCode == 200) {
      final List<Post> data = jsonDecode(response.body);
      posts = data;
    }
  }
}

final postNotifierProvider = ChangeNotifierProvider<PostNotifier>((ref) {
  final notifier = PostNotifier();
  notifier.fetchPosts();
  return notifier;
});
