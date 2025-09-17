import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme.dart'; // Import your AppTheme file
import '../models/meeting.dart';
import 'meeting_scheduler_page.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  // Lists to hold sorted meetings
  List<Meeting> _upcomingMeetings = [];
  List<Meeting> _pastMeetings = [];

  @override
  void initState() {
    super.initState();
    // Use ValueListenableBuilder on the Hive box for automatic UI updates
  }

  // Helper to sort and filter meetings from the Hive box
  void _sortMeetings(Box<Meeting> box) {
    final allMeetings = box.values.toList();
    final now = DateTime.now();

    _upcomingMeetings = allMeetings
        .where((meeting) => meeting.startTime.isAfter(now))
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    _pastMeetings = allMeetings
        .where((meeting) => !meeting.startTime.isAfter(now))
        .toList()
      ..sort((a, b) => b.startTime.compareTo(a.startTime));
  }

  // --- Actions ---

  void _editMeeting(Meeting meeting) {
    // Navigate to the scheduler page to edit the meeting
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MeetingSchedulerPage(meeting: meeting),
      ),
    );
  }

  void _cancelMeeting(Meeting meeting) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusL)),
          title: const Text('Cancel Appointment', style: AppTheme.headingSmall),
          content: Text(
              'Are you sure you want to cancel the appointment with "${meeting.title}"?',
              style: AppTheme.bodyMedium),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('No', style: TextStyle(color: AppTheme.textSecondary)),
            ),
            TextButton(
              onPressed: () {
                final meetingsBox = Hive.box<Meeting>('meetings');
                meetingsBox.delete(meeting.key);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Cancelled appointment: "${meeting.title}"'),
                    backgroundColor: AppTheme.infoColor,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Yes, Cancel', style: TextStyle(color: AppTheme.errorColor)),
            ),
          ],
        );
      },
    );
  }

  // --- UI Builder Methods ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text("Appointments"),
      ),
      body: ValueListenableBuilder<Box<Meeting>>(
        valueListenable: Hive.box<Meeting>('meetings').listenable(),
        builder: (context, box, _) {
          _sortMeetings(box); // Re-sort meetings whenever data changes
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Upcoming Appointments", style: AppTheme.headingMedium),
                const SizedBox(height: AppTheme.spacingS),
                _upcomingMeetings.isEmpty
                    ? _buildEmptyState("No upcoming appointments", Icons.calendar_today_outlined)
                    : _buildUpcomingList(),
                const SizedBox(height: AppTheme.spacingL),
                const Text("Past Appointments", style: AppTheme.headingMedium),
                const SizedBox(height: AppTheme.spacingS),
                _pastMeetings.isEmpty
                    ? _buildEmptyState("No past appointment history", Icons.history)
                    : _buildPastList(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MeetingSchedulerPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Book Now"),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: AppTheme.textOnPrimary,
      ),
    );
  }

  Widget _buildUpcomingList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _upcomingMeetings.length,
      itemBuilder: (context, index) {
        final meeting = _upcomingMeetings[index];
        return _buildUpcomingCard(meeting);
      },
    );
  }

  Widget _buildPastList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _pastMeetings.length,
      itemBuilder: (context, index) {
        final meeting = _pastMeetings[index];
        return _buildPastCard(meeting);
      },
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: AppTheme.cardDecoration
          .copyWith(color: AppTheme.surfaceColor.withOpacity(0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.textLight, size: 24),
          const SizedBox(width: AppTheme.spacingM),
          Text(message, style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildUpcomingCard(Meeting meeting) {
    final isUrgent = meeting.startTime.difference(DateTime.now()).inHours < 24;
    final cardColor = isUrgent ? AppTheme.errorColor : AppTheme.infoColor;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: AppTheme.cardDecoration.copyWith(
        color: cardColor.withOpacity(0.08),
        border: Border.all(color: cardColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppTheme.primaryColor,
                child: Icon(_getMeetingIcon(meeting.meetingType), color: AppTheme.textOnPrimary),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(meeting.title, style: AppTheme.headingSmall),
                    Text(meeting.meetingType.toUpperCase(), style: AppTheme.caption),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          _buildInfoRow(Icons.location_on_outlined, meeting.location),
          const SizedBox(height: AppTheme.spacingS),
          _buildInfoRow(Icons.calendar_today_outlined,
              "${DateFormat('E, MMM dd, yyyy').format(meeting.startTime)} at ${DateFormat('hh:mm a').format(meeting.startTime)}"),
          if (meeting.description.isNotEmpty) ...[
            const SizedBox(height: AppTheme.spacingM),
            Text(meeting.description, style: AppTheme.bodySmall),
          ],
          const SizedBox(height: AppTheme.spacingM),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _editMeeting(meeting),
                  style: AppTheme.secondaryButtonStyle,
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text("Edit"),
                ),
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _cancelMeeting(meeting),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.errorColor.withOpacity(0.1),
                    foregroundColor: AppTheme.errorColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingL, vertical: AppTheme.spacingM),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusM),
                    ),
                  ),
                  icon: const Icon(Icons.cancel_outlined, size: 16),
                  label: const Text("Cancel"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPastCard(Meeting meeting) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppTheme.spacingXS),
      decoration: AppTheme.cardDecoration.copyWith(
        color: AppTheme.surfaceColor.withOpacity(0.7),
        boxShadow: [],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTheme.backgroundColor,
          child: Icon(_getMeetingIcon(meeting.meetingType), color: AppTheme.textSecondary),
        ),
        title: Text(meeting.title, style: AppTheme.bodyLarge),
        subtitle: Text(meeting.location, style: AppTheme.bodySmall),
        trailing: Text(
          DateFormat('dd MMM\nyyyy').format(meeting.startTime),
          textAlign: TextAlign.right,
          style: AppTheme.caption,
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppTheme.textSecondary),
        const SizedBox(width: AppTheme.spacingS),
        Expanded(child: Text(text, style: AppTheme.bodyMedium)),
      ],
    );
  }

  IconData _getMeetingIcon(String meetingType) {
    switch (meetingType.toLowerCase()) {
      case 'consultation':
        return Icons.medical_services_outlined;
      case 'follow-up':
        return Icons.follow_the_signs_outlined;
      case 'emergency':
        return Icons.emergency_outlined;
      default:
        return Icons.event_outlined;
    }
  }
}