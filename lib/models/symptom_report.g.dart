// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'symptom_report.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SymptomReportAdapter extends TypeAdapter<SymptomReport> {
  @override
  final int typeId = 1;

  @override
  SymptomReport read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SymptomReport(
      condition: fields[0] as String,
      confidence: fields[1] as int,
      severity: fields[2] as String,
      description: fields[3] as String,
      symptoms: (fields[4] as List).cast<String>(),
      timestamp: fields[5] as DateTime,
      temperature: fields[6] as double?,
      bloodPressure: fields[7] as String?,
      heartRate: fields[8] as int?,
      medications: (fields[9] as List).cast<String>(),
      whenToSeekHelp: fields[10] as String,
      riskFactors: fields[11] as String?,
      differentialDiagnosis: (fields[12] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, SymptomReport obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.condition)
      ..writeByte(1)
      ..write(obj.confidence)
      ..writeByte(2)
      ..write(obj.severity)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.symptoms)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.temperature)
      ..writeByte(7)
      ..write(obj.bloodPressure)
      ..writeByte(8)
      ..write(obj.heartRate)
      ..writeByte(9)
      ..write(obj.medications)
      ..writeByte(10)
      ..write(obj.whenToSeekHelp)
      ..writeByte(11)
      ..write(obj.riskFactors)
      ..writeByte(12)
      ..write(obj.differentialDiagnosis);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SymptomReportAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
