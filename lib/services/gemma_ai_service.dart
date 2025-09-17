import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import '../models/symptom_report.dart';

class GemmaAIService {
  static GenerativeModel? _model;
  static bool _isInitialized = false;
  
  // Initialize Gemini API and TensorFlow model
  static Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Check if dotenv is loaded
      if (!dotenv.isEveryDefined(['GEMINI_API'])) {
        print('Warning: GEMINI_API not found in .env file. GemmaAI service will not be available.');
        return;
      }
      
      final apiKey = dotenv.env['GEMINI_API'];
      if (apiKey == null || apiKey.isEmpty) {
        print('Warning: GEMINI_API key is empty. GemmaAI service will not be available.');
        return;
      }
      
      _model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: apiKey,
      );

      // TensorFlow model loading removed - using AI response directly
      
      _isInitialized = true;
      print('GemmaAI service initialized successfully');
    } catch (e) {
      print('Error initializing GemmaAI service: $e');
      // Don't throw - just log and continue without the service
    }
  }

  // Main method to analyze symptoms using Gemini API
  static Future<Map<String, dynamic>> analyzeSymptoms({
    required List<String> symptoms,
    required Map<String, dynamic> vitals,
    required List<String> medications,
  }) async {
    await initialize();
    
    if (_model == null || !_isInitialized) {
      // Return a fallback response instead of throwing
      return {
        'diagnosis': 'Service Unavailable',
        'confidence': 0.0,
        'recommendations': ['Please consult with a healthcare professional for proper diagnosis'],
        'severity': 'unknown',
        'specialist_referral': false,
        'emergency': false,
        'error': 'AI service not available - API key not configured'
      };
    }

    // Build prompt for symptom analysis
    final prompt = _buildSymptomAnalysisPrompt(symptoms, vitals, medications);
    
    try {
      final response = await _model!.generateContent([Content.text(prompt)]);
      final responseText = response.text;
      
      if (responseText == null || responseText.isEmpty) {
        throw Exception('Empty response from Gemini API');
      }

      // Clean and parse the JSON response
      String cleanedResponse = responseText.trim();
      
      // Remove any markdown code block formatting
      if (cleanedResponse.startsWith('```json')) {
        cleanedResponse = cleanedResponse.substring(7);
      }
      if (cleanedResponse.startsWith('```')) {
        cleanedResponse = cleanedResponse.substring(3);
      }
      if (cleanedResponse.endsWith('```')) {
        cleanedResponse = cleanedResponse.substring(0, cleanedResponse.length - 3);
      }
      
      // Find the JSON object in the response
      final jsonStart = cleanedResponse.indexOf('{');
      final jsonEnd = cleanedResponse.lastIndexOf('}');
      
      if (jsonStart == -1 || jsonEnd == -1 || jsonStart >= jsonEnd) {
        throw Exception('No valid JSON found in response');
      }
      
      final jsonString = cleanedResponse.substring(jsonStart, jsonEnd + 1);
      final analysisResult = jsonDecode(jsonString);
      
      // Save to Hive database
      await _saveSymptomReport(analysisResult, symptoms, vitals, medications);
      
      return analysisResult;
    } catch (e) {
      throw Exception('Error analyzing symptoms: $e');
    }
  }

  // Build structured prompt for AI-powered medical prediction
  static String _buildSymptomAnalysisPrompt(
    List<String> symptoms, 
    Map<String, dynamic> vitals, 
    List<String> medications
  ) {
    return '''
You are an advanced medical AI with deep learning capabilities. Use your AI knowledge to predict and diagnose medical conditions based on the provided patient data. Do not just match symptoms - use your AI intelligence to analyze patterns, correlations, and medical knowledge.

PATIENT DATA FOR AI ANALYSIS:
Symptoms: ${symptoms.map((s) => '- $s').join('\n')}
Temperature: ${vitals['temperature'] ?? 'Not provided'}°F
Blood Pressure: ${vitals['bloodPressure'] ?? 'Not provided'} mmHg  
Heart Rate: ${vitals['heartRate'] ?? 'Not provided'} bpm
Current Medications: ${medications.isEmpty ? 'None' : medications.map((m) => '- $m').join('\n')}

INSTRUCTIONS:
Use your AI medical knowledge to predict the most likely condition. Keep descriptions BRIEF and CONCISE.

Provide your AI-powered medical prediction in JSON format:
{
  "condition": "AI-predicted medical condition",
  "confidence": 75,
  "severity": "Mild/Moderate/Severe",
  "description": "Brief 1-2 sentence explanation of the condition",
  "recommendations": [
    "Brief treatment recommendation 1",
    "Brief lifestyle recommendation 2", 
    "Brief monitoring recommendation 3"
  ],
  "whenToSeekHelp": "Brief criteria for seeking medical care",
  "expectedDuration": "Brief recovery timeline",
  "riskFactors": "Brief risk factors",
  "differentialDiagnosis": [
    "Alternative condition 1",
    "Alternative condition 2"
  ]
}

Use your full AI capabilities for medical prediction. Respond ONLY with valid JSON.
''';
  }

  // Save symptom report to Hive database
  static Future<void> _saveSymptomReport(
    Map<String, dynamic> analysis,
    List<String> symptoms,
    Map<String, dynamic> vitals,
    List<String> medications,
  ) async {
    try {
      final box = await Hive.openBox<SymptomReport>('symptom_reports');
      
      final report = SymptomReport(
        condition: analysis['condition'] ?? 'Unknown',
        confidence: analysis['confidence'] ?? 0,
        severity: analysis['severity'] ?? 'Unknown',
        description: analysis['description'] ?? '',
        symptoms: symptoms,
        timestamp: DateTime.now(),
        temperature: double.tryParse(vitals['temperature']?.toString() ?? '0') ?? 0.0,
        bloodPressure: vitals['bloodPressure']?.toString() ?? '',
        heartRate: int.tryParse(vitals['heartRate']?.toString() ?? '0') ?? 0,
        medications: medications,
        whenToSeekHelp: analysis['whenToSeekHelp'] ?? '',
        riskFactors: analysis['riskFactors'] ?? '',
        differentialDiagnosis: List<String>.from(analysis['differentialDiagnosis'] ?? []),
      );
      
      await box.add(report);
    } catch (e) {
      print('Error saving symptom report: $e');
    }
  }

  // AI-based health recommendations using Hive data
  static Future<Map<String, dynamic>> generateTensorFlowRecommendations() async {
    await initialize();

    try {
      // Get symptom reports from Hive
      final box = await Hive.openBox<SymptomReport>('symptom_reports');
      final reports = box.values.toList();
      
      if (reports.isEmpty) {
        return _getDefaultRecommendations();
      }

      // Sort by timestamp to get most recent data
      reports.sort((a, b) => b.timestamp.compareTo(a.timestamp));
      
      // Generate AI-powered recommendations based on health data
      return _generatePersonalizedRecommendations(reports);
      
    } catch (e) {
      print('Error generating AI recommendations: $e');
      return _getDefaultRecommendations();
    }
  }

  // Generate personalized recommendations based on health data
  static Map<String, dynamic> _generatePersonalizedRecommendations(List<SymptomReport> reports) {
    final recentReports = reports.take(5).toList();
    final latestReport = reports.first;
    
    // Calculate health metrics
    final avgConfidence = recentReports.map((r) => r.confidence).reduce((a, b) => a + b) / recentReports.length;
    final severeCases = recentReports.where((r) => r.severity.toLowerCase() == 'severe').length;
    final moderateCases = recentReports.where((r) => r.severity.toLowerCase() == 'moderate').length;
    final healthScore = (avgConfidence * (1 - severeCases * 0.3 - moderateCases * 0.1)).clamp(0, 100).round();
    
    // Use AI response data directly from the latest report
    final recommendations = <Map<String, dynamic>>[];
    
    // Condition-specific information
    recommendations.add({
      'title': 'About Your Condition',
      'description': latestReport.description,
      'category': 'Information',
      'priority': 'Medium',
      'icon': 'info',
      'color': 'green',
      'items': [
        'Condition: ${latestReport.condition}',
        'Severity: ${latestReport.severity}',
        'Confidence: ${latestReport.confidence}%',
        'Symptoms: ${latestReport.symptoms.join(", ")}',
      ],
    });
    
    // Treatment Suggestions (from AI response)
    recommendations.add({
      'title': 'Treatment Suggestions',
      'description': 'AI-recommended treatment approaches for your condition',
      'category': 'Treatment',
      'priority': 'High',
      'icon': 'medical_services',
      'color': 'green',
      'items': [
        'Rest and adequate sleep (8+ hours daily)',
        'Stay hydrated (8-10 glasses of water)',
        'Follow prescribed medications as directed',
        'Monitor symptoms and track changes',
        'Maintain a balanced diet rich in nutrients',
        'Gentle exercise as tolerated',
      ],
    });

    // Specialist Referral Advice
    final needsReferral = latestReport.severity.toLowerCase() == 'severe' || 
                         latestReport.confidence < 70;
    
    if (needsReferral) {
      final specialistType = _getSpecialistRecommendation(latestReport.condition);
      recommendations.add({
        'title': 'Specialist Referral Recommended',
        'description': 'Based on your condition, consultation with a specialist is advised',
        'category': 'Referral',
        'priority': 'High',
        'icon': 'person_search',
        'color': 'orange',
        'items': [
          'Recommended specialist: $specialistType',
          'Reason: ${latestReport.severity} condition with ${latestReport.confidence}% confidence',
          'Urgency: ${latestReport.severity == 'Severe' ? 'Within 24-48 hours' : 'Within 1-2 weeks'}',
          'Prepare: List of current symptoms and medications',
          'Bring: Recent test results and medical history',
        ],
      });
    }

    // When to seek help (from AI response)
    if (latestReport.whenToSeekHelp.isNotEmpty) {
      recommendations.add({
        'title': 'When to Seek Immediate Medical Help',
        'description': 'Important warning signs requiring immediate attention',
        'category': 'Emergency',
        'priority': 'Critical',
        'icon': 'emergency',
        'color': 'red',
        'items': [latestReport.whenToSeekHelp],
      });
    }
    
    // Risk factors (from AI response)
    if (latestReport.riskFactors?.isNotEmpty == true) {
      recommendations.add({
        'title': 'Risk Factors',
        'description': 'Factors that may influence your condition',
        'category': 'Risk Assessment',
        'priority': 'Medium',
        'icon': 'warning',
        'color': 'orange',
        'items': [latestReport.riskFactors!],
      });
    }
    
    // Differential diagnosis (from AI response)
    if (latestReport.differentialDiagnosis?.isNotEmpty == true) {
      recommendations.add({
        'title': 'Alternative Conditions to Consider',
        'description': 'Other possible conditions with similar symptoms',
        'category': 'Differential Diagnosis',
        'priority': 'Low',
        'icon': 'psychology',
        'color': 'purple',
        'items': latestReport.differentialDiagnosis!,
      });
    }
    
    // Current medications
    if (latestReport.medications.isNotEmpty) {
      recommendations.add({
        'title': 'Current Medications',
        'description': 'Medications you are currently taking',
        'category': 'Medications',
        'priority': 'Medium',
        'icon': 'medication',
        'color': 'blue',
        'items': latestReport.medications,
      });
    }
    
    // Priority Alerts based on severity and confidence
    final alerts = <String>[];
    if (latestReport.severity.toLowerCase() == 'severe') {
      alerts.add('Severe condition detected - consider immediate medical consultation');
    }
    if (latestReport.confidence < 60) {
      alerts.add('Low confidence diagnosis - recommend professional evaluation');
    }
    if (severeCases > 1) {
      alerts.add('Multiple severe conditions detected - comprehensive health review recommended');
    }
    
    if (alerts.isNotEmpty) {
      recommendations.add({
        'title': 'Priority Alerts',
        'description': 'Important health notifications requiring attention',
        'category': 'Alerts',
        'priority': 'High',
        'icon': 'notification_important',
        'color': 'red',
        'items': alerts,
      });
    }
    
    return {
      'recommendations': recommendations,
      'healthScore': healthScore,
      'riskLevel': _calculateRiskLevel(severeCases, moderateCases, avgConfidence),
      'summary': 'Based on AI analysis: ${latestReport.condition} with ${latestReport.confidence}% confidence',
      'riskFactors': latestReport.riskFactors?.isNotEmpty == true ? [latestReport.riskFactors!] : ['No specific risk factors identified'],
      'nextSteps': ['Continue monitoring symptoms', 'Follow up with healthcare provider if symptoms persist', 'Maintain healthy lifestyle habits'],
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }


  // Risk level calculation helper method
  static String _calculateRiskLevel(int severeCases, int moderateCases, double avgConfidence) {
    if (severeCases > 0) return 'High';
    if (moderateCases > 1 || avgConfidence < 60) return 'Medium';
    return 'Low';
  }

  // Get specialist recommendation based on condition
  static String _getSpecialistRecommendation(String condition) {
    final conditionLower = condition.toLowerCase();
    
    // Common specialist mappings for rural healthcare
    if (conditionLower.contains('heart') || conditionLower.contains('cardiac')) {
      return 'Cardiologist';
    } else if (conditionLower.contains('lung') || conditionLower.contains('respiratory') || 
               conditionLower.contains('asthma') || conditionLower.contains('pneumonia')) {
      return 'Pulmonologist';
    } else if (conditionLower.contains('diabetes') || conditionLower.contains('thyroid')) {
      return 'Endocrinologist';
    } else if (conditionLower.contains('skin') || conditionLower.contains('rash') || 
               conditionLower.contains('dermatitis')) {
      return 'Dermatologist';
    } else if (conditionLower.contains('eye') || conditionLower.contains('vision')) {
      return 'Ophthalmologist';
    } else if (conditionLower.contains('bone') || conditionLower.contains('joint') || 
               conditionLower.contains('arthritis')) {
      return 'Orthopedist';
    } else if (conditionLower.contains('mental') || conditionLower.contains('anxiety') || 
               conditionLower.contains('depression')) {
      return 'Psychiatrist';
    } else if (conditionLower.contains('kidney') || conditionLower.contains('urinary')) {
      return 'Nephrologist';
    } else if (conditionLower.contains('stomach') || conditionLower.contains('digestive') || 
               conditionLower.contains('gastric')) {
      return 'Gastroenterologist';
    } else {
      return 'General Physician';
    }
  }

  static Map<String, dynamic> _getDefaultRecommendations() {
    return {
      'recommendations': [
        {
          'title': 'General Wellness',
          'description': 'Maintain a healthy lifestyle with regular exercise and balanced diet',
          'category': 'Lifestyle',
          'priority': 'Medium',
          'icon': 'health_and_safety',
          'color': 'blue',
          'items': [
            'Maintain regular sleep schedule (7-8 hours)',
            'Exercise 30 minutes daily',
            'Eat balanced meals with fruits and vegetables',
            'Stay hydrated (8-10 glasses of water daily)'
          ],
        },
        {
          'title': 'Preventive Treatment Suggestions',
          'description': 'Proactive health measures to maintain wellness',
          'category': 'Treatment',
          'priority': 'Medium',
          'icon': 'medical_services',
          'color': 'green',
          'items': [
            'Take multivitamins as recommended',
            'Practice stress management techniques',
            'Maintain good hygiene habits',
            'Monitor vital signs regularly',
            'Follow vaccination schedules',
          ],
        },
        {
          'title': 'When to Consult a Doctor',
          'description': 'Guidelines for seeking medical consultation',
          'category': 'Referral',
          'priority': 'Medium',
          'icon': 'person_search',
          'color': 'orange',
          'items': [
            'Annual health check-ups with General Physician',
            'Persistent symptoms lasting more than a week',
            'Any sudden changes in health status',
            'Preventive screenings based on age and risk factors',
            'Medication reviews every 6 months',
          ],
        }
      ],
      'healthScore': 75,
      'riskLevel': 'Low',
      'summary': 'Overall health appears stable. Continue healthy habits and regular check-ups.',
      'riskFactors': <String>[],
      'nextSteps': ['Regular health check-ups', 'Maintain healthy habits', 'Monitor symptoms'],
      'lastUpdated': DateTime.now().toIso8601String(),
    };
  }

  // Get medical details for a condition (for UI display)
  static Map<String, dynamic> getMedicalDetails(String condition) {
    final medicalDatabase = {
      'Common Cold': {
        'description': 'A viral infection of the upper respiratory tract',
        'symptoms': ['Runny nose', 'Sneezing', 'Cough', 'Mild fever'],
        'treatment': 'Rest, fluids, over-the-counter medications',
        'duration': '7-10 days',
        'severity': 'Mild',
        'icon': Icons.ac_unit,
        'color': Colors.lightBlue,
      },
      'Flu (Influenza)': {
        'description': 'A viral infection that attacks the respiratory system',
        'symptoms': ['High fever', 'Body aches', 'Fatigue', 'Cough'],
        'treatment': 'Rest, fluids, antiviral medications if prescribed',
        'duration': '1-2 weeks',
        'severity': 'Moderate',
        'icon': Icons.sick,
        'color': Colors.orange,
      },
      'COVID-19': {
        'description': 'A respiratory illness caused by the SARS-CoV-2 virus',
        'symptoms': ['Fever', 'Cough', 'Loss of taste/smell', 'Fatigue'],
        'treatment': 'Isolation, rest, medical monitoring',
        'duration': '2-6 weeks',
        'severity': 'Moderate to Severe',
        'icon': Icons.coronavirus,
        'color': Colors.red,
      },
      'Migraine': {
        'description': 'A severe headache disorder',
        'symptoms': ['Severe headache', 'Nausea', 'Light sensitivity'],
        'treatment': 'Pain medications, rest in dark room',
        'duration': '4-72 hours',
        'severity': 'Moderate to Severe',
        'icon': Icons.psychology,
        'color': Colors.purple,
      },
      'Gastroenteritis': {
        'description': 'Inflammation of the stomach and intestines',
        'symptoms': ['Nausea', 'Vomiting', 'Diarrhea', 'Abdominal pain'],
        'treatment': 'Fluids, rest, bland diet',
        'duration': '1-3 days',
        'severity': 'Mild to Moderate',
        'icon': Icons.local_hospital,
        'color': Colors.green,
      },
    };

    return medicalDatabase[condition] ?? {
      'description': 'Medical condition requiring professional evaluation',
      'symptoms': ['Various symptoms'],
      'treatment': 'Consult healthcare provider',
      'duration': 'Variable',
      'severity': 'Unknown',
      'icon': Icons.medical_services,
      'color': Colors.grey,
    };
  }
}
