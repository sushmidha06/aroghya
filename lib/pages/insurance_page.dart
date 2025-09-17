import 'dart:io';
import 'package:aroghya_ai/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

// --- Data Models ---

enum DocumentStatus { pending, uploaded }
var uuid = const Uuid();

class ClaimDocument {
  final String id;
  final String name;
  DocumentStatus status;
  String? imagePath; // Path to the uploaded image file

  ClaimDocument({required this.name, this.status = DocumentStatus.pending, this.imagePath}) : id = uuid.v4();
}

class Claim {
  final String id;
  final String policyNumber;
  final String hospitalName;
  final String patientName;
  final DateTime admissionDate;
  final String diagnosis;
  String status;
  DateTime lastUpdated;
  List<ClaimDocument> documents;

  Claim({
    required this.policyNumber,
    required this.hospitalName,
    required this.patientName,
    required this.admissionDate,
    required this.diagnosis,
    this.status = "Documents Needed",
    List<ClaimDocument>? documents,
  })  : id = uuid.v4(),
        lastUpdated = DateTime.now(),
        documents = documents ?? _createDefaultDocumentList();

  static List<ClaimDocument> _createDefaultDocumentList() {
    return [
      ClaimDocument(name: 'ID Proof (Aadhaar/PAN)'),
      ClaimDocument(name: 'Discharge Summary'),
      ClaimDocument(name: 'Final Hospital Bill (Consolidated)'),
      ClaimDocument(name: 'Pharmacy Bills'),
      ClaimDocument(name: 'Investigation Reports (Labs, Scans)'),
      ClaimDocument(name: 'Cancelled Cheque for NEFT'),
    ];
  }
}

// --- Main Insurance Page ---

class InsurancePage extends StatefulWidget {
  const InsurancePage({super.key});
  @override
  State<InsurancePage> createState() => _InsurancePageState();
}

class _InsurancePageState extends State<InsurancePage> {
  final List<Claim> _claims = [];

  void _navigateAndCreateClaim(BuildContext context) async {
    final result = await Navigator.of(context).push<Claim>(
      MaterialPageRoute(builder: (ctx) => const ClaimFormScreen()),
    );
    if (result != null) {
      setState(() {
        _claims.add(result);
        _claims.sort((a, b) => b.admissionDate.compareTo(a.admissionDate));
      });
    }
  }

