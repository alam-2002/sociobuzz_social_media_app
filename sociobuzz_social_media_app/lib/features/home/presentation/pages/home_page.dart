import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociobuzz_social_media_app/features/home/components/drawer_widget.dart';
import 'package:sociobuzz_social_media_app/components/text_widget.dart';
import 'package:sociobuzz_social_media_app/features/post/presentation/components/post_tile.dart';
import 'package:sociobuzz_social_media_app/features/post/presentation/cubits/post_cubits.dart';
import 'package:sociobuzz_social_media_app/features/post/presentation/cubits/post_states.dart';
import 'package:sociobuzz_social_media_app/features/post/presentation/pages/upload_post_page.dart';
import 'package:sociobuzz_social_media_app/responsive/constrained_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final postCubit = context.read<PostCubit>();

  @override
  void initState() {
    fetchAllPosts();
    super.initState();
  }

  void fetchAllPosts() {
    postCubit.fetchAllPosts();
  }

  void deletePost(String postId) {
    postCubit.deletePost(postId);
    fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return ConstrainedScaffold(
      appBar: AppBar(
        title: Label(
          label: 'Home',
          color: primary,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UploadPostPage(),
              ),
            ),
            icon: Icon(Icons.add),
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: BlocBuilder<PostCubit, PostStates>(
        builder: (context, state) {
          // loading.. and uploading
          if (state is PostsLoading && state is PostsUploading) {
            return Center(child: CircularProgressIndicator());
          }

          // loaded
          else if (state is PostsLoaded) {
            final allPosts = state.posts;
            if (allPosts.isEmpty) {
              return Center(child: Label(label: 'No Posts Available'));
            }

            return ListView.builder(
              itemCount: allPosts.length,
              itemBuilder: (context, index) {
                final post = allPosts[index];

                return PostTile(
                  post: post,
                  onDeletePressed: () => deletePost(post.id),
                );
              },
            );
          }

          // error
          else if (state is PostsError) {
            return Center(child: Label(label: state.message));
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}
