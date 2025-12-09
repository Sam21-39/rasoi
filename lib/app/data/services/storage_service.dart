import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;

class StorageService extends GetxService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File file, {required String folder}) async {
    try {
      // TEMPORARY: Return Base64 string instead of uploading to Firebase Storage
      // This helps bypass storage billing/setup for MVP
      List<int> imageBytes = await file.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Determine mime type roughly
      String extension = path.extension(file.path).toLowerCase().replaceAll('.', '');
      if (extension == 'jpg') extension = 'jpeg';

      return 'data:image/$extension;base64,$base64Image';

      /* 
      // Original Firebase Storage Upload Logic
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
      TaskSnapshot snapshot = await _storage.ref('$folder/$fileName').putFile(file);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
      */
    } catch (e) {
      print('Error processing image: $e');
      rethrow;
    }
  }
}
