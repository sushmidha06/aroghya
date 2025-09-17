import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationService {
  static const String _defaultLocale = 'en';
  static const List<String> _supportedLocales = ['en', 'hi', 'ta', 'te', 'bn'];
  
  static Map<String, Map<String, String>> _translations = {};
  static String _currentLocale = _defaultLocale;
  
  // Language names for UI display
  static const Map<String, String> languageNames = {
    'en': 'English',
    'hi': 'हिंदी',
    'ta': 'தமிழ்',
    'te': 'తెలుగు',
    'bn': 'বাংলা',
  };
  
  // Medical terminology translations
  static const Map<String, Map<String, String>> medicalTerms = {
    'fever': {
      'en': 'Fever',
      'hi': 'बुखार',
      'ta': 'காய்ச்சல்',
      'te': 'జ్వరం',
      'bn': 'জ্বর',
    },
    'cough': {
      'en': 'Cough',
      'hi': 'खांसी',
      'ta': 'இருமல்',
      'te': 'దగ్గు',
      'bn': 'কাশি',
    },
    'headache': {
      'en': 'Headache',
      'hi': 'सिरदर्द',
      'ta': 'தலைவலி',
      'te': 'తలనొప్పి',
      'bn': 'মাথাব্যথা',
    },
    'fatigue': {
      'en': 'Fatigue',
      'hi': 'थकान',
      'ta': 'சோர்வு',
      'te': 'అలసట',
      'bn': 'ক্লান্তি',
    },
    'nausea': {
      'en': 'Nausea',
      'hi': 'मतली',
      'ta': 'குமட்டல்',
      'te': 'వాంతులు',
      'bn': 'বমি বমি ভাব',
    },
    'sore_throat': {
      'en': 'Sore Throat',
      'hi': 'गले में खराश',
      'ta': 'தொண்டை வலி',
      'te': 'గొంతు నొప్పి',
      'bn': 'গলা ব্যথা',
    },
    'body_aches': {
      'en': 'Body Aches',
      'hi': 'शरीर में दर्द',
      'ta': 'உடல் வலி',
      'te': 'శరీర నొప్పులు',
      'bn': 'শরীর ব্যথা',
    },
    'runny_nose': {
      'en': 'Runny Nose',
      'hi': 'नाक बहना',
      'ta': 'மூக்கு ஒழுகுதல்',
      'te': 'ముక్కు కారుట',
      'bn': 'নাক দিয়ে পানি পড়া',
    },
    'chest_pain': {
      'en': 'Chest Pain',
      'hi': 'छाती में दर्द',
      'ta': 'மார்பு வலி',
      'te': 'ఛాతీ నొప্পি',
      'bn': 'বুকে ব্যথা',
    },
    'dizziness': {
      'en': 'Dizziness',
      'hi': 'चक्कर आना',
      'ta': 'தலைசுற்றல்',
      'te': 'తలతిరుగుట',
      'bn': 'মাথা ঘোরা',
    },
    'vomiting': {
      'en': 'Vomiting',
      'hi': 'उल्टी',
      'ta': 'வாந்தி',
      'te': 'వాంతులు',
      'bn': 'বমি',
    },
    'diarrhea': {
      'en': 'Diarrhea',
      'hi': 'दस्त',
      'ta': 'வயிற்றுப்போக்கு',
      'te': 'అతిసారం',
      'bn': 'ডায়রিয়া',
    },
    'shortness_of_breath': {
      'en': 'Shortness of Breath',
      'hi': 'सांस लेने में कठिनाई',
      'ta': 'மூச்சுத் திணறல்',
      'te': 'ఊపిరాడక',
      'bn': 'শ্বাসকষ্ট',
    },
    'loss_of_taste': {
      'en': 'Loss of Taste',
      'hi': 'स्वाद का न आना',
      'ta': 'சுவை இழப்பு',
      'te': 'రుచి పోవుట',
      'bn': 'স্বাদ হারানো',
    },
    'loss_of_smell': {
      'en': 'Loss of Smell',
      'hi': 'गंध का न आना',
      'ta': 'வாசனை இழப்பு',
      'te': 'వాసన పోవుట',
      'bn': 'গন্ধ হারানো',
    },
  };
  
  // Severity levels
  static const Map<String, Map<String, String>> severityLevels = {
    'mild': {
      'en': 'Mild',
      'hi': 'हल्का',
      'ta': 'லேசான',
      'te': 'తేలికైన',
      'bn': 'হালকা',
    },
    'moderate': {
      'en': 'Moderate',
      'hi': 'मध्यम',
      'ta': 'மிதமான',
      'te': 'మధ్యస్థ',
      'bn': 'মাঝারি',
    },
    'severe': {
      'en': 'Severe',
      'hi': 'गंभीर',
      'ta': 'கடுமையான',
      'te': 'తీవ్రమైన',
      'bn': 'গুরুতর',
    },
  };
  
  // Common UI strings
  static const Map<String, Map<String, String>> uiStrings = {
    'symptom_checker': {
      'en': 'Symptom Checker',
      'hi': 'लक्षण जांचकर्ता',
      'ta': 'அறிகுறி சரிபார்ப்பு',
      'te': 'లక్షణ తనిఖీ',
      'bn': 'উপসর্গ পরীক্ষক',
    },
    'describe_symptoms': {
      'en': 'Describe Your Symptoms',
      'hi': 'अपने लक्षणों का वर्णन करें',
      'ta': 'உங்கள் அறிகுறிகளை விவரிக்கவும்',
      'te': 'మీ లక్షణాలను వివరించండి',
      'bn': 'আপনার উপসর্গগুলি বর্ণনা করুন',
    },
    'analyze_symptoms': {
      'en': 'Analyze Symptoms with AI',
      'hi': 'AI के साथ लक्षणों का विश्लेषण करें',
      'ta': 'AI உடன் அறிகுறிகளை பகுப்பாய்வு செய்யுங்கள்',
      'te': 'AI తో లక్షణాలను విశ్లేషించండి',
      'bn': 'AI দিয়ে উপসর্গ বিশ্লেষণ করুন',
    },
    'ai_analysis_results': {
      'en': 'AI Analysis Results',
      'hi': 'AI विश्लेषण परिणाम',
      'ta': 'AI பகுப்பாய்வு முடிவுகள்',
      'te': 'AI విశ్లేషణ ఫలితాలు',
      'bn': 'AI বিশ্লেষণের ফলাফল',
    },
    'recommended_actions': {
      'en': 'Recommended Actions',
      'hi': 'अनुशंसित कार्य',
      'ta': 'பரிந்துரைக்கப்பட்ட நடவடிக்கைகள்',
      'te': 'సిఫార్సు చేయబడిన చర్యలు',
      'bn': 'প্রস্তাবিত পদক্ষেপ',
    },
    'when_to_seek_help': {
      'en': 'When to Seek Medical Help',
      'hi': 'कब चिकित्सा सहायता लें',
      'ta': 'எப்போது மருத்துவ உதவி பெறுவது',
      'te': 'ఎప్పుడు వైద్య సహాయం తీసుకోవాలి',
      'bn': 'কখন চিকিৎসা সহায়তা নিতে হবে',
    },
    'emergency': {
      'en': 'Emergency',
      'hi': 'आपातकाल',
      'ta': 'அவசரநிலை',
      'te': 'అత్యవసర',
      'bn': 'জরুরি',
    },
    'appointments': {
      'en': 'Appointments',
      'hi': 'नियुक्तियां',
      'ta': 'சந்திப்புகள்',
      'te': 'అపాయింట్‌మెంట్లు',
      'bn': 'অ্যাপয়েন্টমেন্ট',
    },
    'vault': {
      'en': 'Medical Vault',
      'hi': 'चिकित्सा तिजोरी',
      'ta': 'மருத்துவ பெட்டகம்',
      'te': 'వైద్య ఖజానా',
      'bn': 'চিকিৎসা ভল্ট',
    },
    'ai_insights': {
      'en': 'AI Insights',
      'hi': 'AI अंतर्दृष्टि',
      'ta': 'AI நுண்ணறிவு',
      'te': 'AI అంతర్దృష్టి',
      'bn': 'AI অন্তর্দৃষ্টি',
    },
    'voice_input': {
      'en': 'Voice Input',
      'hi': 'आवाज इनपुट',
      'ta': 'குரல் உள்ளீடு',
      'te': 'వాయిస్ ఇన్‌పుట్',
      'bn': 'ভয়েস ইনপুট',
    },
    'listening': {
      'en': 'Listening...',
      'hi': 'सुन रहा है...',
      'ta': 'கேட்டுக்கொண்டிருக்கிறது...',
      'te': 'వింటున్నది...',
      'bn': 'শুনছে...',
    },
    'confidence': {
      'en': 'Confidence',
      'hi': 'विश्वास',
      'ta': 'நம்பிக்கை',
      'te': 'విశ్వాసం',
      'bn': 'আত্মবিশ্বাস',
    },
    'treatment_protocols': {
      'en': 'Treatment Protocols',
      'hi': 'उपचार प्रोटोकॉल',
      'ta': 'சிகிச்சை நெறிமுறைகள்',
      'te': 'చికిత్స ప్రోటోకాల్స్',
      'bn': 'চিকিৎসা প্রোটোকল',
    },
    'specialist_referral': {
      'en': 'Specialist Referral',
      'hi': 'विशेषज्ञ रेफरल',
      'ta': 'நிபுணர் பரிந்துரை',
      'te': 'స్పెషలిస్ట్ రెఫరల్',
      'bn': 'বিশেষজ্ঞ রেফারেল',
    },
    'drug_interactions': {
      'en': 'Drug Interactions',
      'hi': 'दवा परस्पर क्रिया',
      'ta': 'மருந்து தொடர்புகள்',
      'te': 'ఔషధ పరస్పర చర్యలు',
      'bn': 'ওষুধের মিথস্ক্রিয়া',
    },
    'dosage_recommendations': {
      'en': 'Dosage Recommendations',
      'hi': 'खुराक की सिफारिशें',
      'ta': 'அளவு பரிந்துரைகள்',
      'te': 'మోతాదు సిఫార్సులు',
      'bn': 'ডোজ সুপারিশ',
    },
  };
  
  // Common medical conditions
  static const Map<String, Map<String, String>> conditions = {
    'common_cold': {
      'en': 'Common Cold',
      'hi': 'सामान्य सर्दी',
      'ta': 'பொதுவான சளி',
      'te': 'సాధారణ జలుబు',
      'bn': 'সাধারণ সর্দি',
    },
    'flu': {
      'en': 'Flu',
      'hi': 'फ्लू',
      'ta': 'காய்ச்சல்',
      'te': 'ఫ్లూ',
      'bn': 'ফ্লু',
    },
    'covid19': {
      'en': 'COVID-19',
      'hi': 'कोविड-19',
      'ta': 'கோவிட்-19',
      'te': 'కోవిడ్-19',
      'bn': 'কোভিড-১৯',
    },
    'gastroenteritis': {
      'en': 'Gastroenteritis',
      'hi': 'गैस्ट्रोएंटेराइटिस',
      'ta': 'வயிற்றுப்போக்கு',
      'te': 'గ్యాస్ట్రోఎంటెరైటిస్',
      'bn': 'গ্যাস্ট্রোএন্টেরাইটিস',
    },
    'hypertension': {
      'en': 'Hypertension',
      'hi': 'उच्च रक्तचाप',
      'ta': 'உயர் இரத்த அழுத்தம்',
      'te': 'అధిక రక్తపోటు',
      'bn': 'উচ্চ রক্তচাপ',
    },
    'diabetes': {
      'en': 'Diabetes',
      'hi': 'मधुमेह',
      'ta': 'நீரிழிவு',
      'te': 'మధుమేహం',
      'bn': 'ডায়াবেটিস',
    },
    'asthma': {
      'en': 'Asthma',
      'hi': 'दमा',
      'ta': 'ஆஸ்துமா',
      'te': 'ఆస్తమా',
      'bn': 'হাঁপানি',
    },
    'migraine': {
      'en': 'Migraine',
      'hi': 'माइग्रेन',
      'ta': 'ஒற்றைத் தலைவலி',
      'te': 'మైగ్రేన్',
      'bn': 'মাইগ্রেন',
    },
  };
  
  static Future<void> initialize() async {
    await _loadSavedLocale();
    await _loadTranslations();
  }
  
  static Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _currentLocale = prefs.getString('selected_locale') ?? _defaultLocale;
    } catch (e) {
      print('Error loading saved locale: $e');
      _currentLocale = _defaultLocale;
    }
  }
  
  static Future<void> _loadTranslations() async {
    for (String locale in _supportedLocales) {
      try {
        final String jsonString = await rootBundle.loadString('assets/translations/$locale.json');
        final Map<String, dynamic> jsonMap = json.decode(jsonString);
        _translations[locale] = Map<String, String>.from(jsonMap);
      } catch (e) {
        print('Error loading translations for $locale: $e');
        // Fallback to hardcoded translations
        _translations[locale] = _getHardcodedTranslations(locale);
      }
    }
  }
  
  static Map<String, String> _getHardcodedTranslations(String locale) {
    Map<String, String> translations = {};
    
    // Add all UI strings
    uiStrings.forEach((key, value) {
      translations[key] = value[locale] ?? value['en'] ?? key;
    });
    
    // Add medical terms
    medicalTerms.forEach((key, value) {
      translations[key] = value[locale] ?? value['en'] ?? key;
    });
    
    // Add severity levels
    severityLevels.forEach((key, value) {
      translations[key] = value[locale] ?? value['en'] ?? key;
    });
    
    // Add conditions
    conditions.forEach((key, value) {
      translations[key] = value[locale] ?? value['en'] ?? key;
    });
    
    return translations;
  }
  
  static String get currentLocale => _currentLocale;
  
  static List<String> get supportedLocales => _supportedLocales;
  
  static Future<void> setLocale(String locale) async {
    if (_supportedLocales.contains(locale)) {
      _currentLocale = locale;
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('selected_locale', locale);
      } catch (e) {
        print('Error saving locale: $e');
      }
    }
  }
  
  static String translate(String key, {String? locale}) {
    final targetLocale = locale ?? _currentLocale;
    return _translations[targetLocale]?[key] ?? 
           _translations[_defaultLocale]?[key] ?? 
           key;
  }
  
  static String translateMedicalTerm(String term, {String? locale}) {
    final targetLocale = locale ?? _currentLocale;
    return medicalTerms[term]?[targetLocale] ?? 
           medicalTerms[term]?[_defaultLocale] ?? 
           term;
  }
  
  static String translateSeverity(String severity, {String? locale}) {
    final targetLocale = locale ?? _currentLocale;
    return severityLevels[severity.toLowerCase()]?[targetLocale] ?? 
           severityLevels[severity.toLowerCase()]?[_defaultLocale] ?? 
           severity;
  }
  
  static String translateCondition(String condition, {String? locale}) {
    final targetLocale = locale ?? _currentLocale;
    return conditions[condition.toLowerCase()]?[targetLocale] ?? 
           conditions[condition.toLowerCase()]?[_defaultLocale] ?? 
           condition;
  }
  
  static List<String> translateSymptomList(List<String> symptoms, {String? locale}) {
    return symptoms.map((symptom) => translateMedicalTerm(symptom.toLowerCase().replaceAll(' ', '_'), locale: locale)).toList();
  }
  
  static String getLanguageName(String locale) {
    return languageNames[locale] ?? locale;
  }
  
  static bool isRTL(String locale) {
    // None of our supported languages are RTL, but this method is here for future expansion
    return false;
  }
  
  // Helper method to get localized symptom options for UI
  static List<String> getLocalizedSymptomOptions({String? locale}) {
    final targetLocale = locale ?? _currentLocale;
    return medicalTerms.keys.map((key) => 
      medicalTerms[key]?[targetLocale] ?? 
      medicalTerms[key]?[_defaultLocale] ?? 
      key
    ).toList();
  }
  
  // Helper method to get original symptom key from localized text
  static String getSymptomKey(String localizedSymptom) {
    for (String key in medicalTerms.keys) {
      for (String locale in _supportedLocales) {
        if (medicalTerms[key]?[locale] == localizedSymptom) {
          return key;
        }
      }
    }
    return localizedSymptom;
  }
  
  // Method to translate AI response text (placeholder for future ML translation)
  static Future<String> translateAIResponse(String text, {String? targetLocale}) async {
    final locale = targetLocale ?? _currentLocale;
    
    if (locale == 'en') {
      return text;
    }
    
    // Placeholder for actual translation service
    // In a real implementation, this would call a translation API or local ML model
    return "[$locale] $text";
  }
  
  // Method to get voice recognition locale code
  static String getVoiceLocaleCode(String locale) {
    switch (locale) {
      case 'hi':
        return 'hi_IN';
      case 'ta':
        return 'ta_IN';
      case 'te':
        return 'te_IN';
      case 'bn':
        return 'bn_IN';
      default:
        return 'en_US';
    }
  }
}
