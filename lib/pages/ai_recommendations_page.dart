import 'package:flutter/material.dart';

class AIRecommendationsPage extends StatelessWidget {
  const AIRecommendationsPage({super.key});

  // Dummy recommendation data
  final List<Map<String, dynamic>> recommendations = const [
    {
      'title': 'Diet Recommendations',
      'items': [
        'Eat 5 servings of fruits & vegetables daily',
        'Drink at least 2 liters of water',
        'Reduce sugar, fried, and processed foods',
      ],
      'icon': Icons.restaurant_menu,
      'color': Colors.orangeAccent,
    },
    {
      'title': 'Exercise Tips',
      'items': [
        'Walk 30 minutes daily',
        'Strength training 2-3 times/week',
        'Practice yoga or stretching',
      ],
      'icon': Icons.fitness_center,
      'color': Colors.teal,
    },
    {
      'title': 'Preventive Care',
      'items': [
        'Stay updated on vaccinations',
        'Schedule routine health check-ups',
        'Regular dental & eye exams',
      ],
      'icon': Icons.medical_services,
      'color': Colors.lightBlue,
    },
    {
      'title': 'Mental Health',
      'items': [
        'Meditation or breathing exercises',
        'Sleep 7-8 hours/night',
        'Reduce screen time & stress',
      ],
      'icon': Icons.self_improvement,
      'color': Colors.purpleAccent,
    },
    {
      'title': 'Priority Alerts',
      'items': [
        'High blood pressure or sugar levels',
        'Symptoms requiring urgent attention',
        'Reminders for medications',
      ],
      'icon': Icons.warning,
      'color': Colors.redAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF1E2432);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('AI Health Recommendations', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
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
                          'Overall Risk Level: Low',
                          style: TextStyle(fontSize: screenWidth * 0.035),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          'Summary: Focus on diet and exercise this week',
                          style: TextStyle(fontSize: screenWidth * 0.03, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: screenWidth * 0.06,
                    backgroundColor: primaryColor,
                    child: Text(
                      '85%',
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
            ...recommendations.map((rec) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: rec['color'].withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          rec['icon'],
                          color: rec['color'],
                          size: screenWidth * 0.07,
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: Text(
                            rec['title'],
                            style: TextStyle(
                                fontSize: screenWidth * 0.04, 
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    ...rec['items'].map<Widget>((item) {
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
                              content: Text('Follow-up scheduled for ${rec['title']}'),
                            ),
                          );
                        },
                        icon: Icon(Icons.calendar_today, size: screenWidth * 0.04),
                        label: Text('Schedule Follow-up', style: TextStyle(fontSize: screenWidth * 0.035)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: rec['color'],
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
                color: primaryColor
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
                color: primaryColor
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
