import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class MultiLanguageSpeechService {
  static stt.SpeechToText? _speechToText;
  static bool _isInitialized = false;
  static bool _isListening = false;
  static String _currentLanguage = 'en';
  static String _recognizedText = '';
  static List<stt.LocaleName> _availableLocales = [];
  
  // Supported languages: Hindi, Tamil, Telugu, Bengali, English
  static const Map<String, String> _supportedLanguages = {
    'en': 'English',
    'hi': 'हिन्दी',
    'ta': 'தமிழ்',
    'te': 'తెలుగు',
    'bn': 'বাংলা',
  };

  // Language codes for speech recognition
  static const Map<String, String> _languageCodes = {
    'en': 'en_US',
    'hi': 'hi_IN',
    'ta': 'ta_IN',
    'te': 'te_IN',
    'bn': 'bn_IN',
  };

  // Get available language names
  static Map<String, String> get supportedLanguages => _supportedLanguages;
  
  // Get current language
  static String get currentLanguage => _currentLanguage;
  
  // Get current language name
  static String get currentLanguageName => _supportedLanguages[_currentLanguage] ?? 'English';

  /// Initialize the speech service
  static Future<bool> initialize() async {
    try {
      if (_isInitialized) return true;

      // Initialize speech to text
      _speechToText = stt.SpeechToText();
      
      bool available = await _speechToText!.initialize(
        onStatus: (status) => debugPrint('🎤 Speech status: $status'),
        onError: (error) => debugPrint('❌ Speech error: $error'),
      );

      if (available) {
        _availableLocales = await _speechToText!.locales();
        debugPrint('✅ Speech service initialized with ${_availableLocales.length} locales');
        
        // Debug: Print available locales
        debugPrint('📋 Available locales:');
        for (var locale in _availableLocales) {
          debugPrint('  - ${locale.name} (${locale.localeId})');
        }
        
        // Load saved language preference
        await _loadLanguagePreference();
        
        _isInitialized = true;
        return true;
      } else {
        debugPrint('❌ Speech recognition not available on this device');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error initializing speech service: $e');
      return false;
    }
  }

  /// Load saved language preference
  static Future<void> _loadLanguagePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentLanguage = prefs.getString('speech_language') ?? 'en';
      debugPrint('📱 Loaded speech language preference: $_currentLanguage');
    } catch (e) {
      debugPrint('⚠️ Error loading language preference: $e');
      _currentLanguage = 'en';
    }
  }

  /// Save language preference
  static Future<void> _saveLanguagePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('speech_language', _currentLanguage);
      debugPrint('💾 Saved speech language preference: $_currentLanguage');
    } catch (e) {
      debugPrint('⚠️ Error saving language preference: $e');
    }
  }

  /// Set current language
  static Future<void> setLanguage(String languageCode) async {
    if (_supportedLanguages.containsKey(languageCode)) {
      _currentLanguage = languageCode;
      await _saveLanguagePreference();
      debugPrint('🌐 Language changed to: ${_supportedLanguages[languageCode]}');
    } else {
      debugPrint('❌ Unsupported language: $languageCode');
    }
  }

  /// Check if microphone permission is granted
  static Future<bool> _checkMicrophonePermission() async {
    final status = await Permission.microphone.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      final result = await Permission.microphone.request();
      return result.isGranted;
    }
    return false;
  }

  /// Start listening for speech
  static Future<bool> startListening({
    Function(String)? onResult,
    Function(String)? onError,
  }) async {
    try {
      if (!_isInitialized) {
        final initialized = await initialize();
        if (!initialized) {
          onError?.call('Speech service not available');
          return false;
        }
      }

      if (_isListening) {
        debugPrint('⚠️ Already listening');
        return false;
      }

      // Check microphone permission
      if (!await _checkMicrophonePermission()) {
        onError?.call('Microphone permission denied');
        return false;
      }

      // Get the locale ID for the current language
      String localeId = _languageCodes[_currentLanguage] ?? 'en_US';
      
      // Find the best matching locale from available locales
      stt.LocaleName? selectedLocale;
      
      // First try exact match with our language codes
      String targetLocaleId = _languageCodes[_currentLanguage] ?? 'en_US';
      for (var locale in _availableLocales) {
        if (locale.localeId == targetLocaleId) {
          selectedLocale = locale;
          break;
        }
      }
      
      // If no exact match, try language prefix match
      if (selectedLocale == null) {
        for (var locale in _availableLocales) {
          if (locale.localeId.startsWith(_currentLanguage)) {
            selectedLocale = locale;
            break;
          }
        }
      }
      
      // If still no match, try keyword matching for Indian languages
      if (selectedLocale == null) {
        Map<String, List<String>> languageKeywords = {
          'hi': ['hi_IN', 'hi-IN', 'hindi'],
          'ta': ['ta_IN', 'ta-IN', 'tamil'],
          'te': ['te_IN', 'te-IN', 'telugu'],
          'bn': ['bn_IN', 'bn-IN', 'bengali', 'bangla'],
        };
        
        if (languageKeywords.containsKey(_currentLanguage)) {
          for (var locale in _availableLocales) {
            for (var keyword in languageKeywords[_currentLanguage]!) {
              if (locale.localeId.toLowerCase().contains(keyword.toLowerCase()) || 
                  locale.name.toLowerCase().contains(keyword.toLowerCase())) {
                selectedLocale = locale;
                break;
              }
            }
            if (selectedLocale != null) break;
          }
        }
      }
      
      // Final fallback to any English locale
      if (selectedLocale == null) {
        for (var locale in _availableLocales) {
          if (locale.localeId.toLowerCase().contains('en')) {
            selectedLocale = locale;
            break;
          }
        }
      }
      
      // Ultimate fallback - use first available locale
      if (selectedLocale == null && _availableLocales.isNotEmpty) {
        selectedLocale = _availableLocales.first;
      }

      debugPrint('🎤 Starting speech recognition in ${selectedLocale?.name ?? 'default'} (${selectedLocale?.localeId ?? localeId})');

      // Ensure we have a valid locale
      if (selectedLocale == null) {
        debugPrint('❌ No suitable locale found for language: $_currentLanguage');
        onError?.call('Speech recognition not available for selected language');
        return false;
      }

      bool started = false;
      try {
        started = await _speechToText!.listen(
          onResult: (result) {
            _recognizedText = result.recognizedWords;
            debugPrint('🗣️ Recognized: $_recognizedText');
            
            if (result.finalResult) {
              _processRecognizedText(_recognizedText, onResult, onError);
            }
          },
          localeId: selectedLocale.localeId,
          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 3),
          partialResults: true,
          cancelOnError: true,
        );
      } catch (e) {
        debugPrint('❌ Error starting speech listener: $e');
        onError?.call('Failed to start speech recognition: $e');
        return false;
      }

      if (started) {
        _isListening = true;
        debugPrint('✅ Speech recognition started');
        return true;
      } else {
        debugPrint('❌ Failed to start speech recognition');
        onError?.call('Failed to start speech recognition');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error starting speech recognition: $e');
      onError?.call('Error starting speech recognition: $e');
      return false;
    }
  }

  /// Process recognized text and translate if needed
  static Future<void> _processRecognizedText(
    String text,
    Function(String)? onResult,
    Function(String)? onError,
  ) async {
    try {
      if (text.isEmpty) {
        onResult?.call('');
        return;
      }

      String processedText = text;

      // Use the recognized text directly without translation
      // This allows users to input in their native language and get results in that language
      debugPrint('✅ Using recognized text directly: $text');

      onResult?.call(processedText);
    } catch (e) {
      debugPrint('❌ Error processing recognized text: $e');
      onError?.call('Error processing speech: $e');
    }
  }

  /// Stop listening
  static Future<String?> stopListening({
    Function(String)? onResult,
    Function(String)? onError,
  }) async {
    try {
      if (!_isListening) {
        debugPrint('⚠️ Not currently listening');
        return null;
      }

      await _speechToText!.stop();
      _isListening = false;
      
      debugPrint('🛑 Stopped speech recognition');
      
      // Return the final recognized text
      if (_recognizedText.isNotEmpty) {
        await _processRecognizedText(_recognizedText, onResult, onError);
        return _recognizedText;
      }
      
      return null;
    } catch (e) {
      debugPrint('❌ Error stopping speech recognition: $e');
      onError?.call('Error stopping speech recognition: $e');
      return null;
    }
  }

  /// Cancel listening
  static Future<void> cancelListening() async {
    try {
      if (_isListening && _speechToText != null) {
        await _speechToText!.cancel();
        _isListening = false;
        _recognizedText = '';
        debugPrint('🚫 Speech recognition cancelled');
      }
    } catch (e) {
      debugPrint('❌ Error cancelling speech recognition: $e');
    }
  }

  /// Check if currently listening
  static bool get isListening => _isListening;

  /// Check if service is initialized
  static bool get isInitialized => _isInitialized;

  /// Get available locales for debugging
  static List<stt.LocaleName> get availableLocales => _availableLocales;

  /// Test speech recognition (for language selection page)
  static Future<String?> testSpeechRecognition(String languageCode) async {
    try {
      final oldLanguage = _currentLanguage;
      await setLanguage(languageCode);
      
      // Start a short test recording
      bool started = await startListening();
      if (!started) {
        await setLanguage(oldLanguage);
        return null;
      }
      
      // Wait for 3 seconds then stop
      await Future.delayed(const Duration(seconds: 3));
      final result = await stopListening();
      
      // Restore original language
      await setLanguage(oldLanguage);
      
      return result;
    } catch (e) {
      debugPrint('❌ Error testing speech recognition: $e');
      return null;
    }
  }

  /// Dispose resources
  static Future<void> dispose() async {
    try {
      if (_isListening) {
        await cancelListening();
      }
      
      _speechToText = null;
      _isInitialized = false;
      _availableLocales.clear();
      _recognizedText = '';
      
      debugPrint('🧹 Speech service disposed');
    } catch (e) {
      debugPrint('❌ Error disposing speech service: $e');
    }
  }
}
