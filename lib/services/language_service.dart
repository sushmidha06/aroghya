import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'multi_language_speech_service.dart';

class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  Locale _currentLocale = const Locale('en');
  
  // Supported locales
  static const List<Locale> supportedLocales = [
    Locale('en'), // English
    Locale('hi'), // Hindi
    Locale('ta'), // Tamil
    Locale('te'), // Telugu
    Locale('bn'), // Bengali
  ];

  static const Map<String, String> languageNames = {
    'en': 'English',
    'hi': 'हिन्दी (Hindi)',
    'ta': 'தமிழ் (Tamil)',
    'te': 'తెలుగు (Telugu)',
    'bn': 'বাংলা (Bengali)',
  };

  static const Map<String, String> nativeLanguageNames = {
    'en': 'English',
    'hi': 'हिन्दी',
    'ta': 'தமிழ்',
    'te': 'తెలుగు',
    'bn': 'বাংলা',
  };

  Locale get currentLocale => _currentLocale;
  String get currentLanguageCode => _currentLocale.languageCode;
  String get currentLanguageName => languageNames[currentLanguageCode] ?? 'English';
  String get currentNativeLanguageName => nativeLanguageNames[currentLanguageCode] ?? 'English';

  /// Initialize the language service
  Future<void> initialize() async {
    await _loadSavedLanguage();
  }

  /// Load saved language from preferences
  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString('app_language') ?? 'en';
      
      // Validate that the saved language is supported
      if (supportedLocales.any((locale) => locale.languageCode == savedLanguageCode)) {
        _currentLocale = Locale(savedLanguageCode);
      } else {
        _currentLocale = const Locale('en');
      }
      
      // Sync with speech service
      await MultiLanguageSpeechService.setLanguage(_currentLocale.languageCode);
      
      debugPrint('🌐 Loaded app language: ${_currentLocale.languageCode}');
    } catch (e) {
      debugPrint('Error loading saved language: $e');
      _currentLocale = const Locale('en');
    }
  }

  /// Change the app language
  Future<void> changeLanguage(String languageCode) async {
    try {
      // Validate language code
      if (!supportedLocales.any((locale) => locale.languageCode == languageCode)) {
        debugPrint('❌ Unsupported language code: $languageCode');
        return;
      }

      // Update current locale
      _currentLocale = Locale(languageCode);
      
      // Save to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('app_language', languageCode);
      
      // Update speech service language
      await MultiLanguageSpeechService.setLanguage(languageCode);
      
      // Notify listeners to rebuild UI
      notifyListeners();
      
      debugPrint('✅ Language changed to: ${languageNames[languageCode]}');
    } catch (e) {
      debugPrint('❌ Error changing language: $e');
    }
  }

  /// Get all supported languages with their display names
  Map<String, String> getSupportedLanguages() {
    return Map.from(languageNames);
  }

  /// Get native language names
  Map<String, String> getNativeLanguageNames() {
    return Map.from(nativeLanguageNames);
  }

  /// Check if a language is currently selected
  bool isLanguageSelected(String languageCode) {
    return _currentLocale.languageCode == languageCode;
  }

  /// Get locale from language code
  Locale getLocaleFromCode(String languageCode) {
    return Locale(languageCode);
  }

  /// Get language code from locale
  String getCodeFromLocale(Locale locale) {
    return locale.languageCode;
  }

  /// Reset to default language (English)
  Future<void> resetToDefault() async {
    await changeLanguage('en');
  }

  /// Get system locale if supported, otherwise return default
  Locale getSystemLocaleOrDefault() {
    try {
      final systemLocale = WidgetsBinding.instance.platformDispatcher.locale;
      final systemLanguageCode = systemLocale.languageCode;
      
      // Check if system language is supported
      if (supportedLocales.any((locale) => locale.languageCode == systemLanguageCode)) {
        return Locale(systemLanguageCode);
      }
    } catch (e) {
      debugPrint('Error getting system locale: $e');
    }
    
    return const Locale('en'); // Default to English
  }

  /// Auto-detect and set language based on system locale
  Future<void> autoDetectLanguage() async {
    final systemLocale = getSystemLocaleOrDefault();
    await changeLanguage(systemLocale.languageCode);
  }
}
