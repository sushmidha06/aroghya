import 'package:flutter/material.dart';

class SymptomCheckerPage extends StatefulWidget {
  const SymptomCheckerPage({super.key});

  @override
  State<SymptomCheckerPage> createState() => _SymptomCheckerPageState();
}

class _SymptomCheckerPageState extends State<SymptomCheckerPage> {
  final TextEditingController _symptomController = TextEditingController();
  bool _showResult = false;

  // Dummy AI results
  final List<Map<String, dynamic>> _aiResults = [
    {
      'condition': 'Common Cold',
      'confidence': 85,
      'severity': 'Mild',
      'nextSteps': [
        {'icon': Icons.water_drop_outlined, 'text': 'Stay hydrated and drink warm fluids'},
        {'icon': Icons.hotel_outlined, 'text': 'Get plenty of rest'},
        {'icon': Icons.local_pharmacy_outlined, 'text': 'Consider over-the-counter pain relievers'},
      ],
      'medications': ['Paracetamol 500mg', 'Vitamin C 1000mg']
    },
    {
      'condition': 'Flu',
      'confidence': 65,
      'severity': 'Moderate',
      'nextSteps': [
        {'icon': Icons.thermostat_outlined, 'text': 'Monitor your temperature regularly'},
        {'icon': Icons.local_hospital_outlined, 'text': 'A doctor visit is recommended'},
        {'icon': Icons.masks_outlined, 'text': 'Isolate to prevent spreading'},
      ],
      'medications': ['Oseltamivir 75mg', 'Ibuprofen 400mg']
    },
  ];

  // Symptom chips
  final List<String> _symptomOptions = [
    "Fever", "Cough", "Headache", "Fatigue", "Nausea", "Sore Throat"
  ];
  final List<String> _selectedSymptoms = [];

  // Symptom history
  final List<String> _history = [
    "Checked Cold on 12 Sep 2025",
    "Checked Flu on 08 Sep 2025",
  ];

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF1E2432); // Dark Navy
    final Color redAccent = const Color(0xFFFF6B6B);
    
    // Using MediaQuery for responsive layout
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('AI Symptom Checker', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04), // Responsive padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Symptom Input ---
            _buildSectionTitle("Describe Your Symptoms", screenWidth),
            SizedBox(height: screenHeight * 0.015),
            TextField(
              controller: _symptomController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'e.g., "I have a persistent cough and a high fever..."',
                filled: true,
                fillColor: Colors.grey[100],
                suffixIcon: IconButton(
                  icon: const Icon(Icons.mic, color: Colors.blueAccent),
                  onPressed: () {},
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.015),

            // --- Symptom Chips ---
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: _symptomOptions.map((symptom) {
                final isSelected = _selectedSymptoms.contains(symptom);
                return ChoiceChip(
                  label: Text(symptom),
                  selected: isSelected,
                  selectedColor: primaryColor,
                  backgroundColor: Colors.grey[200],
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black87,
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
                );
              }).toList(),
            ),
            SizedBox(height: screenHeight * 0.03),

            // --- Vitals Input ---
            _buildSectionTitle("Enter Your Vitals (Optional)", screenWidth),
            SizedBox(height: screenHeight * 0.015),
            _buildVitalsInput(),
            SizedBox(height: screenHeight * 0.03),

            // --- Analyze Button ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _showResult = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.smart_toy_outlined),
                label: Text(
                  "Analyze Symptoms",
                  style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.03),

            // --- AI Results Section ---
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: _showResult
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle("AI Analysis Results", screenWidth),
                        SizedBox(height: screenHeight * 0.015),
                        ..._aiResults.map((result) => _buildResultCard(result, primaryColor, screenHeight, screenWidth)),
                      ],
                    )
                  : const SizedBox.shrink(), // Show nothing if no result yet
            ),

            // --- History, Tips, and Emergency Sections ---
            SizedBox(height: screenHeight * 0.03),
            _buildSectionTitle("History", screenWidth),
            SizedBox(height: screenHeight * 0.015),
            ..._history.map((h) => Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.01),
              child: ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(h),
                    tileColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
            )),

            SizedBox(height: screenHeight * 0.03),
            _buildSectionTitle("Emergency", screenWidth),
            SizedBox(height: screenHeight * 0.015),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                    backgroundColor: redAccent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                icon: const Icon(Icons.call),
                label: Text("Call Doctor / Ambulance", style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- Reusable Helper Widgets ---

  Widget _buildSectionTitle(String title, double screenWidth) {
    return Text(
      title,
      style: TextStyle(
        fontSize: (screenWidth * 0.045).clamp(18.0, 22.0),
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1E2432),
      ),
    );
  }

  Widget _buildVitalsInput() {
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Temp (°C)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
        SizedBox(width: screenWidth * 0.02),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: 'BP (mmHg)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            keyboardType: TextInputType.text,
          ),
        ),
        SizedBox(width: screenWidth * 0.02),
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              labelText: 'Heart Rate',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }

  Widget _buildResultCard(Map<String, dynamic> result, Color primaryColor, double screenHeight, double screenWidth) {
    Color severityColor;
    switch (result['severity']) {
      case 'Mild':
        severityColor = Colors.green;
        break;
      case 'Moderate':
        severityColor = Colors.orange;
        break;
      default:
        severityColor = Colors.red;
    }

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: screenHeight * 0.02),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    result['condition'],
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02, vertical: screenHeight * 0.005),
                  decoration: BoxDecoration(
                    color: severityColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    result['severity'],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: screenHeight * 0.01),
            Text("Confidence: ${result['confidence']}%", style: TextStyle(color: Colors.grey[700], fontSize: screenWidth * 0.035)),
            SizedBox(height: screenHeight * 0.005),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: result['confidence'] / 100,
                color: primaryColor,
                backgroundColor: Colors.grey[300],
                minHeight: screenHeight * 0.01,
              ),
            ),
            Divider(height: screenHeight * 0.03),
            Text("Next Steps:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04)),
            ...result['nextSteps'].map<Widget>((step) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(step['icon'], color: primaryColor),
              title: Text(step['text'], style: TextStyle(fontSize: screenWidth * 0.035)),
            )),
            Divider(height: screenHeight * 0.03),
            Text("Possible Medications:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04)),
             ...result['medications'].map<Widget>((med) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.medication_outlined, color: primaryColor),
              title: Text(med, style: TextStyle(fontSize: screenWidth * 0.035)),
            )),
          ],
        ),
      ),
    );
  }
}
