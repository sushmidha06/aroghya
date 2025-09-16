import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import 'package:aroghya_ai/models/user.dart';

class AuthService {
  // Save current user email
  static Future<void> saveCurrentUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('current_user_email', email);
  }
  
  // Get current user email
  static Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('current_user_email');
  }

  // Save user login state
  static Future<void> saveLoginState(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', isLoggedIn);
  }

  // Check if user is logged in
  static Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // Save complete login session
  static Future<void> saveLoginSession(String email) async {
    await saveCurrentUserEmail(email);
    await saveLoginState(true);
  }
  
  // Get current logged in user
  static Future<User?> getCurrentUser() async {
    final email = await getCurrentUserEmail();
    if (email == null) return null;
    
    final userBox = Hive.box<User>('users');
    try {
      return userBox.values.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user_email');
    await prefs.setBool('is_logged_in', false);
  }
}
