import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'language_service.dart';

/// Unified Translation Service using Google Cloud Translation API
/// Replaces all existing translation services with a single, efficient solution
class UnifiedTranslationService {
  static const String _apiKey = 'AIzaSyBGNNzCNvl5tSIxVc0RHPEWt7A7qT4VL3s'; // Replace with your actual API key
  static const String _baseUrl = 'https://translation.googleapis.com/language/translate/v2';
  static final Map<String, String> _translationCache = {};
  static bool _isInitialized = false;
  
  // Language code mapping for Google Cloud Translation API
  static const Map<String, String> _languageCodes = {
    'english': 'en',
    'hindi': 'hi',
    'tamil': 'ta',
    'telugu': 'te',
    'bengali': 'bn',
  };

  // Common UI texts that will be preloaded for better performance
  static const List<String> _commonUITexts = [
    'Home',
    'Settings',
    'Vault',
    'Meetings',
    'Hello',
    'Health Summary',
    'Symptom Checker',
    'AI Recommendations',
    'Notifications',
    'Profile',
    'Logout',
    'Language Selection',
    'Current',
    'Select Language',
    'Health Tip',
    'Check Symptoms',
    'Medication Alerts',
    'Schedule Meeting',
    'Emergency Contacts',
    'Last Check-up',
    'AI Health Score',
    'Upcoming Appointments',
    'Alerts',
    'Feeling good today?',
    'Stay hydrated, exercise daily, and eat nutritious meals.',
    'Language changed successfully',
    'Confirm Logout',
    'Are you sure you want to log out?',
    'Cancel',
    'Close',
    'OK',
    'symptoms',
    'describe_symptoms',
    'loading',
    'analyze_symptoms',
  ];

  /// Initialize the Google Cloud Translation service
  static Future<void> initialize() async {
    try {
      debugPrint('🌍 Initializing Unified Translation Service...');
      
      // Test API connectivity
      await _testApiConnection();
      
      _isInitialized = true;
      
      // Preload common translations in background
      _preloadCommonTranslations();
      
      debugPrint('✅ Unified Translation Service initialized');
    } catch (e) {
      debugPrint('⚠️ Unified Translation Service initialization error: $e');
      debugPrint('📝 Make sure to configure Google Cloud Translation API credentials');
    }
  }

  /// Test API connection
  static Future<void> _testApiConnection() async {
    try {
      await _translateWithApi('Hello', 'en', 'hi');
      debugPrint('✅ Google Cloud Translation API is working');
    } catch (e) {
      debugPrint('⚠️ Google Cloud Translation API test failed: $e');
      throw e;
    }
  }

