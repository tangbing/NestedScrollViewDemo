
import 'package:first_project/clean_architecture/features/login/domain/usecases/login_use_case.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {

  final LoginUseCase loginUseCase;

  LoginController(this.loginUseCase);

  final loading = false.obs;
  final userName = ''.obs;
  final errorMessage = ''.obs;

  void login(String account, String password) async {
    try {
      loading.value = true;
      errorMessage.value = '';

      final user = await loginUseCase(
        account: account,
        password: password,
      );
      userName.value = user.name;

    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      loading.value = false;
  }
}

}