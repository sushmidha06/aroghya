import 'package:permission_handler/permission_handler.dart';

class CameraPermissionService {
  /// Request camera permission and return the status
  static Future<bool> requestCameraPermission() async {
    try {
      final status = await Permission.camera.request();
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  /// Check if camera permission is already granted
  static Future<bool> isCameraPermissionGranted() async {
    try {
      final status = await Permission.camera.status;
      return status.isGranted;
    } catch (e) {
      return false;
    }
  }

  /// Check if camera permission is permanently denied
  static Future<bool> isCameraPermissionPermanentlyDenied() async {
    try {
      final status = await Permission.camera.status;
      return status.isPermanentlyDenied;
    } catch (e) {
      return false;
    }
  }

  /// Open app settings if permission is permanently denied
  static Future<void> openAppSettings() async {
    await openAppSettings();
  }

  /// Request camera permission with user-friendly handling
  static Future<CameraPermissionResult> requestCameraPermissionWithResult() async {
    try {
      // Check current status
      final currentStatus = await Permission.camera.status;
      
      if (currentStatus.isGranted) {
        return CameraPermissionResult.granted;
      }
      
      if (currentStatus.isPermanentlyDenied) {
        return CameraPermissionResult.permanentlyDenied;
      }
      
      // Request permission
      final newStatus = await Permission.camera.request();
      
      if (newStatus.isGranted) {
        return CameraPermissionResult.granted;
      } else if (newStatus.isPermanentlyDenied) {
        return CameraPermissionResult.permanentlyDenied;
      } else {
        return CameraPermissionResult.denied;
      }
    } catch (e) {
      return CameraPermissionResult.error;
    }
  }
}

enum CameraPermissionResult {
  granted,
  denied,
  permanentlyDenied,
  error,
}