  /// Core translation method using Google Cloud Translation API
  static Future<String> _translateWithApi(String text, String fromCode, String toCode) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'q': text,
          'source': fromCode,
          'target': toCode,
          'format': 'text',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['translations'][0]['translatedText'];
      } else {
        throw Exception('Google Translate API error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('API translation error: $e');
      rethrow;
    }
  }

  /// Get translated text using Google Cloud Translation API
  static Future<String> getText(String text) async {
    try {
      final currentLanguage = LanguageService().currentLanguageCode;
      
      // If English, return as is
      if (currentLanguage == 'english') {
        return text;
      }

      // Check cache first
      final cacheKey = '${text}_$currentLanguage';
      if (_translationCache.containsKey(cacheKey)) {
        return _translationCache[cacheKey]!;
      }

      // Get target language code
      final targetCode = _languageCodes[currentLanguage];
      if (targetCode == null) {
        debugPrint('⚠️ Unsupported language: $currentLanguage');
        return text;
      }

      // Use Google Cloud Translation API if initialized
      if (_isInitialized) {
        final translated = await _translateWithApi(text, 'en', targetCode);
        
        // Cache the result
        _translationCache[cacheKey] = translated;
        
        return translated;
      } else {
        debugPrint('⚠️ Translation service not initialized, returning original text');
        return text;
      }
    } catch (e) {
      debugPrint('Translation error for "$text": $e');
      return text; // Return original text if translation fails
    }
  }

  /// Synchronous version that returns cached translation or original text
  static String getTextSync(String text) {
    try {
      final currentLanguage = LanguageService().currentLanguageCode;
      
      // If English, return as is
      if (currentLanguage == 'english') {
        return text;
      }

      // Check cache
      final cacheKey = '${text}_$currentLanguage';
      if (_translationCache.containsKey(cacheKey)) {
        return _translationCache[cacheKey]!;
      }
      
      // If not cached, trigger async translation and return original for now
      getText(text); // This will cache it for next time
      return text;
    } catch (e) {
      return text;
    }
  }

  /// Translate text between any two supported languages
  static Future<String> translateText(String text, String fromLang, String toLang) async {
    try {
      // If same language, return original text
      if (fromLang == toLang) return text;
      
      // Get language codes
      final fromCode = _languageCodes[fromLang] ?? fromLang;
      final toCode = _languageCodes[toLang] ?? toLang;
      
      // Check cache
      final cacheKey = '${text}_${fromCode}_$toCode';
      if (_translationCache.containsKey(cacheKey)) {
        return _translationCache[cacheKey]!;
      }

      // Use Google Cloud Translation API if initialized
      if (_isInitialized) {
        final translated = await _translateWithApi(text, fromCode, toCode);
        
        // Cache the result
        _translationCache[cacheKey] = translated;
        
        return translated;
      } else {
        debugPrint('⚠️ Translation service not initialized, returning original text');
        return text;
      }
    } catch (e) {
      debugPrint('Translation error for "$text" ($fromLang -> $toLang): $e');
      return text;
    }
  }

  /// Translate multiple texts at once for better performance
  static Future<Map<String, String>> translateMultiple(List<String> texts, {String? targetLanguage}) async {
    final results = <String, String>{};
    final languageService = LanguageService();
    final currentLanguage = targetLanguage ?? languageService.currentLanguageCode;
    
    if (currentLanguage == 'english') {
      // Return original texts if target is English
      for (final text in texts) {
        results[text] = text;
      }
      return results;
    }

    try {
      final targetCode = _languageCodes[currentLanguage];
      if (targetCode == null) {
        // Return original texts if language not supported
        for (final text in texts) {
          results[text] = text;
        }
        return results;
      }

      // Check cache first
      final uncachedTexts = <String>[];
      for (final text in texts) {
        final cacheKey = '${text}_$currentLanguage';
        if (_translationCache.containsKey(cacheKey)) {
          results[text] = _translationCache[cacheKey]!;
        } else {
          uncachedTexts.add(text);
        }
      }

      // Translate uncached texts
      if (uncachedTexts.isNotEmpty && _isInitialized) {
        for (final text in uncachedTexts) {
          try {
            final translated = await _translateWithApi(text, 'en', targetCode);
            
            final cacheKey = '${text}_$currentLanguage';
            _translationCache[cacheKey] = translated;
            results[text] = translated;
          } catch (e) {
            debugPrint('Error translating "$text": $e');
            results[text] = text; // Fallback to original text
          }
        }
      } else {
        // If service not initialized, return original texts
        for (final text in uncachedTexts) {
          results[text] = text;
        }
      }
    } catch (e) {
      debugPrint('Batch translation error: $e');
      // Fallback: return original texts
      for (final text in texts) {
        if (!results.containsKey(text)) {
          results[text] = text;
        }
      }
    }
    
    return results;
  }

  /// Preload common translations in background for better performance
  static void _preloadCommonTranslations() async {
    try {
      final currentLanguage = LanguageService().currentLanguageCode;
      if (currentLanguage == 'english') return;

      debugPrint('🔄 Preloading translations for $currentLanguage...');
      
      for (final text in _commonUITexts) {
        try {
          await getText(text); // This will cache the translation
        } catch (e) {
          debugPrint('⚠️ Failed to preload translation for "$text": $e');
        }
      }
      
      debugPrint('✅ Common translations preloaded');
    } catch (e) {
      debugPrint('⚠️ Error preloading translations: $e');
    }
  }

  /// Get symptom input hint for current language
  static String getSymptomInputHint() {
    final currentLanguage = LanguageService().currentLanguageCode;
    
    // Return cached translation if available
    final cacheKey = 'symptom_input_hint_$currentLanguage';
    if (_translationCache.containsKey(cacheKey)) {
      return _translationCache[cacheKey]!;
    }

    // Default English hint
    const englishHint = 'e.g., "I have persistent cough, high fever, and feel very tired..."';
    
    if (currentLanguage == 'english') {
      return englishHint;
    }

    // Trigger async translation and return English for now
    getText(englishHint).then((translated) {
      _translationCache[cacheKey] = translated;
    }).catchError((e) {
      debugPrint('Error translating symptom hint: $e');
    });

    return englishHint;
  }

  /// Clear translation cache
  static void clearCache() {
    _translationCache.clear();
  }

  /// Get cache size for debugging
  static int getCacheSize() {
    return _translationCache.length;
  }

  /// Check if a translation is cached
  static bool isCached(String text, String language) {
    final cacheKey = '${text}_$language';
    return _translationCache.containsKey(cacheKey);
  }

  /// Check if the service is initialized
  static bool get isInitialized => _isInitialized;

  /// Get supported language codes
  static List<String> get supportedLanguages => _languageCodes.keys.toList();
}
