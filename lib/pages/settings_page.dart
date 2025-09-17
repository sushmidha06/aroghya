import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../theme/app_theme.dart';
import '../generated/l10n/app_localizations.dart';
import 'language_selection_page.dart';
import 'backup_page.dart';

class SettingsPage extends StatefulWidget {
  final LanguageService? languageService;
  
  const SettingsPage({super.key, this.languageService});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final LanguageService _languageService;

  @override
  void initState() {
    super.initState();
    _languageService = widget.languageService ?? LanguageService();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.settings,
          style: AppTheme.headingSmall.copyWith(color: AppTheme.textOnPrimary),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: AppTheme.elevationS,
        iconTheme: const IconThemeData(color: AppTheme.textOnPrimary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        children: [
          // Language Selection Section
          _buildSectionHeader(l10n.language),
          const SizedBox(height: AppTheme.spacingS),
          _buildLanguageCard(context, l10n),
          
          const SizedBox(height: AppTheme.spacingL),
          
          // Other settings can be added here
          _buildSectionHeader('General'),
          const SizedBox(height: AppTheme.spacingS),
          _buildSettingsCard(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Manage your notification preferences',
            onTap: () {
              // Navigate to notifications settings
            },
          ),
          
          const SizedBox(height: AppTheme.spacingS),
          _buildSettingsCard(
            icon: Icons.security,
            title: 'Privacy & Security',
            subtitle: 'Manage your privacy settings',
            onTap: () {
              // Navigate to privacy settings
            },
          ),
          
          const SizedBox(height: AppTheme.spacingS),
          _buildSettingsCard(
            icon: Icons.backup,
            title: 'Data Backup',
            subtitle: 'Export your health data and settings',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BackupPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTheme.headingSmall.copyWith(
        color: AppTheme.textSecondary,
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      color: AppTheme.surfaceColor,
      elevation: AppTheme.elevationS,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppTheme.spacingS),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
          ),
          child: Icon(
            Icons.language,
            color: AppTheme.primaryColor,
          ),
        ),
        title: Text(
          l10n.language,
          style: AppTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Current: ${_languageService.currentLanguageName}',
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppTheme.textLight,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LanguageSelectionPage(
                languageService: _languageService,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: AppTheme.surfaceColor,
      elevation: AppTheme.elevationS,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppTheme.spacingS),
          decoration: BoxDecoration(
            color: AppTheme.textLight.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppTheme.radiusS),
          ),
          child: Icon(
            icon,
            color: AppTheme.textSecondary,
          ),
        ),
        title: Text(
          title,
          style: AppTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppTheme.textLight,
        ),
        onTap: onTap,
      ),
    );
  }
}
