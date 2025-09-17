import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';

class ConnectivityService {
  static final Connectivity _connectivity = Connectivity();
  static StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  static bool _isOnline = true;
  static bool _isInitialized = false;
  
  // Offline data storage
  static Box? _offlineDataBox;
  static Box? _syncQueueBox;
  
  // Connectivity status callbacks
  static final List<Function(bool)> _statusCallbacks = [];
  
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Initialize Hive boxes for offline storage
      _offlineDataBox = await Hive.openBox('offline_data');
      _syncQueueBox = await Hive.openBox('sync_queue');
      
      // Check initial connectivity
      final connectivityResult = await _connectivity.checkConnectivity();
      _isOnline = _isConnectedToInternet(connectivityResult.first);
      
      // Listen for connectivity changes
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        (List<ConnectivityResult> results) async {
          final wasOnline = _isOnline;
          _isOnline = _isConnectedToInternet(results.first);
          
          // Notify callbacks of status change
          if (wasOnline != _isOnline) {
            for (var callback in _statusCallbacks) {
              callback(_isOnline);
            }
            
            // If back online, sync pending data
            if (_isOnline) {
              await _syncPendingData();
            }
          }
          
          // TODO: Use a logging framework instead of print
        },
      );
      
      _isInitialized = true;
  // TODO: Use a logging framework instead of print
    } catch (e) {
  // TODO: Use a logging framework instead of print
    }
  }
  
  static bool _isConnectedToInternet(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }
  
  static bool get isOnline => _isOnline;
  
  static void addStatusCallback(Function(bool) callback) {
    _statusCallbacks.add(callback);
  }
  
  static void removeStatusCallback(Function(bool) callback) {
    _statusCallbacks.remove(callback);
  }
  
  // Store data for offline access
  static Future<void> cacheData(String key, Map<String, dynamic> data) async {
    try {
      await _offlineDataBox?.put(key, data);
  // TODO: Use a logging framework instead of print
    } catch (e) {
  // TODO: Use a logging framework instead of print
    }
  }
  
  // Retrieve cached data when offline
  static Map<String, dynamic>? getCachedData(String key) {
    try {
      final data = _offlineDataBox?.get(key);
      return data != null ? Map<String, dynamic>.from(data) : null;
    } catch (e) {
  // TODO: Use a logging framework instead of print
      return null;
    }
  }
  
  // Queue data for sync when back online
  static Future<void> queueForSync(String type, Map<String, dynamic> data) async {
    try {
      final syncItem = {
        'type': type,
        'data': data,
        'timestamp': DateTime.now().toIso8601String(),
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
      };
      
      await _syncQueueBox?.add(syncItem);
  // TODO: Use a logging framework instead of print
    } catch (e) {
  // TODO: Use a logging framework instead of print
    }
  }
  
  // Sync pending data when connectivity is restored
  static Future<void> _syncPendingData() async {
    try {
      if (_syncQueueBox == null || _syncQueueBox!.isEmpty) return;
      
  // TODO: Use a logging framework instead of print
      
      final itemsToSync = _syncQueueBox!.values.toList();
      final successfulSyncs = <int>[];
      
      for (int i = 0; i < itemsToSync.length; i++) {
        final item = itemsToSync[i];
        final success = await _syncItem(item);
        
        if (success) {
          successfulSyncs.add(i);
        }
      }
      
      // Remove successfully synced items
      for (int index in successfulSyncs.reversed) {
        await _syncQueueBox!.deleteAt(index);
      }
      
  // TODO: Use a logging framework instead of print
    } catch (e) {
  // TODO: Use a logging framework instead of print
    }
  }
  
  static Future<bool> _syncItem(Map<String, dynamic> item) async {
    try {
      final type = item['type'];
      final data = item['data'];
      
      switch (type) {
        case 'symptom_report':
          return await _syncSymptomReport(data);
        case 'medical_document':
          return await _syncMedicalDocument(data);
        case 'appointment':
          return await _syncAppointment(data);
        case 'medication_alert':
          return await _syncMedicationAlert(data);
        default:
          // TODO: Use a logging framework instead of print
          return false;
      }
    } catch (e) {
  // TODO: Use a logging framework instead of print
      return false;
    }
  }
  
  static Future<bool> _syncSymptomReport(Map<String, dynamic> data) async {
    try {
      // In a real implementation, this would sync to a remote server
      // For now, we'll just simulate success
      await Future.delayed(const Duration(milliseconds: 500));
  // TODO: Use a logging framework instead of print
      return true;
    } catch (e) {
  // TODO: Use a logging framework instead of print
      return false;
    }
  }
  
  static Future<bool> _syncMedicalDocument(Map<String, dynamic> data) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
  // TODO: Use a logging framework instead of print
      return true;
    } catch (e) {
  // TODO: Use a logging framework instead of print
      return false;
    }
  }
  
  static Future<bool> _syncAppointment(Map<String, dynamic> data) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      print('Synced appointment: ${data['id']}');
      return true;
    } catch (e) {
      print('Error syncing appointment: $e');
      return false;
    }
  }
  
  static Future<bool> _syncMedicationAlert(Map<String, dynamic> data) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      print('Synced medication alert: ${data['id']}');
      return true;
    } catch (e) {
      print('Error syncing medication alert: $e');
      return false;
    }
  }
  
  // Check if internet is actually reachable (not just connected to WiFi)
  static Future<bool> hasInternetAccess() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
  
  // Get connection quality (rough estimate)
  static Future<String> getConnectionQuality() async {
    if (!_isOnline) return 'offline';
    
    try {
      final stopwatch = Stopwatch()..start();
      await InternetAddress.lookup('google.com');
      stopwatch.stop();
      
      final latency = stopwatch.elapsedMilliseconds;
      
      if (latency < 100) return 'excellent';
      if (latency < 300) return 'good';
      if (latency < 1000) return 'fair';
      return 'poor';
    } catch (e) {
      return 'offline';
    }
  }
  
  // Optimize data usage for low-bandwidth connections
  static Map<String, dynamic> optimizeDataForLowBandwidth(Map<String, dynamic> data) {
    Map<String, dynamic> optimized = Map.from(data);
    
    // Remove or compress large fields
    optimized.remove('large_images');
    optimized.remove('detailed_logs');
    
    // Compress text fields
    if (optimized.containsKey('description') && optimized['description'] is String) {
      String description = optimized['description'];
      if (description.length > 500) {
        optimized['description'] = description.substring(0, 500) + '...';
      }
    }
    
    return optimized;
  }
  
  // Get offline-capable features status
  static Map<String, bool> getOfflineCapabilities() {
    return {
      'symptom_analysis': true,
      'medical_records': true,
      'medication_alerts': true,
      'basic_ai_diagnosis': true,
      'translation': true,
      'speech_to_text': true,
      'cloud_sync': _isOnline,
      'online_consultation': _isOnline,
      'real_time_updates': _isOnline,
    };
  }
  
  // Store user preferences for offline mode
  static Future<void> setOfflinePreferences({
    bool autoSync = true,
    bool compressData = true,
    bool cacheTranslations = true,
    int maxCacheSize = 100, // MB
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('offline_auto_sync', autoSync);
      await prefs.setBool('offline_compress_data', compressData);
      await prefs.setBool('offline_cache_translations', cacheTranslations);
      await prefs.setInt('offline_max_cache_size', maxCacheSize);
    } catch (e) {
      print('Error saving offline preferences: $e');
    }
  }
  
  static Future<Map<String, dynamic>> getOfflinePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'auto_sync': prefs.getBool('offline_auto_sync') ?? true,
        'compress_data': prefs.getBool('offline_compress_data') ?? true,
        'cache_translations': prefs.getBool('offline_cache_translations') ?? true,
        'max_cache_size': prefs.getInt('offline_max_cache_size') ?? 100,
      };
    } catch (e) {
      print('Error loading offline preferences: $e');
      return {
        'auto_sync': true,
        'compress_data': true,
        'cache_translations': true,
        'max_cache_size': 100,
      };
    }
  }
  
  // Clean up old cached data
  static Future<void> cleanupCache() async {
    try {
      final prefs = await getOfflinePreferences();
      final maxCacheSize = prefs['max_cache_size'] as int;
      
      // Simple cleanup - remove oldest entries if cache is too large
      if (_offlineDataBox != null && _offlineDataBox!.length > maxCacheSize) {
        final keysToRemove = _offlineDataBox!.keys.take(_offlineDataBox!.length - maxCacheSize);
        for (var key in keysToRemove) {
          await _offlineDataBox!.delete(key);
        }
        print('Cache cleaned up: removed ${keysToRemove.length} old entries');
      }
    } catch (e) {
      print('Error cleaning up cache: $e');
    }
  }
  
  static Future<void> dispose() async {
    try {
      await _connectivitySubscription?.cancel();
      await _offlineDataBox?.close();
      await _syncQueueBox?.close();
      _statusCallbacks.clear();
      _isInitialized = false;
    } catch (e) {
      print('Error disposing connectivity service: $e');
    }
  }
}
