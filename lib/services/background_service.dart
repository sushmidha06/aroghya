import 'dart:async';
import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:aroghya_ai/models/meeting.dart';
import 'package:aroghya_ai/services/notification_service.dart';

class BackgroundService {
  static const String _isolateName = 'background_isolate';
  static SendPort? _sendPort;
  static bool _isRunning = false;

  static Future<void> initialize() async {
    if (_isRunning) return;

    // Register the background isolate
    final receivePort = ReceivePort();
    await Isolate.spawn(_backgroundIsolateEntryPoint, receivePort.sendPort);
    
    // Get the SendPort from the isolate
    _sendPort = await receivePort.first;
    _isRunning = true;

    // Register the isolate with Flutter
    IsolateNameServer.registerPortWithName(_sendPort!, _isolateName);
  }

  static void _backgroundIsolateEntryPoint(SendPort initialSendPort) async {
    // Create a ReceivePort for this isolate
    final port = ReceivePort();
    
    // Send the port back to the main isolate
    initialSendPort.send(port.sendPort);

    // Listen for messages from the main isolate
    port.listen((message) async {
      if (message == 'check_meetings') {
        await _checkUpcomingMeetings();
      }
    });
  }

  static Future<void> _checkUpcomingMeetings() async {
    try {
      // Initialize Hive in the background isolate
      await Hive.initFlutter();
      
      // Open the meetings box
      final meetingsBox = await Hive.openBox<Meeting>('meetings');
      final meetings = meetingsBox.values.toList();

      final now = DateTime.now();
      
      for (final meeting in meetings) {
        // Check if meeting is starting in the next 5 minutes
        final timeDiff = meeting.startTime.difference(now).inMinutes;
        
        if (timeDiff <= 5 && timeDiff > 0 && meeting.isReminderSet) {
          // Send immediate notification for meetings starting soon
          await NotificationService.showImmediateNotification(
            title: 'Meeting Starting Soon!',
            body: 'Your appointment "${meeting.title}" starts in $timeDiff minutes',
          );
        }
        
        // Check for follow-up reminders (using description field as follow-up info)
        if (meeting.description.isNotEmpty && meeting.description.toLowerCase().contains('follow')) {
          final daysSinceStart = DateTime.now().difference(meeting.startTime).inDays;
          if (daysSinceStart >= 7) { // Weekly follow-up reminder
            await NotificationService.showImmediateNotification(
              title: 'Follow-up Reminder',
              body: 'Don\'t forget your follow-up for "${meeting.title}"',
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Background service error: $e');
    }
  }

  static Future<void> schedulePeriodicCheck() async {
    if (_sendPort == null) await initialize();
    
    // Schedule periodic checks every 5 minutes
    Timer.periodic(const Duration(minutes: 5), (timer) {
      _sendPort?.send('check_meetings');
    });
  }

  static Future<void> requestBatteryOptimizationExemption() async {
    // This will be handled by the permission_handler in notification_service.dart
    await NotificationService.requestPermissions();
  }

  static void dispose() {
    _isRunning = false;
    _sendPort = null;
    IsolateNameServer.removePortNameMapping(_isolateName);
  }
}
