
import 'package:first_project/clean_architecture/features/login/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> login({
    required String account,
    required String password,
});
}