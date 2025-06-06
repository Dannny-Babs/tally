import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<bool> checkAndRequestCamera() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      final result = await Permission.camera.request();
      return result.isGranted;
    }
    return true;
  }

  static Future<bool> checkAndRequestStorage() async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      final result = await Permission.storage.request();
      return result.isGranted;
    }
    return true;
  }

  static Future<bool> checkAndRequestPhotos() async {
    final status = await Permission.photos.status;
    if (!status.isGranted) {
      final result = await Permission.photos.request();
      return result.isGranted;
    }
    return true;
  }
} 