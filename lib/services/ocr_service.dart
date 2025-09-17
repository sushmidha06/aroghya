import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class OCRService {
  static final TextRecognizer _textRecognizer = TextRecognizer();
  static final ImagePicker _imagePicker = ImagePicker();

  // Scan prescription/medication label using camera or gallery
  static Future<Map<String, dynamic>?> scanMedicationDetails({bool useCamera = true}) async {
    try {
      // Request camera/storage permissions
      if (useCamera) {
        final cameraStatus = await Permission.camera.request();
        if (!cameraStatus.isGranted) {
          throw Exception('Camera permission denied');
        }
      } else {
        final storageStatus = await Permission.storage.request();
        if (!storageStatus.isGranted) {
          throw Exception('Storage permission denied');
        }
      }

      // Pick image from camera or gallery
      final XFile? image = await _imagePicker.pickImage(
        source: useCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) return null;

      // Process image with OCR
      final inputImage = InputImage.fromFilePath(image.path);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      // Extract medication details from recognized text
      final extractedDetails = _extractMedicationDetails(recognizedText.text);

      return extractedDetails;
    } catch (e) {
      throw Exception('Error scanning medication details: $e');
    }
  }

  // Extract medication details from OCR text using pattern matching
  static Map<String, dynamic> _extractMedicationDetails(String text) {
    final Map<String, dynamic> details = {
      'name': '',
      'frequency': '',
      'daysToFollow': 0,
      'timing': '',
      'confidence': 0.0,
    };

    final lines = text.split('\n').map((line) => line.trim()).where((line) => line.isNotEmpty).toList();
    
    // Medicine name extraction (usually first significant line or after "Tab" keyword)
    String medicineName = _extractMedicineName(lines);
    details['name'] = medicineName;

    // Frequency extraction (1x, 2x, 3x daily, twice, thrice, etc.)
    String frequency = _extractFrequency(text);
    details['frequency'] = frequency;

    // Days extraction (for X days, X days course, etc.)
    int days = _extractDays(text);
    details['daysToFollow'] = days;

    // Timing extraction (before/after meals, empty stomach, etc.)
    String timing = _extractTiming(text);
    details['timing'] = timing;

    // Calculate confidence based on extracted fields
    double confidence = _calculateConfidence(details);
    details['confidence'] = confidence;

    return details;
  }

  static String _extractMedicineName(List<String> lines) {
    // Common patterns for medicine names
    final medicinePatterns = [
      RegExp(r'Tab\.?\s+([A-Za-z]+(?:\s+[A-Za-z]+)*)', caseSensitive: false),
      RegExp(r'Tablet\.?\s+([A-Za-z]+(?:\s+[A-Za-z]+)*)', caseSensitive: false),
      RegExp(r'Cap\.?\s+([A-Za-z]+(?:\s+[A-Za-z]+)*)', caseSensitive: false),
      RegExp(r'Capsule\.?\s+([A-Za-z]+(?:\s+[A-Za-z]+)*)', caseSensitive: false),
      RegExp(r'Syrup\.?\s+([A-Za-z]+(?:\s+[A-Za-z]+)*)', caseSensitive: false),
    ];

    for (final line in lines) {
      for (final pattern in medicinePatterns) {
        final match = pattern.firstMatch(line);
        if (match != null) {
          return match.group(1)?.trim() ?? '';
        }
      }
    }

    // Fallback: look for capitalized words that might be medicine names
    for (final line in lines) {
      final words = line.split(' ');
      for (final word in words) {
        if (word.length > 3 && RegExp(r'^[A-Z][a-z]+').hasMatch(word)) {
          // Check if it's likely a medicine name (not common words)
          if (!_isCommonWord(word)) {
            return word;
          }
        }
      }
    }

    return '';
  }

  static String _extractFrequency(String text) {
    final frequencyPatterns = [
      RegExp(r'(\d+)\s*x\s*daily', caseSensitive: false),
      RegExp(r'(\d+)\s*times?\s*(?:a\s*)?day', caseSensitive: false),
      RegExp(r'(\d+)\s*times?\s*daily', caseSensitive: false),
      RegExp(r'once\s*(?:a\s*)?day', caseSensitive: false),
      RegExp(r'twice\s*(?:a\s*)?day', caseSensitive: false),
      RegExp(r'thrice\s*(?:a\s*)?day', caseSensitive: false),
      RegExp(r'every\s*(\d+)\s*hours?', caseSensitive: false),
      RegExp(r'(\d+)\s*hourly', caseSensitive: false),
    ];

    for (final pattern in frequencyPatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        if (pattern.pattern.contains('once')) return '1x daily';
        if (pattern.pattern.contains('twice')) return '2x daily';
        if (pattern.pattern.contains('thrice')) return '3x daily';
        if (pattern.pattern.contains('hourly') || pattern.pattern.contains('hours')) {
          final hours = match.group(1);
          return 'Every $hours hours';
        }
        final times = match.group(1);
        return '${times}x daily';
      }
    }

    return '';
  }

  static int _extractDays(String text) {
    final daysPatterns = [
      RegExp(r'for\s*(\d+)\s*days?', caseSensitive: false),
      RegExp(r'(\d+)\s*days?\s*course', caseSensitive: false),
      RegExp(r'(\d+)\s*days?\s*treatment', caseSensitive: false),
      RegExp(r'continue\s*for\s*(\d+)\s*days?', caseSensitive: false),
    ];

    for (final pattern in daysPatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return int.tryParse(match.group(1) ?? '0') ?? 0;
      }
    }

    return 0;
  }

  static String _extractTiming(String text) {
    final timingPatterns = [
      RegExp(r'before\s*meals?', caseSensitive: false),
      RegExp(r'after\s*meals?', caseSensitive: false),
      RegExp(r'with\s*meals?', caseSensitive: false),
      RegExp(r'empty\s*stomach', caseSensitive: false),
      RegExp(r'on\s*empty\s*stomach', caseSensitive: false),
      RegExp(r'before\s*food', caseSensitive: false),
      RegExp(r'after\s*food', caseSensitive: false),
      RegExp(r'with\s*food', caseSensitive: false),
    ];

    for (final pattern in timingPatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        final timing = match.group(0)?.toLowerCase() ?? '';
        if (timing.contains('before')) return 'Before meals';
        if (timing.contains('after')) return 'After meals';
        if (timing.contains('with')) return 'With meals';
        if (timing.contains('empty')) return 'Empty stomach';
      }
    }

    return '';
  }

  static double _calculateConfidence(Map<String, dynamic> details) {
    double confidence = 0.0;
    
    if (details['name'].toString().isNotEmpty) confidence += 0.4;
    if (details['frequency'].toString().isNotEmpty) confidence += 0.3;
    if (details['daysToFollow'] > 0) confidence += 0.2;
    if (details['timing'].toString().isNotEmpty) confidence += 0.1;

    return confidence;
  }

  static bool _isCommonWord(String word) {
    final commonWords = [
      'the', 'and', 'for', 'are', 'but', 'not', 'you', 'all', 'can', 'had', 'her', 'was', 'one', 'our', 'out', 'day', 'get', 'has', 'him', 'his', 'how', 'man', 'new', 'now', 'old', 'see', 'two', 'way', 'who', 'boy', 'did', 'its', 'let', 'put', 'say', 'she', 'too', 'use'
    ];
    return commonWords.contains(word.toLowerCase());
  }

  // Dispose resources
  static void dispose() {
    _textRecognizer.close();
  }
}
