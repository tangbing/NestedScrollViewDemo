


import 'package:first_project/mvvm_architecture/viewModels/counter_view_model.dart';
import 'package:first_project/mvvm_architecture/viewModels/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostListView extends StatelessWidget {
  const PostListView({super.key});

  @override
  Widget build(BuildContext context) {
    PostViewModel postViewModel = Provider.of<PostViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter mvvvm Architecture'),
      ),
      body: postViewModel.isRefresh ? const Center(
        child: CircularProgressIndicator()) : ListView.builder(
          itemCount: postViewModel.postList.length,
          itemBuilder: (context, index) {
        var item = postViewModel.postList[index];
           return ListTile(title: Text(item.title), subtitle: Text(item.body));
        }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => postViewModel.fetchPostData(),
        child: Icon(Icons.refresh_outlined),
      ),
    );
  }
}