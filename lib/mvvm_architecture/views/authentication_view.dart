

import 'package:first_project/mvvm_architecture/viewModels/authenticcation_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationView extends StatelessWidget {
  AuthenticationView({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
   var userViewModel = Provider.of<AuthenticationViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('AuthenticationView'),
      ),
      body: userViewModel.isAuthenticated ? Center(child: Column(
        children: [
          Text('Welcome, ${userViewModel.user?.email}'),
          ElevatedButton(onPressed: () => userViewModel.logout(), child: Text('Logout'))
        ],
      )) : Padding(padding: const EdgeInsets.all(16), child: Column(
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              label: Text('Email')
            ),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(
              label: Text('password')
            ),
          ),
           const SizedBox(height: 20),
          ElevatedButton(onPressed: () {
            userViewModel.login(emailController.text, passwordController.text);
          }, child: Text('Login'))
        ],
      )),
    );
  }
}
