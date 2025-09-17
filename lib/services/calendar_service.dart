import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import '../models/meeting.dart';
import 'notification_service.dart';

class CalendarService {
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    final apiKey = dotenv.env['CLOUD_CONSOLE_API'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('CLOUD_CONSOLE_API key not found in .env file');
    }

    // Initialize with API key for public calendar access
    // For full calendar management, OAuth2 would be needed
    _isInitialized = true;
  }

  static Future<Meeting> scheduleMeeting({
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime,
    required String location,
    required List<String> attendees,
    required String meetingType,
    String? doctorName,
    String? specialty,
    int reminderMinutes = 30,
  }) async {
    await initialize();

    // Create meeting object
    final meeting = Meeting(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      description: description,
      startTime: startTime,
      endTime: endTime,
      location: location,
      attendees: attendees,
      meetingType: meetingType,
      doctorName: doctorName,
      specialty: specialty,
      reminderMinutesBefore: reminderMinutes,
    );

    // Save to local database
    await _saveMeetingToHive(meeting);

    // Schedule local notification
    await NotificationService.scheduleMeetingReminder(meeting);
    
    // Schedule follow-up reminder if it's a medical appointment
    if (meetingType == 'doctor_appointment' || meetingType == 'consultation') {
      await NotificationService.scheduleFollowUpReminder(meeting);
    }

    return meeting;
  }

  static Future<void> _saveMeetingToHive(Meeting meeting) async {
    final box = await Hive.openBox<Meeting>('meetings');
    await box.put(meeting.id, meeting);
  }

  static Future<List<Meeting>> getMeetings() async {
    final box = await Hive.openBox<Meeting>('meetings');
    return box.values.toList()..sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  static Future<List<Meeting>> getUpcomingMeetings() async {
    final meetings = await getMeetings();
    final now = DateTime.now();
    return meetings.where((meeting) => meeting.startTime.isAfter(now)).toList();
  }

  static Future<List<Meeting>> getTodaysMeetings() async {
    final meetings = await getMeetings();
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    return meetings.where((meeting) => 
      meeting.startTime.isAfter(startOfDay) && 
      meeting.startTime.isBefore(endOfDay)
    ).toList();
  }

  static Future<void> updateMeeting(Meeting meeting) async {
    await _saveMeetingToHive(meeting);
    
    // Cancel old notification and schedule new one
    await NotificationService.cancelMeetingNotification(meeting.id);
    if (meeting.isReminderSet) {
      await NotificationService.scheduleMeetingReminder(meeting);
    }
  }

  static Future<void> cancelMeeting(String meetingId) async {
    final box = await Hive.openBox<Meeting>('meetings');
    final meeting = box.get(meetingId);
    
    if (meeting != null) {
      meeting.status = 'cancelled';
      await box.put(meetingId, meeting);
      
      // Cancel notifications
      await NotificationService.cancelMeetingNotification(meetingId);
    }
  }

  static Future<void> completeMeeting(String meetingId) async {
    final box = await Hive.openBox<Meeting>('meetings');
    final meeting = box.get(meetingId);
    
    if (meeting != null) {
      meeting.status = 'completed';
      await box.put(meetingId, meeting);
    }
  }

  static Future<void> deleteMeeting(String meetingId) async {
    final box = await Hive.openBox<Meeting>('meetings');
    await box.delete(meetingId);
    
    // Cancel notifications
    await NotificationService.cancelMeetingNotification(meetingId);
  }

  // Helper method to create quick doctor appointments
  static Future<Meeting> scheduleDockerAppointment({
    required String doctorName,
    required String specialty,
    required DateTime appointmentTime,
    required String location,
    String? notes,
    int reminderMinutes = 30,
  }) async {
    final endTime = appointmentTime.add(const Duration(hours: 1)); // Default 1-hour appointment
    
    return await scheduleMeeting(
      title: 'Appointment with Dr. $doctorName',
      description: 'Medical appointment - $specialty${notes != null ? '\n\nNotes: $notes' : ''}',
      startTime: appointmentTime,
      endTime: endTime,
      location: location,
      attendees: [],
      meetingType: 'doctor_appointment',
      doctorName: doctorName,
      specialty: specialty,
      reminderMinutes: reminderMinutes,
    );
  }

  // Helper method to schedule follow-up appointments
  static Future<Meeting> scheduleFollowUp({
    required String doctorName,
    required String specialty,
    required DateTime followUpTime,
    required String location,
    required String previousAppointmentId,
    String? notes,
    int reminderMinutes = 30,
  }) async {
    final endTime = followUpTime.add(const Duration(minutes: 30)); // Default 30-minute follow-up
    
    return await scheduleMeeting(
      title: 'Follow-up with Dr. $doctorName',
      description: 'Follow-up appointment - $specialty\nPrevious appointment: $previousAppointmentId${notes != null ? '\n\nNotes: $notes' : ''}',
      startTime: followUpTime,
      endTime: endTime,
      location: location,
      attendees: [],
      meetingType: 'follow_up',
      doctorName: doctorName,
      specialty: specialty,
      reminderMinutes: reminderMinutes,
    );
  }

  // Get meetings by type
  static Future<List<Meeting>> getMeetingsByType(String meetingType) async {
    final meetings = await getMeetings();
    return meetings.where((meeting) => meeting.meetingType == meetingType).toList();
  }

  // Get meetings by doctor
  static Future<List<Meeting>> getMeetingsByDoctor(String doctorName) async {
    final meetings = await getMeetings();
    return meetings.where((meeting) => meeting.doctorName == doctorName).toList();
  }

  // Search meetings
  static Future<List<Meeting>> searchMeetings(String query) async {
    final meetings = await getMeetings();
    final lowerQuery = query.toLowerCase();
    
    return meetings.where((meeting) =>
      meeting.title.toLowerCase().contains(lowerQuery) ||
      meeting.description.toLowerCase().contains(lowerQuery) ||
      (meeting.doctorName?.toLowerCase().contains(lowerQuery) ?? false) ||
      (meeting.specialty?.toLowerCase().contains(lowerQuery) ?? false) ||
      meeting.location.toLowerCase().contains(lowerQuery)
    ).toList();
  }

  // Get meeting statistics
  static Future<Map<String, dynamic>> getMeetingStats() async {
    final meetings = await getMeetings();
    final now = DateTime.now();
    
    final upcoming = meetings.where((m) => m.startTime.isAfter(now)).length;
    final completed = meetings.where((m) => m.status == 'completed').length;
    final cancelled = meetings.where((m) => m.status == 'cancelled').length;
    
    final thisMonth = meetings.where((m) => 
      m.startTime.year == now.year && 
      m.startTime.month == now.month
    ).length;
    
    return {
      'total': meetings.length,
      'upcoming': upcoming,
      'completed': completed,
      'cancelled': cancelled,
      'thisMonth': thisMonth,
    };
  }
}
