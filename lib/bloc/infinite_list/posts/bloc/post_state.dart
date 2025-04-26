

import 'package:equatable/equatable.dart';
import 'package:first_project/bloc/infinite_list/posts/models/post.dart';


enum PostStatus { initial, success, failure}

final class PostState extends Equatable {

  const PostState({
    this.status = PostStatus.initial,
    this.posts = const <Post>[],
    this.hasReachedMax = false
});

  final PostStatus status;
  final List<Post> posts;
  final bool hasReachedMax;

  PostState copyWith({
    PostStatus? status,
    List<Post>? posts,
    bool? hasReachedMax,
}) {
    return PostState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax
    );
  }


  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length}''';
  }

  @override
  List<Object?> get props => [status, posts, hasReachedMax];

}