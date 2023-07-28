import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pagination_bloc/views/posts_screen.dart';

import 'data/cubit/posts_cubit.dart';
import 'data/repositories/posts_repository.dart';
import 'data/services/posts_service.dart';

void main() {
  runApp(PaginationApp(repository: PostsRepository(PostsService())));
}

class PaginationApp extends StatelessWidget {
  final PostsRepository repository;

  const PaginationApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => PostsCubit(repository),
        child: const PostsScreen(),
      ),
    );
  }
}
