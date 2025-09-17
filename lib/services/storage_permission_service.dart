import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class StoragePermissionService {
  /// Check if storage permissions are granted
  static Future<bool> hasStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        // For Android 13+ (API 33+), we need different permissions
        if (await _isAndroid13OrHigher()) {
          // Check for media permissions on Android 13+
          final photos = await Permission.photos.status;
          final videos = await Permission.videos.status;
          final audio = await Permission.audio.status;
          
          return photos.isGranted && videos.isGranted && audio.isGranted;
        } else {
          // For older Android versions, check storage permissions
          final storage = await Permission.storage.status;
          return storage.isGranted;
        }
      } else if (Platform.isIOS) {
        // For iOS, check photos permission
        final photos = await Permission.photos.status;
        return photos.isGranted;
      }
      
      return false;
    } catch (e) {
      debugPrint('❌ Error checking storage permission: $e');
      return false;
    }
  }

  /// Request storage permissions
  static Future<bool> requestStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        // For Android 13+ (API 33+), request media permissions
        if (await _isAndroid13OrHigher()) {
          debugPrint('📱 Requesting media permissions for Android 13+');
          
          Map<Permission, PermissionStatus> statuses = await [
            Permission.photos,
            Permission.videos,
            Permission.audio,
          ].request();
          
          bool allGranted = statuses.values.every((status) => status.isGranted);
          
          if (!allGranted) {
            // Try requesting manage external storage for full access
            final manageStorage = await Permission.manageExternalStorage.request();
            if (manageStorage.isGranted) {
              debugPrint('✅ Manage external storage permission granted');
              return true;
            }
          }
          
          return allGranted;
        } else {
          // For older Android versions, request storage permission
          debugPrint('📱 Requesting storage permission for older Android');
          
          final storage = await Permission.storage.request();
          
          if (storage.isGranted) {
            return true;
          } else if (storage.isDenied) {
            // Try requesting manage external storage
            final manageStorage = await Permission.manageExternalStorage.request();
            return manageStorage.isGranted;
          }
          
          return false;
        }
      } else if (Platform.isIOS) {
        // For iOS, request photos permission
        debugPrint('📱 Requesting photos permission for iOS');
        final photos = await Permission.photos.request();
        return photos.isGranted;
      }
      
      return false;
    } catch (e) {
      debugPrint('❌ Error requesting storage permission: $e');
      return false;
    }
  }

  /// Check if device is Android 13 or higher
  static Future<bool> _isAndroid13OrHigher() async {
    if (!Platform.isAndroid) return false;
    
    try {
      // This is a simplified check - in a real app you might want to use
      // device_info_plus package for more accurate version detection
      return true; // Assume modern Android for now
    } catch (e) {
      return false;
    }
  }

  /// Request all necessary permissions for the app
  static Future<Map<String, bool>> requestAllPermissions() async {
    Map<String, bool> results = {};
    
    try {
      // Storage permissions
      results['storage'] = await requestStoragePermission();
      
      // Microphone permission for speech recognition
      final microphone = await Permission.microphone.request();
      results['microphone'] = microphone.isGranted;
      
      // Camera permission for document scanning
      final camera = await Permission.camera.request();
      results['camera'] = camera.isGranted;
      
      // Location permissions for nearby hospitals
      final location = await Permission.location.request();
      results['location'] = location.isGranted;
      
      // Notification permissions
      final notification = await Permission.notification.request();
      results['notification'] = notification.isGranted;
      
      debugPrint('📋 Permission results: $results');
      
      return results;
    } catch (e) {
      debugPrint('❌ Error requesting permissions: $e');
      return results;
    }
  }

  /// Show permission rationale dialog
  static Future<bool> shouldShowRequestPermissionRationale(Permission permission) async {
    try {
      return await permission.shouldShowRequestRationale;
    } catch (e) {
      debugPrint('❌ Error checking permission rationale: $e');
      return false;
    }
  }

  /// Open app settings for manual permission grant
  static Future<void> openAppSettings() async {
    try {
      await openAppSettings();
      debugPrint('📱 Opened app settings for manual permission grant');
    } catch (e) {
      debugPrint('❌ Error opening app settings: $e');
    }
  }

  /// Get permission status details for debugging
  static Future<Map<String, String>> getPermissionStatusDetails() async {
    Map<String, String> details = {};
    
    try {
      if (Platform.isAndroid) {
        details['storage'] = (await Permission.storage.status).toString();
        details['manageExternalStorage'] = (await Permission.manageExternalStorage.status).toString();
        details['photos'] = (await Permission.photos.status).toString();
        details['videos'] = (await Permission.videos.status).toString();
        details['audio'] = (await Permission.audio.status).toString();
      } else if (Platform.isIOS) {
        details['photos'] = (await Permission.photos.status).toString();
      }
      
      details['microphone'] = (await Permission.microphone.status).toString();
      details['camera'] = (await Permission.camera.status).toString();
      details['location'] = (await Permission.location.status).toString();
      details['notification'] = (await Permission.notification.status).toString();
      
      debugPrint('📊 Permission status details: $details');
      
      return details;
    } catch (e) {
      debugPrint('❌ Error getting permission details: $e');
      return details;
    }
  }
}
