import 'dart:typed_data';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';

class ImageStorageService {
  static const String _boxName = 'imageBox';

  /// Save image to Hive storage
  static Future<void> saveImageToHive(String key, Uint8List imageData) async {
    try {
      var box = Hive.box(_boxName);
      await box.put(key, imageData);
      debugPrint('✅ Image saved to Hive with key: $key');
    } catch (e) {
      debugPrint('❌ Error saving image to Hive: $e');
      rethrow;
    }
  }

  /// Get image from Hive storage
  static Future<Uint8List?> getImageFromHive(String key) async {
    try {
      var box = Hive.box(_boxName);
      final imageData = box.get(key) as Uint8List?;
      if (imageData != null) {
        debugPrint('✅ Image retrieved from Hive with key: $key');
      } else {
        debugPrint('⚠️ No image found with key: $key');
      }
      return imageData;
    } catch (e) {
      debugPrint('❌ Error retrieving image from Hive: $e');
      return null;
    }
  }

  /// Delete image from Hive storage
  static Future<void> deleteImageFromHive(String key) async {
    try {
      var box = Hive.box(_boxName);
      await box.delete(key);
      debugPrint('✅ Image deleted from Hive with key: $key');
    } catch (e) {
      debugPrint('❌ Error deleting image from Hive: $e');
      rethrow;
    }
  }

  /// Get all image keys
  static List<String> getAllImageKeys() {
    try {
      var box = Hive.box(_boxName);
      return box.keys.cast<String>().toList();
    } catch (e) {
      debugPrint('❌ Error getting image keys: $e');
      return [];
    }
  }

  /// Check if image exists
  static bool imageExists(String key) {
    try {
      var box = Hive.box(_boxName);
      return box.containsKey(key);
    } catch (e) {
      debugPrint('❌ Error checking image existence: $e');
      return false;
    }
  }

  /// Get total number of stored images
  static int getImageCount() {
    try {
      var box = Hive.box(_boxName);
      return box.length;
    } catch (e) {
      debugPrint('❌ Error getting image count: $e');
      return 0;
    }
  }

  /// Clear all images
  static Future<void> clearAllImages() async {
    try {
      var box = Hive.box(_boxName);
      await box.clear();
      debugPrint('✅ All images cleared from Hive');
    } catch (e) {
      debugPrint('❌ Error clearing images: $e');
      rethrow;
    }
  }
}
