import 'package:hive/hive.dart';

part 'symptom_report.g.dart';

@HiveType(typeId: 1)
class SymptomReport extends HiveObject {
  @HiveField(0)
  String condition;

  @HiveField(1)
  int confidence;

  @HiveField(2)
  String severity;

  @HiveField(3)
  String description;

  @HiveField(4)
  List<String> symptoms;

  @HiveField(5)
  DateTime timestamp;

  @HiveField(6)
  double? temperature;

  @HiveField(7)
  String? bloodPressure;

  @HiveField(8)
  int? heartRate;

  @HiveField(9)
  List<String> medications;

  @HiveField(10)
  String whenToSeekHelp;

  @HiveField(11)
  String? riskFactors;

  @HiveField(12)
  List<String>? differentialDiagnosis;

  SymptomReport({
    required this.condition,
    required this.confidence,
    required this.severity,
    required this.description,
    required this.symptoms,
    required this.timestamp,
    this.temperature,
    this.bloodPressure,
    this.heartRate,
    required this.medications,
    required this.whenToSeekHelp,
    this.riskFactors,
    this.differentialDiagnosis,
  });

  Map<String, dynamic> toJson() {
    return {
      'condition': condition,
      'confidence': confidence,
      'severity': severity,
      'description': description,
      'symptoms': symptoms,
      'timestamp': timestamp.toIso8601String(),
      'temperature': temperature,
      'bloodPressure': bloodPressure,
      'heartRate': heartRate,
      'medications': medications,
      'whenToSeekHelp': whenToSeekHelp,
      'riskFactors': riskFactors,
      'differentialDiagnosis': differentialDiagnosis,
    };
  }
}
