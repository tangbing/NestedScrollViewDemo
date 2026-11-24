import 'package:dio/dio.dart';
import 'package:first_project/clean_architecture/features/login/data/datasources/user_remote_data_source.dart';
import 'package:first_project/clean_architecture/features/login/data/repositories/user_repository_impl.dart';
import 'package:first_project/clean_architecture/features/login/domain/repositories/user_repository.dart';
import 'package:first_project/clean_architecture/features/login/domain/usecases/login_use_case.dart';
import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
     Get.lazyPut<Dio>(
         () => Dio(BaseOptions(baseUrl: 'https://api.example.com'))
     );

     Get.lazyPut<UserRemoteDataSource>(
         () => UserRemoteDataSource(
           Get.find<Dio>(),
         )
     );

     Get.lazyPut<UserRepository>(
         () => UserRepositoryImpl(Get.find<UserRemoteDataSource>())
     );

     Get.lazyPut<LoginUseCase>(
         () => LoginUseCase(Get.find<UserRepository>())
     );

     Get.lazyPut<LoginController>(
        () => LoginController(Get.find<LoginUseCase>())
     );

  }

}