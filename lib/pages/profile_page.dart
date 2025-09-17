import 'package:aroghya_ai/auth.dart';
import 'package:aroghya_ai/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:aroghya_ai/models/user.dart';
import 'package:aroghya_ai/services/auth_service.dart';
import 'package:aroghya_ai/pages/change_password_page.dart'; // For navigation

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // In a real app, listen to an auth stream for real-time updates
    final user = await AuthService.getCurrentUser();
    if (mounted) {
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(child: CircularProgressIndicator(color: AppTheme.primaryColor)),
      );
    }

    if (_currentUser == null) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(
          child: Text(
            'Could not load user data.',
            style: AppTheme.bodyLarge.copyWith(color: AppTheme.textSecondary),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('My Profile'),
        // Surface-style AppBar for settings/profile pages
        backgroundColor: AppTheme.surfaceColor,
        foregroundColor: AppTheme.textPrimary,
        elevation: 0,
        titleTextStyle: AppTheme.headingSmall,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              // Navigate to an Edit Profile page
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Edit Profile page coming soon!"),
                backgroundColor: AppTheme.infoColor,
              ));
            },
            tooltip: 'Edit Profile',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: AppTheme.spacingXL),
            _buildInfoCard(
              title: 'Personal Information',
              icon: Icons.person_outline,
              children: [
                _buildInfoRow('Full Name', _currentUser!.name),
                _buildInfoRow('Email Address', _currentUser!.email),
                _buildInfoRow('Date of Birth', DateFormat.yMMMd().format(_currentUser!.dateOfBirth)),
                _buildInfoRow('Primary Condition', _currentUser!.disease),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),
            _buildInfoCard(
              title: 'Health Summary',
              icon: Icons.favorite_border_outlined,
              children: [
                _buildInfoRow('Current Age', _calculateAge(_currentUser!.dateOfBirth).toString()),
                _buildInfoRow('Last Check-up', '12 Sep 2025'), // Example data
                _buildInfoRow('Health Score', '85%'), // Example data
              ],
            ),
             const SizedBox(height: AppTheme.spacingM),
            _buildSettingsCard(),
          ],
        ),
      ),
    );
  }

  // --- Builder Widgets ---

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 64,
          backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
          child: const CircleAvatar(
            radius: 58,
            backgroundImage: AssetImage('assets/avatar.png'), // Ensure you have this asset
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        Text(_currentUser!.name, style: AppTheme.headingLarge),
        const SizedBox(height: AppTheme.spacingXS),
        Text(
          _currentUser!.email,
          style: AppTheme.bodyLarge.copyWith(color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildInfoCard({required String title, required IconData icon, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: AppTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryColor),
              const SizedBox(width: AppTheme.spacingS),
              Text(title, style: AppTheme.headingSmall),
            ],
          ),
          const Divider(height: AppTheme.spacingL),
          ...children,
        ],
      ),
    );
  }
  
  Widget _buildSettingsCard() {
    return Container(
       width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingS),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          _buildSettingsRow(
            'Change Password', 
            Icons.lock_outline, 
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordPage())),
          ),
          const Divider(height: 1),
           _buildSettingsRow(
            'Sign Out', 
            Icons.logout, 
            () async {
              // Show confirmation dialog
              final shouldSignOut = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sign Out'),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              );
              
              if (shouldSignOut == true) {
                await AuthService.logout();
                if (mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthScreen()),
                    (route) => false,
                  );
                }
              }
            },
            isDestructive: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingsRow(String title, IconData icon, VoidCallback onTap, {bool isDestructive = false}) {
    final color = isDestructive ? AppTheme.errorColor : AppTheme.textPrimary;
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: AppTheme.bodyLarge.copyWith(color: color)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.radiusM)),
    );
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}