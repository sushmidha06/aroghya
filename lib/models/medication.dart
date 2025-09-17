import 'package:hive/hive.dart';

part 'medication.g.dart';

@HiveType(typeId: 2)
class Medication extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String frequency;

  @HiveField(2)
  int daysToFollow;

  @HiveField(3)
  String timing; // before/after meals

  @HiveField(4)
  DateTime startDate;

  @HiveField(5)
  DateTime? endDate;

  @HiveField(6)
  String? notes;

  @HiveField(7)
  bool isActive;

  @HiveField(8)
  List<String> reminderTimes;

  Medication({
    required this.name,
    required this.frequency,
    required this.daysToFollow,
    required this.timing,
    required this.startDate,
    this.endDate,
    this.notes,
    this.isActive = true,
    this.reminderTimes = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'frequency': frequency,
      'daysToFollow': daysToFollow,
      'timing': timing,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'notes': notes,
      'isActive': isActive,
      'reminderTimes': reminderTimes,
    };
  }

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      name: json['name'],
      frequency: json['frequency'],
      daysToFollow: json['daysToFollow'],
      timing: json['timing'],
      startDate: DateTime.parse(json['startDate']),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      notes: json['notes'],
      isActive: json['isActive'] ?? true,
      reminderTimes: List<String>.from(json['reminderTimes'] ?? []),
    );
  }
}
