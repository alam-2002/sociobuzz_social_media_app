import 'package:flutter/material.dart';
import 'package:sociobuzz_social_media_app/components/text_widget.dart';

class ProfileStats extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;
  final Function() onTap;
  const ProfileStats({
    super.key,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary; // TSfT
    final inversePrimary = Theme.of(context).colorScheme.inversePrimary; // TSfC fs-20
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // posts
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Label(
                  label: postCount.toString(),
                  fontSize: 20,
                  color: inversePrimary,
                ),
                Label(
                  label: 'Posts',
                  fontSize: 15,
                  color: primary,
                ),
              ],
            ),
          ),

          // followers
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Label(
                  label: followerCount.toString(),
                  fontSize: 20,
                  color: inversePrimary,
                ),
                Label(
                  label: 'Followers',
                  fontSize: 15,
                  color: primary,
                ),
              ],
            ),
          ),

          // followings
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Label(
                  label: followingCount.toString(),
                  fontSize: 20,
                  color: inversePrimary,
                ),
                Label(
                  label: 'Followings',
                  fontSize: 15,
                  color: primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
