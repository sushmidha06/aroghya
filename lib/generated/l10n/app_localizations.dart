import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('hi'),
    Locale('ta'),
    Locale('te')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Aroghya AI'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @vault.
  ///
  /// In en, this message translates to:
  /// **'Medical Vault'**
  String get vault;

  /// No description provided for @insurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insurance;

  /// No description provided for @symptomChecker.
  ///
  /// In en, this message translates to:
  /// **'Symptom Checker'**
  String get symptomChecker;

  /// No description provided for @aiRecommendations.
  ///
  /// In en, this message translates to:
  /// **'AI Recommendations'**
  String get aiRecommendations;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// No description provided for @medications.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medications;

  /// No description provided for @emergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contacts'**
  String get emergencyContacts;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// No description provided for @accountStatus.
  ///
  /// In en, this message translates to:
  /// **'Account Status'**
  String get accountStatus;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @security.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get security;

  /// No description provided for @passwordProtected.
  ///
  /// In en, this message translates to:
  /// **'Password Protected'**
  String get passwordProtected;

  /// No description provided for @lastLogin.
  ///
  /// In en, this message translates to:
  /// **'Last Login'**
  String get lastLogin;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @dataStorage.
  ///
  /// In en, this message translates to:
  /// **'Data Storage'**
  String get dataStorage;

  /// No description provided for @localDevice.
  ///
  /// In en, this message translates to:
  /// **'Local Device'**
  String get localDevice;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'हिन्दी (Hindi)'**
  String get hindi;

  /// No description provided for @tamil.
  ///
  /// In en, this message translates to:
  /// **'தமிழ் (Tamil)'**
  String get tamil;

  /// No description provided for @telugu.
  ///
  /// In en, this message translates to:
  /// **'తెలుగు (Telugu)'**
  String get telugu;

  /// No description provided for @bengali.
  ///
  /// In en, this message translates to:
  /// **'বাংলা (Bengali)'**
  String get bengali;

  /// No description provided for @describeSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Describe Your Symptoms'**
  String get describeSymptoms;

  /// No description provided for @quickSelectSymptoms.
  ///
  /// In en, this message translates to:
  /// **'Quick Select Symptoms:'**
  String get quickSelectSymptoms;

  /// No description provided for @analyzeSymptomsWithAI.
  ///
  /// In en, this message translates to:
  /// **'Analyze Symptoms with AI'**
  String get analyzeSymptomsWithAI;

  /// No description provided for @analyzingWithGemma.
  ///
  /// In en, this message translates to:
  /// **'Analyzing with Gemma 3...'**
  String get analyzingWithGemma;

  /// No description provided for @enterVitalsOptional.
  ///
  /// In en, this message translates to:
  /// **'Enter Your Vitals (Optional)'**
  String get enterVitalsOptional;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature (°F)'**
  String get temperature;

  /// No description provided for @bloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure'**
  String get bloodPressure;

  /// No description provided for @heartRate.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate (bpm)'**
  String get heartRate;

  /// No description provided for @emergencyActions.
  ///
  /// In en, this message translates to:
  /// **'Emergency Actions'**
  String get emergencyActions;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergency;

  /// No description provided for @callDoctor.
  ///
  /// In en, this message translates to:
  /// **'Call Doctor'**
  String get callDoctor;

  /// No description provided for @searchDocuments.
  ///
  /// In en, this message translates to:
  /// **'Search documents...'**
  String get searchDocuments;

  /// No description provided for @uploadDocument.
  ///
  /// In en, this message translates to:
  /// **'Upload Document'**
  String get uploadDocument;

  /// No description provided for @documentUploaded.
  ///
  /// In en, this message translates to:
  /// **'Document uploaded successfully'**
  String get documentUploaded;

  /// No description provided for @errorProcessingDocument.
  ///
  /// In en, this message translates to:
  /// **'Error processing document: {error}'**
  String errorProcessingDocument(String error);

  /// No description provided for @aiHealthRecommendations.
  ///
  /// In en, this message translates to:
  /// **'AI Health Recommendations'**
  String get aiHealthRecommendations;

  /// No description provided for @errorLoadingRecommendations.
  ///
  /// In en, this message translates to:
  /// **'Error loading recommendations'**
  String get errorLoadingRecommendations;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @dailyHealthTips.
  ///
  /// In en, this message translates to:
  /// **'Daily Health Tips'**
  String get dailyHealthTips;

  /// No description provided for @stayHydrated.
  ///
  /// In en, this message translates to:
  /// **'Stay hydrated'**
  String get stayHydrated;

  /// No description provided for @takeShortBreaks.
  ///
  /// In en, this message translates to:
  /// **'Take short breaks'**
  String get takeShortBreaks;

  /// No description provided for @getEnoughSleep.
  ///
  /// In en, this message translates to:
  /// **'Get enough sleep'**
  String get getEnoughSleep;

  /// No description provided for @exerciseRegularly.
  ///
  /// In en, this message translates to:
  /// **'Exercise regularly'**
  String get exerciseRegularly;

  /// No description provided for @speakNow.
  ///
  /// In en, this message translates to:
  /// **'Speak now...'**
  String get speakNow;

  /// No description provided for @listeningForSpeech.
  ///
  /// In en, this message translates to:
  /// **'Listening for speech in {language}'**
  String listeningForSpeech(String language);

  /// No description provided for @speechRecognitionError.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition error: {error}'**
  String speechRecognitionError(String error);

  /// No description provided for @translating.
  ///
  /// In en, this message translates to:
  /// **'Translating...'**
  String get translating;

  /// No description provided for @translationComplete.
  ///
  /// In en, this message translates to:
  /// **'Translation complete'**
  String get translationComplete;

  /// No description provided for @addMedication.
  ///
  /// In en, this message translates to:
  /// **'Add Medication'**
  String get addMedication;

  /// No description provided for @medicationName.
  ///
  /// In en, this message translates to:
  /// **'Medication Name'**
  String get medicationName;

  /// No description provided for @dosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosage;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @medicationAdded.
  ///
  /// In en, this message translates to:
  /// **'Medication added successfully'**
  String get medicationAdded;

  /// No description provided for @medicationUpdated.
  ///
  /// In en, this message translates to:
  /// **'Medication updated successfully'**
  String get medicationUpdated;

  /// No description provided for @medicationDeleted.
  ///
  /// In en, this message translates to:
  /// **'Medication deleted successfully'**
  String get medicationDeleted;

  /// No description provided for @deleteMedicationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this medication?'**
  String get deleteMedicationConfirm;

  /// No description provided for @medicationAlerts.
  ///
  /// In en, this message translates to:
  /// **'Medication Alerts'**
  String get medicationAlerts;

  /// No description provided for @timeToTakeMedication.
  ///
  /// In en, this message translates to:
  /// **'Time to take your medication'**
  String get timeToTakeMedication;

  /// No description provided for @markAsTaken.
  ///
  /// In en, this message translates to:
  /// **'Mark as Taken'**
  String get markAsTaken;

  /// No description provided for @snooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze'**
  String get snooze;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @scheduleAppointment.
  ///
  /// In en, this message translates to:
  /// **'Schedule Appointment'**
  String get scheduleAppointment;

  /// No description provided for @doctorName.
  ///
  /// In en, this message translates to:
  /// **'Doctor Name'**
  String get doctorName;

  /// No description provided for @appointmentDate.
  ///
  /// In en, this message translates to:
  /// **'Appointment Date'**
  String get appointmentDate;

  /// No description provided for @appointmentTime.
  ///
  /// In en, this message translates to:
  /// **'Appointment Time'**
  String get appointmentTime;

  /// No description provided for @appointmentType.
  ///
  /// In en, this message translates to:
  /// **'Appointment Type'**
  String get appointmentType;

  /// No description provided for @appointmentNotes.
  ///
  /// In en, this message translates to:
  /// **'Appointment Notes'**
  String get appointmentNotes;

  /// No description provided for @appointmentScheduled.
  ///
  /// In en, this message translates to:
  /// **'Appointment scheduled successfully'**
  String get appointmentScheduled;

  /// No description provided for @appointmentUpdated.
  ///
  /// In en, this message translates to:
  /// **'Appointment updated successfully'**
  String get appointmentUpdated;

  /// No description provided for @appointmentCancelled.
  ///
  /// In en, this message translates to:
  /// **'Appointment cancelled'**
  String get appointmentCancelled;

  /// No description provided for @cancelAppointmentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this appointment?'**
  String get cancelAppointmentConfirm;

  /// No description provided for @upcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointments'**
  String get upcomingAppointments;

  /// No description provided for @pastAppointments.
  ///
  /// In en, this message translates to:
  /// **'Past Appointments'**
  String get pastAppointments;

  /// No description provided for @noAppointments.
  ///
  /// In en, this message translates to:
  /// **'No appointments scheduled'**
  String get noAppointments;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmPassword;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChanged;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// No description provided for @invalidCurrentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect'**
  String get invalidCurrentPassword;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordRequirements.
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter, one lowercase letter, and one number'**
  String get passwordRequirements;

  /// No description provided for @emergencyContactName.
  ///
  /// In en, this message translates to:
  /// **'Contact Name'**
  String get emergencyContactName;

  /// No description provided for @emergencyContactPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get emergencyContactPhone;

  /// No description provided for @emergencyContactRelation.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get emergencyContactRelation;

  /// No description provided for @addEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Add Emergency Contact'**
  String get addEmergencyContact;

  /// No description provided for @editEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Edit Emergency Contact'**
  String get editEmergencyContact;

  /// No description provided for @deleteEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Delete Emergency Contact'**
  String get deleteEmergencyContact;

  /// No description provided for @emergencyContactAdded.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact added successfully'**
  String get emergencyContactAdded;

  /// No description provided for @emergencyContactUpdated.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact updated successfully'**
  String get emergencyContactUpdated;

  /// No description provided for @emergencyContactDeleted.
  ///
  /// In en, this message translates to:
  /// **'Emergency contact deleted successfully'**
  String get emergencyContactDeleted;

  /// No description provided for @deleteContactConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this contact?'**
  String get deleteContactConfirm;

  /// No description provided for @callEmergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Call Emergency Contact'**
  String get callEmergencyContact;

  /// No description provided for @noEmergencyContacts.
  ///
  /// In en, this message translates to:
  /// **'No emergency contacts added'**
  String get noEmergencyContacts;

  /// No description provided for @healthClaimTracker.
  ///
  /// In en, this message translates to:
  /// **'Health Claim Tracker'**
  String get healthClaimTracker;

  /// No description provided for @fileNewClaim.
  ///
  /// In en, this message translates to:
  /// **'File New Claim'**
  String get fileNewClaim;

  /// No description provided for @claimStatus.
  ///
  /// In en, this message translates to:
  /// **'Claim Status'**
  String get claimStatus;

  /// No description provided for @policyNumber.
  ///
  /// In en, this message translates to:
  /// **'Policy Number'**
  String get policyNumber;

  /// No description provided for @hospitalName.
  ///
  /// In en, this message translates to:
  /// **'Hospital Name'**
  String get hospitalName;

  /// No description provided for @patientName.
  ///
  /// In en, this message translates to:
  /// **'Patient Name'**
  String get patientName;

  /// No description provided for @admissionDate.
  ///
  /// In en, this message translates to:
  /// **'Admission Date'**
  String get admissionDate;

  /// No description provided for @diagnosis.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis'**
  String get diagnosis;

  /// No description provided for @claimAmount.
  ///
  /// In en, this message translates to:
  /// **'Claim Amount'**
  String get claimAmount;

  /// No description provided for @documentsRequired.
  ///
  /// In en, this message translates to:
  /// **'Documents Required'**
  String get documentsRequired;

  /// No description provided for @uploadDocuments.
  ///
  /// In en, this message translates to:
  /// **'Upload Documents'**
  String get uploadDocuments;

  /// No description provided for @claimSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Claim submitted successfully'**
  String get claimSubmitted;

  /// No description provided for @claimUpdated.
  ///
  /// In en, this message translates to:
  /// **'Claim updated successfully'**
  String get claimUpdated;

  /// No description provided for @claimApproved.
  ///
  /// In en, this message translates to:
  /// **'Claim Approved'**
  String get claimApproved;

  /// No description provided for @claimRejected.
  ///
  /// In en, this message translates to:
  /// **'Claim Rejected'**
  String get claimRejected;

  /// No description provided for @claimPending.
  ///
  /// In en, this message translates to:
  /// **'Claim Pending'**
  String get claimPending;

  /// No description provided for @documentsNeeded.
  ///
  /// In en, this message translates to:
  /// **'Documents Needed'**
  String get documentsNeeded;

  /// No description provided for @noClaims.
  ///
  /// In en, this message translates to:
  /// **'No claims found'**
  String get noClaims;

  /// No description provided for @languageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {language}'**
  String languageChanged(String language);

  /// No description provided for @testSpeechRecognition.
  ///
  /// In en, this message translates to:
  /// **'Test Speech Recognition'**
  String get testSpeechRecognition;

  /// No description provided for @speakInSelectedLanguage.
  ///
  /// In en, this message translates to:
  /// **'Speak in the selected language to test'**
  String get speakInSelectedLanguage;

  /// No description provided for @speechTestSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition test successful'**
  String get speechTestSuccessful;

  /// No description provided for @speechTestFailed.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition test failed'**
  String get speechTestFailed;

  /// No description provided for @scanMedication.
  ///
  /// In en, this message translates to:
  /// **'Scan Medication'**
  String get scanMedication;

  /// No description provided for @scanPrescription.
  ///
  /// In en, this message translates to:
  /// **'Scan Prescription'**
  String get scanPrescription;

  /// No description provided for @medicationScanned.
  ///
  /// In en, this message translates to:
  /// **'Medication scanned successfully'**
  String get medicationScanned;

  /// No description provided for @prescriptionScanned.
  ///
  /// In en, this message translates to:
  /// **'Prescription scanned successfully'**
  String get prescriptionScanned;

  /// No description provided for @scanningError.
  ///
  /// In en, this message translates to:
  /// **'Error scanning: {error}'**
  String scanningError(String error);

  /// No description provided for @ocrProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing image...'**
  String get ocrProcessing;

  /// No description provided for @ocrComplete.
  ///
  /// In en, this message translates to:
  /// **'Text extraction complete'**
  String get ocrComplete;

  /// No description provided for @scheduleMeeting.
  ///
  /// In en, this message translates to:
  /// **'Schedule Meeting'**
  String get scheduleMeeting;

  /// No description provided for @meetingTitle.
  ///
  /// In en, this message translates to:
  /// **'Meeting Title'**
  String get meetingTitle;

  /// No description provided for @meetingDate.
  ///
  /// In en, this message translates to:
  /// **'Meeting Date'**
  String get meetingDate;

  /// No description provided for @meetingTime.
  ///
  /// In en, this message translates to:
  /// **'Meeting Time'**
  String get meetingTime;

  /// No description provided for @meetingLocation.
  ///
  /// In en, this message translates to:
  /// **'Meeting Location'**
  String get meetingLocation;

  /// No description provided for @meetingNotes.
  ///
  /// In en, this message translates to:
  /// **'Meeting Notes'**
  String get meetingNotes;

  /// No description provided for @meetingScheduled.
  ///
  /// In en, this message translates to:
  /// **'Meeting scheduled successfully'**
  String get meetingScheduled;

  /// No description provided for @meetingUpdated.
  ///
  /// In en, this message translates to:
  /// **'Meeting updated successfully'**
  String get meetingUpdated;

  /// No description provided for @meetingCancelled.
  ///
  /// In en, this message translates to:
  /// **'Meeting cancelled'**
  String get meetingCancelled;

  /// No description provided for @upcomingMeetings.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Meetings'**
  String get upcomingMeetings;

  /// No description provided for @pastMeetings.
  ///
  /// In en, this message translates to:
  /// **'Past Meetings'**
  String get pastMeetings;

  /// No description provided for @noMeetings.
  ///
  /// In en, this message translates to:
  /// **'No meetings scheduled'**
  String get noMeetings;

  /// No description provided for @personalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @bloodGroup.
  ///
  /// In en, this message translates to:
  /// **'Blood Group'**
  String get bloodGroup;

  /// No description provided for @allergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergies;

  /// No description provided for @medicalHistory.
  ///
  /// In en, this message translates to:
  /// **'Medical History'**
  String get medicalHistory;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @profileUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Error updating profile'**
  String get profileUpdateError;

  /// No description provided for @healthSummary.
  ///
  /// In en, this message translates to:
  /// **'Health Summary'**
  String get healthSummary;

  /// No description provided for @lastCheckup.
  ///
  /// In en, this message translates to:
  /// **'Last Checkup'**
  String get lastCheckup;

  /// No description provided for @aiHealthScore.
  ///
  /// In en, this message translates to:
  /// **'AI Health Score'**
  String get aiHealthScore;

  /// No description provided for @upcomingAppointmentsCount.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointments'**
  String get upcomingAppointmentsCount;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;

  /// No description provided for @completeSymptomCheck.
  ///
  /// In en, this message translates to:
  /// **'Complete a symptom check'**
  String get completeSymptomCheck;

  /// No description provided for @noCheckupsRecorded.
  ///
  /// In en, this message translates to:
  /// **'No checkups recorded'**
  String get noCheckupsRecorded;

  /// No description provided for @activeMedications.
  ///
  /// In en, this message translates to:
  /// **'{count} active medications'**
  String activeMedications(int count);

  /// No description provided for @fever.
  ///
  /// In en, this message translates to:
  /// **'Fever'**
  String get fever;

  /// No description provided for @cough.
  ///
  /// In en, this message translates to:
  /// **'Cough'**
  String get cough;

  /// No description provided for @headache.
  ///
  /// In en, this message translates to:
  /// **'Headache'**
  String get headache;

  /// No description provided for @nausea.
  ///
  /// In en, this message translates to:
  /// **'Nausea'**
  String get nausea;

  /// No description provided for @fatigue.
  ///
  /// In en, this message translates to:
  /// **'Fatigue'**
  String get fatigue;

  /// No description provided for @bodyAche.
  ///
  /// In en, this message translates to:
  /// **'Body Ache'**
  String get bodyAche;

  /// No description provided for @soreThroat.
  ///
  /// In en, this message translates to:
  /// **'Sore Throat'**
  String get soreThroat;

  /// No description provided for @runnyNose.
  ///
  /// In en, this message translates to:
  /// **'Runny Nose'**
  String get runnyNose;

  /// No description provided for @dizziness.
  ///
  /// In en, this message translates to:
  /// **'Dizziness'**
  String get dizziness;

  /// No description provided for @chestPain.
  ///
  /// In en, this message translates to:
  /// **'Chest Pain'**
  String get chestPain;

  /// No description provided for @shortnessOfBreath.
  ///
  /// In en, this message translates to:
  /// **'Shortness of Breath'**
  String get shortnessOfBreath;

  /// No description provided for @stomachPain.
  ///
  /// In en, this message translates to:
  /// **'Stomach Pain'**
  String get stomachPain;

  /// No description provided for @mild.
  ///
  /// In en, this message translates to:
  /// **'Mild'**
  String get mild;

  /// No description provided for @moderate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get moderate;

  /// No description provided for @severe.
  ///
  /// In en, this message translates to:
  /// **'Severe'**
  String get severe;

  /// No description provided for @critical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get critical;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @preferNotToSay.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get preferNotToSay;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @twiceDaily.
  ///
  /// In en, this message translates to:
  /// **'Twice Daily'**
  String get twiceDaily;

  /// No description provided for @threeTimesDaily.
  ///
  /// In en, this message translates to:
  /// **'Three Times Daily'**
  String get threeTimesDaily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @asNeeded.
  ///
  /// In en, this message translates to:
  /// **'As Needed'**
  String get asNeeded;

  /// No description provided for @consultation.
  ///
  /// In en, this message translates to:
  /// **'Consultation'**
  String get consultation;

  /// No description provided for @followUp.
  ///
  /// In en, this message translates to:
  /// **'Follow-up'**
  String get followUp;

  /// No description provided for @checkup.
  ///
  /// In en, this message translates to:
  /// **'Check-up'**
  String get checkup;

  /// No description provided for @vaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get vaccination;

  /// No description provided for @labTest.
  ///
  /// In en, this message translates to:
  /// **'Lab Test'**
  String get labTest;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get required;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @pleaseEnterValue.
  ///
  /// In en, this message translates to:
  /// **'Please enter a value'**
  String get pleaseEnterValue;

  /// No description provided for @pleaseSelectDate.
  ///
  /// In en, this message translates to:
  /// **'Please select a date'**
  String get pleaseSelectDate;

  /// No description provided for @pleaseSelectTime.
  ///
  /// In en, this message translates to:
  /// **'Please select a time'**
  String get pleaseSelectTime;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// No description provided for @invalidPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get invalidPhone;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @chooseUploadMethod.
  ///
  /// In en, this message translates to:
  /// **'Choose upload method'**
  String get chooseUploadMethod;

  /// No description provided for @imageSelected.
  ///
  /// In en, this message translates to:
  /// **'Image selected'**
  String get imageSelected;

  /// No description provided for @imageUploadError.
  ///
  /// In en, this message translates to:
  /// **'Error uploading image'**
  String get imageUploadError;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// No description provided for @cameraPermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Camera permission is required'**
  String get cameraPermissionRequired;

  /// No description provided for @storagePermissionRequired.
  ///
  /// In en, this message translates to:
  /// **'Storage permission is required'**
  String get storagePermissionRequired;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @cut.
  ///
  /// In en, this message translates to:
  /// **'Cut'**
  String get cut;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @redo.
  ///
  /// In en, this message translates to:
  /// **'Redo'**
  String get redo;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// No description provided for @loggedOutSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get loggedOutSuccessfully;

  /// No description provided for @logoutError.
  ///
  /// In en, this message translates to:
  /// **'Logout error: {error}'**
  String logoutError(String error);

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get networkError;

  /// No description provided for @serverError.
  ///
  /// In en, this message translates to:
  /// **'Server error. Please try again later.'**
  String get serverError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown error occurred'**
  String get unknownError;

  /// No description provided for @timeoutError.
  ///
  /// In en, this message translates to:
  /// **'Request timeout. Please try again.'**
  String get timeoutError;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @connectionRestored.
  ///
  /// In en, this message translates to:
  /// **'Connection restored'**
  String get connectionRestored;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get night;

  /// No description provided for @beforeMeals.
  ///
  /// In en, this message translates to:
  /// **'Before Meals'**
  String get beforeMeals;

  /// No description provided for @afterMeals.
  ///
  /// In en, this message translates to:
  /// **'After Meals'**
  String get afterMeals;

  /// No description provided for @withMeals.
  ///
  /// In en, this message translates to:
  /// **'With Meals'**
  String get withMeals;

  /// No description provided for @onEmptyStomach.
  ///
  /// In en, this message translates to:
  /// **'On Empty Stomach'**
  String get onEmptyStomach;

  /// No description provided for @tablet.
  ///
  /// In en, this message translates to:
  /// **'Tablet'**
  String get tablet;

  /// No description provided for @capsule.
  ///
  /// In en, this message translates to:
  /// **'Capsule'**
  String get capsule;

  /// No description provided for @syrup.
  ///
  /// In en, this message translates to:
  /// **'Syrup'**
  String get syrup;

  /// No description provided for @injection.
  ///
  /// In en, this message translates to:
  /// **'Injection'**
  String get injection;

  /// No description provided for @drops.
  ///
  /// In en, this message translates to:
  /// **'Drops'**
  String get drops;

  /// No description provided for @cream.
  ///
  /// In en, this message translates to:
  /// **'Cream'**
  String get cream;

  /// No description provided for @ointment.
  ///
  /// In en, this message translates to:
  /// **'Ointment'**
  String get ointment;

  /// No description provided for @inhaler.
  ///
  /// In en, this message translates to:
  /// **'Inhaler'**
  String get inhaler;

  /// No description provided for @mg.
  ///
  /// In en, this message translates to:
  /// **'mg'**
  String get mg;

  /// No description provided for @ml.
  ///
  /// In en, this message translates to:
  /// **'ml'**
  String get ml;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'units'**
  String get units;

  /// No description provided for @puffs.
  ///
  /// In en, this message translates to:
  /// **'puffs'**
  String get puffs;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @viewLess.
  ///
  /// In en, this message translates to:
  /// **'View Less'**
  String get viewLess;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show More'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show Less'**
  String get showLess;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @collapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get collapse;

  /// No description provided for @expand.
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get expand;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bn', 'en', 'hi', 'ta', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn': return AppLocalizationsBn();
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'ta': return AppLocalizationsTa();
    case 'te': return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
