import 'package:flutter/material.dart';
import 'package:sociobuzz_social_media_app/components/text_widget.dart';

class FollowButton extends StatelessWidget {
  final bool isFollowing;
  final Function() onPressed;

  const FollowButton({
    super.key,
    required this.isFollowing,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: MaterialButton(
        onPressed: onPressed,
        padding: EdgeInsets.all(10),
        color: isFollowing ? primary : Colors.blue,
        child: Label(
          label: isFollowing ? 'Unfollow' : 'Follow',
          color: secondary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
