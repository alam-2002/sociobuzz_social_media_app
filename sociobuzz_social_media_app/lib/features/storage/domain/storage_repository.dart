import 'dart:typed_data';

abstract class StorageRepository {

  // upload profile image on mobile
  Future<String?> uploadProfileImageMobile(String path, String fileName);

  // upload profile image on web
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes ,String fileName);

  // upload post image on mobile
  Future<String?> uploadPostImageMobile(String path, String fileName);

  // upload post image on web
  Future<String?> uploadPostImageWeb(Uint8List fileBytes ,String fileName);
}