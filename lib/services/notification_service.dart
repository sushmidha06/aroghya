import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import '../models/meeting.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Initialize timezone
      tz.initializeTimeZones();
      
      // Request notification permissions first
      await _requestPermissions();

      // Android initialization settings
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // iOS initialization settings
      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _notifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Create notification channels for Android
      await _createNotificationChannels();

      _isInitialized = true;
      print('NotificationService initialized successfully');
    } catch (e) {
      print('NotificationService initialization error: $e');
      _isInitialized = false;
    }
  }
  
  static Future<void> _requestPermissions() async {
    try {
      // Request notification permission
      final notificationStatus = await Permission.notification.request();
      if (!notificationStatus.isGranted) {
        print('Notification permission denied');
      }
      
      // Request exact alarm permission for Android 12+
      if (await Permission.scheduleExactAlarm.isDenied) {
        await Permission.scheduleExactAlarm.request();
      }
    } catch (e) {
      print('Error requesting permissions: $e');
    }
  }
  
  static Future<void> _createNotificationChannels() async {
    try {
      // Medication reminders channel
      const AndroidNotificationChannel medicationChannel = AndroidNotificationChannel(
        'medication_reminders',
        'Medication Reminders',
        description: 'Notifications for medication reminders',
        importance: Importance.high,
        sound: RawResourceAndroidNotificationSound('notification_sound'),
      );
      
      // Appointment reminders channel
      const AndroidNotificationChannel appointmentChannel = AndroidNotificationChannel(
        'appointment_reminders',
        'Appointment Reminders',
        description: 'Notifications for appointment reminders',
        importance: Importance.high,
        sound: RawResourceAndroidNotificationSound('notification_sound'),
      );
      
      // Health alerts channel
      const AndroidNotificationChannel healthAlertsChannel = AndroidNotificationChannel(
        'health_alerts',
        'Health Alerts',
        description: 'Important health-related notifications',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('alert_sound'),
      );
      
      await _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(medicationChannel);
      await _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(appointmentChannel);
      await _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(healthAlertsChannel);
          
      print('Notification channels created');
    } catch (e) {
      print('Error creating notification channels: $e');
    }
  }

  static void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap
    print('Notification tapped: ${response.payload}');
  }

  static Future<bool> requestPermissions() async {
    await initialize();
    
    // Request notification permission
    final status = await Permission.notification.request();
    
    if (status.isGranted) {
      // For Android 13+, also request POST_NOTIFICATIONS permission
      await _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      
      // Request exact alarm permission for Android 12+
      await _notifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestExactAlarmsPermission();
      
      // Request battery optimization exemption for background execution (only if available)
      try {
        await Permission.ignoreBatteryOptimizations.request();
      } catch (e) {
        print('Battery optimization permission not available: $e');
      }
      
      // Request system alert window permission for overlay notifications (only if available)
      try {
        await Permission.systemAlertWindow.request();
      } catch (e) {
        print('System alert window permission not available: $e');
      }
      
      return true;
    }
    
    return false;
  }

  static Future<void> scheduleMeetingReminder(Meeting meeting) async {
    await initialize();
    
    if (!meeting.isReminderSet) return;

    final reminderTime = meeting.startTime.subtract(
      Duration(minutes: meeting.reminderMinutesBefore),
    );

    // Don't schedule if reminder time is in the past
    if (reminderTime.isBefore(DateTime.now())) return;

    // Check if exact alarms are allowed
    final androidPlugin = _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final canScheduleExactAlarms = await androidPlugin?.canScheduleExactNotifications() ?? true;
    
    if (!canScheduleExactAlarms) {
      print('Exact alarms not permitted. Using inexact scheduling...');
      // Fall back to inexact scheduling for devices without exact alarm permission
      await _scheduleInexactNotification(meeting, reminderTime);
      return;
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'meeting_reminders',
      'Meeting Reminders',
      channelDescription: 'Notifications for upcoming medical appointments',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      meeting.id.hashCode,
      'Upcoming Appointment: ${meeting.title}',
      'Your appointment with ${meeting.doctorName ?? 'healthcare provider'} is in ${meeting.reminderMinutesBefore} minutes at ${meeting.location}',
      tz.TZDateTime.from(reminderTime, tz.local),
      notificationDetails,
      payload: meeting.id,
      matchDateTimeComponents: DateTimeComponents.time, androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> scheduleFollowUpReminder(Meeting meeting) async {
    await initialize();
    
    // Schedule a follow-up reminder 1 day after the meeting
    final followUpTime = meeting.endTime.add(const Duration(days: 1));
    
    // Don't schedule if follow-up time is in the past
    if (followUpTime.isBefore(DateTime.now())) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'follow_up_reminders',
      'Follow-up Reminders',
      channelDescription: 'Reminders for post-appointment follow-ups',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.zonedSchedule(
      '${meeting.id}_followup'.hashCode,
      'Follow-up Reminder',
      'How did your appointment with ${meeting.doctorName ?? 'healthcare provider'} go? Consider scheduling a follow-up if needed.',
      tz.TZDateTime.from(followUpTime, tz.local),
      notificationDetails,
      payload: '${meeting.id}_followup',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> showImmediateNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    await initialize();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'immediate_notifications',
      'Immediate Notifications',
      channelDescription: 'Immediate health-related notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> _scheduleInexactNotification(Meeting meeting, DateTime reminderTime) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'meeting_reminders_inexact',
      'Meeting Reminders (Inexact)',
      channelDescription: 'Inexact notifications for upcoming medical appointments',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Use regular scheduling without exact timing
    await _notifications.zonedSchedule(
      meeting.id.hashCode,
      'Meeting Reminder',
      'Your appointment "${meeting.title}" is starting in ${meeting.reminderMinutesBefore} minutes',
      tz.TZDateTime.from(reminderTime, tz.local),
      notificationDetails,
      payload: 'meeting_${meeting.id}',
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future<void> cancelMeetingNotification(String meetingId) async {
    await _notifications.cancel(meetingId.hashCode);
    await _notifications.cancel('${meetingId}_followup'.hashCode);
  }

  static Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }

  static Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }
}
