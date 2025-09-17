import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/camera_permission_service.dart';

class CameraPermissionDialog {
  /// Show camera permission dialog and handle the result
  static Future<bool> showPermissionDialog(BuildContext context) async {
    final result = await CameraPermissionService.requestCameraPermissionWithResult();
    
    switch (result) {
      case CameraPermissionResult.granted:
        return true;
        
      case CameraPermissionResult.denied:
        if (context.mounted) {
          _showPermissionDeniedDialog(context);
        }
        return false;
        
      case CameraPermissionResult.permanentlyDenied:
        if (context.mounted) {
          _showPermanentlyDeniedDialog(context);
        }
        return false;
        
      case CameraPermissionResult.error:
        if (context.mounted) {
          _showErrorDialog(context);
        }
        return false;
    }
  }

  static void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Camera Permission Required'),
          content: const Text(
            'This app needs camera access to scan medication labels and prescriptions. Please grant camera permission to continue.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await CameraPermissionService.requestCameraPermission();
              },
              child: const Text('Grant Permission'),
            ),
          ],
        );
      },
    );
  }

  static void _showPermanentlyDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Camera Permission Denied'),
          content: const Text(
            'Camera permission has been permanently denied. Please enable it in your device settings to use the scanning feature.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await openAppSettings();
              },
              child: const Text('Open Settings'),
            ),
          ],
        );
      },
    );
  }

  static void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Permission Error'),
          content: const Text(
            'An error occurred while requesting camera permission. Please try again.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
