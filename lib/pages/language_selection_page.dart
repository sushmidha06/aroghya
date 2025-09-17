import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../services/multi_language_speech_service.dart';
import '../theme/app_theme.dart';
import '../generated/l10n/app_localizations.dart';

class LanguageSelectionPage extends StatefulWidget {
  final LanguageService? languageService;
  
  const LanguageSelectionPage({super.key, this.languageService});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  late final LanguageService _languageService;
  bool _isLoading = false;
  String? _testingLanguage;

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
          l10n.selectLanguage,
          style: AppTheme.headingSmall.copyWith(color: AppTheme.textOnPrimary),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: AppTheme.elevationS,
        iconTheme: const IconThemeData(color: AppTheme.textOnPrimary),
      ),
      body: Column(
        children: [
          // Header Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spacingL),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.textLight.withOpacity(0.1),
                  blurRadius: AppTheme.elevationS,
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
                      padding: const EdgeInsets.all(AppTheme.spacingS),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      ),
                      child: Icon(
                        Icons.language,
                        color: AppTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.language,
                            style: AppTheme.headingMedium,
                          ),
                          const SizedBox(height: AppTheme.spacingXS),
                          Text(
                            'Current: ${_languageService.currentLanguageName}',
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textSecondary,
                            ),
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
                    color: AppTheme.infoColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                    border: Border.all(
                      color: AppTheme.infoColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppTheme.infoColor,
                        size: 20,
                      ),
                      const SizedBox(width: AppTheme.spacingS),
                      Expanded(
                        child: Text(
                          'Changing language will update both UI and voice recognition',
                          style: AppTheme.bodyMedium.copyWith(
                            color: AppTheme.infoColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Language List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              itemCount: LanguageService.supportedLocales.length,
              itemBuilder: (context, index) {
                final locale = LanguageService.supportedLocales[index];
                final languageCode = locale.languageCode;
                final isSelected = _languageService.isLanguageSelected(languageCode);
                final isTesting = _testingLanguage == languageCode;
                
                return _buildLanguageCard(
                  languageCode: languageCode,
                  displayName: LanguageService.languageNames[languageCode]!,
                  nativeName: LanguageService.nativeLanguageNames[languageCode]!,
                  isSelected: isSelected,
                  isTesting: isTesting,
                );
              },
            ),
          ),
          
          // Footer with speech test
          if (_testingLanguage != null)
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.textLight.withOpacity(0.1),
                    blurRadius: AppTheme.elevationS,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.listeningForSpeech(_languageService.currentLanguageName),
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _stopTesting,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.errorColor,
                          foregroundColor: AppTheme.textOnPrimary,
                        ),
                        icon: const Icon(Icons.stop),
                        label: Text(l10n.cancel),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _testSpeechRecognition(_testingLanguage!),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: AppTheme.textOnPrimary,
                        ),
                        icon: Icon(
                          MultiLanguageSpeechService.isListening 
                            ? Icons.mic 
                            : Icons.mic_none,
                        ),
                        label: Text(l10n.speakNow),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard({
    required String languageCode,
    required String displayName,
    required String nativeName,
    required bool isSelected,
    required bool isTesting,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacingS),
      child: Material(
        color: isSelected ? AppTheme.primaryColor.withOpacity(0.1) : AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
          onTap: _isLoading ? null : () => _selectLanguage(languageCode),
          child: Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              border: Border.all(
                color: isSelected 
                  ? AppTheme.primaryColor 
                  : AppTheme.textLight.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Language Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isSelected 
                      ? AppTheme.primaryColor 
                      : AppTheme.textLight.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusS),
                  ),
                  child: Center(
                    child: Text(
                      _getLanguageFlag(languageCode),
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
                
                const SizedBox(width: AppTheme.spacingM),
                
                // Language Names
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nativeName,
                        style: AppTheme.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXS),
                      Text(
                        displayName,
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Actions
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Test Speech Button
                    IconButton(
                      onPressed: _isLoading ? null : () => _testSpeechRecognition(languageCode),
                      icon: Icon(
                        isTesting ? Icons.mic : Icons.mic_none,
                        color: isTesting ? AppTheme.errorColor : AppTheme.textSecondary,
                      ),
                      tooltip: 'Test speech recognition',
                    ),
                    
                    // Selection Indicator
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingXS),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(AppTheme.radiusS),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: AppTheme.textOnPrimary,
                          size: 16,
                        ),
                      )
                    else
                      const SizedBox(width: 32),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getLanguageFlag(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '🇺🇸';
      case 'hi':
        return '🇮🇳';
      case 'ta':
        return '🇮🇳';
      case 'te':
        return '🇮🇳';
      case 'bn':
        return '🇧🇩';
      default:
        return '🌐';
    }
  }

  Future<void> _selectLanguage(String languageCode) async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
    });

    try {
      await _languageService.changeLanguage(languageCode);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Language changed to ${LanguageService.languageNames[languageCode]}',
            ),
            backgroundColor: AppTheme.successColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error changing language: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _testSpeechRecognition(String languageCode) async {
    try {
      // Set the language for testing
      await MultiLanguageSpeechService.setLanguage(languageCode);
      
      setState(() {
        _testingLanguage = languageCode;
      });

      await MultiLanguageSpeechService.startListening(
        onResult: (result) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Recognized: $result'),
                backgroundColor: AppTheme.successColor,
              ),
            );
            _stopTesting();
          }
        },
        onError: (error) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Speech error: $error'),
                backgroundColor: AppTheme.errorColor,
              ),
            );
            _stopTesting();
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error testing speech: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        _stopTesting();
      }
    }
  }

  void _stopTesting() {
    if (mounted) {
      setState(() {
        _testingLanguage = null;
      });
    }
  }

  @override
  void dispose() {
    // Cancel any ongoing speech recognition without calling setState
    MultiLanguageSpeechService.cancelListening();
    _testingLanguage = null;
    super.dispose();
  }
}
