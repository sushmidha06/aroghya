import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:aroghya_ai/auth.dart';
import 'package:aroghya_ai/models/user.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'User';
  String _userEmail = 'No Email';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final authBox = Hive.box('authBox');
      final userBox = Hive.box<User>('users');
      
      final email = authBox.get('email', defaultValue: 'No Email');
      
      // Find user in users box by email
      User? currentUser;
      for (int i = 0; i < userBox.length; i++) {
        final user = userBox.getAt(i);
        if (user?.email == email) {
          currentUser = user;
          break;
        }
      }
      
      if (mounted) {
        setState(() {
          _userEmail = email;
          _userName = currentUser?.name ?? 'User';
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
      if (mounted) {
        setState(() {
          _userEmail = 'No Email';
          _userName = 'User';
        });
      }
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      final box = Hive.box('authBox');
      await box.put('isLoggedIn', false);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Logged out successfully"),
            backgroundColor: AppTheme.successColor,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AuthScreen()),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Logout error: $e"),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
                foregroundColor: AppTheme.textOnPrimary,
              ),
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          "Home",
          style: AppTheme.headingSmall,
        ),
        backgroundColor: AppTheme.surfaceColor,
        elevation: AppTheme.elevationS,
        shadowColor: AppTheme.textLight,
        foregroundColor: AppTheme.textPrimary,
        actions: [
          IconButton(
            onPressed: () => _showLogoutConfirmation(context),
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.spacingL),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(AppTheme.radiusL),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.textLight.withOpacity(0.1),
                      blurRadius: AppTheme.elevationM,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: AppTheme.textOnPrimary,
                            size: 30,
                          ),
                        ),
                        const SizedBox(width: AppTheme.spacingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome back,",
                                style: AppTheme.bodyMedium.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: AppTheme.spacingXS),
                              Text(
                                _userName,
                                style: AppTheme.headingMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    Container(
                      padding: const EdgeInsets.all(AppTheme.spacingS),
                      decoration: BoxDecoration(
                        color: AppTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 20,
                            color: AppTheme.textSecondary,
                          ),
                          const SizedBox(width: AppTheme.spacingS),
                          Text(
                            _userEmail,
                            style: AppTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),
              Text(
                "Account Information",
                style: AppTheme.headingSmall,
              ),
              const SizedBox(height: AppTheme.spacingM),
              _buildInfoCard(
                icon: Icons.verified_user,
                title: "Account Status",
                subtitle: "Active",
                iconColor: AppTheme.successColor,
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                icon: Icons.security,
                title: "Security",
                subtitle: "Password Protected",
                iconColor: AppTheme.accentBlue,
              ),
              const SizedBox(height: AppTheme.spacingS),
              _buildInfoCard(
                icon: Icons.access_time,
                title: "Last Login",
                subtitle: "Today",
                iconColor: AppTheme.accentOrange,
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                icon: Icons.storage,
                title: "Data Storage",
                subtitle: "Local Device",
                iconColor: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        boxShadow: [
          BoxShadow(
            color: AppTheme.textLight.withOpacity(0.1),
            blurRadius: AppTheme.elevationS,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spacingS),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Text(
                  subtitle,
                  style: AppTheme.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppTheme.textLight,
          ),
        ],
      ),
    );
  }
}