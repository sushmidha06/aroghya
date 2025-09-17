import 'package:flutter/material.dart';
import 'package:aroghya_ai/theme/app_theme.dart'; // Import your AppTheme file

class MedicationNamePage extends StatefulWidget {
  const MedicationNamePage({super.key});

  @override
  State<MedicationNamePage> createState() => _MedicationNamePageState();
}

class _MedicationNamePageState extends State<MedicationNamePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _addMedication() {
    if (_nameController.text.isNotEmpty &&
        _dosageController.text.isNotEmpty &&
        _timeController.text.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Medication added successfully!'),
          backgroundColor: AppTheme.successColor, // Themed color
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all fields'),
          backgroundColor: AppTheme.errorColor, // Themed color
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The AppBar now automatically uses the appBarTheme from your AppTheme
      appBar: AppBar(
        title: const Text('Add Medication'),
      ),
      // Use the background color from the theme
      backgroundColor: AppTheme.backgroundColor,
      body: Padding(
        // Use consistent spacing from the theme
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Use a predefined text style from the theme
            const Text(
              'Medication Details',
              style: AppTheme.headingMedium,
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Medication Name TextField
            TextField(
              controller: _nameController,
              // Use the predefined input decoration from the theme
              decoration: AppTheme.inputDecoration(
                labelText: 'Medication Name',
                prefixIcon: const Icon(
                  Icons.medication_outlined,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),

            // Dosage TextField
            TextField(
              controller: _dosageController,
              decoration: AppTheme.inputDecoration(
                labelText: 'Dosage (e.g., 500mg)',
                prefixIcon: const Icon(
                  Icons.local_pharmacy_outlined,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),

            // Time TextField
            TextField(
              controller: _timeController,
              decoration: AppTheme.inputDecoration(
                labelText: 'Time (e.g., 8:00 AM, 8:00 PM)',
                prefixIcon: const Icon(
                  Icons.schedule,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),

            const Spacer(),

            // Add Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // Use the predefined button style from the theme
                style: AppTheme.primaryButtonStyle,
                onPressed: _addMedication,
                child: Text(
                  'Add Medication',
                  // Style the text to be bold, color is handled by the button's style
                  style: AppTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textOnPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
          ],
        ),
      ),
    );
  }
}