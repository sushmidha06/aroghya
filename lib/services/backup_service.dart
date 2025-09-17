import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cross_file/cross_file.dart';
import '../models/user.dart';
import '../models/medical_document.dart';
import '../models/medication.dart';
import '../models/symptom_report.dart';
import '../models/meeting.dart';

class BackupService {
  static const String _backupFileName = 'aroghya_ai_backup';
  
  /// Creates a complete backup of all user data from Hive boxes
  static Future<Map<String, dynamic>> createBackup() async {
    try {
      debugPrint('🔄 Starting backup creation...');
      
      final backup = <String, dynamic>{
        'metadata': {
          'app_name': 'Aroghya AI',
          'backup_version': '1.0',
          'created_at': DateTime.now().toIso8601String(),
          'device_info': await _getDeviceInfo(),
        },
        'data': {},
      };

      // Backup Users
      try {
        final usersBox = await Hive.openBox<User>('users');
        backup['data']['users'] = usersBox.values.map((user) => user.toJson()).toList();
        debugPrint('✅ Users backed up: ${usersBox.length} records');
      } catch (e) {
        debugPrint('⚠️ Error backing up users: $e');
        backup['data']['users'] = [];
      }

      // Backup Medical Documents
      try {
        final documentsBox = await Hive.openBox<MedicalDocument>('medical_documents');
        backup['data']['medical_documents'] = documentsBox.values.map((doc) => doc.toJson()).toList();
        debugPrint('✅ Medical documents backed up: ${documentsBox.length} records');
      } catch (e) {
        debugPrint('⚠️ Error backing up medical documents: $e');
        backup['data']['medical_documents'] = [];
      }

      // Backup Medications
      try {
        final medicationsBox = await Hive.openBox('medications');
        backup['data']['medications'] = medicationsBox.values.map((med) {
          if (med is Medication) {
            return med.toJson();
          } else {
            // Handle raw map data
            return med;
          }
        }).toList();
        debugPrint('✅ Medications backed up: ${medicationsBox.length} records');
      } catch (e) {
        debugPrint('⚠️ Error backing up medications: $e');
        backup['data']['medications'] = [];
      }

      // Backup Symptom Reports
      try {
        final reportsBox = await Hive.openBox<SymptomReport>('symptom_reports');
        backup['data']['symptom_reports'] = reportsBox.values.map((report) => report.toJson()).toList();
        debugPrint('✅ Symptom reports backed up: ${reportsBox.length} records');
      } catch (e) {
        debugPrint('⚠️ Error backing up symptom reports: $e');
        backup['data']['symptom_reports'] = [];
      }

      // Backup Meetings
      try {
        final meetingsBox = await Hive.openBox<Meeting>('meetings');
        backup['data']['meetings'] = meetingsBox.values.map((meeting) => meeting.toJson()).toList();
        debugPrint('✅ Meetings backed up: ${meetingsBox.length} records');
      } catch (e) {
        debugPrint('⚠️ Error backing up meetings: $e');
        backup['data']['meetings'] = [];
      }

      // Backup Language Settings
      try {
        final languageBox = await Hive.openBox('language_settings');
        backup['data']['language_settings'] = Map<String, dynamic>.from(languageBox.toMap());
        debugPrint('✅ Language settings backed up');
      } catch (e) {
        debugPrint('⚠️ Error backing up language settings: $e');
        backup['data']['language_settings'] = {};
      }

      // Backup Auth Settings (excluding sensitive data)
      try {
        final authBox = await Hive.openBox('auth_box');
        final authData = Map<String, dynamic>.from(authBox.toMap());
        // Remove sensitive data like passwords
        authData.remove('password');
        authData.remove('hashedPassword');
        backup['data']['auth_settings'] = authData;
        debugPrint('✅ Auth settings backed up (sensitive data excluded)');
      } catch (e) {
        debugPrint('⚠️ Error backing up auth settings: $e');
        backup['data']['auth_settings'] = {};
      }

      debugPrint('✅ Backup creation completed successfully');
      return backup;
    } catch (e) {
      debugPrint('❌ Error creating backup: $e');
      rethrow;
    }
  }

  /// Exports backup data to a JSON file and shares it
  static Future<bool> exportBackup() async {
    try {
      debugPrint('📤 Starting backup export...');

      // Request storage permission
      if (!await _requestStoragePermission()) {
        debugPrint('❌ Storage permission denied');
        return false;
      }

      // Create backup data
      final backupData = await createBackup();
      
      // Convert to JSON string
      final jsonString = const JsonEncoder.withIndent('  ').convert(backupData);
      
      // Get temporary directory
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${_backupFileName}_$timestamp.json';
      final file = File('${tempDir.path}/$fileName');
      
      // Write backup to file
      await file.writeAsString(jsonString);
      debugPrint('📁 Backup file created: ${file.path}');
      
      // Share the file
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Aroghya AI Data Backup - ${DateTime.now().toString().split('.')[0]}',
        subject: 'Aroghya AI Backup Export',
      );
      
      debugPrint('✅ Backup exported and shared successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Error exporting backup: $e');
      return false;
    }
  }

  /// Gets backup statistics for display
  static Future<Map<String, int>> getBackupStats() async {
    try {
      final stats = <String, int>{};
      
      // Count users
      try {
        final usersBox = await Hive.openBox<User>('users');
        stats['users'] = usersBox.length;
      } catch (e) {
        stats['users'] = 0;
      }

      // Count medical documents
      try {
        final documentsBox = await Hive.openBox<MedicalDocument>('medical_documents');
        stats['medical_documents'] = documentsBox.length;
      } catch (e) {
        stats['medical_documents'] = 0;
      }

      // Count medications
      try {
        final medicationsBox = await Hive.openBox('medications');
        stats['medications'] = medicationsBox.length;
      } catch (e) {
        stats['medications'] = 0;
      }

      // Count symptom reports
      try {
        final reportsBox = await Hive.openBox<SymptomReport>('symptom_reports');
        stats['symptom_reports'] = reportsBox.length;
      } catch (e) {
        stats['symptom_reports'] = 0;
      }

      // Count meetings
      try {
        final meetingsBox = await Hive.openBox<Meeting>('meetings');
        stats['meetings'] = meetingsBox.length;
      } catch (e) {
        stats['meetings'] = 0;
      }

      return stats;
    } catch (e) {
      debugPrint('Error getting backup stats: $e');
      return {};
    }
  }

  /// Requests storage permission for backup export
  static Future<bool> _requestStoragePermission() async {
    try {
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        return status.isGranted;
      } else if (Platform.isIOS) {
        // iOS doesn't need explicit storage permission for sharing
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error requesting storage permission: $e');
      return false;
    }
  }

  /// Gets basic device information for backup metadata
  static Future<Map<String, String>> _getDeviceInfo() async {
    return {
      'platform': Platform.operatingSystem,
      'version': Platform.operatingSystemVersion,
    };
  }

  /// Calculates estimated backup size
  static Future<String> getEstimatedBackupSize() async {
    try {
      final backup = await createBackup();
      final jsonString = jsonEncode(backup);
      final sizeInBytes = jsonString.length;
      
      if (sizeInBytes < 1024) {
        return '${sizeInBytes} B';
      } else if (sizeInBytes < 1024 * 1024) {
        return '${(sizeInBytes / 1024).toStringAsFixed(1)} KB';
      } else {
        return '${(sizeInBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
      }
    } catch (e) {
      debugPrint('Error calculating backup size: $e');
      return 'Unknown';
    }
  }
}
