import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthLocalStorage {
  static const _storage = FlutterSecureStorage();

  static const _onboardingSeenKey = 'onboarding_seen';
  static const _isLoggedInKey = 'is_logged_in';
  static const _userEmailKey = 'user_email';
  static const _userFullNameKey = 'user_full_name';
  static const _userTypeKey = 'user_type';
  static const _userRolesKey = 'user_roles';
  static const _appRoleKey = 'app_role';

  Future<void> setOnboardingSeen() async {
    await _storage.write(key: _onboardingSeenKey, value: 'true');
  }

  Future<bool> isOnboardingSeen() async {
    final value = await _storage.read(key: _onboardingSeenKey);
    return value == 'true';
  }

  Future<void> setLoggedIn({
    required String email,
    required String fullName,
    required String userType,
    required String rolesCsv,
    required String appRole,
  }) async {
    await _storage.write(key: _isLoggedInKey, value: 'true');
    await _storage.write(key: _userEmailKey, value: email);
    await _storage.write(key: _userFullNameKey, value: fullName);
    await _storage.write(key: _userTypeKey, value: userType);
    await _storage.write(key: _userRolesKey, value: rolesCsv);
    await _storage.write(key: _appRoleKey, value: appRole);
  }

  Future<bool> isLoggedIn() async {
    final value = await _storage.read(key: _isLoggedInKey);
    return value == 'true';
  }

  Future<String?> getSavedEmail() => _storage.read(key: _userEmailKey);
  Future<String?> getSavedFullName() => _storage.read(key: _userFullNameKey);
  Future<String?> getSavedUserType() => _storage.read(key: _userTypeKey);
  Future<String?> getSavedRolesCsv() => _storage.read(key: _userRolesKey);
  Future<String?> getSavedAppRole() => _storage.read(key: _appRoleKey);

  Future<void> logout() async {
    await _storage.delete(key: _isLoggedInKey);
    await _storage.delete(key: _userEmailKey);
    await _storage.delete(key: _userFullNameKey);
    await _storage.delete(key: _userTypeKey);
    await _storage.delete(key: _userRolesKey);
    await _storage.delete(key: _appRoleKey);
  }
}