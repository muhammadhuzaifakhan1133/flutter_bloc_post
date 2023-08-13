import 'package:flutter_bloc_posts/data_provider/post_provider.dart';
import 'package:flutter_bloc_posts/posts/models/post.dart';

class PostRepository {
  final PostProvider _postProvider = PostProvider();
  
  Future<List<Post>> fetchPosts({int startIndex = 0}) async {
    final rawData =
        await _postProvider.fetchPosts(startIndex: startIndex, postLimit: 20);
    final body = rawData as List;
    List<Post> posts = [];
    for (var json in body) {
      final map = json as Map<String, dynamic>;
      final post = Post(
          id: map["id"] as int,
          title: map["title"] as String,
          body: map["body"] as String);
      posts.add(post);
    }
    return posts;
  }
}
