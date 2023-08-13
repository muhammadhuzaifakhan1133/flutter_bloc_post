import 'dart:convert';

import 'package:flutter_bloc_posts/posts/models/post.dart';
import 'package:http/http.dart' as http;

class PostProvider {
  Future<dynamic> fetchPosts(
      {int startIndex = 0, int postLimit = 20}) async {
    Uri uri = Uri.https("jsonplaceholder.typicode.com", '/posts',
        <String, String>{"_start": "$startIndex", "_limit": "$postLimit"});
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception("error fetching posts");
  }
}
