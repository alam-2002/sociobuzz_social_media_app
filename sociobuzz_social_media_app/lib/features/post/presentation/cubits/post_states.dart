import 'package:sociobuzz_social_media_app/features/post/domain/entities/post.dart';

abstract class PostStates {}

/// initial state
class PostsInitial extends PostStates {}

/// loading.. state
class PostsLoading extends PostStates {}

/// uploading.. state
class PostsUploading extends PostStates {}

/// loaded state
class PostsLoaded extends PostStates {
  final List<Post> posts;
  PostsLoaded(this.posts);
}

/// error state
class PostsError extends PostStates {
  final String message;
  PostsError(this.message);
}
