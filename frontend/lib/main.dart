import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_project/src/features/post/presentation/pages/profile_page.dart';

import 'src/features/user/data/repositories/user_repository_impl.dart';
import 'src/features/user/presentation/bloc/user_bloc.dart';
import 'src/features/user/presentation/pages/login_page.dart';
import 'src/features/user/presentation/pages/register_page.dart';

import 'src/features/post/data/repositories/post_repository_impl.dart';
import 'src/features/post/presentation/pages/post_page.dart';

void main() {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'http://localhost:8080', // backend Dart shelf
      headers: {'Content-Type': 'application/json'},
    ),
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepositoryImpl>(
          create: (_) => UserRepositoryImpl(dio),
        ),
        RepositoryProvider<PostRepositoryImpl>(
          create: (_) => PostRepositoryImpl(dio),
        ),
      ],
      child: BlocProvider(
        create: (context) => UserBloc(context.read<UserRepositoryImpl>()),
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Auth',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (_) => LoginPage(),
        '/register': (_) => RegisterPage(),
        '/posts': (_) => PostPage(),
        '/profile': (_) => const ProfilePage(),
      },
      initialRoute: '/',
    );
  }
}
