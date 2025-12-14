import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _userController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserLoaded) {
              // ✅ CHỈ CHUYỂN ROUTE – KHÔNG TRUYỀN GÌ
              Navigator.pushReplacementNamed(context, '/posts');
            }

            if (state is UserError) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                TextField(
                  controller: _userController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _passController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<UserBloc>().add(
                          UserLoginEvent(
                            _userController.text,
                            _passController.text,
                          ),
                        );
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  child: const Text("Don't have an account? Register"),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
