import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sociobuzz_social_media_app/features/post/domain/entities/comments.dart';
import 'package:sociobuzz_social_media_app/features/post/domain/entities/post.dart';
import 'package:sociobuzz_social_media_app/features/post/domain/repository/post_repository.dart';
import 'package:sociobuzz_social_media_app/features/post/presentation/cubits/post_states.dart';
import 'package:sociobuzz_social_media_app/features/storage/domain/storage_repository.dart';

class PostCubit extends Cubit<PostStates> {
  final PostRepository postRepo;
  final StorageRepository storageRepo;

  PostCubit({
    required this.postRepo,
    required this.storageRepo,
  }) : super(PostsInitial());

  /// create new post
  Future<void> createPost({
    required Post post,
    String? imagePath,
    Uint8List? imageBytes,
  }) async {
    String? imageUrl;

    try {
      // image upload for mobile platforms
      if (imagePath != null) {
        emit(PostsUploading());
        imageUrl = await storageRepo.uploadPostImageMobile(imagePath, post.id);
      }

      // image upload for web platforms
      else if (imageBytes != null) {
        emit(PostsUploading());
        imageUrl = await storageRepo.uploadPostImageWeb(imageBytes, post.id);
      }

      final newPost = post.copyWith(imageUrl: imageUrl);

      postRepo.createPost(newPost);

      fetchAllPosts();
    } catch (e) {
      emit(PostsError('Failed to create post - ${e.toString()}'));
    }
  }

  /// fetch all post
  Future<void> fetchAllPosts() async {
    try {
      emit(PostsLoading());
      final posts = await postRepo.fetchAllPosts();
      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError('Failed to fetch posts - ${e.toString()}'));
    }
  }

  /// delete a post
  Future<void> deletePost(String postId) async {
    try {
      await postRepo.deletePost(postId);
    } catch (e) {
      throw Exception('Failed to delete posts - ${e.toString()}');
      // emit(PostsError('Failed to delete posts - ${e.toString()}'));
    }
  }

  /// toggle likes
  Future<void> toggleLikePost(String postId, String userId) async {
    try {
      await postRepo.toggleLikePost(postId, userId);
      // fetchAllPosts();
    } catch (e) {
      emit(PostsError('Failed to toggle like - ${e.toString()}'));
    }
  }

  /// add comments to a post
  Future<void> addComment(String postId, Comment comment) async {
    try {
      await postRepo.addComment(postId, comment);
      await fetchAllPosts();
    } catch (e) {
      emit(PostsError('Failed to add comment - ${e.toString()}'));
    }
  }

  Future<void> deleteComment(String postId, String commentId) async {
    try {
      await postRepo.deleteComment(postId, commentId);

      await fetchAllPosts();
    } catch (e) {
      emit(PostsError('Failed to delete comment - ${e.toString()}'));
    }
  }
}
