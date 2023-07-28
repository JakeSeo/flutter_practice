import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/cubit/posts_cubit.dart';
import '../data/models/post.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<PostsCubit>(context).loadPosts();
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: BlocBuilder<PostsCubit, PostsState>(
        builder: (context, state) {
          if (state is PostsLoading && state.isFirstFetch) {
            return Center(child: CircularProgressIndicator());
          }
          List<Post> posts = [];
          if (state is PostsLoading) {
            posts = state.oldPosts;
          } else if (state is PostsLoaded) {
            posts = state.posts;
          }
          return ListView.separated(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              return Text('${index + 1} ${posts[index].title}');
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey[400],
              );
            },
          );
        },
      ),
    );
  }
}
