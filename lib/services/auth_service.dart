import 'package:hive/hive.dart';
import 'package:aroghya_ai/models/user.dart';

class AuthService {
  // Get current logged in user
  static Future<User?> getCurrentUser() async {
    final authBox = Hive.box('authBox');
    final userBox = Hive.box<User>('users');
    
    final email = authBox.get('email');
    if (email != null) {
      try {
        final user = userBox.values.firstWhere((user) => user.email == email);
        return user;
      } catch (e) {
        // User not found in users box, return null
        return null;
      }
    }
    return null;
  }
  
  // Change password
  static Future<bool> changePassword(String currentPassword, String newPassword) async {
    final user = await getCurrentUser();
    if (user == null) return false;
    
    // Verify current password
    if (user.password != currentPassword) return false;
    
    // Update password
    user.password = newPassword;
    await user.save();
    return true;
  }
  
  // Logout
  static Future<void> logout() async {
    final authBox = Hive.box('authBox');
    await authBox.put('isLoggedIn', false);
  }
}
