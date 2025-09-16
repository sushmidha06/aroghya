import 'package:flutter/material.dart';

class AppointmentsPage extends StatefulWidget {
  const AppointmentsPage({super.key});

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  final Color primaryColor = const Color(0xFF1E2432);

  // Dummy appointment data
  final List<Map<String, dynamic>> upcomingAppointments = [
    {
      "doctor": "Dr. Meera Sharma",
      "specialty": "Cardiologist",
      "clinic": "Apollo Clinic",
      "date": "18 Sep 2025",
      "time": "10:30 AM",
      "critical": true,
    },
    {
      "doctor": "Dr. Rajesh Kumar",
      "specialty": "Dermatologist",
      "clinic": "Fortis Health",
      "date": "22 Sep 2025",
      "time": "3:00 PM",
      "critical": false,
    },
  ];

  final List<Map<String, dynamic>> pastAppointments = [
    {
      "doctor": "Dr. Anjali Verma",
      "specialty": "General Physician",
      "clinic": "City Care Hospital",
      "date": "05 Sep 2025",
      "time": "11:00 AM",
    },
    {
      "doctor": "Dr. Sunil Nair",
      "specialty": "ENT Specialist",
      "clinic": "MedLife Clinic",
      "date": "20 Aug 2025",
      "time": "4:30 PM",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Appointments", style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Upcoming Appointments ---
            Text(
              "Upcoming Appointments",
              style: TextStyle(
                  fontSize: screenWidth * 0.045, 
                  fontWeight: FontWeight.bold, 
                  color: primaryColor),
            ),
            SizedBox(height: screenHeight * 0.01),
            ...upcomingAppointments.map((appt) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                padding: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                  color: appt["critical"]
                      ? Colors.red[50]
                      : Colors.lightBlue[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: appt["critical"]
                          ? Colors.redAccent
                          : Colors.lightBlue,
                      width: 1.5),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Doctor & Specialty
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: primaryColor,
                          radius: screenWidth * 0.06,
                          child: Icon(Icons.person, color: Colors.white, size: screenWidth * 0.06),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(appt["doctor"],
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.04, 
                                      fontWeight: FontWeight.bold)),
                              Text(appt["specialty"],
                                  style: TextStyle(
                                      fontSize: screenWidth * 0.035, 
                                      color: Colors.black54)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    // Clinic + Date & Time
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.local_hospital,
                                  size: screenWidth * 0.045, color: Colors.grey),
                              SizedBox(width: screenWidth * 0.015),
                              Expanded(child: Text(appt["clinic"], style: TextStyle(fontSize: screenWidth * 0.035))),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: screenWidth * 0.045, color: Colors.grey),
                            SizedBox(width: screenWidth * 0.015),
                            Text("${appt["date"]}, ${appt["time"]}", style: TextStyle(fontSize: screenWidth * 0.035)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: screenHeight * 0.015),
                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Reschedule option for ${appt["doctor"]}")));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.012),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: Icon(Icons.schedule, size: screenWidth * 0.04),
                            label: Text("Reschedule", style: TextStyle(fontSize: screenWidth * 0.035)),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.03),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Cancelled appointment with ${appt["doctor"]}")));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.012),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: Icon(Icons.cancel, size: screenWidth * 0.04),
                            label: Text("Cancel", style: TextStyle(fontSize: screenWidth * 0.035)),
                          ),
                        ),
                      ],
                    ),
                    if (appt["critical"])
                      Padding(
                        padding: EdgeInsets.only(top: screenHeight * 0.01),
                        child: Row(
                          children: [
                            Icon(Icons.warning, color: Colors.red, size: screenWidth * 0.05),
                            SizedBox(width: screenWidth * 0.015),
                            Expanded(
                              child: Text(
                                "Critical Appointment! Don't miss it.",
                                style: TextStyle(
                                    color: Colors.red, 
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth * 0.035),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),

            SizedBox(height: screenHeight * 0.025),

            // --- Past Appointments ---
            Text(
              "Past Appointments",
              style: TextStyle(
                  fontSize: screenWidth * 0.045, 
                  fontWeight: FontWeight.bold, 
                  color: primaryColor),
            ),
            SizedBox(height: screenHeight * 0.01),
            ...pastAppointments.map((appt) {
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.008),
                child: ListTile(
                  contentPadding: EdgeInsets.all(screenWidth * 0.04),
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: screenWidth * 0.06,
                    child: Icon(Icons.person, color: Colors.black54, size: screenWidth * 0.06),
                  ),
                  title: Text(appt["doctor"], style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500)),
                  subtitle: Text("${appt["specialty"]} • ${appt["clinic"]}", style: TextStyle(fontSize: screenWidth * 0.035)),
                  trailing: Text(
                    "${appt["date"]}\n${appt["time"]}",
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: screenWidth * 0.03),
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Redirecting to booking page...")));
        },
        icon: Icon(Icons.add, size: screenWidth * 0.05),
        label: Text("Book Appointment", style: TextStyle(fontSize: screenWidth * 0.035)),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
