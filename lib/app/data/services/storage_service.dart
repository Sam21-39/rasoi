import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

class StorageService extends GetxService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File file, {required String folder}) async {
    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
      TaskSnapshot snapshot = await _storage.ref('$folder/$fileName').putFile(file);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      rethrow;
    }
  }
}
