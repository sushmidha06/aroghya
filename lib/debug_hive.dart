import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:aroghya_ai/models/user.dart';

class HiveDebugScreen extends StatefulWidget {
  const HiveDebugScreen({super.key});

  @override
  State<HiveDebugScreen> createState() => _HiveDebugScreenState();
}

class _HiveDebugScreenState extends State<HiveDebugScreen> {
  String _debugInfo = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadDebugInfo();
  }

  Future<void> _loadDebugInfo() async {
    try {
      final authBox = Hive.box('authBox');
      final userBox = Hive.box<User>('users');
      
      StringBuffer buffer = StringBuffer();
      buffer.writeln('=== HIVE DATABASE DEBUG ===\n');
      
      // AuthBox info
      buffer.writeln('📦 AuthBox:');
      buffer.writeln('Keys: ${authBox.keys.toList()}');
      buffer.writeln('Values: ${authBox.toMap()}');
      buffer.writeln('Is Empty: ${authBox.isEmpty}');
      buffer.writeln('Length: ${authBox.length}\n');
      
      // Users box info
      buffer.writeln('👥 Users Box:');
      buffer.writeln('Length: ${userBox.length}');
      buffer.writeln('Keys: ${userBox.keys.toList()}');
      buffer.writeln('Is Empty: ${userBox.isEmpty}\n');
      
      // List all users
      if (userBox.isNotEmpty) {
        buffer.writeln('📋 All Users:');
        for (int i = 0; i < userBox.length; i++) {
          final user = userBox.getAt(i);
          if (user != null) {
            buffer.writeln('User $i:');
            buffer.writeln('  Name: ${user.name}');
            buffer.writeln('  Email: ${user.email}');
            buffer.writeln('  Password: ${user.password}');
            buffer.writeln('  DOB: ${user.dateOfBirth}');
            buffer.writeln('  Disease: ${user.disease}\n');
          }
        }
      } else {
        buffer.writeln('No users found in users box\n');
      }
      
      // Check other boxes
      buffer.writeln('📊 All Open Boxes:');
      final openBoxes = ['authBox', 'users', 'symptom_reports', 'meetings', 'medical_documents'];
      for (var boxName in openBoxes) {
        try {
          if (Hive.isBoxOpen(boxName)) {
            final box = Hive.box(boxName);
            buffer.writeln('$boxName: ${box.length} items (open)');
          } else {
            buffer.writeln('$boxName: not open');
          }
        } catch (e) {
          buffer.writeln('$boxName: Error accessing - $e');
        }
      }
      
      setState(() {
        _debugInfo = buffer.toString();
      });
    } catch (e) {
      setState(() {
        _debugInfo = 'Error loading debug info: $e';
      });
    }
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text('Are you sure you want to delete all Hive data? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final authBox = Hive.box('authBox');
        final userBox = Hive.box<User>('users');
        
        await authBox.clear();
        await userBox.clear();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All Hive data cleared!')),
        );
        
        _loadDebugInfo(); // Refresh the debug info
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error clearing data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive Debug'),
        actions: [
          IconButton(
            onPressed: _loadDebugInfo,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
          IconButton(
            onPressed: _clearAllData,
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Clear All Data',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _loadDebugInfo,
                    child: const Text('Refresh Data'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _clearAllData,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('Clear All Data'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: SingleChildScrollView(
                  child: Text(
                    _debugInfo,
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
