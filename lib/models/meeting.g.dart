// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meeting.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MeetingAdapter extends TypeAdapter<Meeting> {
  @override
  final int typeId = 3;

  @override
  Meeting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Meeting(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      startTime: fields[3] as DateTime,
      endTime: fields[4] as DateTime,
      location: fields[5] as String,
      attendees: (fields[6] as List).cast<String>(),
      googleEventId: fields[7] as String?,
      isReminderSet: fields[8] as bool,
      reminderMinutesBefore: fields[9] as int,
      meetingType: fields[10] as String,
      doctorName: fields[11] as String?,
      specialty: fields[12] as String?,
      status: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Meeting obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.location)
      ..writeByte(6)
      ..write(obj.attendees)
      ..writeByte(7)
      ..write(obj.googleEventId)
      ..writeByte(8)
      ..write(obj.isReminderSet)
      ..writeByte(9)
      ..write(obj.reminderMinutesBefore)
      ..writeByte(10)
      ..write(obj.meetingType)
      ..writeByte(11)
      ..write(obj.doctorName)
      ..writeByte(12)
      ..write(obj.specialty)
      ..writeByte(13)
      ..write(obj.status);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeetingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
