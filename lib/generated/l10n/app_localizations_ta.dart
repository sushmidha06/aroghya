// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'ஆரோக்ய AI';

  @override
  String get home => 'முகப்பு';

  @override
  String get profile => 'சுயவிவரம்';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get vault => 'மருத்துவ பெட்டகம்';

  @override
  String get insurance => 'காப்பீடு';

  @override
  String get symptomChecker => 'அறிகுறி சரிபார்ப்பு';

  @override
  String get aiRecommendations => 'AI பரிந்துரைகள்';

  @override
  String get appointments => 'சந்திப்புகள்';

  @override
  String get medications => 'மருந்துகள்';

  @override
  String get emergencyContacts => 'அவசர தொடர்புகள்';

  @override
  String get welcomeBack => 'மீண்டும் வரவேற்கிறோம்,';

  @override
  String get accountInformation => 'கணக்கு தகவல்';

  @override
  String get accountStatus => 'கணக்கு நிலை';

  @override
  String get active => 'செயலில்';

  @override
  String get security => 'பாதுகாப்பு';

  @override
  String get passwordProtected => 'கடவுச்சொல் பாதுகாக்கப்பட்டது';

  @override
  String get lastLogin => 'கடைசி உள்நுழைவு';

  @override
  String get today => 'இன்று';

  @override
  String get dataStorage => 'தரவு சேமிப்பு';

  @override
  String get localDevice => 'உள்ளூர் சாதனம்';

  @override
  String get language => 'மொழி';

  @override
  String get selectLanguage => 'மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String get english => 'English (ஆங்கிலம்)';

  @override
  String get hindi => 'हिन्दी (இந்தி)';

  @override
  String get tamil => 'தமிழ்';

  @override
  String get telugu => 'తెలుగు (தெலுங்கு)';

  @override
  String get bengali => 'বাংলা (வங்காளம்)';

  @override
  String get describeSymptoms => 'உங்கள் அறிகுறிகளை விவரிக்கவும்';

  @override
  String get quickSelectSymptoms => 'விரைவு அறிகுறி தேர்வு:';

  @override
  String get analyzeSymptomsWithAI => 'AI உடன் அறிகுறிகளை பகுப்பாய்வு செய்யவும்';

  @override
  String get analyzingWithGemma => 'Gemma 3 உடன் பகுப்பாய்வு செய்கிறது...';

  @override
  String get enterVitalsOptional => 'உங்கள் உயிர்ச்சக்தியை உள்ளிடவும் (விருப்பமானது)';

  @override
  String get temperature => 'வெப்பநிலை (°F)';

  @override
  String get bloodPressure => 'இரத்த அழுத்தம்';

  @override
  String get heartRate => 'இதய துடிப்பு (bpm)';

  @override
  String get emergencyActions => 'அவசர நடவடிக்கைகள்';

  @override
  String get emergency => 'அவசரநிலை';

  @override
  String get callDoctor => 'மருத்துவரை அழைக்கவும்';

  @override
  String get searchDocuments => 'ஆவணங்களைத் தேடவும்...';

  @override
  String get uploadDocument => 'ஆவணத்தை பதிவேற்றவும்';

  @override
  String get documentUploaded => 'ஆவணம் வெற்றிகரமாக பதிவேற்றப்பட்டது';

  @override
  String errorProcessingDocument(String error) {
    return 'ஆவணத்தை செயலாக்குவதில் பிழை: $error';
  }

  @override
  String get aiHealthRecommendations => 'AI சுகாதார பரிந்துரைகள்';

  @override
  String get errorLoadingRecommendations => 'பரிந்துரைகளை ஏற்றுவதில் பிழை';

  @override
  String get retry => 'மீண்டும் முயற்சிக்கவும்';

  @override
  String get dailyHealthTips => 'தினசரி சுகாதார குறிப்புகள்';

  @override
  String get stayHydrated => 'நீர்ச்சத்துடன் இருங்கள்';

  @override
  String get takeShortBreaks => 'குறுகிய இடைவேளைகள் எடுங்கள்';

  @override
  String get getEnoughSleep => 'போதுமான தூக்கம் பெறுங்கள்';

  @override
  String get exerciseRegularly => 'தொடர்ந்து உடற்பயிற்சி செய்யுங்கள்';

  @override
  String get speakNow => 'இப்போது பேசுங்கள்...';

  @override
  String listeningForSpeech(String language) {
    return '$language இல் பேச்சைக் கேட்கிறது';
  }

  @override
  String speechRecognitionError(String error) {
    return 'பேச்சு அடையாள பிழை: $error';
  }

  @override
  String get translating => 'மொழிபெயர்க்கிறது...';

  @override
  String get translationComplete => 'மொழிபெயர்ப்பு முடிந்தது';

  @override
  String get addMedication => 'மருந்து சேர்க்கவும்';

  @override
  String get medicationName => 'மருந்தின் பெயர்';

  @override
  String get dosage => 'அளவு';

  @override
  String get frequency => 'அதிர்வெண்';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get notes => 'Notes';

  @override
  String get medicationAdded => 'Medication added successfully';

  @override
  String get medicationUpdated => 'Medication updated successfully';

  @override
  String get medicationDeleted => 'Medication deleted successfully';

  @override
  String get deleteMedicationConfirm => 'Are you sure you want to delete this medication?';

  @override
  String get medicationAlerts => 'Medication Alerts';

  @override
  String get timeToTakeMedication => 'Time to take your medication';

  @override
  String get markAsTaken => 'Mark as Taken';

  @override
  String get snooze => 'Snooze';

  @override
  String get skip => 'Skip';

  @override
  String get scheduleAppointment => 'Schedule Appointment';

  @override
  String get doctorName => 'Doctor Name';

  @override
  String get appointmentDate => 'Appointment Date';

  @override
  String get appointmentTime => 'Appointment Time';

  @override
  String get appointmentType => 'Appointment Type';

  @override
  String get appointmentNotes => 'Appointment Notes';

  @override
  String get appointmentScheduled => 'Appointment scheduled successfully';

  @override
  String get appointmentUpdated => 'Appointment updated successfully';

  @override
  String get appointmentCancelled => 'Appointment cancelled';

  @override
  String get cancelAppointmentConfirm => 'Are you sure you want to cancel this appointment?';

  @override
  String get upcomingAppointments => 'Upcoming Appointments';

  @override
  String get pastAppointments => 'Past Appointments';

  @override
  String get noAppointments => 'No appointments scheduled';

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
  String get emergencyContactName => 'Contact Name';

  @override
  String get emergencyContactPhone => 'Phone Number';

  @override
  String get emergencyContactRelation => 'Relationship';

  @override
  String get addEmergencyContact => 'Add Emergency Contact';

  @override
  String get editEmergencyContact => 'Edit Emergency Contact';

  @override
  String get deleteEmergencyContact => 'Delete Emergency Contact';

  @override
  String get emergencyContactAdded => 'Emergency contact added successfully';

  @override
  String get emergencyContactUpdated => 'Emergency contact updated successfully';

  @override
  String get emergencyContactDeleted => 'Emergency contact deleted successfully';

  @override
  String get deleteContactConfirm => 'Are you sure you want to delete this contact?';

  @override
  String get callEmergencyContact => 'Call Emergency Contact';

  @override
  String get noEmergencyContacts => 'No emergency contacts added';

  @override
  String get healthClaimTracker => 'Health Claim Tracker';

  @override
  String get fileNewClaim => 'File New Claim';

  @override
  String get claimStatus => 'Claim Status';

  @override
  String get policyNumber => 'Policy Number';

  @override
  String get hospitalName => 'Hospital Name';

  @override
  String get patientName => 'Patient Name';

  @override
  String get admissionDate => 'Admission Date';

  @override
  String get diagnosis => 'Diagnosis';

  @override
  String get claimAmount => 'Claim Amount';

  @override
  String get documentsRequired => 'Documents Required';

  @override
  String get uploadDocuments => 'Upload Documents';

  @override
  String get claimSubmitted => 'Claim submitted successfully';

  @override
  String get claimUpdated => 'Claim updated successfully';

  @override
  String get claimApproved => 'Claim Approved';

  @override
  String get claimRejected => 'Claim Rejected';

  @override
  String get claimPending => 'Claim Pending';

  @override
  String get documentsNeeded => 'Documents Needed';

  @override
  String get noClaims => 'No claims found';

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
  String get personalInformation => 'Personal Information';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get gender => 'Gender';

  @override
  String get bloodGroup => 'Blood Group';

  @override
  String get allergies => 'Allergies';

  @override
  String get medicalHistory => 'Medical History';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get profileUpdateError => 'Error updating profile';

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
  String get fever => 'காய்ச்சல்';

  @override
  String get cough => 'இருமல்';

  @override
  String get headache => 'தலைவலி';

  @override
  String get nausea => 'குமட்டல்';

  @override
  String get fatigue => 'சோர்வு';

  @override
  String get bodyAche => 'உடல் வலி';

  @override
  String get soreThroat => 'தொண்டை வலி';

  @override
  String get runnyNose => 'Runny Nose';

  @override
  String get dizziness => 'Dizziness';

  @override
  String get chestPain => 'Chest Pain';

  @override
  String get shortnessOfBreath => 'Shortness of Breath';

  @override
  String get stomachPain => 'Stomach Pain';

  @override
  String get mild => 'Mild';

  @override
  String get moderate => 'Moderate';

  @override
  String get severe => 'Severe';

  @override
  String get critical => 'Critical';

  @override
  String get male => 'ஆண்';

  @override
  String get female => 'பெண்';

  @override
  String get other => 'Other';

  @override
  String get preferNotToSay => 'Prefer not to say';

  @override
  String get daily => 'தினசரி';

  @override
  String get twiceDaily => 'Twice Daily';

  @override
  String get threeTimesDaily => 'Three Times Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get asNeeded => 'As Needed';

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
  String get required => 'தேவையான';

  @override
  String get optional => 'விருப்பமான';

  @override
  String get pleaseEnterValue => 'Please enter a value';

  @override
  String get pleaseSelectDate => 'Please select a date';

  @override
  String get pleaseSelectTime => 'Please select a time';

  @override
  String get invalidEmail => 'Please enter a valid email';

  @override
  String get invalidPhone => 'Please enter a valid phone number';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get camera => 'கேமரா';

  @override
  String get gallery => 'கேலரி';

  @override
  String get chooseUploadMethod => 'Choose upload method';

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
  String get save => 'சேமிக்கவும்';

  @override
  String get cancel => 'ரத்து செய்யவும்';

  @override
  String get delete => 'நீக்கவும்';

  @override
  String get edit => 'திருத்தவும்';

  @override
  String get close => 'மூடவும்';

  @override
  String get ok => 'சரி';

  @override
  String get yes => 'ஆம்';

  @override
  String get no => 'இல்லை';

  @override
  String get loading => 'ஏற்றுகிறது...';

  @override
  String get error => 'பிழை';

  @override
  String get success => 'வெற்றி';

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
  String get logout => 'வெளியேறு';

  @override
  String get logoutConfirmation => 'நீங்கள் நிச்சயமாக வெளியேற விரும்புகிறீர்களா?';

  @override
  String get loggedOutSuccessfully => 'வெற்றிகரமாக வெளியேறினீர்கள்';

  @override
  String logoutError(String error) {
    return 'வெளியேறும் பிழை: $error';
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
