
import 'package:first_project/clean_architecture/features/login/data/datasources/user_remote_data_source.dart';
import 'package:first_project/clean_architecture/features/login/domain/entities/user.dart';
import 'package:first_project/clean_architecture/features/login/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {

  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login({required String account, required String password}) async {
    final model = await remoteDataSource.login(
        account: account,
        password: password
    );
    return model.toEntity();
  }

}