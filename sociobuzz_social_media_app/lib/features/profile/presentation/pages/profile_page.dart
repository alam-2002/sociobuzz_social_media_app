import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociobuzz_social_media_app/components/text_widget.dart';
import 'package:sociobuzz_social_media_app/features/authentication/domain/entities/app_user.dart';
import 'package:sociobuzz_social_media_app/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:sociobuzz_social_media_app/features/post/presentation/components/post_tile.dart';
import 'package:sociobuzz_social_media_app/features/post/presentation/cubits/post_cubits.dart';
import 'package:sociobuzz_social_media_app/features/post/presentation/cubits/post_states.dart';
import 'package:sociobuzz_social_media_app/features/profile/presentation/components/bio_box.dart';
import 'package:sociobuzz_social_media_app/features/profile/presentation/components/follow_button.dart';
import 'package:sociobuzz_social_media_app/features/profile/presentation/components/profile_stats.dart';
import 'package:sociobuzz_social_media_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:sociobuzz_social_media_app/features/profile/presentation/cubits/profile_states.dart';
import 'package:sociobuzz_social_media_app/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:sociobuzz_social_media_app/features/profile/presentation/pages/follower_page.dart';
import 'package:sociobuzz_social_media_app/responsive/constrained_scaffold.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();
  late AppUser? currentUser = authCubit.currentUser;

  int postCount = 0;

  @override
  void initState() {
    profileCubit.fetchUserProfile(widget.uid);
    super.initState();
  }

  void followButtonPressed() {
    final profileState = profileCubit.state;
    if (profileState is! ProfileLoaded) {
      return; // return profile is not loaded
    }

    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(currentUser!.uid);

    setState(() {
      // unfollow
      if (isFollowing) {
        profileUser.followers.remove(currentUser!.uid);
      }
      // follow
      else {
        profileUser.followers.add(currentUser!.uid);
      }
    });

    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error) {
      setState(() {
        // unfollow
        if (isFollowing) {
          profileUser.followers.remove(currentUser!.uid);
        }
        // follow
        else {
          profileUser.followers.add(currentUser!.uid);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    bool isOwnPost = (widget.uid == currentUser!.uid);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        // loaded state
        if (state is ProfileLoaded) {
          final user = state.profileUser;
          return ConstrainedScaffold(
            appBar: AppBar(
              title: Label(
                label: user.name,
                color: primary,
              ),
              centerTitle: true,
              actions: [
                // edit profile button
                if (isOwnPost)
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(user: user),
                      ),
                    ),
                    icon: Icon(
                      Icons.settings,
                      color: primary,
                    ),
                  ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // email
                  Center(
                    child: Label(
                      label: user.email,
                      color: primary,
                    ),
                  ),
                  SizedBox(height: 25),

                  // profile pic
                  CachedNetworkImage(
                    imageUrl: user.profileImageUrl,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(
                      Icons.person,
                      size: 72,
                      color: primary,
                    ),
                    imageBuilder: (context, imageProvider) => Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),

                  // profile stats
                  ProfileStats(
                    postCount: postCount,
                    followerCount: user.followers.length,
                    followingCount: user.following.length,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FollowerPage(
                          followers: user.followers,
                          following: user.following,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),

                  // follow button
                  if (!isOwnPost)
                    FollowButton(
                      onPressed: followButtonPressed,
                      isFollowing: user.followers.contains(currentUser!.uid),
                      // isFollowing: true,
                    ),
                  SizedBox(height: 25),

                  // bio box
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0),
                    child: Row(
                      children: [
                        Label(
                          label: 'Bio',
                          color: primary,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  BioBox(text: user.bio),

                  // posts
                  Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 25),
                    child: Row(
                      children: [
                        Label(
                          label: 'Posts',
                          color: primary,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                  // list of posts
                  BlocBuilder<PostCubit, PostStates>(
                    builder: (context, state) {
                      // post loaded
                      if (state is PostsLoaded) {
                        final userPosts = state.posts
                            .where((post) => post.userId == widget.uid)
                            .toList();

                        postCount = userPosts.length;

                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: postCount,
                          itemBuilder: (context, index) {
                            final post = userPosts[index];

                            return PostTile(
                              post: post,
                              onDeletePressed: () =>
                                  context.read<PostCubit>().deletePost(post.id),
                            );
                          },
                        );
                      }

                      // post loading..
                      else if (state is PostsLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Center(
                          child: Label(label: 'No Posts..'),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }

        // loading... state
        else if (state is ProfileLoading) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        // error state
        else if (state is ProfileError) {
          return Center(child: Label(label: 'Error - ${state.message}'));
        } else {
          return Center(child: Label(label: 'No profile found...'));
        }
      },
    );
  }
}
