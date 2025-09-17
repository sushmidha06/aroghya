import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../services/gemma_ai_service.dart';
import '../services/multi_language_speech_service.dart';
import '../models/symptom_report.dart';
import '../theme/app_theme.dart';
import '../generated/l10n/app_localizations.dart';
import '../widgets/language_selector_widget.dart';

class SymptomCheckerPage extends StatefulWidget {
  const SymptomCheckerPage({super.key});

  @override
  State<SymptomCheckerPage> createState() => _SymptomCheckerPageState();
}

class _SymptomCheckerPageState extends State<SymptomCheckerPage>
    with TickerProviderStateMixin {
  final TextEditingController _symptomController = TextEditingController();
  final TextEditingController _tempController = TextEditingController();
  final TextEditingController _bpController = TextEditingController();
  final TextEditingController _hrController = TextEditingController();

  bool _showResult = false;
  bool _isAnalyzing = false;
  bool _isListening = false;
  List<Map<String, dynamic>> _aiResults = [];
  late AnimationController _loadingController;

  // Enhanced symptom options - will be localized in build method
  List<String> _getSymptomOptions(AppLocalizations l10n) => [
    l10n.fever, l10n.cough, l10n.headache, l10n.fatigue, l10n.nausea, l10n.soreThroat,
    l10n.bodyAche, l10n.runnyNose, l10n.chestPain, l10n.dizziness, "Vomiting",
    "Diarrhea", l10n.shortnessOfBreath, "Loss of Taste", "Loss of Smell"
  ];
  final List<String> _selectedSymptoms = [];

  // Dynamic history loaded from Hive
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    // Initialize services asynchronously
    _initializeServices();
    _loadHistoryFromHive();
  }

  // Initialize services asynchronously to avoid blocking UI
  Future<void> _initializeServices() async {
    try {
      await GemmaAIService.initialize();
      await MultiLanguageSpeechService.initialize();
    } catch (e) {
      print('Error initializing services: $e');
    }
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  // Load history from Hive database
  Future<void> _loadHistoryFromHive() async {
    try {
      final box = await Hive.openBox<SymptomReport>('symptom_reports');
      final reports = box.values.toList();
      
      setState(() {
        _history = reports.map((report) => {
          'symptoms': report.symptoms.join(', '),
          'condition': report.condition,
          'date': _formatDate(report.timestamp),
          'confidence': report.confidence,
          'severity': report.severity,
        }).toList();
      });
    } catch (e) {
  // TODO: Use a logging framework instead of print
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')} ${_getMonthName(date.month)} ${date.year}';
  }

  String _getMonthName(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  // Clear history
  Future<void> _clearHistory() async {
    try {
      final box = await Hive.openBox<SymptomReport>('symptom_reports');
      await box.clear();
      setState(() {
        _history.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('History cleared successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error clearing history: $e')),
      );
    }
  }

  // Show clear history confirmation dialog
  void _showClearHistoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text('Clear History'),
            ],
          ),
          content: Text('Are you sure you want to clear all symptom history? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _clearHistory();
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text('Clear All', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // Speech recognition methods
  Future<void> _toggleSpeechRecognition() async {
    if (_isListening) {
      await _stopListening();
    } else {
      await _startListening();
    }
  }

  Future<void> _startListening() async {
    setState(() {
      _isListening = true;
    });

    await MultiLanguageSpeechService.startListening(
      onResult: (result) {
        setState(() {
          _symptomController.text = result;
          _isListening = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Voice input completed: $result'),
            backgroundColor: Colors.green,
          ),
        );
      },
      onError: (error) {
        setState(() {
          _isListening = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Speech recognition error: $error'),
            backgroundColor: Colors.red,
          ),
        );
      },
    );
  }

  Future<void> _stopListening() async {
    await MultiLanguageSpeechService.stopListening();
    setState(() {
      _isListening = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(l10n.symptomChecker, 
            style: AppTheme.headingSmall.copyWith(color: AppTheme.textOnPrimary)),
        backgroundColor: AppTheme.primaryColor,
        iconTheme: const IconThemeData(color: AppTheme.textOnPrimary),
        elevation: AppTheme.elevationS,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => _showHistoryDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Language Selector
            const LanguageSelectorWidget(),
            const SizedBox(height: AppTheme.spacingM),
            
            // AI Status Indicator
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingM),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppTheme.primaryColor.withValues(alpha: 0.1), AppTheme.accentBlue.withValues(alpha: 0.1)],
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusM),
                border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.smart_toy, color: AppTheme.primaryColor, size: screenWidth * 0.06),
                  SizedBox(width: screenWidth * 0.03),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Local Gemma 3 AI Ready',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.04,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        Text(
                          'Advanced symptom analysis with medical knowledge base',
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'ONLINE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.03,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            // Symptom Input Section
            _buildSectionTitle("Describe Your Symptoms", screenWidth),
            SizedBox(height: screenHeight * 0.015),
            TextField(
              controller: _symptomController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'e.g., "I have a persistent cough, high fever, and feel very tired..."',
                filled: true,
                fillColor: AppTheme.backgroundColor,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isListening ? Icons.mic : Icons.mic_none,
                    color: _isListening ? AppTheme.errorColor : AppTheme.primaryColor,
                  ),
                  onPressed: _toggleSpeechRecognition,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.015),

            // Enhanced Symptom Chips
            Text(
              l10n.quickSelectSymptoms,
              style: AppTheme.headingSmall,
            ),
            const SizedBox(height: AppTheme.spacingS),
            Wrap(
              spacing: AppTheme.spacingS,
              runSpacing: AppTheme.spacingXS,
              children: _getSymptomOptions(l10n).map((symptom) {
                final isSelected = _selectedSymptoms.contains(symptom);
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: ChoiceChip(
                    label: Text(symptom),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryColor,
                    backgroundColor: AppTheme.backgroundColor,
                    labelStyle: TextStyle(
                      color: isSelected ? AppTheme.textOnPrimary : AppTheme.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _selectedSymptoms.add(symptom);
                        } else {
                          _selectedSymptoms.remove(symptom);
                        }
                      });
                    },
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: screenHeight * 0.03),

            // Enhanced Vitals Input
            _buildSectionTitle("Enter Your Vitals (Optional)", screenWidth),
            SizedBox(height: screenHeight * 0.015),
            _buildEnhancedVitalsInput(),
            SizedBox(height: screenHeight * 0.03),

            // Enhanced Analyze Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isAnalyzing ? null : () async {
                  if (_symptomController.text.isEmpty && _selectedSymptoms.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please describe your symptoms first!')),
                    );
                    return;
                  }
                  
                  await _analyzeSymptoms();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isAnalyzing ? AppTheme.textLight : AppTheme.primaryColor,
                  foregroundColor: AppTheme.textOnPrimary,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  ),
                ),
                icon: _isAnalyzing
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.textOnPrimary),
                        ),
                      )
                    : const Icon(Icons.psychology_outlined),
                label: Text(
                  _isAnalyzing ? "Analyzing with Gemma 3..." : "Analyze Symptoms with AI",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // AI Results Section with enhanced animations
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 800),
              transitionBuilder: (child, animation) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.3),
                    end: Offset.zero,
                  ).animate(animation),
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: _showResult && _aiResults.isNotEmpty
                  ? Column(
                      key: const ValueKey('results'),
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.psychology, color: AppTheme.primaryColor),
                            SizedBox(width: screenWidth * 0.02),
                            _buildSectionTitle("Gemma 3 AI Analysis Results", screenWidth),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        ..._aiResults.map((result) => _buildEnhancedResultCard(
                            result, AppTheme.primaryColor, screenHeight, screenWidth)),
                        
                        // Disclaimer
                        Container(
                          margin: EdgeInsets.only(top: screenHeight * 0.02),
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber, color: Colors.amber[700]),
                              SizedBox(width: screenWidth * 0.03),
                              Expanded(
                                child: Text(
                                  'This AI analysis is for informational purposes only. Always consult with a qualified healthcare professional for proper medical diagnosis and treatment.',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    color: Colors.amber[800],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : _showResult && _aiResults.isEmpty
                      ? Container(
                          key: const ValueKey('no-results'),
                          padding: EdgeInsets.all(screenWidth * 0.04),
                          child: Text(
                            'Unable to analyze symptoms. Please provide more specific symptom information.',
                            style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
            ),

            // Emergency Section (Enhanced)
            SizedBox(height: screenHeight * 0.03),
            _buildSectionTitle("Emergency Actions", screenWidth),
            SizedBox(height: screenHeight * 0.015),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showEmergencyDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.local_hospital),
                    label: Text(
                      "Emergency",
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showTelehealthDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.video_call),
                    label: Text(
                      "Telehealth",
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widgets (Enhanced)

  Widget _buildSectionTitle(String title, double screenWidth) {
    return Text(
      title,
      style: AppTheme.headingSmall,
    );
  }

  Widget _buildEnhancedVitalsInput() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _tempController,
                decoration: InputDecoration(
                  labelText: 'Temperature (°C)',
                  hintText: '37.5',
                  prefixIcon: const Icon(Icons.thermostat),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(width: screenWidth * 0.02),
            Expanded(
              child: TextField(
                controller: _hrController,
                decoration: InputDecoration(
                  labelText: 'Heart Rate (bpm)',
                  hintText: '72',
                  prefixIcon: const Icon(Icons.favorite),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        SizedBox(height: screenWidth * 0.03),
        TextField(
          controller: _bpController,
          decoration: InputDecoration(
            labelText: 'Blood Pressure (mmHg)',
            hintText: '120/80',
            prefixIcon: const Icon(Icons.monitor_heart),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }

  Widget _buildEnhancedResultCard(Map<String, dynamic> result, Color themeColor, 
      double screenHeight, double screenWidth) {
    final severity = (result['severity'] is String && result['severity'] != null)
        ? result['severity'] as String
        : 'Severe';
    Color severityColor;
    IconData severityIcon;
    switch (severity) {
      case 'Mild':
        severityColor = Colors.green;
        severityIcon = Icons.check_circle;
        break;
      case 'Moderate':
        severityColor = Colors.orange;
        severityIcon = Icons.warning;
        break;
      default:
        severityColor = Colors.red;
        severityIcon = Icons.error;
    }

    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (result['condition'] is String && result['condition'] != null)
                            ? result['condition'] as String
                            : 'Unknown Condition',
                        style: AppTheme.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      Text(
                        (result['description'] is String && result['description'] != null)
                            ? result['description'] as String
                            : 'No description available.',
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.03,
                    vertical: screenHeight * 0.008,
                  ),
                  decoration: BoxDecoration(
                    color: severityColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        severityIcon,
                        color: Colors.white,
                        size: screenWidth * 0.04,
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      Text(
                        severity,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.035,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.015),

            // Confidence Indicator
            Row(
              children: [
                Text(
                  "AI Confidence: ${result['confidence'] is num && result['confidence'] != null ? result['confidence'] : 0}%",
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: screenWidth * 0.035,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                Icon(
                  (result['confidence'] is num && result['confidence'] != null && result['confidence'] >= 80)
                      ? Icons.verified
                      : (result['confidence'] is num && result['confidence'] != null && result['confidence'] >= 60)
                          ? Icons.info
                          : Icons.help,
                  color: (result['confidence'] is num && result['confidence'] != null && result['confidence'] >= 80)
                      ? Colors.green
                      : (result['confidence'] is num && result['confidence'] != null && result['confidence'] >= 60)
                          ? Colors.orange
                          : Colors.grey,
                  size: screenWidth * 0.045,
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (result['confidence'] is num && result['confidence'] != null)
                    ? (result['confidence'] as num) / 100
                    : 0.0,
                color: (result['confidence'] is num && result['confidence'] != null && result['confidence'] >= 80)
                    ? Colors.green
                    : (result['confidence'] is num && result['confidence'] != null && result['confidence'] >= 60)
                        ? Colors.orange
                        : Colors.grey,
                backgroundColor: Colors.grey[300],
                minHeight: screenHeight * 0.01,
              ),
            ),
            
            Divider(height: screenHeight * 0.03),

            // Next Steps
            Text(
              "Recommended Actions:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.04,
                color: AppTheme.primaryColor,
              ),
            ),
            ...(result['nextSteps'] is List ? result['nextSteps'] as List : []).map<Widget>((step) {
              final icon = (step is Map && step['icon'] is IconData) ? step['icon'] as IconData : Icons.arrow_right;
              final text = (step is Map && step['text'] is String && step['text'] != null) ? step['text'] as String : '';
              return Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.01),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                    child: Icon(icon, color: AppTheme.primaryColor, size: screenWidth * 0.05),
                  ),
                  title: Text(
                    text,
                    style: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                ),
              );
            }),

            Divider(height: screenHeight * 0.03),

            // Medications
            Text(
              "Suggested Over-the-Counter Options:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.04,
                color: AppTheme.primaryColor,
              ),
            ),
            ...(result['medications'] is List ? result['medications'] as List : []).map<Widget>((med) {
              final medText = (med is String) ? med : '';
              return Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.008),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    child: Icon(Icons.medication_outlined, color: Colors.blue, size: screenWidth * 0.045),
                  ),
                  title: Text(
                    medText,
                    style: TextStyle(fontSize: screenWidth * 0.035),
                  ),
                ),
              );
            }),

            Divider(height: screenHeight * 0.03),

            // When to Seek Help
            Container(
              padding: EdgeInsets.all(screenWidth * 0.03),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.priority_high, color: Colors.red, size: screenWidth * 0.05),
                      SizedBox(width: screenWidth * 0.02),
                      Text(
                        "Seek Immediate Medical Help If:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04,
                          color: Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    (result['whenToSeekHelp'] is String && result['whenToSeekHelp'] != null)
                        ? result['whenToSeekHelp'] as String
                        : 'No emergency instructions available.',
                    style: AppTheme.bodyMedium.copyWith(
                      color: AppTheme.primaryColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showHistoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.history, color: const Color(0xFF1E2432)),
              SizedBox(width: 8),
              Text('Symptom History'),
              Spacer(),
              IconButton(
                icon: Icon(Icons.clear_all, color: Colors.red),
                onPressed: () {
                  Navigator.pop(context);
                  _showClearHistoryDialog();
                },
                tooltip: 'Clear History',
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF1E2432).withValues(alpha: 0.1),
                      child: Text('${index + 1}'),
                    ),
                    title: Text(item['condition']),
                    subtitle: Text('${item['symptoms']}\n${item['date']}'),
                    trailing: Text('${item['confidence']}%'),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.emergency, color: Colors.red),
              SizedBox(width: 8),
              Text('Emergency Contacts'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.local_hospital, color: Colors.red),
                title: Text('Emergency Services'),
                subtitle: Text('Call 108 (India) / 911 (US)'),
                trailing: Icon(Icons.call),
                onTap: () {
                  // Implement emergency call functionality
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Emergency calling feature would be implemented here'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.local_pharmacy, color: Colors.blue),
                title: Text('Poison Control'),
                subtitle: Text('Call your local poison control center'),
                trailing: Icon(Icons.call),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Analyze symptoms using Gemini AI
  Future<void> _analyzeSymptoms() async {
    if (_symptomController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your symptoms first')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _showResult = false;
      _aiResults.clear();
    });

    try {
      // Prepare symptoms list from both text input and selected chips
      final symptoms = <String>[];
      
      // Add selected symptoms from chips
      symptoms.addAll(_selectedSymptoms);
      
      // Add symptoms from text input
      if (_symptomController.text.trim().isNotEmpty) {
        final textSymptoms = _symptomController.text
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList();
        symptoms.addAll(textSymptoms);
      }
      
      // Remove duplicates
      final uniqueSymptoms = symptoms.toSet().toList();

      // Prepare vitals
      final vitals = <String, dynamic>{
        'temperature': _tempController.text.isNotEmpty ? _tempController.text : null,
        'bloodPressure': _bpController.text.isNotEmpty ? _bpController.text : null,
        'heartRate': _hrController.text.isNotEmpty ? _hrController.text : null,
      };

      // Get analysis from Gemini AI
      final result = await GemmaAIService.analyzeSymptoms(
        symptoms: uniqueSymptoms,
        vitals: vitals,
        medications: [], // Could be expanded to include medications
      );

      // Create symptom report for Hive storage
      final report = SymptomReport(
        symptoms: uniqueSymptoms,
        condition: result['diagnosis'] ?? 'Unknown',
        confidence: ((result['confidence'] ?? 0.0) as num).round(),
        severity: result['severity'] ?? 'Unknown',
        timestamp: DateTime.now(),
        description: result['description'] ?? '',
        whenToSeekHelp: result['whenToSeekHelp'] ?? '',
        medications: [], // Empty for now, could be expanded
        temperature: vitals['temperature'] != null ? double.tryParse(vitals['temperature'].toString()) : null,
        bloodPressure: vitals['bloodPressure']?.toString(),
        heartRate: vitals['heartRate'] != null ? int.tryParse(vitals['heartRate'].toString()) : null,
        riskFactors: result['riskFactors']?.toString(),
        differentialDiagnosis: result['differentialDiagnosis'] != null ? List<String>.from(result['differentialDiagnosis']) : null,
      );

      // Save to Hive
      final box = await Hive.openBox<SymptomReport>('symptom_reports');
      await box.add(report);

      // Update UI
      setState(() {
        _aiResults = [result];
        _showResult = true;
        _isAnalyzing = false;
      });

      // Reload history
      _loadHistoryFromHive();

    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error analyzing symptoms: $e')),
      );
    }
  }

  void _showTelehealthDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.video_call, color: Colors.blue),
              SizedBox(width: 8),
              Text('Telehealth Options'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.schedule, color: Colors.green),
                title: Text('Book Appointment'),
                subtitle: Text('Schedule a virtual consultation'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Appointment booking feature coming soon!')),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.chat, color: Colors.blue),
                title: Text('Chat with Doctor'),
                subtitle: Text('Get immediate medical advice'),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Chat feature coming soon!')),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}