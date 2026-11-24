
import 'package:first_project/clean_architecture/features/login/domain/entities/user.dart';
import 'package:first_project/clean_architecture/features/login/domain/repositories/user_repository.dart';

class LoginUseCase {
  final UserRepository repository;


  LoginUseCase(this.repository);

  /// dart 类定义了 call()方法以后，这个类的实例就可以像函数一样直接调用，与useCase.call(...)等价
  Future<User> call ({
    required String account,
    required String password,
}) {
    if (account.isEmpty) {
      throw Exception('账号不能为空');
    }

    if (password.length < 6) {
      throw Exception('密码不能少于6位');
    }

    return repository.login(
        account: account,
        password: password
    );

  }

}