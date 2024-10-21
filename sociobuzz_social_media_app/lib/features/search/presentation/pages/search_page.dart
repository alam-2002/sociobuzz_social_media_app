import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sociobuzz_social_media_app/components/text_widget.dart';
import 'package:sociobuzz_social_media_app/features/profile/presentation/components/user_tile.dart';
import 'package:sociobuzz_social_media_app/features/search/presentation/cubits/search_cubit.dart';
import 'package:sociobuzz_social_media_app/features/search/presentation/cubits/search_states.dart';
import 'package:sociobuzz_social_media_app/responsive/constrained_scaffold.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();

  void onSearchChanged() {
    final query = searchController.text;
    searchCubit.searchUsers(query);
  }

  @override
  void initState() {
    searchController.addListener(onSearchChanged);
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return ConstrainedScaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search Users...',
            hintStyle: GoogleFonts.notoSans(
              textStyle: TextStyle(
                color: primary,
              ),
            ),
          ),
        ),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          // loaded
          if (state is SearchLoaded) {
            // no user results
            if (state.user.isEmpty) {
              return Center(child: Label(label: 'No users found !!'));
            }

            // user available
            return ListView.builder(
              itemCount: state.user.length,
              itemBuilder: (context, index) {
                final user = state.user[index];
                return UserTile(user: user!);
              },
            );
          }

          // loading..
          else if (state is SearchLoading) {
            return Center(child: CircularProgressIndicator());
          }

          // error
          else if (state is SearchError) {
            return Center(child: Label(label: state.message));
          }

          // default
          return Center(child: Label(label: 'Start searching for users..'));
        },
      ),
    );
  }
}
