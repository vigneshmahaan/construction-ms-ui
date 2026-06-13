import 'package:shared_preferences/shared_preferences.dart';
import 'package:construction_ms_ui/shared/models/user_role.dart';

class AuthService {
  static const _keyIsFirstTime = 'isFirstTime';
  static const _keyUserRole = 'userRole';

  static String? currentWorkerId;

  /// Returns true if this is the very first app launch.
  static Future<bool> isFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsFirstTime) ?? true;
  }

  /// Saves the role and marks the app as no longer first-time.
  static Future<void> completeSetup(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsFirstTime, false);
    await prefs.setString(_keyUserRole, role.key);
  }

  /// Saves only the role (used on login for returning users).
  static Future<void> saveRole(UserRole role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserRole, role.key);
  }

  /// Retrieves the saved role. Defaults to admin if none saved.
  static Future<UserRole> getSavedRole() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString(_keyUserRole) ?? 'admin';
    return UserRoleExtension.fromKey(key);
  }

  /// Clears all auth data (logout).
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserRole);
    // Note: isFirstTime stays false so onboarding doesn't repeat.
  }
}
