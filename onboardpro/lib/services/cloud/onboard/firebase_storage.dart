import 'dart:io';
import 'package:onboardpro/services/auth/auth_exceptions.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> uploadFile(
    String filePath,
    String fileName,
  ) async {
    File file = File(filePath);

    try {
      await storage.ref('onboard/$fileName').putFile(file);
    } on FirebaseException catch (_) {
      throw FileNotUploadedAuthException();
    }
  }

  Future<String> downloadUrl(String imageName) async {
    String downloadUrl =
        await storage.ref('onboard/$imageName').getDownloadURL();
    return downloadUrl;
  }

  Future<void> deleteImage(String imageName) async {
    await storage.ref('onboard/$imageName').delete();
  }
}
