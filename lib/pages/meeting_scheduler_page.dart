import 'package:aroghya_ai/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../services/calendar_service.dart';
import '../services/notification_service.dart';
import '../models/meeting.dart';

class MeetingSchedulerPage extends StatefulWidget {
  final Meeting? meeting;
  
  const MeetingSchedulerPage({super.key, this.meeting});

  @override
  State<MeetingSchedulerPage> createState() => _MeetingSchedulerPageState();
}

class _MeetingSchedulerPageState extends State<MeetingSchedulerPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _doctorController = TextEditingController();
  final _specialtyController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  String _meetingType = 'doctor_appointment';
  int _reminderMinutes = 30;
  
  List<Meeting> _upcomingMeetings = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadMeetings();
    _requestNotificationPermissions();
    
    // If editing an existing meeting, populate the form
    if (widget.meeting != null) {
      _populateFormWithMeeting(widget.meeting!);
    }
  }
  
  void _populateFormWithMeeting(Meeting meeting) {
    _titleController.text = meeting.title;
    _doctorController.text = meeting.doctorName ?? '';
    _specialtyController.text = meeting.specialty ?? '';
    _locationController.text = meeting.location;
    _notesController.text = meeting.description;
    _selectedDate = meeting.startTime;
    _selectedTime = TimeOfDay.fromDateTime(meeting.startTime);
    _meetingType = meeting.meetingType;
    _reminderMinutes = meeting.reminderMinutesBefore;
  }

  Future<void> _requestNotificationPermissions() async {
    await NotificationService.requestPermissions();
  }

  Future<void> _loadMeetings() async {
    setState(() => _isLoading = true);
    try {
      final meetings = await CalendarService.getUpcomingMeetings();
      setState(() => _upcomingMeetings = meetings);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading meetings: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _scheduleMeeting() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    try {
      final startDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );
      
      final endDateTime = startDateTime.add(const Duration(hours: 1));

      await CalendarService.scheduleMeeting(
        title: _titleController.text.isEmpty 
            ? 'Appointment with Dr. ${_doctorController.text}'
            : _titleController.text,
        description: _notesController.text,
        startTime: startDateTime,
        endTime: endDateTime,
        location: _locationController.text,
        attendees: [],
        meetingType: _meetingType,
        doctorName: _doctorController.text,
        specialty: _specialtyController.text,
        reminderMinutes: _reminderMinutes,
      );

      _clearForm();
      await _loadMeetings();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meeting scheduled successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error scheduling meeting: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _clearForm() {
    _titleController.clear();
    _doctorController.clear();
    _specialtyController.clear();
    _locationController.clear();
    _notesController.clear();
    setState(() {
      _selectedDate = DateTime.now().add(const Duration(days: 1));
      _selectedTime = const TimeOfDay(hour: 9, minute: 0);
      _meetingType = 'doctor_appointment';
      _reminderMinutes = 30;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Meeting'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildScheduleForm(),
                  const SizedBox(height: 32),
                  _buildUpcomingMeetings(),
                ],
              ),
            ),
    );
  }

  Widget _buildScheduleForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Schedule New Appointment',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              
              DropdownButtonFormField<String>(
                value: _meetingType,
                decoration: const InputDecoration(
                  labelText: 'Appointment Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'doctor_appointment', child: Text('Doctor Appointment')),
                  DropdownMenuItem(value: 'consultation', child: Text('Consultation')),
                  DropdownMenuItem(value: 'follow_up', child: Text('Follow-up')),
                ],
                onChanged: (value) => setState(() => _meetingType = value!),
              ),
              
              const SizedBox(height: 16),
              TextFormField(
                controller: _doctorController,
                decoration: const InputDecoration(
                  labelText: 'Doctor Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Required' : null,
              ),
              
              const SizedBox(height: 16),
              TextFormField(
                controller: _specialtyController,
                decoration: const InputDecoration(
                  labelText: 'Specialty',
                  border: OutlineInputBorder(),
                ),
              ),
              
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _selectedDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) setState(() => _selectedDate = date);
                      },
                    ),
                  ),
                ],
              ),
              
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Time: ${_selectedTime.format(context)}'),
                      trailing: const Icon(Icons.access_time),
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: _selectedTime,
                        );
                        if (time != null) setState(() => _selectedTime = time);
                      },
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value?.isEmpty == true ? 'Required' : null,
              ),
              
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _reminderMinutes,
                decoration: const InputDecoration(
                  labelText: 'Reminder',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 15, child: Text('15 minutes before')),
                  DropdownMenuItem(value: 30, child: Text('30 minutes before')),
                  DropdownMenuItem(value: 60, child: Text('1 hour before')),
                  DropdownMenuItem(value: 120, child: Text('2 hours before')),
                ],
                onChanged: (value) => setState(() => _reminderMinutes = value!),
              ),
              
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _scheduleMeeting,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Schedule Appointment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingMeetings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming Appointments',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            
            if (_upcomingMeetings.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No upcoming appointments'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _upcomingMeetings.length,
                itemBuilder: (context, index) {
                  final meeting = _upcomingMeetings[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getMeetingTypeColor(meeting.meetingType),
                        child: Icon(
                          _getMeetingTypeIcon(meeting.meetingType),
                          color: Colors.white,
                        ),
                      ),
                      title: Text(meeting.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${meeting.doctorName} - ${meeting.specialty}'),
                          Text('${meeting.startTime.day}/${meeting.startTime.month}/${meeting.startTime.year} at ${TimeOfDay.fromDateTime(meeting.startTime).format(context)}'),
                          Text(meeting.location),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit'),
                          ),
                          const PopupMenuItem(
                            value: 'cancel',
                            child: Text('Cancel'),
                          ),
                        ],
                        onSelected: (value) async {
                          if (value == 'cancel') {
                            await CalendarService.cancelMeeting(meeting.id);
                            _loadMeetings();
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Color _getMeetingTypeColor(String type) {
    switch (type) {
      case 'doctor_appointment':
        return Colors.blue;
      case 'consultation':
        return Colors.green;
      case 'follow_up':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getMeetingTypeIcon(String type) {
    switch (type) {
      case 'doctor_appointment':
        return Icons.medical_services;
      case 'consultation':
        return Icons.chat;
      case 'follow_up':
        return Icons.follow_the_signs;
      default:
        return Icons.event;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _doctorController.dispose();
    _specialtyController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
