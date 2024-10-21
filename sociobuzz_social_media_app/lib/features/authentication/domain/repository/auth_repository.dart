import 'package:sociobuzz_social_media_app/features/authentication/domain/entities/app_user.dart';

abstract class AuthenticationRepository {
  ///login function
  Future<AppUser?> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  ///signUp function
  Future<AppUser?> registerWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
  });

  ///logout function
  Future<void> logout();

  ///get user function
  Future<AppUser?> getCurrentUser();
}
