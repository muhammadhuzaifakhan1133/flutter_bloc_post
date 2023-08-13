import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc_posts/posts/bloc/post_event.dart';
import 'package:flutter_bloc_posts/posts/bloc/post_state.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_posts/posts/repository/post_repository.dart';
import 'package:stream_transform/stream_transform.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
     return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository postRepository;

  PostBloc({required this.postRepository}) : super(const PostState()) {
    on<PostFetched>(_onPostFetched, transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _onPostFetched(PostEvent event, Emitter<PostState> emit) async {
    if (state.hasReachedMax) return;
    try {
     if (state.status == PostStatus.initial) {
        final posts = await postRepository.fetchPosts();
        return emit(
          state.copyWith(
            status: PostStatus.success,
            posts: posts,
            hasReachedMax: false,
          ),
        );
      }
      final posts = await postRepository.fetchPosts(startIndex: state.posts.length);
      posts.isEmpty
          ? emit(state.copyWith(hasReachedMax: true))
          : emit(
              state.copyWith(
                status: PostStatus.success,
                posts: state.posts + posts,
                hasReachedMax: false,
              ),
            );
    } catch (_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }
}
