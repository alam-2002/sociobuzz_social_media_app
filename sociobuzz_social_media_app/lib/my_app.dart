import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociobuzz_social_media_app/components/text_widget.dart';
import 'package:sociobuzz_social_media_app/features/authentication/data/firebase_auth_repo.dart';
import 'package:sociobuzz_social_media_app/features/authentication/presentation/cubits/auth_cubit.dart';
import 'package:sociobuzz_social_media_app/features/authentication/presentation/cubits/auth_states.dart';
import 'package:sociobuzz_social_media_app/features/home/presentation/pages/home_page.dart';
import 'package:sociobuzz_social_media_app/features/post/data/firebase_post_repo.dart';
import 'package:sociobuzz_social_media_app/features/post/presentation/cubits/post_cubits.dart';
import 'package:sociobuzz_social_media_app/features/profile/data/firebase_profile_repository.dart';
import 'package:sociobuzz_social_media_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:sociobuzz_social_media_app/features/search/data/firebase_search_repo.dart';
import 'package:sociobuzz_social_media_app/features/search/presentation/cubits/search_cubit.dart';
import 'package:sociobuzz_social_media_app/features/storage/data/firebase_storage_repo.dart';
import 'package:sociobuzz_social_media_app/themes/light_mode.dart';
import 'package:sociobuzz_social_media_app/themes/theme_cubit.dart';
import 'features/authentication/presentation/pages/auth_page.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final firebaseAuthRepo = FirebaseAuthenticationRepository();
  final firebaseProfileRepo = FirebaseProfileRepository();
  final firebaseStorageRepo = FirebaseStorageRepository();
  final firebasePostRepo = FirebasePostRepository();
  final firebaseSearchRepo = FirebaseSearchRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// auth cubit
        BlocProvider<AuthCubit>(
          create: (context) =>
              AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),

        /// profile cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(
            profileRepo: firebaseProfileRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),

        /// post cubit
        BlocProvider<PostCubit>(
          create: (context) => PostCubit(
            postRepo: firebasePostRepo,
            storageRepo: firebaseStorageRepo,
          ),
        ),

        /// search cubit
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(searchRepo: firebaseSearchRepo),
        ),

        /// theme cubit
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (context, currentTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: currentTheme,
          home: BlocConsumer<AuthCubit, AuthState>(
            builder: (context, authState) {
              print(authState);
              if (authState is Unauthenticated) {
                return AuthPage();
              }
              if (authState is Authenticated) {
                return HomePage();
              } else {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
            listener: (context, state) {
              if (state is AuthErrors) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Label(label: state.message),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
// 03:00:30