  void _navigateToDetails(int index) async {
    final updatedClaim = await Navigator.of(context).push<Claim>(
      MaterialPageRoute(builder: (ctx) => ClaimDetailsScreen(claim: _claims[index])),
    );
    if (updatedClaim != null) {
      setState(() {
        _claims[index] = updatedClaim;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Health Claim Tracker'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
      body: _claims.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_open_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No Claims Found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Tap the "+" button to file your first claim.', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: _claims.length,
              itemBuilder: (ctx, index) => ClaimCard(claim: _claims[index], onTap: () => _navigateToDetails(index)),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndCreateClaim(context),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}

// --- Professional Claim Card Widget ---

class ClaimCard extends StatelessWidget {
  final Claim claim;
  final VoidCallback onTap;
  const ClaimCard({super.key, required this.claim, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final docsUploaded = claim.documents.where((d) => d.status == DocumentStatus.uploaded).length;
    final totalDocs = claim.documents.length;

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 8, decoration: BoxDecoration(color: _getStatusColor(claim.status), borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)))),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Flexible(child: Text(claim.patientName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                        StatusChip(status: claim.status),
                      ]),
                      const SizedBox(height: 12),
                      InfoRow(icon: Icons.local_hospital_outlined, text: claim.hospitalName),
                      const SizedBox(height: 8),
                      InfoRow(icon: Icons.calendar_month_outlined, text: 'Admitted on ${DateFormat.yMMMd().format(claim.admissionDate)}'),
                      const SizedBox(height: 12),
                      // Document Progress Indicator
                      Row(
                        children: [
                          Expanded(child: LinearProgressIndicator(value: docsUploaded / totalDocs, backgroundColor: Colors.grey.shade300, color: _getStatusColor(claim.status))),
                          const SizedBox(width: 8),
                          Text('$docsUploaded / $totalDocs Docs', style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Claim Details Screen ---

class ClaimDetailsScreen extends StatefulWidget {
  final Claim claim;
  const ClaimDetailsScreen({super.key, required this.claim});
  @override
  State<ClaimDetailsScreen> createState() => _ClaimDetailsScreenState();
}

class _ClaimDetailsScreenState extends State<ClaimDetailsScreen> {
  late Claim _currentClaim;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _currentClaim = widget.claim;
  }

  void _showStatusDialog() {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Update Claim Status'),
        children: ['Submitted', 'Pending with Insurer', 'Approved', 'Rejected', 'Documents Needed']
            .map((status) => SimpleDialogOption(
                  onPressed: () {
                    setState(() {
                      _currentClaim.status = status;
                      _currentClaim.lastUpdated = DateTime.now(); // Update the timestamp
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text(status),
                ))
            .toList(),
      ),
    );
  }

  Future<void> _pickDocument(ClaimDocument doc) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        doc.imagePath = image.path;
        doc.status = DocumentStatus.uploaded;
        _currentClaim.lastUpdated = DateTime.now();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysSinceUpdate = DateTime.now().difference(_currentClaim.lastUpdated).inDays;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(_currentClaim.patientName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
        leading: BackButton(onPressed: () => Navigator.of(context).pop(_currentClaim)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reminder Banner
            if (daysSinceUpdate > 7)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(color: Colors.amber.shade100, borderRadius: BorderRadius.circular(8)),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_rounded, color: Colors.amber.shade800),
                    const SizedBox(width: 12),
                    Expanded(child: Text('This claim has not been updated in $daysSinceUpdate days. Consider following up.', style: TextStyle(color: Colors.amber.shade900))),
                  ],
                ),
              ),
            // Status Section
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Status:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              StatusChip(status: _currentClaim.status),
            ]),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Update Status'),
                onPressed: _showStatusDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200, 
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const Divider(height: 30),
            // Document Checklist Section
            const Text('Document Checklist', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ..._currentClaim.documents.map((doc) => DocumentTile(document: doc, onUpload: () => _pickDocument(doc))),
            const Divider(height: 30),
            // Details Section
            const Text('Claim Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildDetailRow('Patient Name:', _currentClaim.patientName),
            _buildDetailRow('Hospital:', _currentClaim.hospitalName),
            _buildDetailRow('Admission Date:', DateFormat.yMMMd().format(_currentClaim.admissionDate)),
            _buildDetailRow('Policy Number:', _currentClaim.policyNumber),
            const SizedBox(height: 10),
            const Text('Diagnosis / Details:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(_currentClaim.diagnosis, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Text.rich(TextSpan(children: [TextSpan(text: '$title ', style: const TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: value, style: const TextStyle(fontSize: 16))])),
      );
}

// --- New Claim Form Screen ---

class ClaimFormScreen extends StatefulWidget {
  const ClaimFormScreen({super.key});
  @override
  State<ClaimFormScreen> createState() => _ClaimFormScreenState();
}

class _ClaimFormScreenState extends State<ClaimFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _policyController = TextEditingController();
  final _hospitalController = TextEditingController();
  final _patientController = TextEditingController();
  final _diagnosisController = TextEditingController();
  DateTime? _selectedDate;

  void _submitForm() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid || _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields.'), backgroundColor: Colors.red));
      return;
    }
    final newClaim = Claim(
      policyNumber: _policyController.text,
      hospitalName: _hospitalController.text,
      patientName: _patientController.text,
      admissionDate: _selectedDate!,
      diagnosis: _diagnosisController.text,
    );
    Navigator.of(context).pop(newClaim);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: _selectedDate ?? DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime.now());
    if (picked != null && picked != _selectedDate) setState(() => _selectedDate = picked);
  }

  @override
  void dispose() {
    _policyController.dispose();
    _hospitalController.dispose();
    _patientController.dispose();
    _diagnosisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('File New Claim'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _policyController,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  labelText: 'Insurance Policy Number', 
                  prefixIcon: const Icon(Icons.policy_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  prefixIconColor: AppTheme.primaryColor,
                ), 
                validator: (v) => v!.isEmpty ? 'Required' : null
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _patientController, 
                decoration: InputDecoration(
                  labelText: 'Patient Name', 
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  prefixIconColor: AppTheme.primaryColor,
                ), 
                validator: (v) => v!.isEmpty ? 'Required' : null
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _hospitalController, 
                decoration: InputDecoration(
                  labelText: 'Hospital Name', 
                  prefixIcon: const Icon(Icons.local_hospital_outlined),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  prefixIconColor: AppTheme.primaryColor,
                ), 
                validator: (v) => v!.isEmpty ? 'Required' : null
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                  child: Row(children: [const Icon(Icons.calendar_month_outlined, color: AppTheme.primaryColor), const SizedBox(width: 12), Text(_selectedDate == null ? 'Select Admission Date' : DateFormat.yMMMd().format(_selectedDate!), style: const TextStyle(fontSize: 16))]),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _diagnosisController, 
                decoration: InputDecoration(
                  labelText: 'Admission Details / Diagnosis', 
                  alignLabelWithHint: true,
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ), 
                maxLines: 4, 
                validator: (v) => v!.isEmpty ? 'Required' : null
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitForm, 
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                child: const Text('Create Claim Case')
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Helper Widgets ---

class StatusChip extends StatelessWidget {
  final String status;
  const StatusChip({super.key, required this.status});
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: _getStatusColor(status).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(color: _getStatusColor(status), fontWeight: FontWeight.bold, fontSize: 12)));
}

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const InfoRow({super.key, required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Row(children: [Icon(icon, size: 16, color: Colors.grey.shade600), const SizedBox(width: 8), Expanded(child: Text(text, style: TextStyle(fontSize: 14, color: Colors.grey.shade800)))]);
}

class DocumentTile extends StatelessWidget {
  final ClaimDocument document;
  final VoidCallback onUpload;
  const DocumentTile({super.key, required this.document, required this.onUpload});

  @override
  Widget build(BuildContext context) {
    bool isUploaded = document.status == DocumentStatus.uploaded;
    return Card(
      elevation: 0,
      color: Colors.grey.shade50,
      margin: const EdgeInsets.symmetric(vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(isUploaded ? Icons.check_circle_rounded : Icons.cancel_rounded, color: isUploaded ? Colors.green : Colors.red),
        title: Text(document.name),
        subtitle: isUploaded ? Text('File: ${p.basename(document.imagePath!)}', style: const TextStyle(fontSize: 12)) : null,
        trailing: isUploaded
            ? Icon(Icons.visibility, color: Colors.grey.shade600) // In a real app, this would open the image
            : TextButton(onPressed: onUpload, child: const Text('Upload')),
      ),
    );
  }
}

Color _getStatusColor(String status) {
  switch (status) {
    case 'Approved': return Colors.green;
    case 'Rejected': return Colors.red;
    case 'Submitted': return Colors.blue;
    case 'Pending with Insurer': return Colors.purple;
    case 'Documents Needed': default: return Colors.orange;
  }
}
