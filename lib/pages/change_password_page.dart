import 'package:flutter/material.dart';
import 'package:aroghya_ai/services/auth_service.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New passwords do not match')),
      );
      return;
    }

    if (_newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await AuthService.changePassword(
      _currentPasswordController.text,
      _newPasswordController.text,
    );

    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Current password is incorrect')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E2432);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildPasswordField(
              controller: _currentPasswordController,
              hint: 'Current Password',
              icon: Icons.lock_outline,
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              controller: _newPasswordController,
              hint: 'New Password',
              icon: Icons.lock,
            ),
            const SizedBox(height: 16),
            _buildPasswordField(
              controller: _confirmPasswordController,
              hint: 'Confirm New Password',
              icon: Icons.lock,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _changePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(color: Color(0xFF1E2432)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[500]),
        prefixIcon: Icon(icon, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1E2432), width: 1.5),
        ),
      ),
    );
  }
}
