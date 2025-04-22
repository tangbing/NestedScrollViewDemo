
import 'package:equatable/equatable.dart';

class GithubEventModel extends Equatable {
  final String id;
  final String username;
  final String avatarUrl;
  final String repoUrl;

  const GithubEventModel({
    required this.id,
    required this.username,
    required this.avatarUrl,
    required this.repoUrl
  });

  factory GithubEventModel.fromJson(Map<String, dynamic> json) {
    return GithubEventModel(
      id: json['id'].toString(),
      username: json['actor']['login'],
      avatarUrl: json['actor']['avatar_url'],
      repoUrl: json['repo']['url'],
    );
  }


  @override
  // TODO: implement props
  List<Object?> get props => [id, username, avatarUrl, repoUrl];

}