import 'package:sociobuzz_social_media_app/features/profile/domain/entities/user_profile.dart';

abstract class SearchState {}

/// initial state
class SearchInitial extends SearchState{}

/// loading state
class SearchLoading extends SearchState{}

/// loaded state
class SearchLoaded extends SearchState{
  final List<ProfileUser?> user;
  SearchLoaded(this.user);
}

/// error state
class SearchError extends SearchState{
  final String message;
  SearchError(this.message);
}