import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociobuzz_social_media_app/features/authentication/domain/entities/app_user.dart';
import 'package:sociobuzz_social_media_app/features/authentication/domain/repository/auth_repository.dart';
import 'package:sociobuzz_social_media_app/features/authentication/presentation/cubits/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthenticationRepository authRepo;
  AppUser? _currentUser;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  /// checking if user is already authenticated
  void checkAuth() async {
    final AppUser? user = await authRepo.getCurrentUser();

    if (user != null) {
      _currentUser = user;
      emit(Authenticated(user));
    } else {
      emit(Unauthenticated());
    }
  }

  /// get current user
  AppUser? get currentUser => _currentUser;

  /// login with email + pw
  Future<void> login({required String email, required String password}) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.loginWithEmailAndPassword(
          email: email, password: password);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthErrors(e.toString()));
      emit(Unauthenticated());
    }
  }

  /// register with email + pw
  Future<void> register(
      {required String name,
      required String email,
      required String password}) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.registerWithEmailAndPassword(
          name: name, email: email, password: password);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthErrors(e.toString()));
      emit(Unauthenticated());
    }
  }

  /// logout
  Future<void> logout() async {
    authRepo.logout();
    emit(Unauthenticated());
  }
}
