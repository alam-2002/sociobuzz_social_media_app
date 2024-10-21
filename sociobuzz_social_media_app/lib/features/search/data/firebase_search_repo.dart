import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sociobuzz_social_media_app/features/profile/domain/entities/user_profile.dart';
import 'package:sociobuzz_social_media_app/features/search/domain/search_repo.dart';

class FirebaseSearchRepository implements SearchRepository {
  @override
  Future<List<ProfileUser?>> searchUser(String query) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      return result.docs
          .map((doc) => ProfileUser.fromJson(doc.data()))
          .toList();

    } catch (e) {
      throw Exception('Error searching user - ${e.toString()}');
    }
  }
}
