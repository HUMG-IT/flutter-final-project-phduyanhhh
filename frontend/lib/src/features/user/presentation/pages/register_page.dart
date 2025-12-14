import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_event.dart';
import '../bloc/user_state.dart';

class RegisterPage extends StatelessWidget {
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('Register success: ${state.user.username}')));
              Navigator.pushReplacementNamed(context, '/');
            } else if (state is UserError) {
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
                    decoration: const InputDecoration(labelText: 'Username')),
                const SizedBox(height: 12),
                TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email')),
                const SizedBox(height: 12),
                TextField(
                    controller: _passController,
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password')),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<UserBloc>().add(
                          UserRegisterEvent(
                            _userController.text,
                            _emailController.text,
                            _passController.text,
                          ),
                        );
                  },
                  child: const Text('Register'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                  child: const Text('Already have an account? Login'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
