import 'package:hive/hive.dart';

part 'medical_document.g.dart';

@HiveType(typeId: 4)
class MedicalDocument extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String fileName;

  @HiveField(2)
  String filePath;

  @HiveField(3)
  String fileType; // pdf, jpg, png, etc.

  @HiveField(4)
  DateTime uploadDate;

  @HiveField(5)
  String? description;

  @HiveField(6)
  List<String> tags;

  @HiveField(7)
  String? extractedText;

  @HiveField(8)
  String? aiAnalysis;

  @HiveField(9)
  double fileSize; // in bytes

  @HiveField(10)
  String category; // lab_report, prescription, scan, etc.

  @HiveField(11)
  List<double>? embedding; // GGUF-generated embedding for semantic search

  @HiveField(12)
  List<String>? textChunks; // For RAG processing

  @HiveField(13)
  String? thumbnailPath; // For image documents

  @HiveField(14)
  bool isProcessed; // Whether GGUF processing is complete

  MedicalDocument({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.fileType,
    required this.uploadDate,
    this.description,
    required this.tags,
    this.extractedText,
    this.aiAnalysis,
    required this.fileSize,
    required this.category,
    this.embedding,
    this.textChunks,
    this.thumbnailPath,
    this.isProcessed = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'filePath': filePath,
      'fileType': fileType,
      'uploadDate': uploadDate.toIso8601String(),
      'description': description,
      'tags': tags,
      'extractedText': extractedText,
      'aiAnalysis': aiAnalysis,
      'fileSize': fileSize,
      'category': category,
      'embedding': embedding,
      'textChunks': textChunks,
      'thumbnailPath': thumbnailPath,
      'isProcessed': isProcessed,
    };
  }

  factory MedicalDocument.fromJson(Map<String, dynamic> json) {
    return MedicalDocument(
      id: json['id'],
      fileName: json['fileName'],
      filePath: json['filePath'],
      fileType: json['fileType'],
      uploadDate: DateTime.parse(json['uploadDate']),
      description: json['description'],
      tags: List<String>.from(json['tags']),
      extractedText: json['extractedText'],
      aiAnalysis: json['aiAnalysis'],
      fileSize: json['fileSize'],
      category: json['category'],
      embedding: json['embedding'] != null ? List<double>.from(json['embedding']) : null,
      textChunks: json['textChunks'] != null ? List<String>.from(json['textChunks']) : null,
      thumbnailPath: json['thumbnailPath'],
      isProcessed: json['isProcessed'] ?? false,
    );
  }
}
