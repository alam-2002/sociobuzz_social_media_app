import 'package:sociobuzz_social_media_app/features/authentication/domain/entities/app_user.dart';

abstract class AuthState {}

/// initial
class AuthInitial extends AuthState{}

/// Loading...
class AuthLoading extends AuthState{}

/// Authenticated
class Authenticated extends AuthState{
  final AppUser user;
  Authenticated(this.user);
}

/// unAuthenticated
class Unauthenticated extends AuthState{}

/// errors...
class AuthErrors extends AuthState{
  final String message;
  AuthErrors(this.message);
}
