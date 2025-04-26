


import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:first_project/bloc/infinite_list/posts/bloc/post_event.dart';
import 'package:first_project/bloc/infinite_list/posts/bloc/post_state.dart';
import 'package:first_project/bloc/infinite_list/posts/models/post.dart';
import 'package:http/http.dart' as http;
import 'package:stream_transform/stream_transform.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

const _postLimit = 20;
const throttleDuration = Duration(milliseconds:  100);

/*
节流 (throttle)：在指定时间窗口内，只允许第一个事件通过，后续事件被忽略。
丢弃策略 (droppable)：在处理当前事件时，如果新事件到达，直接丢弃新事件，直到当前事件处理完成。
结合两者后，可以实现：

防抖动（避免高频触发，如快速滚动）。

防并发冲突（防止同时处理多个相同事件，如多次加载请求）。
 */
EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc({required this.httpClient}) : super(const PostState()) {
    /// TODO: register on<PostFetched> event
    on<PostFetched>(_onFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  Future<void> _onFetched(PostFetched event, Emitter<PostState> emit) async {
    if (state.hasReachedMax) return;

    try {
      final posts = await _fetchPosts(startIndex: state.posts.length);

      if (posts.isEmpty) {
        return emit(state.copyWith(hasReachedMax: true));
      }

      emit(
        state.copyWith(
          status: PostStatus.success,
          posts: [...state.posts, ...posts],
        )
      );

    } catch(_) {
      emit(state.copyWith(status: PostStatus.failure));
    }
  }

  final http.Client httpClient;
  
  Future<List<Post>> _fetchPosts({required int startIndex}) async {
    final response = await httpClient.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/posts',
        <String, String>{'_start': '$startIndex', '_limit' : '$_postLimit'}
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;
        return Post(
            id: map['id'] as int,
            title: map['title'] as String,
            body: map['body'] as String,
        );
      }).toList();
    }
    throw Exception('error fetching posts');
  }
}