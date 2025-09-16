import 'package:flutter/material.dart';
import 'package:aroghya_ai/services/auth_service.dart';
import 'package:aroghya_ai/pages/profile_page.dart';
import 'package:aroghya_ai/pages/change_password_page.dart';
import 'package:aroghya_ai/pages/symptom_checker_page.dart';
import 'package:aroghya_ai/pages/ai_recommendations_page.dart';
import 'package:aroghya_ai/pages/appointments_page.dart';

// --- MAIN APP SHELL (Controls Navigation) ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // The list of pages now includes the patient dashboard
  static const List<Widget> _pages = <Widget>[
    PatientDashboardPage(), // The new dashboard UI
    ChatPage(),
    SchedulePage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return Container(
      height: screenHeight * 0.09,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(screenWidth * 0.06)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(Icons.home, 'Home', 0, screenWidth),
          _buildNavBarItem(
              Icons.chat_bubble_outline, 'Chat', 1, screenWidth),
          _buildNavBarItem(
              Icons.calendar_month_outlined, 'Schedule', 2, screenWidth),
          _buildNavBarItem(
              Icons.settings_outlined, 'Settings', 3, screenWidth),
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
  
  @override
  void initState() {
    super.initState();
    _loadUserName();
  }
  
  Future<void> _loadUserName() async {
    final user = await AuthService.getCurrentUser();
    if (mounted) {
      setState(() {
        _cachedUserName = user?.name ?? 'User';
      });
    }
  }
  

  @override
  Widget build(BuildContext context) {
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
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/avatar.png'), // replace with patient image
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello, ${_cachedUserName ?? 'User'}!",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        "Feeling good today?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
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
                      color: Colors.amber.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb, color: primaryColor, size: 28),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        "Health Tip: Stay hydrated, exercise daily, and eat nutritious meals.",
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
                  _buildQuickTab(Icons.healing, "Symptom\nChecker", primaryColor, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SymptomCheckerPage()),
                    );
                  }),
                  _buildQuickTab(Icons.smart_toy, "AI\nRecommendations", primaryColor, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AIRecommendationsPage()),
                    );
                  }),
                  _buildQuickTab(Icons.calendar_today, "My\nAppointments", primaryColor, () {
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
                  Expanded(child: _buildActionCard(Icons.medical_services, "Check Symptoms", Colors.teal)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildActionCard(Icons.medication, "Medication Alerts", Colors.orange)),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildActionCard(Icons.calendar_today, "Appointments", Colors.blueAccent)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildActionCard(Icons.warning, "Emergency Contacts", redAccent)),
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
                    _buildSummaryRow("Last Check-up", "12 Sep 2025"),
                    _buildSummaryRow("AI Health Score", "85%"),
                    _buildSummaryRow("Upcoming Appointments", "2"),
                    _buildSummaryRow("Alerts", "No critical conditions"),
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
            backgroundColor: color.withOpacity(0.1),
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
  Widget _buildActionCard(IconData icon, String title, Color color) {
    return Container(
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

// --- PAGE 3: SCHEDULE PAGE ---
class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Schedule'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E2432),
        elevation: 1,
      ),
      body: const Center(
        child: Text(
          'Schedule Page',
          style: TextStyle(fontSize: 24, fontFamily: 'Inter'),
        ),
      ),
    );
  }
}

// --- PAGE 4: SETTINGS PAGE (WITH LOGOUT) ---
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _logout(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child:
                  const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await AuthService.logout();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthScreen()),
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E2432),
        elevation: 1,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profile'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: const Text('Change Password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePasswordPage()),
              );
            },
          ),
// Biometric authentication removed
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title:
                const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}


// --- AUTHENTICATION FLOW ---
enum AuthMode { login, register }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthMode _authMode = AuthMode.login;

  void _switchAuthMode(AuthMode newMode) {
    setState(() {
      _authMode = newMode;
    });
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    switch (_authMode) {
      case AuthMode.login:
        return LoginForm(
          onRegisterTap: () => _switchAuthMode(AuthMode.register),
          onLoginSuccess: _navigateToHome,
        );
      case AuthMode.register:
        return RegisterForm(
          onLoginTap: () => _switchAuthMode(AuthMode.login),
          onRegisterSuccess: _navigateToHome,
        );
    }
  }
}

class LoginForm extends StatelessWidget {
  final VoidCallback onRegisterTap;
  final VoidCallback onLoginSuccess;

  const LoginForm(
      {super.key,
      required this.onRegisterTap,
      required this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('login_form'),
      children: [
        const Text('Welcome Back',
            style: TextStyle(
                color: Color(0xFF1E2432),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter')),
        const SizedBox(height: 10),
        Text('Sign in to your account',
            style:
                TextStyle(color: Colors.grey[700], fontSize: 16, fontFamily: 'Inter')),
        const SizedBox(height: 40),
        _buildTextField(hint: 'Email or Phone', icon: Icons.person_outline),
        const SizedBox(height: 20),
        _buildTextField(
            hint: 'Password', icon: Icons.lock_outline, obscure: true),
        const SizedBox(height: 40),
        _buildAuthButton('Login', onLoginSuccess),
        const SizedBox(height: 20),
        _buildSwitchText("Don't have an account?", ' Register', onRegisterTap),
      ],
    );
  }
}

class RegisterForm extends StatelessWidget {
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterSuccess;

  const RegisterForm(
      {super.key,
      required this.onLoginTap,
      required this.onRegisterSuccess});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('register_form'),
      children: [
        const Text('Create Account',
            style: TextStyle(
                color: Color(0xFF1E2432),
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter')),
        const SizedBox(height: 10),
        Text('Fill the details to get started',
            style:
                TextStyle(color: Colors.grey[700], fontSize: 16, fontFamily: 'Inter')),
        const SizedBox(height: 40),
        _buildTextField(hint: 'Full Name', icon: Icons.badge_outlined),
        const SizedBox(height: 20),
        _buildTextField(hint: 'Email or Phone', icon: Icons.email_outlined),
        const SizedBox(height: 20),
        _buildTextField(
            hint: 'Password', icon: Icons.lock_outline, obscure: true),
        const SizedBox(height: 40),
        _buildAuthButton('Register', onRegisterSuccess),
        const SizedBox(height: 20),
        _buildSwitchText(
            'Already have an account?', ' Login', onLoginTap),
      ],
    );
  }
}

// OTP form removed as per requirements

Widget _buildTextField(
    {required String hint, required IconData icon, bool obscure = false}) {
  return TextField(
    obscureText: obscure,
    style: const TextStyle(color: Color(0xFF1E2432), fontFamily: 'Inter'),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[500], fontFamily: 'Inter'),
      prefixIcon: Icon(icon, color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.grey[100],
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

Widget _buildAuthButton(String text, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF1E2432),
      foregroundColor: Colors.white,
      minimumSize: const Size(double.infinity, 56),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      shadowColor: const Color(0xFF1E2432).withOpacity(0.3),
    ),
    child: Text(text,
        style:
            const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
  );
}

Widget _buildSwitchText(String text1, String text2, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: RichText(
      text: TextSpan(
        style: TextStyle(
            color: Colors.grey[700], fontSize: 14, fontFamily: 'Inter'),
        children: [
          TextSpan(text: text1),
          TextSpan(
            text: text2,
            style: const TextStyle(
                color: Color(0xFF1E2432), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}