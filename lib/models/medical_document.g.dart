// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medical_document.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicalDocumentAdapter extends TypeAdapter<MedicalDocument> {
  @override
  final int typeId = 4;

  @override
  MedicalDocument read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicalDocument(
      id: fields[0] as String,
      fileName: fields[1] as String,
      filePath: fields[2] as String,
      fileType: fields[3] as String,
      uploadDate: fields[4] as DateTime,
      description: fields[5] as String?,
      tags: (fields[6] as List).cast<String>(),
      extractedText: fields[7] as String?,
      aiAnalysis: fields[8] as String?,
      fileSize: fields[9] as double,
      category: fields[10] as String,
    );
  }

  @override
  void write(BinaryWriter writer, MedicalDocument obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.fileName)
      ..writeByte(2)
      ..write(obj.filePath)
      ..writeByte(3)
      ..write(obj.fileType)
      ..writeByte(4)
      ..write(obj.uploadDate)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.extractedText)
      ..writeByte(8)
      ..write(obj.aiAnalysis)
      ..writeByte(9)
      ..write(obj.fileSize)
      ..writeByte(10)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicalDocumentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
