// auth_screen.dart
import 'package:flutter/material.dart';
import 'package:aroghya_ai/home.dart';
import 'package:hive/hive.dart';
import 'package:aroghya_ai/models/user.dart';
import 'package:aroghya_ai/services/auth_service.dart';

// Enum to manage the current authentication view
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

  // --- NEW: Navigation Method ---
  void _navigateToHome() {
    // Use pushReplacement to prevent the user from going back to the auth screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1A1A1A)),
      ),
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

  // --- MODIFIED: This widget builder now handles the new navigation logic ---
  Widget _buildForm() {
    switch (_authMode) {
      case AuthMode.login:
        return LoginForm(
          key: const ValueKey('login'),
          onRegisterTap: () => _switchAuthMode(AuthMode.register),
          // CHANGED: This now navigates directly to home
          onLoginSuccess: _navigateToHome,
        );
      case AuthMode.register:
        return RegisterForm(
          key: const ValueKey('register'),
          onLoginTap: () => _switchAuthMode(AuthMode.login),
          // CHANGED: This now navigates directly to home
          onRegisterSuccess: _navigateToHome,
        );
    }
  }
}

// --- Form Widgets (No changes needed here) ---

class LoginForm extends StatefulWidget {
  final VoidCallback onRegisterTap;
  final VoidCallback onLoginSuccess;

  const LoginForm({super.key, required this.onRegisterTap, required this.onLoginSuccess});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      final userBox = Hive.box<User>('users');
      
      // Find user with matching email and password
      User? foundUser;
      for (var user in userBox.values) {
        if (user.email == _emailController.text && user.password == _passwordController.text) {
          foundUser = user;
          break;
        }
      }

      if (foundUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
        return;
      }

      // Save login session
      await AuthService.saveLoginSession(_emailController.text);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
      
      widget.onLoginSuccess();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('login_form'),
      children: [
        const Text('Welcome Back', style: TextStyle(color: Color(0xFF1E2432), fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
        const SizedBox(height: 10),
        Text('Sign in to your account', style: TextStyle(color: Colors.grey[700], fontSize: 16, fontFamily: 'Inter')),
        const SizedBox(height: 40),
        _buildTextFieldWithController(controller: _emailController, hint: 'Email', icon: Icons.person_outline),
        const SizedBox(height: 20),
        _buildTextFieldWithController(controller: _passwordController, hint: 'Password', icon: Icons.lock_outline, obscure: true),
        const SizedBox(height: 40),
        _buildAuthButton('Login', _handleLogin),
        const SizedBox(height: 16),
// Biometric login removed
        const SizedBox(height: 20),
        _buildSwitchText("Don't have an account?", ' Register', widget.onRegisterTap),
      ],
    );
  }
}


class RegisterForm extends StatefulWidget {
  final VoidCallback onLoginTap;
  final VoidCallback onRegisterSuccess;
  
  const RegisterForm({super.key, required this.onLoginTap, required this.onRegisterSuccess});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _diseaseController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _diseaseController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 6570)), // 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _handleRegister() async {
    if (_nameController.text.isEmpty || 
        _emailController.text.isEmpty || 
        _passwordController.text.isEmpty || 
        _diseaseController.text.isEmpty || 
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      final userBox = Hive.box<User>('users');
      
      // Check if user already exists
      bool userExists = false;
      for (var user in userBox.values) {
        if (user.email == _emailController.text) {
          userExists = true;
          break;
        }
      }

      if (userExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User already exists')),
        );
        return;
      }

      final newUser = User(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        dateOfBirth: _selectedDate!,
        disease: _diseaseController.text,
      );

      await userBox.add(newUser);
      
      // Save login session
      await AuthService.saveLoginSession(_emailController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful!')),
      );
      
      widget.onRegisterSuccess();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('register_form'),
      children: [
        const Text('Create Account', style: TextStyle(color: Color(0xFF1E2432), fontSize: 28, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
        const SizedBox(height: 10),
        Text('Fill the details to get started', style: TextStyle(color: Colors.grey[700], fontSize: 16, fontFamily: 'Inter')),
        const SizedBox(height: 40),
        _buildTextFieldWithController(controller: _nameController, hint: 'Full Name', icon: Icons.badge_outlined),
        const SizedBox(height: 20),
        _buildTextFieldWithController(controller: _emailController, hint: 'Email', icon: Icons.email_outlined),
        const SizedBox(height: 20),
        _buildTextFieldWithController(controller: _passwordController, hint: 'Password', icon: Icons.lock_outline, obscure: true),
        const SizedBox(height: 20),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.grey[600]),
                const SizedBox(width: 12),
                Text(
                  _selectedDate == null
                      ? 'Date of Birth'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                  style: TextStyle(
                    color: _selectedDate == null ? Colors.grey[500] : const Color(0xFF1A1A1A),
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildTextFieldWithController(controller: _diseaseController, hint: 'Disease/Medical Condition', icon: Icons.medical_services_outlined),
        const SizedBox(height: 40),
        _buildAuthButton('Register', _handleRegister),
        const SizedBox(height: 20),
        _buildSwitchText('Already have an account?', ' Login', widget.onLoginTap),
      ],
    );
  }
}



// --- Helper Widgets ---


Widget _buildTextFieldWithController({required TextEditingController controller, required String hint, required IconData icon, bool obscure = false}) {
  return TextField(
    controller: controller,
    obscureText: obscure,
    style: const TextStyle(color: Color(0xFF1A1A1A), fontFamily: 'Inter'),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[500], fontFamily: 'Inter'),
      prefixIcon: Icon(icon, color: Colors.grey[600]),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
       enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1E2432), width: 1.5),
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
    child: Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
  );
}

Widget _buildSwitchText(String text1, String text2, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: RichText(
      text: TextSpan(
        style: TextStyle(color: Colors.grey[700], fontSize: 14, fontFamily: 'Inter'),
        children: [
          TextSpan(text: text1),
          TextSpan(
            text: text2,
            style: const TextStyle(color: Color(0xFF1E2432), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ),
  );
}