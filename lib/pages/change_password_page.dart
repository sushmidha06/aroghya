import 'package:aroghya_ai/theme/app_theme.dart';
import 'package:flutter/material.dart';

import 'package:aroghya_ai/services/auth_service.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
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
    // Basic validation
    if (_newPasswordController.text != _confirmPasswordController.text) {
      _showFeedback('New passwords do not match.', isError: true);
      return;
    }
    if (_newPasswordController.text.length < 6) {
      _showFeedback('Password must be at least 6 characters.', isError: true);
      return;
    }
    if (_currentPasswordController.text.isEmpty) {
        _showFeedback('Please enter your current password.', isError: true);
        return;
    }

    if (!mounted) return;
    setState(() => _isLoading = true);

    // Assuming AuthService handles the logic and returns a boolean
    final success = await AuthService.changePassword(
      _currentPasswordController.text,
      _newPasswordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      _showFeedback('Password changed successfully!', isError: false);
      Navigator.pop(context);
    } else {
      _showFeedback('Failed to change password. Please check your current password.', isError: true);
    }
  }

  void _showFeedback(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppTheme.errorColor : AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      // The AppBar now uses the theme, but we can override for a specific look
      appBar: AppBar(
        title: const Text('Change Password'),
        // Overriding the theme for a surface-style AppBar
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textPrimary),
        titleTextStyle: AppTheme.headingSmall,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppTheme.spacingM),
              const Text(
                "Update Your Password",
                style: AppTheme.headingMedium,
              ),
              const SizedBox(height: AppTheme.spacingS),
              const Text(
                "Enter your current password and a new password to secure your account.",
                style: AppTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spacingXL),

              // Use the themed input decoration from AppTheme
              _buildPasswordField(
                controller: _currentPasswordController,
                hint: 'Current Password',
                icon: Icons.lock_outline,
              ),
              const SizedBox(height: AppTheme.spacingM),
              _buildPasswordField(
                controller: _newPasswordController,
                hint: 'New Password',
                icon: Icons.lock,
              ),
              const SizedBox(height: AppTheme.spacingM),
              _buildPasswordField(
                controller: _confirmPasswordController,
                hint: 'Confirm New Password',
                icon: Icons.lock,
              ),
              const SizedBox(height: AppTheme.spacingXL),

              // Use the themed primary button style
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _changePassword,
                  style: AppTheme.primaryButtonStyle,
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: AppTheme.textOnPrimary,
                            strokeWidth: 3,
                          ),
                        )
                      : Text(
                          'Update Password',
                          style: AppTheme.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textOnPrimary,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget for password fields, now simplified to use the theme
  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      style: AppTheme.bodyLarge,
      decoration: AppTheme.inputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: AppTheme.textSecondary),
      ),
    );
  }
}