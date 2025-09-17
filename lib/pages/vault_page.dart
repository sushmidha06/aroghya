import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:local_auth/local_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:aroghya_ai/models/medical_document.dart';
import '../theme/app_theme.dart';
import '../services/image_storage_service.dart';
import '../generated/l10n/app_localizations.dart';
import 'dart:io';
import 'dart:typed_data';

class VaultPage extends StatefulWidget {
  const VaultPage({super.key});

  @override
  State<VaultPage> createState() => _VaultPageState();
}

class _VaultPageState extends State<VaultPage> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final TextEditingController _searchController = TextEditingController();
  
  bool _isLoading = false;
  List<MedicalDocument> _documents = [];
  List<MedicalDocument> _filteredDocuments = [];

  @override
  void initState() {
    super.initState();
    // Don't authenticate on init - wait for user interaction
    // Storage permission will be requested only when needed (during upload)
  }

  Future<void> _authenticateUser() async {
    try {
      final bool isAvailable = await _localAuth.isDeviceSupported();
      if (!isAvailable) {
        _showAuthError('Biometric authentication not available on this device');
        return;
      }

      final bool hasFingerprint = await _localAuth.canCheckBiometrics;
      if (!hasFingerprint) {
        _showAuthError('No biometric authentication set up on this device');
        return;
      }

      final bool isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Access your secure medical vault',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated) {
        await _loadDocuments();
      }
    } catch (e) {
      _showAuthError('Authentication failed: ${e.toString()}');
    }
  }

  void _showAuthError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Authentication Required'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _authenticateUser();
            },
            child: const Text('Try Again'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _loadDocuments() async {
    try {
      final documentsBox = Hive.box<MedicalDocument>('medical_documents');
      setState(() {
        _documents = documentsBox.values.toList();
        _filteredDocuments = _documents;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading documents: ${e.toString()}')),
      );
    }
  }


  Future<void> _uploadDocument() async {
    try {
      final result = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Upload Document'),
          content: const Text('Choose upload method:'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop('camera'),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.camera_alt),
                  SizedBox(width: 8),
                  Text('Camera'),
                ],
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop('gallery'),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.photo_library),
                  SizedBox(width: 8),
                  Text('Gallery'),
                ],
              ),
            ),
          ],
        ),
      );

      if (result == null) return;

      File? file;
      String fileName = '';

      final picker = ImagePicker();
      
      switch (result) {
        case 'camera':
          final image = await picker.pickImage(
            source: ImageSource.camera,
            imageQuality: 80, // Compress image to reduce size
          );
          if (image != null) {
            file = File(image.path);
            fileName = 'camera_${DateTime.now().millisecondsSinceEpoch}.jpg';
          }
          break;
        case 'gallery':
          final image = await picker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 80, // Compress image to reduce size
          );
          if (image != null) {
            file = File(image.path);
            fileName = 'gallery_${DateTime.now().millisecondsSinceEpoch}.jpg';
          }
          break;
      }

      if (file == null) return;

      await _processAndSaveDocument(file, fileName);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading document: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _processAndSaveDocument(File file, String fileName) async {
    if (!mounted) return;
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Copy file to app directory (using app's private storage, no permissions needed)
      final appDir = await getApplicationDocumentsDirectory();
      final vaultDir = Directory('${appDir.path}/vault');
      if (!await vaultDir.exists()) {
        await vaultDir.create(recursive: true);
      }

      final newPath = '${vaultDir.path}/$fileName';
      final newFile = await file.copy(newPath);

      // Get file info
      final fileStats = await newFile.stat();
      final fileExtension = fileName.split('.').last.toLowerCase();
      
      // If it's an image, also save to Hive for easy access
      if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(fileExtension)) {
        try {
          final imageBytes = await newFile.readAsBytes();
          final imageKey = 'vault_image_${DateTime.now().millisecondsSinceEpoch}';
          await ImageStorageService.saveImageToHive(imageKey, imageBytes);
          debugPrint('✅ Image saved to Hive with key: $imageKey');
        } catch (e) {
          debugPrint('⚠️ Failed to save image to Hive: $e');
          // Continue with normal document processing even if Hive save fails
        }
      }

      // Show document details dialog
      final documentInfo = await _showDocumentDetailsDialog(fileName, fileExtension);
      if (documentInfo == null) return;

      // Create document object
      final document = MedicalDocument(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fileName: fileName,
        filePath: newPath,
        fileType: fileExtension,
        uploadDate: DateTime.now(),
        description: documentInfo['description'],
        tags: documentInfo['tags'],
        fileSize: fileStats.size.toDouble(),
        category: documentInfo['category'],
      );

      // Document saved without AI analysis

      // Save to Hive
      final documentsBox = Hive.box<MedicalDocument>('medical_documents');
      await documentsBox.put(document.id, document);

      await _loadDocuments();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document uploaded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing document: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  /// View stored images from Hive
  Future<void> _viewStoredImages() async {
    try {
      final imageKeys = ImageStorageService.getAllImageKeys();
      
      if (imageKeys.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No images stored in vault')),
        );
        return;
      }

      showDialog(
        context: context,
        builder: (context) => Dialog(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Stored Images (${imageKeys.length})',
                      style: AppTheme.headingSmall,
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: imageKeys.length,
                    itemBuilder: (context, index) {
                      final imageKey = imageKeys[index];
                      return FutureBuilder<Uint8List?>(
                        future: ImageStorageService.getImageFromHive(imageKey),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return GestureDetector(
                              onTap: () => _showFullScreenImage(snapshot.data!, imageKey),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppTheme.textLight),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    snapshot.data!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppTheme.surfaceColor,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error viewing images: $e')),
      );
    }
  }

  /// Show full screen image
  void _showFullScreenImage(Uint8List imageData, String imageKey) {
    showDialog(
      context: context,
      builder: (context) => Dialog.fullscreen(
        child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              IconButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Image'),
                      content: const Text('Are you sure you want to delete this image?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  
                  if (confirm == true) {
                    try {
                      await ImageStorageService.deleteImageFromHive(imageKey);
                      Navigator.of(context).pop(); // Close full screen
                      Navigator.of(context).pop(); // Close gallery
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Image deleted successfully')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error deleting image: $e')),
                      );
                    }
                  }
                },
                icon: const Icon(Icons.delete, color: Colors.white),
              ),
            ],
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.memory(imageData),
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>?> _showDocumentDetailsDialog(String fileName, String fileType) async {
    final descriptionController = TextEditingController();
    final tagsController = TextEditingController();
    String selectedCategory = 'general';

    return showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Document Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('File: $fileName'),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags (comma separated)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'general', child: Text('General')),
                  DropdownMenuItem(value: 'lab_report', child: Text('Lab Report')),
                  DropdownMenuItem(value: 'prescription', child: Text('Prescription')),
                  DropdownMenuItem(value: 'scan', child: Text('Medical Scan')),
                  DropdownMenuItem(value: 'medical_history', child: Text('Medical History')),
                  DropdownMenuItem(value: 'insurance', child: Text('Insurance')),
                  DropdownMenuItem(value: 'vaccination', child: Text('Vaccination Record')),
                ],
                onChanged: (value) {
                  selectedCategory = value ?? 'general';
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final tags = tagsController.text
                  .split(',')
                  .map((tag) => tag.trim())
                  .where((tag) => tag.isNotEmpty)
                  .toList();
              
              Navigator.of(context).pop({
                'description': descriptionController.text,
                'tags': tags,
                'category': selectedCategory,
              });
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }


  void _searchDocuments(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredDocuments = _documents;
      });
      return;
    }

    setState(() {
      _filteredDocuments = _documents.where((doc) {
        final searchText = '${doc.fileName} ${doc.description ?? ''} ${doc.category} ${doc.tags.join(' ')}'.toLowerCase();
        return searchText.contains(query.toLowerCase());
      }).toList();
    });
  }

  void _viewDocument(MedicalDocument document) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      document.fileName,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('Category: ${document.category}'),
              Text('Upload Date: ${document.uploadDate.toString().split(' ')[0]}'),
              Text('File Size: ${(document.fileSize / 1024).toStringAsFixed(1)} KB'),
              if (document.description?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                Text('Description: ${document.description}'),
              ],
              if (document.tags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 4,
                  children: document.tags.map((tag) => Chip(
                    label: Text(tag),
                    backgroundColor: Colors.blue.shade100,
                  )).toList(),
                ),
              ],
              if (document.aiAnalysis?.isNotEmpty == true) ...[
                const SizedBox(height: 16),
                const Text('AI Analysis:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(document.aiAnalysis!),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Always load documents when vault page is accessed
    if (_documents.isEmpty && !_isLoading) {
      _loadDocuments();
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).vault, style: AppTheme.headingSmall.copyWith(color: AppTheme.textOnPrimary)),
        backgroundColor: AppTheme.primaryColor,
        elevation: AppTheme.elevationS,
        actions: [
          IconButton(
            onPressed: _viewStoredImages,
            icon: const Icon(Icons.photo_library, color: AppTheme.textOnPrimary),
            tooltip: 'View Images',
          ),
          IconButton(
            onPressed: _uploadDocument,
            icon: const Icon(Icons.add, color: AppTheme.textOnPrimary),
            tooltip: 'Upload Document',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Section
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            color: AppTheme.surfaceColor,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context).searchDocuments,
                prefixIcon: Icon(Icons.search, color: AppTheme.textSecondary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                  borderSide: BorderSide(color: AppTheme.textLight),
                ),
                filled: true,
                fillColor: AppTheme.backgroundColor,
              ),
              onChanged: _searchDocuments,
            ),
          ),
          
          // Documents List
          Expanded(
            child: _filteredDocuments.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _documents.isEmpty
                              ? 'No documents uploaded yet'
                              : 'No documents match your search',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (_documents.isEmpty)
                          ElevatedButton.icon(
                            onPressed: _uploadDocument,
                            icon: const Icon(Icons.add),
                            label: const Text('Upload First Document'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E2432),
                              foregroundColor: Colors.white,
                            ),
                          ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredDocuments.length,
                    itemBuilder: (context, index) {
                      final document = _filteredDocuments[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getCategoryColor(document.category),
                            child: Icon(
                              _getCategoryIcon(document.category),
                              color: Colors.white,
                            ),
                          ),
                          title: Text(document.fileName),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(document.category.replaceAll('_', ' ').toUpperCase()),
                              Text(document.uploadDate.toString().split(' ')[0]),
                              if (document.description?.isNotEmpty == true)
                                Text(
                                  document.description!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                            ],
                          ),
                          trailing: PopupMenuButton(
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'view',
                                child: Row(
                                  children: [
                                    Icon(Icons.visibility),
                                    SizedBox(width: 8),
                                    Text('View'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Delete', style: TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                            onSelected: (value) async {
                              if (value == 'view') {
                                _viewDocument(document);
                              } else if (value == 'delete') {
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Document'),
                                    content: Text('Are you sure you want to delete "${document.fileName}"?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                                
                                if (confirmed == true) {
                                  final documentsBox = Hive.box<MedicalDocument>('medical_documents');
                                  await documentsBox.delete(document.id);
                                  
                                  // Delete file
                                  try {
                                    final file = File(document.filePath);
                                    if (await file.exists()) {
                                      await file.delete();
                                    }
                                  } catch (e) {
                                    print('Error deleting file: $e');
                                  }
                                  
                                  await _loadDocuments();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Document deleted')),
                                  );
                                }
                              }
                            },
                          ),
                          onTap: () => _viewDocument(document),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'lab_report':
        return Colors.green;
      case 'prescription':
        return Colors.blue;
      case 'scan':
        return Colors.purple;
      case 'medical_history':
        return Colors.orange;
      case 'insurance':
        return Colors.teal;
      case 'vaccination':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'lab_report':
        return Icons.science;
      case 'prescription':
        return Icons.medication;
      case 'scan':
        return Icons.medical_services;
      case 'medical_history':
        return Icons.history;
      case 'insurance':
        return Icons.security;
      case 'vaccination':
        return Icons.vaccines;
      default:
        return Icons.description;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
