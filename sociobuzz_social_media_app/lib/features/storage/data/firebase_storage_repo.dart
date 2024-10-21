import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sociobuzz_social_media_app/features/storage/domain/storage_repository.dart';

class FirebaseStorageRepository implements StorageRepository {
  FirebaseStorage storage = FirebaseStorage.instance;

  // profile -->
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, 'profile_images');
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, 'profile_images');
  }

  // posts -->
  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, 'post_images');
  }

  @override
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(fileBytes, fileName, 'post_images');
  }
  /*
  --- Methods ---
  */
  Future<String?> _uploadFile(String path, String fileName, String folder) async {
    try {
      // get file
      final file = File(path);

      // find place to store
      final storageRef = await storage.ref().child('$folder/$fileName');

      // upload
      final uploadTask = await storageRef.putFile(file);

      // get image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<String?> _uploadFileBytes(Uint8List fileBytes, String fileName, String folder) async {
    try {

      // find place to store
      final storageRef = await storage.ref().child('$folder/$fileName');

      // upload
      final uploadTask = await storageRef.putData(fileBytes);

      // get image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }


}