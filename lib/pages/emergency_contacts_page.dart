import 'package:aroghya_ai/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'nearby_hospitals_page.dart';

class EmergencyContactsPage extends StatelessWidget {
  const EmergencyContactsPage({super.key});

  // Dummy emergency contacts
  final List<Map<String, dynamic>> contacts = const [
    {"name": "Ambulance", "phone": "108", "priority": true},
    {"name": "Local Clinic", "phone": "9876543210", "priority": true},
    {"name": "Family - Dad", "phone": "9876543211", "priority": false},
    {"name": "Family - Mom", "phone": "9876543212", "priority": false},
    {"name": "Health Helpline", "phone": "1800123456", "priority": false},
  ];

  // Function to make a phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri url = Uri.parse("tel:$phoneNumber");
    if (!await launchUrl(url)) {
      throw Exception("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    Color primaryColor = AppTheme.primaryColor;
    Color criticalColor = Colors.red.shade600;

    // Sort: priority contacts first
    List<Map<String, dynamic>> sortedContacts = [...contacts];
    sortedContacts.sort(
        (a, b) => (b["priority"] ? 1 : 0) - (a["priority"] ? 1 : 0));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        title: Text(
          "Emergency Contacts",
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: screenWidth * 0.05, 
            color: Colors.white
          ),
        ),
        centerTitle: true,
      ),

      body: ListView.separated(
        padding: EdgeInsets.all(screenWidth * 0.04),
        itemCount: sortedContacts.length,
        separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0.015),
        itemBuilder: (context, index) {
          final contact = sortedContacts[index];
          final isPriority = contact["priority"];

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: isPriority ? criticalColor : Colors.grey.shade300,
                  width: isPriority ? 1.5 : 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, 
                vertical: screenHeight * 0.015
              ),
              leading: CircleAvatar(
                radius: screenWidth * 0.065,
                backgroundColor: isPriority
                    ? criticalColor.withValues(alpha: 0.15)
                    : primaryColor.withValues(alpha: 0.15),
                child: Icon(
                  Icons.phone,
                  color: isPriority ? criticalColor : primaryColor, 
                  size: screenWidth * 0.065
                ),
              ),
              title: Text(
                contact["name"],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.04,
                  color: isPriority ? criticalColor : primaryColor,
                ),
              ),
              subtitle: Text(
                contact["phone"],
                style: TextStyle(
                  color: Colors.grey.shade700, 
                  fontSize: screenWidth * 0.035
                ),
              ),
              trailing: ElevatedButton(
                onPressed: () => _makePhoneCall(contact["phone"]),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPriority ? criticalColor : primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.045, 
                    vertical: screenHeight * 0.012
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Call",
                  style: TextStyle(
                    fontSize: screenWidth * 0.035, 
                    color: Colors.white
                  )
                ),
              ),
            ),
          );
        },
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryColor,
        icon: const Icon(Icons.local_hospital, color: Colors.white),
        label: Text(
          "Nearby Hospitals",
          style: TextStyle(
            color: Colors.white, 
            fontSize: screenWidth * 0.035
          )
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NearbyHospitalsPage(),
            ),
          );
        },
      ),
    );
  }
}
