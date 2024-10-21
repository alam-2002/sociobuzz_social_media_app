import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociobuzz_social_media_app/components/custom_text_field.dart';
import 'package:sociobuzz_social_media_app/components/text_widget.dart';
import 'package:sociobuzz_social_media_app/features/authentication/domain/entities/app_user.dart';
import 'package:sociobuzz_social_media_app/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:sociobuzz_social_media_app/features/post/presentation/components/comment_tile.dart';
import 'package:sociobuzz_social_media_app/features/post/domain/entities/comments.dart';
import 'package:sociobuzz_social_media_app/features/post/domain/entities/post.dart';
import 'package:sociobuzz_social_media_app/features/post/presentation/cubits/post_cubits.dart';
import 'package:sociobuzz_social_media_app/features/post/presentation/cubits/post_states.dart';
import 'package:sociobuzz_social_media_app/features/profile/domain/entities/user_profile.dart';
import 'package:sociobuzz_social_media_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:sociobuzz_social_media_app/features/profile/presentation/pages/profile_page.dart';

class PostTile extends StatefulWidget {
  final Post post;
  final Function() onDeletePressed;
  const PostTile({
    super.key,
    required this.post,
    required this.onDeletePressed,
  });

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  late final postCubit = context.read<PostCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  final commentTextController = TextEditingController();

  bool isOwnPost = false;

  AppUser? currentUser;

  ProfileUser? postUser;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
    fetchPostUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.post.userId == currentUser!.uid);
  }

  Future<void> fetchPostUser() async {
    final fetchedUser = await profileCubit.getUserProfile(widget.post.userId);

    if (fetchedUser != null) {
      setState(() {
        postUser = fetchedUser;
      });
    }
  }

  /// like method
  void toggleLikePost() {
    final isLiked = widget.post.likes.contains(currentUser!.uid);

    setState(() {
      if (isLiked) {
        widget.post.likes.remove(currentUser!.uid);
      } else {
        widget.post.likes.add(currentUser!.uid);
      }
    });

    postCubit
        .toggleLikePost(widget.post.id, currentUser!.uid)
        .catchError((error) {
      setState(() {
        if (isLiked) {
          widget.post.likes.add(currentUser!.uid);
        } else {
          widget.post.likes.remove(currentUser!.uid);
        }
      });
    });
  }

  /// comment method
  void openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Label(label: 'Add a new comment'),
          content: CustomTextField(
            controller: commentTextController,
            hintText: 'type a comment',
            obscureText: false,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Label(
                label: 'Cancel',
                fontSize: 15,
              ),
            ),
            TextButton(
              onPressed: () {
                addComment();
                Navigator.of(context).pop();
              },
              child: Label(
                label: 'Save',
                fontSize: 15,
              ),
            ),
          ],
        );
      },
    );
  }

  void addComment() {
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: widget.post.id,
      userId: currentUser!.uid,
      userName: currentUser!.name,
      text: commentTextController.text,
      timestamp: DateTime.now(),
    );

    if (commentTextController.text.isNotEmpty) {
      postCubit.addComment(widget.post.id, newComment);
    }
  }

  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Label(
          label: 'Delete Post?',
          // fontSize: 13,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Label(
              label: 'Cancel',
              fontSize: 15,
            ),
          ),
          TextButton(
            onPressed: () {
              widget.onDeletePressed();
              Navigator.of(context).pop();
            },
            child: Label(
              label: 'Delete',
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    commentTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).colorScheme.secondary;
    final inversePrimary = Theme.of(context).colorScheme.inversePrimary;
    final primary = Theme.of(context).colorScheme.primary;
    return Container(
      color: secondary,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(uid: widget.post.userId),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  postUser?.profileImageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: postUser!.profileImageUrl,
                          errorWidget: (context, url, error) =>
                              Icon(Icons.person),
                          imageBuilder: (context, imageProvider) => Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        )
                      : Icon(Icons.person),
                  SizedBox(width: 10),
                  Label(
                    label: widget.post.userName,
                    color: inversePrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  Spacer(),
                  if (isOwnPost)
                    GestureDetector(
                      onTap: showOptions,
                      child: Icon(
                        Icons.delete,
                        color: primary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          CachedNetworkImage(
            imageUrl: widget.post.imageUrl,
            height: 430,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => SizedBox(height: 430),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 50,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: Icon(
                          widget.post.likes.contains(currentUser!.uid)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: widget.post.likes.contains(currentUser!.uid)
                              ? Colors.red
                              : primary,
                        ),
                      ),
                      SizedBox(width: 5),
                      Label(
                        label: widget.post.likes.length.toString(),
                        color: primary,
                        fontSize: 15,
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: openNewCommentBox,
                  child: Icon(
                    Icons.comment,
                    color: primary,
                  ),
                ),
                SizedBox(width: 5),
                Label(
                  label: widget.post.comments.length.toString(),
                  color: primary,
                  fontSize: 15,
                ),
                Spacer(),
                Label(label: widget.post.timestamp.toString(), fontSize: 10),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: [
                Label(
                  label: widget.post.userName,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                SizedBox(width: 10),
                Label(
                  label: widget.post.text,
                  fontSize: 15,
                ),
              ],
            ),
          ),
          BlocBuilder<PostCubit, PostStates>(
            builder: (context, state) {
              // loaded
              if (state is PostsLoaded) {
                final post = state.posts
                    .firstWhere((post) => (post.id == widget.post.id));
                if (post.comments.isNotEmpty) {
                  int showCommentCount = post.comments.length;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: showCommentCount,
                    itemBuilder: (context, index) {
                      final comment = post.comments[index];

                      return CommentTile(comment: comment);
                    },
                  );
                }
              }

              // loading..
              if (state is PostsLoading) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              // error
              if (state is PostsError) {
                return Center(
                  child: Label(label: state.message),
                );
              } else {
                return SizedBox();
              }
            },
          ),
          SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }
}
