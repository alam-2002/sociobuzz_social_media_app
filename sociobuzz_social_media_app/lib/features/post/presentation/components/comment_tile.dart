import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociobuzz_social_media_app/components/text_widget.dart';
import 'package:sociobuzz_social_media_app/features/authentication/domain/entities/app_user.dart';
import 'package:sociobuzz_social_media_app/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:sociobuzz_social_media_app/features/post/domain/entities/comments.dart';
import 'package:sociobuzz_social_media_app/features/post/presentation/cubits/post_cubits.dart';

class CommentTile extends StatefulWidget {
  final Comment comment;
  const CommentTile({super.key, required this.comment});

  @override
  State<CommentTile> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  AppUser? currentUser;
  bool isOwnPost = false;

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void getCurrentUser() {
    final authCubit = context.read<AuthCubit>();
    currentUser = authCubit.currentUser;
    isOwnPost = (widget.comment.userId == currentUser!.uid);
  }

  void showOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Label(
          label: 'Delete Comment?',
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
              context
                  .read<PostCubit>()
                  .deleteComment(widget.comment.postId, widget.comment.id);
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
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Label(
            label: widget.comment.userName,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          SizedBox(width: 10),
          Label(
            label: widget.comment.text,
            fontSize: 15,
          ),
          Spacer(),
          if(isOwnPost)
          GestureDetector(
            onTap: showOptions,
            child: Icon(
              Icons.more_horiz,
              color: primary,
            ),
          ),
        ],
      ),
    );
  }
}
