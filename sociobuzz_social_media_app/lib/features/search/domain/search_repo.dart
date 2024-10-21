import 'package:sociobuzz_social_media_app/features/profile/domain/entities/user_profile.dart';

abstract class SearchRepository {
  Future<List<ProfileUser?>> searchUser(String query);
}
