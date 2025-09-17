import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hive/hive.dart';
import '../models/symptom_report.dart';

class GeminiService {
  static GenerativeModel? _model;
  static bool _isInitialized = false;

  static Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      await dotenv.load(fileName: ".env");
      final apiKey = dotenv.env['GEMINI_API'];
      
      if (apiKey == null || apiKey.isEmpty) {
        print('❌ Gemini API key not found in .env file');
        return false;
      }

      _model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );

      _isInitialized = true;
      print('✅ Gemini AI service initialized successfully');
      return true;
    } catch (e) {
      print('❌ Failed to initialize Gemini AI service: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>> generateHealthRecommendations() async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_model == null) {
      throw Exception('Gemini AI service not initialized');
    }

    try {
      // Get stored symptom reports from Hive
      final box = await Hive.openBox<SymptomReport>('symptom_reports');
      final reports = box.values.toList();

      if (reports.isEmpty) {
        return _getDefaultRecommendations();
      }

      // Prepare data for Gemini API
      final reportsData = reports.map((report) => report.toJson()).toList();
      final prompt = _buildHealthRecommendationPrompt(reportsData);

      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);

      if (response.text == null) {
        throw Exception('No response from Gemini API');
      }

      return _parseGeminiResponse(response.text!);
    } catch (e) {
      print('❌ Error generating health recommendations: $e');
      return _getDefaultRecommendations();
    }
  }

  static String _buildHealthRecommendationPrompt(List<Map<String, dynamic>> reports) {
    final reportsJson = jsonEncode(reports);
    
    return '''
You are a medical AI assistant. Based on the following symptom checker reports and health data, provide personalized health recommendations.

Health Reports Data:
$reportsJson

Please provide a JSON response with the following structure:
{
  "healthScore": 85,
  "riskLevel": "Low",
  "summary": "Brief health summary",
  "recommendations": [
    {
      "title": "Diet Recommendations",
      "items": ["recommendation 1", "recommendation 2", "recommendation 3"],
      "icon": "restaurant_menu",
      "color": "orangeAccent"
    },
    {
      "title": "Exercise Tips", 
      "items": ["exercise tip 1", "exercise tip 2", "exercise tip 3"],
      "icon": "fitness_center",
      "color": "teal"
    },
    {
      "title": "Preventive Care",
      "items": ["preventive care 1", "preventive care 2", "preventive care 3"],
      "icon": "medical_services", 
      "color": "lightBlue"
    },
    {
      "title": "Mental Health",
      "items": ["mental health tip 1", "mental health tip 2", "mental health tip 3"],
      "icon": "self_improvement",
      "color": "purpleAccent"
    }
  ],
  "priorityAlerts": [
    "Alert 1 if any urgent issues",
    "Alert 2 if any urgent issues"
  ]
}

Base your recommendations on:
1. Recent symptoms and conditions diagnosed
2. Frequency of health issues
3. Severity patterns
4. Vital signs trends (temperature, heart rate, blood pressure)
5. General health maintenance

Provide specific, actionable recommendations. If there are concerning patterns, include priority alerts.
''';
  }

  static Map<String, dynamic> _parseGeminiResponse(String response) {
    try {
      // Extract JSON from response (in case there's additional text)
      final jsonStart = response.indexOf('{');
      final jsonEnd = response.lastIndexOf('}') + 1;
      
      if (jsonStart == -1 || jsonEnd == 0) {
        throw Exception('No JSON found in response');
      }

      final jsonString = response.substring(jsonStart, jsonEnd);
      final parsed = jsonDecode(jsonString) as Map<String, dynamic>;

      // Convert icon strings to Flutter Icons
      if (parsed['recommendations'] != null) {
        for (var rec in parsed['recommendations']) {
          rec['icon'] = _getIconFromString(rec['icon']);
          rec['color'] = _getColorFromString(rec['color']);
        }
      }

      return parsed;
    } catch (e) {
      print('❌ Error parsing Gemini response: $e');
      return _getDefaultRecommendations();
    }
  }

  static dynamic _getIconFromString(String iconName) {
    // Map string icon names to Flutter Icons
    switch (iconName) {
      case 'restaurant_menu':
        return 'restaurant_menu';
      case 'fitness_center':
        return 'fitness_center';
      case 'medical_services':
        return 'medical_services';
      case 'self_improvement':
        return 'self_improvement';
      case 'warning':
        return 'warning';
      default:
        return 'info';
    }
  }

  static dynamic _getColorFromString(String colorName) {
    // Map string color names to Flutter Colors
    switch (colorName) {
      case 'orangeAccent':
        return 'orangeAccent';
      case 'teal':
        return 'teal';
      case 'lightBlue':
        return 'lightBlue';
      case 'purpleAccent':
        return 'purpleAccent';
      case 'redAccent':
        return 'redAccent';
      default:
        return 'blue';
    }
  }

  static Map<String, dynamic> _getDefaultRecommendations() {
    return {
      "healthScore": 75,
      "riskLevel": "Low",
      "summary": "No recent health data available. Focus on maintaining good health habits.",
      "recommendations": [
        {
          "title": "General Health",
          "items": [
            "Stay hydrated - drink 8-10 glasses of water daily",
            "Maintain a balanced diet with fruits and vegetables",
            "Get 7-8 hours of quality sleep"
          ],
          "icon": "health_and_safety",
          "color": "green"
        }
      ],
      "priorityAlerts": []
    };
  }
}
