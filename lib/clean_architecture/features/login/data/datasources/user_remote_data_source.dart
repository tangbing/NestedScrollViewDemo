
import 'package:dio/dio.dart';
import 'package:first_project/clean_architecture/features/login/data/models/user_model.dart';

class UserRemoteDataSource {
  final Dio dio;

  UserRemoteDataSource(this.dio);

  Future<UserModel> login({
    required String account,
    required String password,
}) async {
    final response = await dio.post('/login', data: {
      'account': account,
      'password': account,
    });

    return UserModel.fromJson(response.data);
  }

}