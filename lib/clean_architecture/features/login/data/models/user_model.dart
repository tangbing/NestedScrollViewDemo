
import 'package:first_project/clean_architecture/features/login/domain/entities/user.dart';

class UserModel {
  final int userId;
  final String nickname;
  final String accessToken;

  const UserModel({
   required this.userId,
   required this.nickname,
   required this.accessToken,
});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        userId: json['user_id'],
        nickname: json['nickname'],
        accessToken: json['access_token']
    );
  }

  User toEntity() {
      return User(
          id: userId,
          name: nickname,
          token: accessToken
      );
  }

}