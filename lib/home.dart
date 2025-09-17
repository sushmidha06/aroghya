import 'package:aroghya_ai/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:hive/hive.dart';
import 'theme/app_theme.dart';
import 'pages/symptom_checker_page.dart';
import 'pages/appointments_page.dart';
import 'pages/vault_page.dart';
import 'pages/ai_recommendations_page.dart';
import 'pages/change_password_page.dart';
import 'services/auth_service.dart';
import 'services/language_service.dart';
import 'pages/profile_page.dart';
import 'pages/emergency_contacts_page.dart';
import 'pages/medication_alerts_page.dart';
import 'pages/insurance_page.dart';
import 'models/symptom_report.dart';
import 'models/meeting.dart';
import 'auth.dart' as main_auth;
import 'generated/l10n/app_localizations.dart';

// --- MAIN APP SHELL (Controls Navigation) ---
class HomePage extends StatefulWidget {
  final LanguageService? languageService;
  
  const HomePage({super.key, this.languageService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late final LanguageService _languageService;

  @override
  void initState() {
    super.initState();
    _languageService = widget.languageService ?? LanguageService();
  }

  // The list of pages now includes the patient dashboard
  List<Widget> get _pages => <Widget>[
    const PatientDashboardPage(), // The new dashboard UI
    const VaultPage(),
    const InsurancePage(), // Health claim tracker
    SettingsPage(languageService: _languageService),
  ];

  void _onItemTapped(int index) async {
    // If user taps on Vault (index 1), show authentication first
    if (index == 1) {
      final authenticated = await _authenticateForVault();
      if (!authenticated) {
        return; // Don't navigate if authentication failed
      }
    }
    
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _authenticateForVault() async {
    try {
      final LocalAuthentication localAuth = LocalAuthentication();
      
      final bool isAvailable = await localAuth.isDeviceSupported();
      if (!isAvailable) {
        _showAuthError('Biometric authentication not available on this device');
        return false;
      }

      final bool hasFingerprint = await localAuth.canCheckBiometrics;
      if (!hasFingerprint) {
        _showAuthError('No biometric authentication set up on this device');
        return false;
      }

      final bool isAuthenticated = await localAuth.authenticate(
        localizedReason: 'Access your secure medical vault',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      return isAuthenticated;
    } catch (e) {
      _showAuthError('Authentication failed: ${e.toString()}');
      return false;
    }
  }

  void _showAuthError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Authentication Required'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNavBar(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height),
    );
  }

  Widget _buildBottomNavBar(double screenWidth, double screenHeight) {
    final l10n = AppLocalizations.of(context);
    
    return Container(
      height: screenHeight * 0.09,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppTheme.radiusL)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(Icons.home, l10n.home, 0, screenWidth),
          _buildNavBarItem(
              Icons.folder_special_outlined, l10n.vault, 1, screenWidth),
          _buildNavBarItem(
              Icons.health_and_safety, 'Insurance', 2, screenWidth),
          _buildNavBarItem(
              Icons.settings_outlined, l10n.settings, 3, screenWidth),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(
      IconData icon, String label, int index, double screenWidth) {
    bool isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF1E2432) : Colors.grey[500],
            size: screenWidth * 0.06,
          ),
          SizedBox(height: screenWidth * 0.005),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF1E2432) : Colors.grey[500],
              fontSize: (screenWidth * 0.03).clamp(10.0, 12.0),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

// --- PAGE 1: PATIENT DASHBOARD (THE NEW HOME CONTENT) ---
class PatientDashboardPage extends StatefulWidget {
  const PatientDashboardPage({super.key});

  @override
  State<PatientDashboardPage> createState() => _PatientDashboardPageState();
}

class _PatientDashboardPageState extends State<PatientDashboardPage> {
  String? _cachedUserName;
  Map<String, dynamic> _healthSummary = {
    'lastCheckup': 'No data',
    'aiHealthScore': 'N/A',
    'upcomingAppointments': '0',
    'alerts': 'No data available'
  };
  
  bool _isLoading = false;
  
  @override
  void initState() {
    super.initState();
    print('🏠 PatientDashboardPage initState called');
    // Initialize data after the widget is built to prevent stack overflow
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }
  
  Future<void> _initializeData() async {
    if (_isLoading || !mounted) return; // Prevent multiple simultaneous calls
    
    _isLoading = true;
    try {
      await _loadUserName();
      await _loadHealthSummary();
    } catch (e) {
      print('Error initializing data: $e');
    } finally {
      if (mounted) {
        _isLoading = false;
      }
    }
  }
  
  Future<void> _loadUserName() async {
    print('📝 Loading user name...');
    
    try {
      final user = await AuthService.getCurrentUser();
      print('👤 User retrieved: ${user?.name ?? 'null'} (${user?.email ?? 'null'})');
      
      if (mounted) {
        setState(() {
          _cachedUserName = user?.name ?? 'User';
          print('🔄 UI updated with user name: $_cachedUserName');
        });
      } else {
        print('⚠️ Widget not mounted, skipping UI update');
      }
    } catch (e) {
      print('Error loading user name: $e');
      if (mounted) {
        setState(() {
          _cachedUserName = 'User';
        });
      }
    }
  }

  Future<void> _loadHealthSummary() async {
    try {
      print('🔄 Loading health summary...');
      
      // Load symptom reports
      final reportsBox = await Hive.openBox<SymptomReport>('symptom_reports');
      final reports = reportsBox.values.toList();
      print('📊 Loaded ${reports.length} symptom reports');
      
      // Load meetings for appointments count
      int upcomingMeetings = 0;
      try {
        final meetingsBox = await Hive.openBox<Meeting>('meetings');
        final meetings = meetingsBox.values.toList();
        upcomingMeetings = meetings.where((meeting) {
          return meeting.startTime.isAfter(DateTime.now()) && 
                 meeting.status != 'cancelled' && 
                 meeting.status != 'completed';
        }).length;
        print('📅 Found $upcomingMeetings upcoming meetings');
      } catch (e) {
        print('⚠️ Error loading meetings: $e');
        upcomingMeetings = 0;
      }
      
      // Load medications for additional health context
      int activeMedications = 0;
      try {
        final medicationsBox = Hive.box('medications');
        activeMedications = medicationsBox.values.length;
        print('💊 Found $activeMedications medications');
      } catch (e) {
        print('⚠️ Error loading medications: $e');
        activeMedications = 0;
      }
      
      if (mounted) {
        if (reports.isNotEmpty) {
          // Sort by timestamp to get most recent
          reports.sort((a, b) => b.timestamp.compareTo(a.timestamp));
          final latestReport = reports.first;
          
          // Calculate AI health score based on recent reports
          final recentReports = reports.take(5).toList();
          final avgConfidence = recentReports.map((r) => r.confidence).reduce((a, b) => a + b) / recentReports.length;
          final severeCases = recentReports.where((r) => r.severity == 'Severe').length;
          final moderateCases = recentReports.where((r) => r.severity == 'Moderate').length;
          final healthScore = (avgConfidence * (1 - severeCases * 0.3 - moderateCases * 0.1)).clamp(0, 100).round();
          
          // Create comprehensive alerts
          final alerts = <String>[];
          if (severeCases > 0) alerts.add('$severeCases severe condition(s)');
          if (moderateCases > 1) alerts.add('$moderateCases moderate conditions');
          if (activeMedications > 0) alerts.add('$activeMedications active medications');
          
          setState(() {
            _healthSummary = {
              'lastCheckup': _formatDate(latestReport.timestamp),
              'aiHealthScore': '$healthScore%',
              'upcomingAppointments': upcomingMeetings.toString(),
              'alerts': alerts.isEmpty ? 'No critical conditions' : alerts.join(', ')
            };
          });
        } else {
          // No symptom reports, show basic info
          setState(() {
            _healthSummary = {
              'lastCheckup': 'No checkups recorded',
              'aiHealthScore': 'Complete a symptom check',
              'upcomingAppointments': upcomingMeetings.toString(),
              'alerts': activeMedications > 0 ? '$activeMedications active medications' : 'No data available'
            };
          });
        }
      }
    } catch (e) {
      print('Error loading health summary: $e');
      if (mounted) {
        setState(() {
          _healthSummary = {
            'lastCheckup': 'Error loading data',
            'aiHealthScore': 'N/A',
            'upcomingAppointments': '0',
            'alerts': 'Unable to load health data'
          };
        });
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }
  

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    // Define main accent colors
    const Color primaryColor = Color(0xFF1E2432); // Dark Navy
    const Color yellowAccent = Color(0xFFFFD54F); // Yellow accent
    const Color redAccent = Color(0xFFFF6B6B);    // Red accent
    const Color bgColor = Colors.white;          // Background

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Profile Header ---
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: primaryColor,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${l10n.welcomeBack} ${_cachedUserName ?? 'User'}!",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          "Feeling good today?",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- Health Tip Card ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: yellowAccent,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb, color: primaryColor, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "${l10n.dailyHealthTips}: ${l10n.stayHydrated}, ${l10n.exerciseRegularly}, and eat nutritious meals.",
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- Quick Tabs / Navigation ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickTab(Icons.healing, l10n.symptomChecker.replaceAll(' ', '\n'), primaryColor, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SymptomCheckerPage()),
                    );
                  }),
                  _buildQuickTab(Icons.smart_toy, l10n.aiRecommendations.replaceAll(' ', '\n'), primaryColor, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AIRecommendationsPage()),
                    );
                  }),
                  _buildQuickTab(Icons.calendar_today, l10n.appointments.replaceAll(' ', '\n'), primaryColor, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AppointmentsPage()),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 20),

              // --- Quick Action Cards ---
              Row(
                children: [
                  Expanded(child: _buildActionCard(Icons.medical_services, l10n.symptomChecker, Colors.teal, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SymptomCheckerPage()),
                    );
                  })),
                  const SizedBox(width: 16),
                  Expanded(child: _buildActionCard(Icons.medication, l10n.medications, Colors.orange, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MedicationAlertsPage()),
                    );
                  })),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildActionCard(Icons.calendar_today, "Schedule Meeting", Colors.blueAccent, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AppointmentsPage()),
                    );
                  })),
                  const SizedBox(width: 16),
                  Expanded(child: _buildActionCard(Icons.warning, l10n.emergencyContacts, redAccent, onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EmergencyContactsPage()),
                    );
                  })),
                ],
              ),
              const SizedBox(height: 20),

              // --- Health Summary Card ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Health Summary",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryRow("Last Check-up", _healthSummary['lastCheckup']),
                    _buildSummaryRow("AI Health Score", _healthSummary['aiHealthScore']),
                    _buildSummaryRow("Upcoming Appointments", _healthSummary['upcomingAppointments']),
                    _buildSummaryRow("Alerts", _healthSummary['alerts']),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Quick Tab Builder
  Widget _buildQuickTab(IconData icon, String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Quick Action Card Builder
  Widget _buildActionCard(IconData icon, String title, Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Health Summary Row
  Widget _buildSummaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E2432))),
        ],
      ),
    );
  }
}


