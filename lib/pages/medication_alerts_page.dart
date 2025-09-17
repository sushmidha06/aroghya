import 'package:aroghya_ai/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'medication_scanner_page.dart';

class MedicationAlertsPage extends StatefulWidget {
  const MedicationAlertsPage({super.key});

  @override
  State<MedicationAlertsPage> createState() => _MedicationAlertsPageState();
}

class _MedicationAlertsPageState extends State<MedicationAlertsPage> {
  List<Map<String, dynamic>> medications = [];

  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  Future<void> _loadMedications() async {
    // This will be implemented to load from Hive database
    // For now, keeping empty list
  }

  void _toggleAlert(int index) {
    setState(() {
      medications[index]["isEnabled"] = !medications[index]["isEnabled"];
    });
  }

  void _deleteMedication(int index) {
    setState(() {
      medications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    Color primaryColor = AppTheme.primaryColor;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text(
          "Medication Alerts",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MedicationScannerPage(),
                ),
              );
            },
          ),
        ],
      ),

      body: medications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medication_outlined,
                    size: screenWidth * 0.2,
                    color: Colors.grey,
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "No medications added yet",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "Tap the + button to add your first medication",
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: EdgeInsets.all(screenWidth * 0.04),
              itemCount: medications.length,
              separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0.015),
              itemBuilder: (context, index) {
                final medication = medications[index];
                final isEnabled = medication["isEnabled"];

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isEnabled ? primaryColor.withValues(alpha: 0.3) : Colors.grey.shade300,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(screenWidth * 0.025),
                              decoration: BoxDecoration(
                                color: isEnabled 
                                    ? primaryColor.withValues(alpha: 0.15)
                                    : Colors.grey.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.medication,
                                color: isEnabled ? primaryColor : Colors.grey,
                                size: screenWidth * 0.06,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    medication["name"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.045,
                                      color: isEnabled ? Colors.black87 : Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    "${medication["dosage"]} • ${medication["time"]}",
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: screenWidth * 0.035,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: isEnabled,
                              onChanged: (_) => _toggleAlert(index),
                              activeColor: primaryColor,
                            ),
                          ],
                        ),
                        
                        if (isEnabled) ...[
                          SizedBox(height: screenHeight * 0.015),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03,
                              vertical: screenHeight * 0.008,
                            ),
                            decoration: BoxDecoration(
                              color: primaryColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.notifications_active,
                                  size: screenWidth * 0.04,
                                  color: primaryColor,
                                ),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  "Alert enabled",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontSize: screenWidth * 0.03,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        
                        SizedBox(height: screenHeight * 0.015),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton.icon(
                              onPressed: () => _deleteMedication(index),
                              icon: Icon(
                                Icons.delete_outline,
                                size: screenWidth * 0.04,
                                color: Colors.red,
                              ),
                              label: Text(
                                "Remove",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          "Add Medication",
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.035,
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MedicationScannerPage(),
            ),
          );
        },
      ),
    );
  }
}
