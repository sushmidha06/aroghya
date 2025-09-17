import 'package:hive/hive.dart';

part 'meeting.g.dart';

@HiveType(typeId: 3)
class Meeting extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime startTime;

  @HiveField(4)
  DateTime endTime;

  @HiveField(5)
  String location;

  @HiveField(6)
  List<String> attendees;

  @HiveField(7)
  String? googleEventId;

  @HiveField(8)
  bool isReminderSet;

  @HiveField(9)
  int reminderMinutesBefore;

  @HiveField(10)
  String meetingType; // 'doctor_appointment', 'consultation', 'follow_up'

  @HiveField(11)
  String? doctorName;

  @HiveField(12)
  String? specialty;

  @HiveField(13)
  String status; // 'scheduled', 'confirmed', 'cancelled', 'completed'

  Meeting({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.attendees,
    this.googleEventId,
    this.isReminderSet = true,
    this.reminderMinutesBefore = 30,
    required this.meetingType,
    this.doctorName,
    this.specialty,
    this.status = 'scheduled',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location,
      'attendees': attendees,
      'googleEventId': googleEventId,
      'isReminderSet': isReminderSet,
      'reminderMinutesBefore': reminderMinutesBefore,
      'meetingType': meetingType,
      'doctorName': doctorName,
      'specialty': specialty,
      'status': status,
    };
  }

  factory Meeting.fromJson(Map<String, dynamic> json) {
    return Meeting(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      location: json['location'],
      attendees: List<String>.from(json['attendees']),
      googleEventId: json['googleEventId'],
      isReminderSet: json['isReminderSet'] ?? true,
      reminderMinutesBefore: json['reminderMinutesBefore'] ?? 30,
      meetingType: json['meetingType'],
      doctorName: json['doctorName'],
      specialty: json['specialty'],
      status: json['status'] ?? 'scheduled',
    );
  }
}