// --- PAGE 2: CHAT PAGE ---
class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Chat'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E2432),
        elevation: 1,
      ),
      body: const Center(
        child: Text(
          'Chat Page',
          style: TextStyle(fontSize: 24, fontFamily: 'Inter'),
        ),
      ),
    );
  }
}


// // --- PAGE 4: SETTINGS PAGE (WITH LOGOUT) ---
// class SettingsPage extends StatefulWidget {
//   const SettingsPage({super.key});

//   @override
//   State<SettingsPage> createState() => _SettingsPageState();
// }

// class _SettingsPageState extends State<SettingsPage> {
//   Future<void> _logout(BuildContext context) async {
//     final bool? confirmed = await showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Confirm Logout'),
//           content: const Text('Are you sure you want to log out?'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(true),
//               child: const Text('Logout', style: TextStyle(color: Colors.red)),
//             ),
//           ],
//         );
//       },
//     );

//     if (confirmed == true) {
//       await AuthService.logout();
//       Navigator.of(context).pushAndRemoveUntil(
//         MaterialPageRoute(builder: (context) => const main_auth.AuthScreen()),
//         (Route<dynamic> route) => false,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Settings'),
//         backgroundColor: Colors.white,
//         foregroundColor: const Color(0xFF1E2432),
//         elevation: 1,
//         leading: const Icon(Icons.settings),
//       ),
//       body: ListView(
//         children: [
//           ListTile(
//             leading: const Icon(Icons.person_outline),
//             title: const Text('Profile'),
//             trailing: const Icon(Icons.chevron_right),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const ProfilePage()),
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.lock_outline),
//             title: const Text('Change Password'),
//             trailing: const Icon(Icons.chevron_right),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
//               );
//             },
//           ),
// // Biometric authentication removed
//           const Divider(),
//           ListTile(
//             leading: const Icon(Icons.logout, color: Colors.red),
//             title:
//                 const Text('Logout', style: TextStyle(color: Colors.red)),
//             onTap: () => _logout(context),
//           ),
//         ],
//       ),
//     );
//   }
// }


// // --- DUPLICATE AUTH REMOVED ---
// // Using main auth.dart instead of this duplicate implementation
// // The duplicate AuthScreen with only 3 fields has been removed