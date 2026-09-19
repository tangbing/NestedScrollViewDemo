

import 'package:first_project/clean_architecture/features/login/presentation/controllers/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
   LoginPage({super.key});

  final controller = Get.find<LoginController>();

  final accountController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('登录'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: accountController,
              decoration: const InputDecoration(
                hintText: '账号'
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: '密码'
              ),
            ),

            const SizedBox(height: 24),

            Obx(() => ElevatedButton(onPressed:  controller.loading.value ? null : () {
                controller.login(accountController.text, passwordController.text);
              }, child: Text(controller.loading.value ? '登录中...' : '登录')),
            ),

            Obx(() => Text(controller.userName.value.isEmpty ? '' : '欢迎 ${controller.userName.value}')),

            Obx(() => Text(controller.errorMessage.value))

          ],
        ),
      ),
    );
  }
}
