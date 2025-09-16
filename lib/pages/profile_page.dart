import 'package:flutter/material.dart';
import 'package:aroghya_ai/models/user.dart';
import 'package:aroghya_ai/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User? currentUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await AuthService.getCurrentUser();
    setState(() {
      currentUser = user;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF1E2432);
    
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (currentUser == null) {
      return const Scaffold(
        body: Center(child: Text('No user data found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Picture and Basic Info
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    currentUser!.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentUser!.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Profile Information Cards
            _buildInfoCard('Personal Information', [
              _buildInfoRow('Full Name', currentUser!.name),
              _buildInfoRow('Email', currentUser!.email),
              _buildInfoRow('Date of Birth', 
                '${currentUser!.dateOfBirth.day}/${currentUser!.dateOfBirth.month}/${currentUser!.dateOfBirth.year}'),
              _buildInfoRow('Medical Condition', currentUser!.disease),
            ]),
            
            const SizedBox(height: 20),
            
            // Health Summary Card
            _buildInfoCard('Health Summary', [
              _buildInfoRow('Age', _calculateAge(currentUser!.dateOfBirth).toString()),
              _buildInfoRow('Last Check-up', '12 Sep 2025'),
              _buildInfoRow('Health Score', '85%'),
              _buildInfoRow('Active Medications', '2'),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E2432),
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E2432),
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _calculateAge(DateTime birthDate) {
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month || 
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    return age;
  }
}
