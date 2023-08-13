import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_posts/posts/bloc/post_bloc.dart';
import 'package:flutter_bloc_posts/posts/bloc/post_event.dart';
import 'package:flutter_bloc_posts/posts/bloc/post_state.dart';
import 'package:flutter_bloc_posts/posts/widgets/bottom_loader.dart';
import 'package:flutter_bloc_posts/posts/widgets/post_list_item.dart';

class PostsList extends StatefulWidget {
  const PostsList({super.key});

  @override
  State<PostsList> createState() => _PostsListState();
}

class _PostsListState extends State<PostsList> {
  final _scrollController = ScrollController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostBloc, PostState>(
      builder: (context, state) {
        if (state.status == PostStatus.failure) {
          return const Center(child: Text('failed to fetch posts'));
        }
        if (state.status == PostStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }
        isLoading = false;
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return index >= state.posts.length
                ? const BottomLoader()
                : PostListItem(post: state.posts[index]);
          },
          itemCount:
              state.hasReachedMax ? state.posts.length : state.posts.length + 1,
          controller: _scrollController,
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && !isLoading) {
      print("fetching");
      isLoading = true;
      context.read<PostBloc>().add(PostFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
