// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'आरोग्य एआई';

  @override
  String get home => 'होम';

  @override
  String get profile => 'प्रोफाइल';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get vault => 'मेडिकल वॉल्ट';

  @override
  String get insurance => 'बीमा';

  @override
  String get symptomChecker => 'लक्षण जांचकर्ता';

  @override
  String get aiRecommendations => 'एआई सिफारिशें';

  @override
  String get appointments => 'अपॉइंटमेंट्स';

  @override
  String get medications => 'दवाइयां';

  @override
  String get emergencyContacts => 'आपातकालीन संपर्क';

  @override
  String get welcomeBack => 'वापस स्वागत है';

  @override
  String get accountInformation => 'खाता जानकारी';

  @override
  String get accountStatus => 'खाता स्थिति';

  @override
  String get active => 'सक्रिय';

  @override
  String get security => 'सुरक्षा';

  @override
  String get passwordProtected => 'पासवर्ड संरक्षित';

  @override
  String get lastLogin => 'अंतिम लॉगिन';

  @override
  String get today => 'आज';

  @override
  String get dataStorage => 'डेटा भंडारण';

  @override
  String get localDevice => 'स्थानीय डिवाइस';

  @override
  String get language => 'भाषा';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String get english => 'English (अंग्रेजी)';

  @override
  String get hindi => 'हिन्दी';

  @override
  String get tamil => 'தமிழ் (तमिल)';

  @override
  String get telugu => 'తెలుగు (तेलुगु)';

  @override
  String get bengali => 'বাংলা (बंगाली)';

  @override
  String get describeSymptoms => 'अपने लक्षणों का वर्णन करें';

  @override
  String get quickSelectSymptoms => 'त्वरित लक्षण चयन:';

  @override
  String get analyzeSymptomsWithAI => 'एआई के साथ लक्षणों का विश्लेषण करें';

  @override
  String get analyzingWithGemma => 'जेम्मा 3 के साथ विश्लेषण कर रहे हैं...';

  @override
  String get enterVitalsOptional => 'अपने वाइटल्स दर्ज करें (वैकल्पिक)';

  @override
  String get temperature => 'तापमान (°F)';

  @override
  String get bloodPressure => 'रक्तचाप';

  @override
  String get heartRate => 'हृदय गति (bpm)';

  @override
  String get emergencyActions => 'आपातकालीन कार्य';

  @override
  String get emergency => 'आपातकाल';

  @override
  String get callDoctor => 'डॉक्टर को कॉल करें';

  @override
  String get searchDocuments => 'दस्तावेज़ खोजें...';

  @override
  String get uploadDocument => 'दस्तावेज़ अपलोड करें';

  @override
  String get documentUploaded => 'दस्तावेज़ सफलतापूर्वक अपलोड किया गया';

  @override
  String errorProcessingDocument(String error) {
    return 'दस्तावेज़ प्रसंस्करण में त्रुटि: $error';
  }

  @override
  String get aiHealthRecommendations => 'एआई स्वास्थ्य सिफारिशें';

  @override
  String get errorLoadingRecommendations => 'सिफारिशें लोड करने में त्रुटि';

  @override
  String get retry => 'पुनः प्रयास करें';

  @override
  String get dailyHealthTips => 'दैनिक स्वास्थ्य सुझाव';

  @override
  String get stayHydrated => 'हाइड्रेटेड रहें';

  @override
  String get takeShortBreaks => 'छोटे ब्रेक लें';

  @override
  String get getEnoughSleep => 'पर्याप्त नींद लें';

  @override
  String get exerciseRegularly => 'नियमित व्यायाम करें';

  @override
  String get speakNow => 'अब बोलें...';

  @override
  String listeningForSpeech(String language) {
    return '$language में भाषण सुन रहे हैं';
  }

  @override
  String speechRecognitionError(String error) {
    return 'भाषण पहचान त्रुटि: $error';
  }

  @override
  String get translating => 'अनुवाद कर रहे हैं...';

  @override
  String get translationComplete => 'अनुवाद पूर्ण';

  @override
  String get addMedication => 'दवा जोड़ें';

  @override
  String get medicationName => 'दवा का नाम';

  @override
  String get dosage => 'खुराक';

  @override
  String get frequency => 'आवृत्ति';

  @override
  String get startDate => 'शुरुआती तारीख';

  @override
  String get endDate => 'समाप्ति तारीख';

  @override
  String get notes => 'नोट्स';

  @override
  String get medicationAdded => 'दवा सफलतापूर्वक जोड़ी गई';

  @override
  String get medicationUpdated => 'दवा सफलतापूर्वक अपडेट की गई';

  @override
  String get medicationDeleted => 'दवा सफलतापूर्वक हटाई गई';

  @override
  String get deleteMedicationConfirm => 'क्या आप वाकई इस दवा को हटाना चाहते हैं?';

  @override
  String get medicationAlerts => 'दवा अलर्ट';

  @override
  String get timeToTakeMedication => 'दवा लेने का समय';

  @override
  String get markAsTaken => 'लिया गया के रूप में चिह्नित करें';

  @override
  String get snooze => 'स्नूज़';

  @override
  String get skip => 'छोड़ें';

  @override
  String get scheduleAppointment => 'अपॉइंटमेंट शेड्यूल करें';

  @override
  String get doctorName => 'डॉक्टर का नाम';

  @override
  String get appointmentDate => 'अपॉइंटमेंट की तारीख';

  @override
  String get appointmentTime => 'अपॉइंटमेंट का समय';

  @override
  String get appointmentType => 'अपॉइंटमेंट का प्रकार';

  @override
  String get appointmentNotes => 'अपॉइंटमेंट नोट्स';

  @override
  String get appointmentScheduled => 'अपॉइंटमेंट सफलतापूर्वक शेड्यूल की गई';

  @override
  String get appointmentUpdated => 'अपॉइंटमेंट सफलतापूर्वक अपडेट की गई';

  @override
  String get appointmentCancelled => 'अपॉइंटमेंट रद्द की गई';

  @override
  String get cancelAppointmentConfirm => 'क्या आप वाकई इस अपॉइंटमेंट को रद्द करना चाहते हैं?';

  @override
  String get upcomingAppointments => 'आगामी अपॉइंटमेंट्स';

  @override
  String get pastAppointments => 'पिछली अपॉइंटमेंट्स';

  @override
  String get noAppointments => 'कोई अपॉइंटमेंट शेड्यूल नहीं की गई';

  @override
  String get changePassword => 'पासवर्ड बदलें';

  @override
  String get currentPassword => 'वर्तमान पासवर्ड';

  @override
  String get newPassword => 'नया पासवर्ड';

  @override
  String get confirmPassword => 'नया पासवर्ड कन्फर्म करें';

  @override
  String get passwordChanged => 'पासवर्ड सफलतापूर्वक बदला गया';

  @override
  String get passwordMismatch => 'पासवर्ड मेल नहीं खाते';

  @override
  String get invalidCurrentPassword => 'वर्तमान पासवर्ड गलत है';

  @override
  String get passwordTooShort => 'पासवर्ड कम से कम 8 अक्षर का होना चाहिए';

  @override
  String get passwordRequirements => 'पासवर्ड में कम से कम एक बड़ा अक्षर, एक छोटा अक्षर और एक संख्या होनी चाहिए';

  @override
  String get emergencyContactName => 'संपर्क नाम';

  @override
  String get emergencyContactPhone => 'फोन नंबर';

  @override
  String get emergencyContactRelation => 'रिश्ता';

  @override
  String get addEmergencyContact => 'आपातकालीन संपर्क जोड़ें';

  @override
  String get editEmergencyContact => 'आपातकालीन संपर्क संपादित करें';

  @override
  String get deleteEmergencyContact => 'आपातकालीन संपर्क हटाएं';

  @override
  String get emergencyContactAdded => 'आपातकालीन संपर्क सफलतापूर्वक जोड़ा गया';

  @override
  String get emergencyContactUpdated => 'आपातकालीन संपर्क सफलतापूर्वक अपडेट किया गया';

  @override
  String get emergencyContactDeleted => 'आपातकालीन संपर्क सफलतापूर्वक हटाया गया';

  @override
  String get deleteContactConfirm => 'क्या आप वाकई इस संपर्क को हटाना चाहते हैं?';

  @override
  String get callEmergencyContact => 'आपातकालीन संपर्क को कॉल करें';

  @override
  String get noEmergencyContacts => 'कोई आपातकालीन संपर्क नहीं जोड़ा गया';

  @override
  String get healthClaimTracker => 'स्वास्थ्य दावा ट्रैकर';

  @override
  String get fileNewClaim => 'नया दावा दर्ज करें';

  @override
  String get claimStatus => 'दावा स्थिति';

  @override
  String get policyNumber => 'पॉलिसी नंबर';

  @override
  String get hospitalName => 'अस्पताल का नाम';

  @override
  String get patientName => 'मरीज़ का नाम';

  @override
  String get admissionDate => 'भर्ती की तारीख';

  @override
  String get diagnosis => 'निदान';

  @override
  String get claimAmount => 'दावा राशि';

  @override
  String get documentsRequired => 'आवश्यक दस्तावेज़';

  @override
  String get uploadDocuments => 'दस्तावेज़ अपलोड करें';

  @override
  String get claimSubmitted => 'दावा सफलतापूर्वक जमा किया गया';

  @override
  String get claimUpdated => 'दावा सफलतापूर्वक अपडेट किया गया';

  @override
  String get claimApproved => 'दावा स्वीकृत';

  @override
  String get claimRejected => 'दावा अस्वीकृत';

  @override
  String get claimPending => 'दावा लंबित';

  @override
  String get documentsNeeded => 'दस्तावेज़ आवश्यक';

  @override
  String get noClaims => 'कोई दावा नहीं मिला';

  @override
  String languageChanged(String language) {
    return 'भाषा $language में बदली गई';
  }

  @override
  String get testSpeechRecognition => 'भाषण पहचान परीक्षण';

  @override
  String get speakInSelectedLanguage => 'चयनित भाषा में बोलकर परीक्षण करें';

  @override
  String get speechTestSuccessful => 'भाषण पहचान परीक्षण सफल';

  @override
  String get speechTestFailed => 'भाषण पहचान परीक्षण असफल';

  @override
  String get scanMedication => 'दवा स्कैन करें';

  @override
  String get scanPrescription => 'प्रिस्क्रिप्शन स्कैन करें';

  @override
  String get medicationScanned => 'दवा सफलतापूर्वक स्कैन की गई';

  @override
  String get prescriptionScanned => 'प्रिस्क्रिप्शन सफलतापूर्वक स्कैन की गई';

  @override
  String scanningError(String error) {
    return 'स्कैनिंग त्रुटि: $error';
  }

  @override
  String get ocrProcessing => 'छवि प्रसंस्करण...';

  @override
  String get ocrComplete => 'टेक्स्ट निष्कर्षण पूर्ण';

  @override
  String get scheduleMeeting => 'मीटिंग शेड्यूल करें';

  @override
  String get meetingTitle => 'मीटिंग शीर्षक';

  @override
  String get meetingDate => 'मीटिंग की तारीख';

  @override
  String get meetingTime => 'मीटिंग का समय';

  @override
  String get meetingLocation => 'मीटिंग स्थान';

  @override
  String get meetingNotes => 'मीटिंग नोट्स';

  @override
  String get meetingScheduled => 'मीटिंग सफलतापूर्वक शेड्यूल की गई';

  @override
  String get meetingUpdated => 'मीटिंग सफलतापूर्वक अपडेट की गई';

  @override
  String get meetingCancelled => 'मीटिंग रद्द की गई';

  @override
  String get upcomingMeetings => 'आगामी मीटिंग्स';

  @override
  String get pastMeetings => 'पिछली मीटिंग्स';

  @override
  String get noMeetings => 'कोई मीटिंग शेड्यूल नहीं की गई';

  @override
  String get personalInformation => 'व्यक्तिगत जानकारी';

  @override
  String get fullName => 'पूरा नाम';

  @override
  String get email => 'ईमेल';

  @override
  String get phoneNumber => 'फोन नंबर';

  @override
  String get dateOfBirth => 'जन्म तिथि';

  @override
  String get gender => 'लिंग';

  @override
  String get bloodGroup => 'रक्त समूह';

  @override
  String get allergies => 'एलर्जी';

  @override
  String get medicalHistory => 'चिकित्सा इतिहास';

  @override
  String get profileUpdated => 'प्रोफाइल सफलतापूर्वक अपडेट की गई';

  @override
  String get profileUpdateError => 'प्रोफाइल अपडेट करने में त्रुटि';

  @override
  String get healthSummary => 'स्वास्थ्य सारांश';

  @override
  String get lastCheckup => 'अंतिम जांच';

  @override
  String get aiHealthScore => 'एआई स्वास्थ्य स्कोर';

  @override
  String get upcomingAppointmentsCount => 'आगामी अपॉइंटमेंट्स';

  @override
  String get alerts => 'अलर्ट';

  @override
  String get noDataAvailable => 'कोई डेटा उपलब्ध नहीं';

  @override
  String get completeSymptomCheck => 'लक्षण जांच पूरी करें';

  @override
  String get noCheckupsRecorded => 'कोई जांच रिकॉर्ड नहीं की गई';

  @override
  String activeMedications(int count) {
    return '$count सक्रिय दवाएं';
  }

  @override
  String get fever => 'बुखार';

  @override
  String get cough => 'खांसी';

  @override
  String get headache => 'सिरदर्द';

  @override
  String get nausea => 'मतली';

  @override
  String get fatigue => 'थकान';

  @override
  String get bodyAche => 'शरीर में दर्द';

  @override
  String get soreThroat => 'गले में खराश';

  @override
  String get runnyNose => 'नाक बहना';

  @override
  String get dizziness => 'चक्कर आना';

  @override
  String get chestPain => 'छाती में दर्द';

  @override
  String get shortnessOfBreath => 'सांस लेने में कठिनाई';

  @override
  String get stomachPain => 'पेट दर्द';

  @override
  String get mild => 'हल्का';

  @override
  String get moderate => 'मध्यम';

  @override
  String get severe => 'गंभीर';

  @override
  String get critical => 'अत्यधिक गंभीर';

  @override
  String get male => 'पुरुष';

  @override
  String get female => 'महिला';

  @override
  String get other => 'अन्य';

  @override
  String get preferNotToSay => 'नहीं बताना चाहते';

  @override
  String get daily => 'दैनिक';

  @override
  String get twiceDaily => 'दिन में दो बार';

  @override
  String get threeTimesDaily => 'दिन में तीन बार';

  @override
  String get weekly => 'साप्ताहिक';

  @override
  String get asNeeded => 'आवश्यकतानुसार';

  @override
  String get consultation => 'परामर्श';

  @override
  String get followUp => 'फॉलो-अप';

  @override
  String get checkup => 'जांच';

  @override
  String get vaccination => 'टीकाकरण';

  @override
  String get labTest => 'लैब टेस्ट';

  @override
  String get required => 'आवश्यक';

  @override
  String get optional => 'वैकल्पिक';

  @override
  String get pleaseEnterValue => 'कृपया एक मान दर्ज करें';

  @override
  String get pleaseSelectDate => 'कृपया एक तारीख चुनें';

  @override
  String get pleaseSelectTime => 'कृपया एक समय चुनें';

  @override
  String get invalidEmail => 'कृपया एक वैध ईमेल दर्ज करें';

  @override
  String get invalidPhone => 'कृपया एक वैध फोन नंबर दर्ज करें';

  @override
  String get fieldRequired => 'यह फील्ड आवश्यक है';

  @override
  String get camera => 'कैमरा';

  @override
  String get gallery => 'गैलरी';

  @override
  String get chooseUploadMethod => 'अपलोड विधि चुनें';

  @override
  String get imageSelected => 'छवि चुनी गई';

  @override
  String get imageUploadError => 'छवि अपलोड करने में त्रुटि';

  @override
  String get permissionDenied => 'अनुमति अस्वीकार';

  @override
  String get cameraPermissionRequired => 'कैमरा अनुमति आवश्यक है';

  @override
  String get storagePermissionRequired => 'स्टोरेज अनुमति आवश्यक है';

  @override
  String get save => 'सेव करें';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'हटाएं';

  @override
  String get edit => 'संपादित करें';

  @override
  String get close => 'बंद करें';

  @override
  String get ok => 'ठीक है';

  @override
  String get yes => 'हां';

  @override
  String get no => 'नहीं';

  @override
  String get loading => 'लोड हो रहा है...';

  @override
  String get error => 'त्रुटि';

  @override
  String get success => 'सफलता';

  @override
  String get warning => 'चेतावनी';

  @override
  String get info => 'जानकारी';

  @override
  String get confirm => 'पुष्टि करें';

  @override
  String get back => 'वापस';

  @override
  String get next => 'अगला';

  @override
  String get done => 'पूर्ण';

  @override
  String get submit => 'जमा करें';

  @override
  String get update => 'अपडेट करें';

  @override
  String get add => 'जोड़ें';

  @override
  String get remove => 'हटाएं';

  @override
  String get search => 'खोजें';

  @override
  String get filter => 'फिल्टर';

  @override
  String get sort => 'क्रमबद्ध करें';

  @override
  String get refresh => 'रिफ्रेश करें';

  @override
  String get share => 'साझा करें';

  @override
  String get export => 'निर्यात करें';

  @override
  String get import => 'आयात करें';

  @override
  String get print => 'प्रिंट करें';

  @override
  String get copy => 'कॉपी करें';

  @override
  String get paste => 'पेस्ट करें';

  @override
  String get cut => 'कट करें';

  @override
  String get undo => 'पूर्ववत करें';

  @override
  String get redo => 'फिर से करें';

  @override
  String get selectAll => 'सभी चुनें';

  @override
  String get clear => 'साफ करें';

  @override
  String get reset => 'रीसेट करें';

  @override
  String get logout => 'लॉगआउट';

  @override
  String get logoutConfirmation => 'क्या आप वाकई लॉगआउट करना चाहते हैं?';

  @override
  String get loggedOutSuccessfully => 'सफलतापूर्वक लॉगआउट हो गए';

  @override
  String logoutError(String error) {
    return 'लॉगआउट त्रुटि: $error';
  }

  @override
  String get networkError => 'नेटवर्क त्रुटि। कृपया अपना कनेक्शन जांचें।';

  @override
  String get serverError => 'सर्वर त्रुटि। कृपया बाद में पुनः प्रयास करें।';

  @override
  String get unknownError => 'एक अज्ञात त्रुटि हुई';

  @override
  String get timeoutError => 'अनुरोध समय समाप्त। कृपया पुनः प्रयास करें।';

  @override
  String get noInternetConnection => 'कोई इंटरनेट कनेक्शन नहीं';

  @override
  String get connectionRestored => 'कनेक्शन बहाल';

  @override
  String get morning => 'सुबह';

  @override
  String get afternoon => 'दोपहर';

  @override
  String get evening => 'शाम';

  @override
  String get night => 'रात';

  @override
  String get beforeMeals => 'खाने से पहले';

  @override
  String get afterMeals => 'खाने के बाद';

  @override
  String get withMeals => 'खाने के साथ';

  @override
  String get onEmptyStomach => 'खाली पेट';

  @override
  String get tablet => 'गोली';

  @override
  String get capsule => 'कैप्सूल';

  @override
  String get syrup => 'सिरप';

  @override
  String get injection => 'इंजेक्शन';

  @override
  String get drops => 'बूंदें';

  @override
  String get cream => 'क्रीम';

  @override
  String get ointment => 'मरहम';

  @override
  String get inhaler => 'इनहेलर';

  @override
  String get mg => 'मिग्रा';

  @override
  String get ml => 'मिली';

  @override
  String get units => 'यूनिट्स';

  @override
  String get puffs => 'पफ्स';

  @override
  String get viewAll => 'सभी देखें';

  @override
  String get viewLess => 'कम देखें';

  @override
  String get showMore => 'और दिखाएं';

  @override
  String get showLess => 'कम दिखाएं';

  @override
  String get seeAll => 'सभी देखें';

  @override
  String get collapse => 'संक्षिप्त करें';

  @override
  String get expand => 'विस्तार करें';
}
