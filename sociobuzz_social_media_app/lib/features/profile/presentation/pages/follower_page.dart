import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociobuzz_social_media_app/components/text_widget.dart';
import 'package:sociobuzz_social_media_app/features/profile/presentation/components/user_tile.dart';
import 'package:sociobuzz_social_media_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:sociobuzz_social_media_app/responsive/constrained_scaffold.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;
  const FollowerPage({
    super.key,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    final inversePrimary = Theme.of(context).colorScheme.inversePrimary;
    final primary = Theme.of(context).colorScheme.primary;
    return DefaultTabController(
      length: 2,
      child: ConstrainedScaffold(
        appBar: AppBar(
          bottom: TabBar(
            dividerColor: Colors.transparent,
            labelColor: inversePrimary,
            unselectedLabelColor: primary,
            tabs: const [
              Tab(text: 'Followers'),
              Tab(text: 'Followings'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUserList(
                uids: followers,
                emptyMessage: 'No Followers',
                context: context),
            _buildUserList(
                uids: following,
                emptyMessage: 'No Following',
                context: context),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList({
    required List<String> uids,
    required String emptyMessage,
    required BuildContext context,
  }) {
    return uids.isEmpty
        ? Center(child: Label(label: emptyMessage))
        : ListView.builder(
            itemCount: uids.length,
            itemBuilder: (context, index) {
              final uid = uids[index];

              return FutureBuilder(
                future: context.read<ProfileCubit>().getUserProfile(uid),
                builder: (context, snapshot) {
                  // user loaded
                  if (snapshot.hasData) {
                    final user = snapshot.data!;
                    return UserTile(user: user);
                  }

                  // user loading
                  else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return ListTile(title: Label(label: 'Loading...'));
                  }

                  // not found or error
                  else {
                    return ListTile(title: Label(label: 'User not found !!'));
                  }
                },
              );
            },
          );
  }
}
