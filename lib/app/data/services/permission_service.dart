import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService extends GetxService {
  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<bool> requestPhotosPermission() async {
    // On Android 13+ (SDK 33+), READ_EXTERNAL_STORAGE is deprecated for images.
    // Use Permission.photos instead.
    // Logic can be refined based on platform version if needed,
    // but permission_handler handles most nuances.
    final status = await Permission.photos.request();
    return status.isGranted;
  }

  Future<bool> requestStoragePermission() async {
    // For general storage (files other than media)
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  Future<void> openSettings() async {
    await openAppSettings();
  }
}
