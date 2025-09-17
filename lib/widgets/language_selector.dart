import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../theme/app_theme.dart';

class LanguageSelector extends StatefulWidget {
  final Function(String)? onLanguageChanged;
  
  const LanguageSelector({
    Key? key,
    this.onLanguageChanged,
  }) : super(key: key);

  @override
  State<LanguageSelector> createState() => _LanguageSelectorState();
}

class _LanguageSelectorState extends State<LanguageSelector> {
  final LanguageService _languageService = LanguageService();
  String _currentLocale = 'en';
  
  @override
  void initState() {
    super.initState();
    _currentLocale = _languageService.currentLanguageCode;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(color: AppTheme.textLight.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _currentLocale,
          icon: Icon(Icons.language, color: AppTheme.primaryColor),
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
          dropdownColor: AppTheme.surfaceColor,
          items: _languageService.getSupportedLanguages().entries.map((entry) {
            final String locale = entry.key;
            final String name = entry.value;
            return DropdownMenuItem<String>(
              value: locale,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _getLanguageFlag(locale),
                  const SizedBox(width: 8),
                  Text(
                    name,
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (String? newValue) async {
            if (newValue != null) {
              setState(() {
                _currentLocale = newValue;
              });
              await _languageService.changeLanguage(newValue);
              widget.onLanguageChanged?.call(newValue);
              
              // Show success message
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Language changed to ${_languageService.getSupportedLanguages()[newValue] ?? newValue}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: AppTheme.primaryColor,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  Widget _getLanguageFlag(String locale) {
    switch (locale) {
      case 'en':
        return const Text('🇺🇸', style: TextStyle(fontSize: 16));
      case 'hi':
        return const Text('🇮🇳', style: TextStyle(fontSize: 16));
      case 'ta':
        return const Text('🇮🇳', style: TextStyle(fontSize: 16));
      case 'te':
        return const Text('🇮🇳', style: TextStyle(fontSize: 16));
      case 'bn':
        return const Text('🇮🇳', style: TextStyle(fontSize: 16));
      default:
        return const Icon(Icons.language, size: 16);
    }
  }
}
