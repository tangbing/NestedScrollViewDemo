import 'dart:convert';

import 'package:first_project/mvvm_architecture/models/post_model.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class PostViewModel with ChangeNotifier {
  List<Post> _postList = [];

  List<Post> get postList => _postList;

  bool _isRefresh = false;

  bool get isRefresh => _isRefresh;

  Future<void> fetchPostData() async {
    _isRefresh = true;
    notifyListeners();

    try {
      final response = await http
          .get(Uri.parse('http://jsonplaceholder.typicode.com/posts'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        _postList = jsonData.map((json) => Post.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      throw Exception('Failed to load data');
    } finally {
      _isRefresh = false;
      notifyListeners();
    }
  }
}
