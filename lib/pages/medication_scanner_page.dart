import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../services/ocr_service.dart';
import '../models/medication.dart';

class MedicationScannerPage extends StatefulWidget {
  const MedicationScannerPage({super.key});

  @override
  State<MedicationScannerPage> createState() => _MedicationScannerPageState();
}

class _MedicationScannerPageState extends State<MedicationScannerPage> {
  bool _isScanning = false;
  Map<String, dynamic>? _extractedData;
  bool _showConfirmation = false;

  // Controllers for editing extracted data
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _daysController = TextEditingController();
  final TextEditingController _timingController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _frequencyController.dispose();
    _daysController.dispose();
    _timingController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _scanWithCamera() async {
    setState(() {
      _isScanning = true;
    });

    try {
      final result = await OCRService.scanMedicationDetails(useCamera: true);
      if (result != null) {
        _handleScanResult(result);
      }
    } catch (e) {
      _showErrorDialog('Camera scan failed: $e');
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  Future<void> _scanFromGallery() async {
    setState(() {
      _isScanning = true;
    });

    try {
      final result = await OCRService.scanMedicationDetails(useCamera: false);
      if (result != null) {
        _handleScanResult(result);
      }
    } catch (e) {
      _showErrorDialog('Gallery scan failed: $e');
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  void _handleScanResult(Map<String, dynamic> result) {
    setState(() {
      _extractedData = result;
      _showConfirmation = true;
    });

    // Populate controllers with extracted data
    _nameController.text = result['name'] ?? '';
    _frequencyController.text = result['frequency'] ?? '';
    _daysController.text = result['daysToFollow']?.toString() ?? '';
    _timingController.text = result['timing'] ?? '';
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showManualEntry() {
    setState(() {
      _showConfirmation = true;
      _extractedData = {
        'name': '',
        'frequency': '',
        'daysToFollow': 0,
        'timing': '',
        'confidence': 1.0,
      };
    });
  }

  Future<void> _saveMedication() async {
    try {
      final medication = Medication(
        name: _nameController.text.trim(),
        frequency: _frequencyController.text.trim(),
        daysToFollow: int.tryParse(_daysController.text) ?? 0,
        timing: _timingController.text.trim(),
        startDate: DateTime.now(),
        endDate: int.tryParse(_daysController.text) != null 
          ? DateTime.now().add(Duration(days: int.parse(_daysController.text)))
          : null,
        notes: _notesController.text.trim(),
        reminderTimes: _generateReminderTimes(),
      );

      final box = await Hive.openBox<Medication>('medications');
      await box.add(medication);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Medication saved successfully!')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      _showErrorDialog('Failed to save medication: $e');
    }
  }

  List<String> _generateReminderTimes() {
    final frequency = _frequencyController.text.toLowerCase();
    final reminderTimes = <String>[];

    if (frequency.contains('1x') || frequency.contains('once')) {
      reminderTimes.add('09:00');
    } else if (frequency.contains('2x') || frequency.contains('twice')) {
      reminderTimes.addAll(['09:00', '21:00']);
    } else if (frequency.contains('3x') || frequency.contains('thrice')) {
      reminderTimes.addAll(['09:00', '14:00', '21:00']);
    } else if (frequency.contains('4x')) {
      reminderTimes.addAll(['08:00', '12:00', '16:00', '20:00']);
    }

    return reminderTimes;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.teal,
        title: Text(
          "Medication Scanner",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: _showConfirmation ? _buildConfirmationView() : _buildScannerView(),
    );
  }

  Widget _buildScannerView() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt,
            size: screenWidth * 0.2,
            color: Colors.teal,
          ),
          SizedBox(height: screenHeight * 0.03),
          Text(
            "Scan Medication Details",
            style: TextStyle(
              fontSize: screenWidth * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.02),
          Text(
            "Use your camera to scan prescription or medication labels to automatically extract details",
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenHeight * 0.05),
          
          // Camera scan button
          SizedBox(
            width: double.infinity,
            height: screenHeight * 0.07,
            child: ElevatedButton.icon(
              onPressed: _isScanning ? null : _scanWithCamera,
              icon: _isScanning 
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Icon(Icons.camera_alt, color: Colors.white),
              label: Text(
                _isScanning ? "Scanning..." : "Scan with Camera",
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          SizedBox(height: screenHeight * 0.02),
          
          // Gallery scan button
          SizedBox(
            width: double.infinity,
            height: screenHeight * 0.07,
            child: ElevatedButton.icon(
              onPressed: _isScanning ? null : _scanFromGallery,
              icon: Icon(Icons.photo_library, color: Colors.teal),
              label: Text(
                "Select from Gallery",
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: BorderSide(color: Colors.teal, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          
          SizedBox(height: screenHeight * 0.03),
          
          // Manual entry option
          TextButton(
            onPressed: _showManualEntry,
            child: Text(
              "Or enter details manually",
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.teal,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationView() {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final confidence = _extractedData?['confidence'] ?? 0.0;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Confidence indicator
          if (confidence > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: confidence > 0.7 ? Colors.green[100] : confidence > 0.4 ? Colors.orange[100] : Colors.red[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: confidence > 0.7 ? Colors.green : confidence > 0.4 ? Colors.orange : Colors.red,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    confidence > 0.7 ? Icons.check_circle : confidence > 0.4 ? Icons.warning : Icons.error,
                    color: confidence > 0.7 ? Colors.green : confidence > 0.4 ? Colors.orange : Colors.red,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Scan Confidence: ${(confidence * 100).toInt()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: confidence > 0.7 ? Colors.green[800] : confidence > 0.4 ? Colors.orange[800] : Colors.red[800],
                    ),
                  ),
                ],
              ),
            ),

          Text(
            "Confirm Medication Details",
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          
          Text(
            "Please review and edit the extracted information:",
            style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: screenHeight * 0.03),

          // Medicine name
          _buildTextField(
            controller: _nameController,
            label: "Medicine Name",
            icon: Icons.medication,
            required: true,
          ),
          
          SizedBox(height: screenHeight * 0.02),

          // Frequency
          _buildTextField(
            controller: _frequencyController,
            label: "Frequency (e.g., 2x daily, twice a day)",
            icon: Icons.schedule,
            required: true,
          ),
          
          SizedBox(height: screenHeight * 0.02),

          // Days to follow
          _buildTextField(
            controller: _daysController,
            label: "Days to Follow",
            icon: Icons.calendar_today,
            keyboardType: TextInputType.number,
          ),
          
          SizedBox(height: screenHeight * 0.02),

          // Timing
          _buildTextField(
            controller: _timingController,
            label: "Timing (e.g., Before meals, After meals)",
            icon: Icons.restaurant,
          ),
          
          SizedBox(height: screenHeight * 0.02),

          // Notes
          _buildTextField(
            controller: _notesController,
            label: "Additional Notes (Optional)",
            icon: Icons.note,
            maxLines: 3,
          ),
          
          SizedBox(height: screenHeight * 0.04),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showConfirmation = false;
                      _extractedData = null;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.grey[700],
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Back",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _saveMedication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Save Medication",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool required = false,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label + (required ? ' *' : ''),
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
