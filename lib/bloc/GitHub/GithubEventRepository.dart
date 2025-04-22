


import 'dart:convert';

import 'package:first_project/bloc/GitHub/GithubEventModel.dart';
import 'package:http/http.dart' as http;


class GithubEventRepository {
  
  Future<List<GithubEventModel>> fetchGithubEvents({int page = 1}) async {
    final response = await http.get(Uri.parse('https://api.github.com/events?page=$page'));
    if (response.statusCode != 200) {
      throw Exception("Failed to fetch Github events");
    }

    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((e) => GithubEventModel.fromJson(e)).toList();
  }
}