

import 'package:first_project/bloc/infinite_list/posts/bloc/post_bloc.dart';
import 'package:first_project/bloc/infinite_list/posts/bloc/post_event.dart';
import 'package:first_project/bloc/infinite_list/posts/view/posts_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
          create: (context) => PostBloc(httpClient: http.Client())..add(PostFetched()),
        child: PostsList(),
      ),

    );
  }
}
