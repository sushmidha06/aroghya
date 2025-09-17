// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Aroghya AI';

  @override
  String get home => 'Home';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get vault => 'Medical Vault';

  @override
  String get insurance => 'Insurance';

  @override
  String get symptomChecker => 'Symptom Checker';

  @override
  String get aiRecommendations => 'AI Recommendations';

  @override
  String get appointments => 'Appointments';

  @override
  String get medications => 'Medications';

  @override
  String get emergencyContacts => 'Emergency Contacts';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get accountInformation => 'Account Information';

  @override
  String get accountStatus => 'Account Status';

  @override
  String get active => 'Active';

  @override
  String get security => 'Security';

  @override
  String get passwordProtected => 'Password Protected';

  @override
  String get lastLogin => 'Last Login';

  @override
  String get today => 'Today';

  @override
  String get dataStorage => 'Data Storage';

  @override
  String get localDevice => 'Local Device';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get hindi => 'हिन्दी (Hindi)';

  @override
  String get tamil => 'தமிழ் (Tamil)';

  @override
  String get telugu => 'తెలుగు (Telugu)';

  @override
  String get bengali => 'বাংলা (Bengali)';

  @override
  String get describeSymptoms => 'Describe Your Symptoms';

  @override
  String get quickSelectSymptoms => 'Quick Select Symptoms:';

  @override
  String get analyzeSymptomsWithAI => 'Analyze Symptoms with AI';

  @override
  String get analyzingWithGemma => 'Analyzing with Gemma 3...';

  @override
  String get enterVitalsOptional => 'Enter Your Vitals (Optional)';

  @override
  String get temperature => 'Temperature (°F)';

  @override
  String get bloodPressure => 'Blood Pressure';

  @override
  String get heartRate => 'Heart Rate (bpm)';

  @override
  String get emergencyActions => 'Emergency Actions';

  @override
  String get emergency => 'Emergency';

  @override
  String get callDoctor => 'Call Doctor';

  @override
  String get searchDocuments => 'Search documents...';

  @override
  String get uploadDocument => 'Upload Document';

  @override
  String get documentUploaded => 'Document uploaded successfully';

  @override
  String errorProcessingDocument(String error) {
    return 'Error processing document: $error';
  }

  @override
  String get aiHealthRecommendations => 'AI Health Recommendations';

  @override
  String get errorLoadingRecommendations => 'Error loading recommendations';

  @override
  String get retry => 'Retry';

  @override
  String get dailyHealthTips => 'Daily Health Tips';

  @override
  String get stayHydrated => 'Stay hydrated';

  @override
  String get takeShortBreaks => 'Take short breaks';

  @override
  String get getEnoughSleep => 'Get enough sleep';

  @override
  String get exerciseRegularly => 'Exercise regularly';

  @override
  String get speakNow => 'Speak now...';

  @override
  String listeningForSpeech(String language) {
    return 'Listening for speech in $language';
  }

  @override
  String speechRecognitionError(String error) {
    return 'Speech recognition error: $error';
  }

  @override
  String get translating => 'Translating...';

  @override
  String get translationComplete => 'Translation complete';

  @override
  String get addMedication => 'Add Medication';

  @override
  String get medicationName => 'Medication Name';

  @override
  String get dosage => 'Dosage';

  @override
  String get frequency => 'Frequency';

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
  String get fever => 'Fever';

  @override
  String get cough => 'Cough';

  @override
  String get headache => 'Headache';

  @override
  String get nausea => 'Nausea';

  @override
  String get fatigue => 'Fatigue';

  @override
  String get bodyAche => 'Body Ache';

  @override
  String get soreThroat => 'Sore Throat';

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
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get other => 'Other';

  @override
  String get preferNotToSay => 'Prefer not to say';

  @override
  String get daily => 'Daily';

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
  String get required => 'Required';

  @override
  String get optional => 'Optional';

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
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

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
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get close => 'Close';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

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
  String get logout => 'Logout';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get loggedOutSuccessfully => 'Logged out successfully';

  @override
  String logoutError(String error) {
    return 'Logout error: $error';
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
