// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'আরোগ্য AI';

  @override
  String get home => 'হোম';

  @override
  String get profile => 'প্রোফাইল';

  @override
  String get settings => 'সেটিংস';

  @override
  String get vault => 'মেডিকেল ভল্ট';

  @override
  String get insurance => 'বীমা';

  @override
  String get symptomChecker => 'লক্ষণ পরীক্ষক';

  @override
  String get aiRecommendations => 'AI সুপারিশ';

  @override
  String get appointments => 'অ্যাপয়েন্টমেন্ট';

  @override
  String get medications => 'ওষুধ';

  @override
  String get emergencyContacts => 'জরুরি যোগাযোগ';

  @override
  String get welcomeBack => 'আবার স্বাগতম,';

  @override
  String get accountInformation => 'অ্যাকাউন্ট তথ্য';

  @override
  String get accountStatus => 'অ্যাকাউন্ট স্ট্যাটাস';

  @override
  String get active => 'সক্রিয়';

  @override
  String get security => 'নিরাপত্তা';

  @override
  String get passwordProtected => 'পাসওয়ার্ড সুরক্ষিত';

  @override
  String get lastLogin => 'শেষ লগইন';

  @override
  String get today => 'আজ';

  @override
  String get dataStorage => 'ডেটা স্টোরেজ';

  @override
  String get localDevice => 'স্থানীয় ডিভাইস';

  @override
  String get language => 'ভাষা';

  @override
  String get selectLanguage => 'ভাষা নির্বাচন করুন';

  @override
  String get english => 'English (ইংরেজি)';

  @override
  String get hindi => 'हिन्दी (হিন্দি)';

  @override
  String get tamil => 'தமிழ் (তামিল)';

  @override
  String get telugu => 'తెలుగు (তেলুগু)';

  @override
  String get bengali => 'বাংলা';

  @override
  String get describeSymptoms => 'আপনার লক্ষণগুলি বর্ণনা করুন';

  @override
  String get quickSelectSymptoms => 'দ্রুত লক্ষণ নির্বাচন:';

  @override
  String get analyzeSymptomsWithAI => 'AI দিয়ে লক্ষণ বিশ্লেষণ করুন';

  @override
  String get analyzingWithGemma => 'Gemma 3 দিয়ে বিশ্লেষণ করছে...';

  @override
  String get enterVitalsOptional => 'আপনার ভাইটাল এন্টার করুন (ঐচ্ছিক)';

  @override
  String get temperature => 'তাপমাত্রা (°F)';

  @override
  String get bloodPressure => 'রক্তচাপ';

  @override
  String get heartRate => 'হৃদস্পন্দন (bpm)';

  @override
  String get emergencyActions => 'জরুরি পদক্ষেপ';

  @override
  String get emergency => 'জরুরি অবস্থা';

  @override
  String get callDoctor => 'ডাক্তারকে কল করুন';

  @override
  String get searchDocuments => 'নথি খুঁজুন...';

  @override
  String get uploadDocument => 'নথি আপলোড করুন';

  @override
  String get documentUploaded => 'নথি সফলভাবে আপলোড হয়েছে';

  @override
  String errorProcessingDocument(String error) {
    return 'নথি প্রক্রিয়াকরণে ত্রুটি: $error';
  }

  @override
  String get aiHealthRecommendations => 'AI স্বাস্থ্য সুপারিশ';

  @override
  String get errorLoadingRecommendations => 'সুপারিশ লোড করতে ত্রুটি';

  @override
  String get retry => 'আবার চেষ্টা করুন';

  @override
  String get dailyHealthTips => 'দৈনিক স্বাস্থ্য টিপস';

  @override
  String get stayHydrated => 'হাইড্রেটেড থাকুন';

  @override
  String get takeShortBreaks => 'ছোট বিরতি নিন';

  @override
  String get getEnoughSleep => 'পর্যাপ্ত ঘুম পান';

  @override
  String get exerciseRegularly => 'নিয়মিত ব্যায়াম করুন';

  @override
  String get speakNow => 'এখন বলুন...';

  @override
  String listeningForSpeech(String language) {
    return '$language এ কথা শুনছে';
  }

  @override
  String speechRecognitionError(String error) {
    return 'বক্তৃতা চিনতে ত্রুটি: $error';
  }

  @override
  String get translating => 'অনুবাদ করছে...';

  @override
  String get translationComplete => 'অনুবাদ সম্পূর্ণ';

  @override
  String get addMedication => 'ওষুধ যোগ করুন';

  @override
  String get medicationName => 'ওষুধের নাম';

  @override
  String get dosage => 'ডোজ';

  @override
  String get frequency => 'ফ্রিকোয়েন্সি';

  @override
  String get startDate => 'শুরুর তারিখ';

  @override
  String get endDate => 'শেষের তারিখ';

  @override
  String get notes => 'নোট';

  @override
  String get medicationAdded => 'ওষুধ সফলভাবে যোগ করা হয়েছে';

  @override
  String get medicationUpdated => 'ওষুধ সফলভাবে আপডেট করা হয়েছে';

  @override
  String get medicationDeleted => 'ওষুধ সফলভাবে মুছে ফেলা হয়েছে';

  @override
  String get deleteMedicationConfirm => 'আপনি কি নিশ্চিত যে আপনি এই ওষুধটি মুছে ফেলতে চান?';

  @override
  String get medicationAlerts => 'ওষুধের সতর্কতা';

  @override
  String get timeToTakeMedication => 'ওষুধ খাওয়ার সময়';

  @override
  String get markAsTaken => 'নেওয়া হয়েছে হিসেবে চিহ্নিত করুন';

  @override
  String get snooze => 'স্নুজ';

  @override
  String get skip => 'এড়িয়ে যান';

  @override
  String get scheduleAppointment => 'অ্যাপয়েন্টমেন্ট নির্ধারণ করুন';

  @override
  String get doctorName => 'ডাক্তারের নাম';

  @override
  String get appointmentDate => 'অ্যাপয়েন্টমেন্টের তারিখ';

  @override
  String get appointmentTime => 'অ্যাপয়েন্টমেন্টের সময়';

  @override
  String get appointmentType => 'অ্যাপয়েন্টমেন্টের ধরন';

  @override
  String get appointmentNotes => 'অ্যাপয়েন্টমেন্টের নোট';

  @override
  String get appointmentScheduled => 'অ্যাপয়েন্টমেন্ট সফলভাবে নির্ধারিত হয়েছে';

  @override
  String get appointmentUpdated => 'অ্যাপয়েন্টমেন্ট সফলভাবে আপডেট করা হয়েছে';

  @override
  String get appointmentCancelled => 'অ্যাপয়েন্টমেন্ট বাতিল করা হয়েছে';

  @override
  String get cancelAppointmentConfirm => 'আপনি কি নিশ্চিত যে আপনি এই অ্যাপয়েন্টমেন্টটি বাতিল করতে চান?';

  @override
  String get upcomingAppointments => 'আসন্ন অ্যাপয়েন্টমেন্ট';

  @override
  String get pastAppointments => 'পূর্ববর্তী অ্যাপয়েন্টমেন্ট';

  @override
  String get noAppointments => 'কোনো অ্যাপয়েন্টমেন্ট নির্ধারিত নেই';

  @override
  String get changePassword => 'Change Password';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmPassword => 'Confirm New Password';

  @override
  String get passwordChanged => 'Password changed successfully';

  @override
  String get passwordMismatch => 'Passwords do not match';

  @override
  String get invalidCurrentPassword => 'Current password is incorrect';

  @override
  String get passwordTooShort => 'Password must be at least 8 characters';

  @override
  String get passwordRequirements => 'Password must contain at least one uppercase letter, one lowercase letter, and one number';

  @override
  String get emergencyContactName => 'যোগাযোগের নাম';

  @override
  String get emergencyContactPhone => 'ফোন নম্বর';

  @override
  String get emergencyContactRelation => 'সম্পর্ক';

  @override
  String get addEmergencyContact => 'জরুরি যোগাযোগ যোগ করুন';

  @override
  String get editEmergencyContact => 'জরুরি যোগাযোগ সম্পাদনা করুন';

  @override
  String get deleteEmergencyContact => 'জরুরি যোগাযোগ মুছে ফেলুন';

  @override
  String get emergencyContactAdded => 'জরুরি যোগাযোগ সফলভাবে যোগ করা হয়েছে';

  @override
  String get emergencyContactUpdated => 'জরুরি যোগাযোগ সফলভাবে আপডেট করা হয়েছে';

  @override
  String get emergencyContactDeleted => 'জরুরি যোগাযোগ সফলভাবে মুছে ফেলা হয়েছে';

  @override
  String get deleteContactConfirm => 'আপনি কি নিশ্চিত যে আপনি এই যোগাযোগটি মুছে ফেলতে চান?';

  @override
  String get callEmergencyContact => 'জরুরি যোগাযোগে কল করুন';

  @override
  String get noEmergencyContacts => 'কোনো জরুরি যোগাযোগ যোগ করা হয়নি';

  @override
  String get healthClaimTracker => 'স্বাস্থ্য দাবি ট্র্যাকার';

  @override
  String get fileNewClaim => 'নতুন দাবি দাখিল করুন';

  @override
  String get claimStatus => 'দাবির অবস্থা';

  @override
  String get policyNumber => 'পলিসি নম্বর';

  @override
  String get hospitalName => 'হাসপাতালের নাম';

  @override
  String get patientName => 'রোগীর নাম';

  @override
  String get admissionDate => 'ভর্তির তারিখ';

  @override
  String get diagnosis => 'রোগ নির্ণয়';

  @override
  String get claimAmount => 'দাবির পরিমাণ';

  @override
  String get documentsRequired => 'প্রয়োজনীয় নথি';

  @override
  String get uploadDocuments => 'নথি আপলোড করুন';

  @override
  String get claimSubmitted => 'দাবি সফলভাবে জমা দেওয়া হয়েছে';

  @override
  String get claimUpdated => 'দাবি সফলভাবে আপডেট করা হয়েছে';

  @override
  String get claimApproved => 'দাবি অনুমোদিত';

  @override
  String get claimRejected => 'দাবি প্রত্যাখ্যাত';

  @override
  String get claimPending => 'দাবি অপেক্ষমাণ';

  @override
  String get documentsNeeded => 'নথি প্রয়োজন';

  @override
  String get noClaims => 'কোনো দাবি পাওয়া যায়নি';

  @override
  String languageChanged(String language) {
    return 'Language changed to $language';
  }

  @override
  String get testSpeechRecognition => 'Test Speech Recognition';

  @override
  String get speakInSelectedLanguage => 'Speak in the selected language to test';

  @override
  String get speechTestSuccessful => 'Speech recognition test successful';

  @override
  String get speechTestFailed => 'Speech recognition test failed';

  @override
  String get scanMedication => 'Scan Medication';

  @override
  String get scanPrescription => 'Scan Prescription';

  @override
  String get medicationScanned => 'Medication scanned successfully';

  @override
  String get prescriptionScanned => 'Prescription scanned successfully';

  @override
  String scanningError(String error) {
    return 'Error scanning: $error';
  }

  @override
  String get ocrProcessing => 'Processing image...';

  @override
  String get ocrComplete => 'Text extraction complete';

  @override
  String get scheduleMeeting => 'Schedule Meeting';

  @override
  String get meetingTitle => 'Meeting Title';

  @override
  String get meetingDate => 'Meeting Date';

  @override
  String get meetingTime => 'Meeting Time';

  @override
  String get meetingLocation => 'Meeting Location';

  @override
  String get meetingNotes => 'Meeting Notes';

  @override
  String get meetingScheduled => 'Meeting scheduled successfully';

  @override
  String get meetingUpdated => 'Meeting updated successfully';

  @override
  String get meetingCancelled => 'Meeting cancelled';

  @override
  String get upcomingMeetings => 'Upcoming Meetings';

  @override
  String get pastMeetings => 'Past Meetings';

  @override
  String get noMeetings => 'No meetings scheduled';

  @override
  String get personalInformation => 'ব্যক্তিগত তথ্য';

  @override
  String get fullName => 'পূর্ণ নাম';

  @override
  String get email => 'ইমেইল';

  @override
  String get phoneNumber => 'ফোন নম্বর';

  @override
  String get dateOfBirth => 'জন্ম তারিখ';

  @override
  String get gender => 'লিঙ্গ';

  @override
  String get bloodGroup => 'রক্তের গ্রুপ';

  @override
  String get allergies => 'অ্যালার্জি';

  @override
  String get medicalHistory => 'চিকিৎসা ইতিহাস';

  @override
  String get profileUpdated => 'প্রোফাইল সফলভাবে আপডেট করা হয়েছে';

  @override
  String get profileUpdateError => 'প্রোফাইল আপডেট করতে ত্রুটি';

  @override
  String get healthSummary => 'Health Summary';

  @override
  String get lastCheckup => 'Last Checkup';

  @override
  String get aiHealthScore => 'AI Health Score';

  @override
  String get upcomingAppointmentsCount => 'Upcoming Appointments';

  @override
  String get alerts => 'Alerts';

  @override
  String get noDataAvailable => 'No data available';

  @override
  String get completeSymptomCheck => 'Complete a symptom check';

  @override
  String get noCheckupsRecorded => 'No checkups recorded';

  @override
  String activeMedications(int count) {
    return '$count active medications';
  }

  @override
  String get fever => 'জ্বর';

  @override
  String get cough => 'কাশি';

  @override
  String get headache => 'মাথাব্যথা';

  @override
  String get nausea => 'বমি বমি ভাব';

  @override
  String get fatigue => 'ক্লান্তি';

  @override
  String get bodyAche => 'শরীর ব্যথা';

  @override
  String get soreThroat => 'গলা ব্যথা';

  @override
  String get runnyNose => 'নাক দিয়ে পানি পড়া';

  @override
  String get dizziness => 'মাথা ঘোরা';

  @override
  String get chestPain => 'বুকে ব্যথা';

  @override
  String get shortnessOfBreath => 'শ্বাসকষ্ট';

  @override
  String get stomachPain => 'পেট ব্যথা';

  @override
  String get mild => 'হালকা';

  @override
  String get moderate => 'মাঝারি';

  @override
  String get severe => 'গুরুতর';

  @override
  String get critical => 'অত্যন্ত গুরুতর';

  @override
  String get male => 'পুরুষ';

  @override
  String get female => 'মহিলা';

  @override
  String get other => 'অন্যান্য';

  @override
  String get preferNotToSay => 'বলতে চাই না';

  @override
  String get daily => 'দৈনিক';

  @override
  String get twiceDaily => 'দিনে দুইবার';

  @override
  String get threeTimesDaily => 'দিনে তিনবার';

  @override
  String get weekly => 'সাপ্তাহিক';

  @override
  String get asNeeded => 'প্রয়োজন অনুযায়ী';

  @override
  String get consultation => 'Consultation';

  @override
  String get followUp => 'Follow-up';

  @override
  String get checkup => 'Check-up';

  @override
  String get vaccination => 'Vaccination';

  @override
  String get labTest => 'Lab Test';

  @override
  String get required => 'প্রয়োজনীয়';

  @override
  String get optional => 'ঐচ্ছিক';

  @override
  String get pleaseEnterValue => 'অনুগ্রহ করে একটি মান লিখুন';

  @override
  String get pleaseSelectDate => 'অনুগ্রহ করে একটি তারিখ নির্বাচন করুন';

  @override
  String get pleaseSelectTime => 'অনুগ্রহ করে একটি সময় নির্বাচন করুন';

  @override
  String get invalidEmail => 'অনুগ্রহ করে একটি বৈধ ইমেইল লিখুন';

  @override
  String get invalidPhone => 'অনুগ্রহ করে একটি বৈধ ফোন নম্বর লিখুন';

  @override
  String get fieldRequired => 'এই ক্ষেত্রটি প্রয়োজনীয়';

  @override
  String get camera => 'ক্যামেরা';

  @override
  String get gallery => 'গ্যালারি';

  @override
  String get chooseUploadMethod => 'আপলোড পদ্ধতি নির্বাচন করুন';

  @override
  String get imageSelected => 'Image selected';

  @override
  String get imageUploadError => 'Error uploading image';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get cameraPermissionRequired => 'Camera permission is required';

  @override
  String get storagePermissionRequired => 'Storage permission is required';

  @override
  String get save => 'সেভ করুন';

  @override
  String get cancel => 'বাতিল করুন';

  @override
  String get delete => 'মুছে ফেলুন';

  @override
  String get edit => 'সম্পাদনা করুন';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get ok => 'ঠিক আছে';

  @override
  String get yes => 'হ্যাঁ';

  @override
  String get no => 'না';

  @override
  String get loading => 'লোড হচ্ছে...';

  @override
  String get error => 'ত্রুটি';

  @override
  String get success => 'সফল';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Information';

  @override
  String get confirm => 'Confirm';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get submit => 'Submit';

  @override
  String get update => 'Update';

  @override
  String get add => 'Add';

  @override
  String get remove => 'Remove';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get refresh => 'Refresh';

  @override
  String get share => 'Share';

  @override
  String get export => 'Export';

  @override
  String get import => 'Import';

  @override
  String get print => 'Print';

  @override
  String get copy => 'Copy';

  @override
  String get paste => 'Paste';

  @override
  String get cut => 'Cut';

  @override
  String get undo => 'Undo';

  @override
  String get redo => 'Redo';

  @override
  String get selectAll => 'Select All';

  @override
  String get clear => 'Clear';

  @override
  String get reset => 'Reset';

  @override
  String get logout => 'লগআউট';

  @override
  String get logoutConfirmation => 'আপনি কি নিশ্চিত যে আপনি লগআউট করতে চান?';

  @override
  String get loggedOutSuccessfully => 'সফলভাবে লগআউট হয়েছে';

  @override
  String logoutError(String error) {
    return 'লগআউট ত্রুটি: $error';
  }

  @override
  String get networkError => 'Network error. Please check your connection.';

  @override
  String get serverError => 'Server error. Please try again later.';

  @override
  String get unknownError => 'An unknown error occurred';

  @override
  String get timeoutError => 'Request timeout. Please try again.';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get connectionRestored => 'Connection restored';

  @override
  String get morning => 'Morning';

  @override
  String get afternoon => 'Afternoon';

  @override
  String get evening => 'Evening';

  @override
  String get night => 'Night';

  @override
  String get beforeMeals => 'Before Meals';

  @override
  String get afterMeals => 'After Meals';

  @override
  String get withMeals => 'With Meals';

  @override
  String get onEmptyStomach => 'On Empty Stomach';

  @override
  String get tablet => 'Tablet';

  @override
  String get capsule => 'Capsule';

  @override
  String get syrup => 'Syrup';

  @override
  String get injection => 'Injection';

  @override
  String get drops => 'Drops';

  @override
  String get cream => 'Cream';

  @override
  String get ointment => 'Ointment';

  @override
  String get inhaler => 'Inhaler';

  @override
  String get mg => 'mg';

  @override
  String get ml => 'ml';

  @override
  String get units => 'units';

  @override
  String get puffs => 'puffs';

  @override
  String get viewAll => 'View All';

  @override
  String get viewLess => 'View Less';

  @override
  String get showMore => 'Show More';

  @override
  String get showLess => 'Show Less';

  @override
  String get seeAll => 'See All';

  @override
  String get collapse => 'Collapse';

  @override
  String get expand => 'Expand';
}
