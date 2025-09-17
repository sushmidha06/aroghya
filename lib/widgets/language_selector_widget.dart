import 'package:flutter/material.dart';
import '../services/multi_language_speech_service.dart';
import '../theme/app_theme.dart';

class LanguageSelectorWidget extends StatefulWidget {
  final Function(String)? onLanguageChanged;
  final bool showLabel;
  
  const LanguageSelectorWidget({
    super.key,
    this.onLanguageChanged,
    this.showLabel = true,
  });

  @override
  State<LanguageSelectorWidget> createState() => _LanguageSelectorWidgetState();
}

class _LanguageSelectorWidgetState extends State<LanguageSelectorWidget> {
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _selectedLanguage = MultiLanguageSpeechService.currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.showLabel) ...[
            Row(
              children: [
                Icon(
                  Icons.language,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacingS),
                Text(
                  'Language:',
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingS),
          ],
          
          // Scrollable language buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: MultiLanguageSpeechService.supportedLanguages.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppTheme.spacingXS),
                  child: _buildLanguageButton(
                    entry.key,
                    entry.value,
                    _getLanguageIcon(entry.key),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getLanguageIcon(String languageCode) {
    switch (languageCode) {
      case 'en':
        return Icons.language;
      case 'hi':
        return Icons.translate;
      case 'ta':
        return Icons.record_voice_over;
      case 'te':
        return Icons.mic;
      case 'bn':
        return Icons.speaker;
      default:
        return Icons.language;
    }
  }

  Widget _buildLanguageButton(String code, String name, IconData icon) {
    final isSelected = _selectedLanguage == code;
    
    return GestureDetector(
      onTap: () => _selectLanguage(code),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingS,
          vertical: AppTheme.spacingXS,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusS),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.textLight,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppTheme.textOnPrimary : AppTheme.textSecondary,
            ),
            const SizedBox(width: AppTheme.spacingXS),
            Text(
              name,
              style: AppTheme.bodySmall.copyWith(
                color: isSelected ? AppTheme.textOnPrimary : AppTheme.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectLanguage(String languageCode) async {
    if (_selectedLanguage == languageCode) return;
    
    setState(() {
      _selectedLanguage = languageCode;
    });

    // Update the speech service language
    await MultiLanguageSpeechService.setLanguage(languageCode);
    
    // Notify parent widget
    widget.onLanguageChanged?.call(languageCode);
    
    // Show feedback
    if (mounted) {
      final languageName = MultiLanguageSpeechService.supportedLanguages[languageCode] ?? languageCode;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Speech language changed to $languageName'),
          duration: const Duration(seconds: 2),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }
}
