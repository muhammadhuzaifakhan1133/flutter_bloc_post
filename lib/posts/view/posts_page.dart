import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_posts/posts/bloc/post_bloc.dart';
import 'package:flutter_bloc_posts/posts/bloc/post_event.dart';
import 'package:flutter_bloc_posts/posts/repository/post_repository.dart';
import 'package:flutter_bloc_posts/posts/view/posts_list.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Posts"),
      ),
      body: BlocProvider(
        create: (_) => PostBloc(postRepository: PostRepository())..add(PostFetched()),
        child: const PostsList(),
      ),
    );
  }
}