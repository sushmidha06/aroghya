import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../services/gemma_ai_service.dart';
import '../models/symptom_report.dart';
import '../theme/app_theme.dart';

class AIRecommendationsPage extends StatefulWidget {
  const AIRecommendationsPage({super.key});

  @override
  State<AIRecommendationsPage> createState() => _AIRecommendationsPageState();
}

class _AIRecommendationsPageState extends State<AIRecommendationsPage> {
  Map<String, dynamic>? _recommendationsData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      // Load symptom reports from Hive to generate recommendations
      final box = await Hive.openBox<SymptomReport>('symptom_reports');
      final reports = box.values.toList();
      
      Map<String, dynamic> data;
      
      if (reports.isNotEmpty) {
        // Use the existing method that generates recommendations from symptom reports
        data = await GemmaAIService.generateTensorFlowRecommendations();
      } else {
        // Provide default recommendations if no symptom data exists
        data = {
          'recommendations': [
            {
              'title': 'Welcome to AI Health Recommendations',
              'description': 'Complete a symptom check to get personalized health recommendations',
              'category': 'Getting Started',
              'priority': 'Medium',
              'icon': 'info',
              'color': 'blue',
              'items': [
                'Use the Symptom Checker to analyze your health',
                'Get AI-powered medical insights',
                'Receive personalized recommendations',
                'Track your health over time'
              ],
            }
          ],
          'healthScore': 85,
          'lastUpdated': DateTime.now().toIso8601String(),
        };
      }
      
      setState(() {
        _recommendationsData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text('AI Health Recommendations', 
            style: AppTheme.headingSmall.copyWith(color: AppTheme.textOnPrimary)),
        backgroundColor: AppTheme.primaryColor,
        iconTheme: const IconThemeData(color: AppTheme.textOnPrimary),
        elevation: AppTheme.elevationS,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: AppTheme.errorColor),
                      const SizedBox(height: AppTheme.spacingM),
                      Text('Error loading recommendations', style: AppTheme.headingSmall),
                      const SizedBox(height: AppTheme.spacingS),
                      Text(_error!, textAlign: TextAlign.center, style: AppTheme.bodyMedium),
                      const SizedBox(height: AppTheme.spacingM),
                      ElevatedButton(
                        onPressed: _loadRecommendations,
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Health Score Card ---
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(screenWidth * 0.04),
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[50],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'AI Health Score',
                                    style: TextStyle(
                                      fontSize: screenWidth * 0.04,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    'Overall Risk Level: ${_recommendationsData?['riskLevel'] ?? 'Unknown'}',
                                    style: TextStyle(fontSize: screenWidth * 0.035),
                                  ),
                                  SizedBox(height: screenHeight * 0.005),
                                  Text(
                                    _recommendationsData?['summary'] ?? 'No summary available',
                                    style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                            CircleAvatar(
                              radius: screenWidth * 0.06,
                              backgroundColor: AppTheme.primaryColor,
                              child: Text(
                                '${_recommendationsData?['healthScore'] ?? 0}%',
                                style: TextStyle(
                                    color: Colors.white, 
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.035),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.02),

                      // --- Recommendations ---
                      if (_recommendationsData?['recommendations'] != null && 
                          _recommendationsData!['recommendations'] is List)
                        ...(_recommendationsData!['recommendations'] as List).map((rec) {
                final colorName = (rec['color'] is String && rec['color'] != null) ? rec['color'] as String : 'blue';
                final iconName = (rec['icon'] is String && rec['icon'] != null) ? rec['icon'] as String : '';
                final title = (rec['title'] is String && rec['title'] != null) ? rec['title'] as String : 'Recommendation';
                return Container(
                  margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  decoration: BoxDecoration(
                    color: _getColorFromString(colorName).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _getIconFromString(iconName),
                            color: _getColorFromString(colorName),
                            size: screenWidth * 0.07,
                          ),
                          SizedBox(width: screenWidth * 0.03),
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                  fontSize: screenWidth * 0.04, 
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      ...(rec['items'] as List? ?? []).map<Widget>((item) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.002),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.arrow_right, size: screenWidth * 0.05),
                              SizedBox(width: screenWidth * 0.015),
                              Expanded(
                                child: Text(
                                  item,
                                  style: TextStyle(fontSize: screenWidth * 0.035),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      SizedBox(height: screenHeight * 0.01),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Follow-up scheduled for $title'),
                              ),
                            );
                          },
                          icon: Icon(Icons.calendar_today, size: screenWidth * 0.04),
                          label: Text('Schedule Follow-up', style: TextStyle(fontSize: screenWidth * 0.035)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getColorFromString(colorName),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
            }).toList(),

            SizedBox(height: screenHeight * 0.02),
            // --- Daily Tips ---
            Text(
              "Daily Health Tips",
              style: TextStyle(
                fontSize: screenWidth * 0.045, 
                fontWeight: FontWeight.bold, 
                color: AppTheme.primaryColor
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            SizedBox(
              height: screenHeight * 0.12,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _TipCard(text: 'Stay hydrated', icon: Icons.water, screenWidth: screenWidth, screenHeight: screenHeight),
                  _TipCard(text: 'Take short breaks', icon: Icons.timer, screenWidth: screenWidth, screenHeight: screenHeight),
                  _TipCard(text: 'Take a 10-min walk', icon: Icons.directions_walk, screenWidth: screenWidth, screenHeight: screenHeight),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.025),
            // --- Emergency Section ---
            Text(
              "Emergency",
              style: TextStyle(
                fontSize: screenWidth * 0.045, 
                fontWeight: FontWeight.bold, 
                color: AppTheme.primaryColor
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Calling emergency contact...")),
                  );
                },
                icon: Icon(Icons.call, size: screenWidth * 0.05),
                label: Text("Call Doctor / Ambulance", style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorFromString(String colorName) {
    switch (colorName) {
      case 'orangeAccent':
        return Colors.orangeAccent;
      case 'teal':
        return Colors.teal;
      case 'lightBlue':
        return Colors.lightBlue;
      case 'purpleAccent':
        return Colors.purpleAccent;
      case 'redAccent':
        return Colors.redAccent;
      case 'green':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'restaurant_menu':
        return Icons.restaurant_menu;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'medical_services':
        return Icons.medical_services;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'warning':
        return Icons.warning;
      case 'health_and_safety':
        return Icons.health_and_safety;
      default:
        return Icons.info;
    }
  }
}

// --- Tip Card Widget ---
class _TipCard extends StatelessWidget {
  final String text;
  final IconData icon;
  final double screenWidth;
  final double screenHeight;

  const _TipCard({
    required this.text, 
    required this.icon, 
    required this.screenWidth, 
    required this.screenHeight
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth * 0.35,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.015),
      padding: EdgeInsets.all(screenWidth * 0.03),
      decoration: BoxDecoration(
        color: Colors.yellow[50],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.orange, size: screenWidth * 0.07),
          SizedBox(height: screenHeight * 0.01),
          Text(
            text,
            style: TextStyle(fontSize: screenWidth * 0.035),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
