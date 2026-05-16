import 'package:erp_sales/features/auth/data/local/auth_local_storage.dart';
import 'package:erp_sales/features/auth/data/models/app_permission_model.dart';
import 'package:erp_sales/features/auth/data/models/app_user_model.dart';
import 'package:erp_sales/features/auth/data/remote/auth_api_service.dart';
import 'package:erp_sales/features/customers/data/repo/customers_repository.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final AuthApiService apiService;
  final AuthLocalStorage localStorage;
  final CustomersRepository customersRepository;

  AuthRepository({
    required this.apiService,
    required this.localStorage,
    required this.customersRepository,
  });

  Future<bool> isOnboardingSeen() async {
    return localStorage.isOnboardingSeen();
  }

  Future<void> completeOnboarding() async {
    await localStorage.setOnboardingSeen();
  }

  Future<bool> isLoggedIn() async {
    return localStorage.isLoggedIn();
  }

  String _normalizeRole(String value) {
    return value.toLowerCase().trim();
  }

  List<String> _extractRoles(Map<String, dynamic> userDoc) {
    final rolesRaw = userDoc['roles'];

    if (rolesRaw is! List) return [];

    final roles = <String>[];

    for (final item in rolesRaw) {
      if (item is Map) {
        final roleName = item['role']?.toString() ?? '';
        if (roleName.trim().isNotEmpty) {
          roles.add(roleName.trim());
        }
      } else if (item is String && item.trim().isNotEmpty) {
        roles.add(item.trim());
      }
    }

    return roles;
  }

  List<String> _extractRoleProfiles(Map<String, dynamic> userDoc) {
    final profilesRaw = userDoc['role_profiles'];

    if (profilesRaw is! List) return [];

    final profiles = <String>[];

    for (final item in profilesRaw) {
      if (item is Map) {
        final profileName = item['role_profile']?.toString() ?? '';
        if (profileName.trim().isNotEmpty) {
          profiles.add(profileName.trim());
        }
      } else if (item is String && item.trim().isNotEmpty) {
        profiles.add(item.trim());
      }
    }

    return profiles;
  }

  AppRole _mapRolesToAppRole({
    required String userType,
    required List<String> roles,
    required List<String> roleProfiles,
  }) {
    final lowerRoles = roles.map(_normalizeRole).toList();
    final lowerProfiles = roleProfiles.map(_normalizeRole).toList();
    final lowerUserType = _normalizeRole(userType);

    if (lowerRoles.contains('system manager') ||
        lowerRoles.contains('administrator') ||
        lowerProfiles.contains('administrator') ||
        lowerProfiles.contains('system manager') ||
        lowerProfiles.contains('admin')) {
      return AppRole.admin;
    }

    if (lowerRoles.contains('hr manager') ||
        lowerRoles.contains('hr user') ||
        lowerProfiles.contains('hr') ||
        lowerProfiles.contains('human resources')) {
      return AppRole.hr;
    }

    if (lowerRoles.contains('sales manager') ||
        lowerRoles.contains('sales user') ||
        lowerProfiles.contains('sales')) {
      return AppRole.sales;
    }

    if (lowerRoles.contains('customer') ||
        lowerProfiles.contains('customer') ||
        lowerUserType == 'website user') {
      return AppRole.customer;
    }

    if (lowerUserType == 'system user') {
      return AppRole.employee;
    }

    return AppRole.unknown;
  }

  Future<AppUserModel> _buildUserFromServer(String email) async {
    final userDoc = await apiService.getUserProfile(email);

    final fullName = userDoc['full_name']?.toString() ?? email;
    final userType = userDoc['user_type']?.toString() ?? 'System User';

    debugPrint('USER DOC KEYS => ${userDoc.keys.toList()}');
    final rolesList = _extractRoles(userDoc);
    final roleProfiles = _extractRoleProfiles(userDoc);

    debugPrint('USER TYPE => $userType');
    debugPrint('ROLES LIST => $rolesList');
    debugPrint('ROLE PROFILES => $roleProfiles');

    final appRole = _mapRolesToAppRole(
      userType: userType,
      roles: rolesList,
      roleProfiles: roleProfiles,
    );

    debugPrint('APP ROLE => ${appRole.name}');

    await localStorage.setLoggedIn(
      email: email,
      fullName: fullName,
      userType: userType,
      rolesCsv: rolesList.join(','),
      appRole: appRole.name,
    );

    return AppUserModel(
      email: email,
      fullName: fullName,
      userType: userType,
      roles: rolesList,
      appRole: appRole,
    );
  }

  Future<AppUserModel> login({
    required String email,
    required String password,
  }) async {
    await apiService.login(email: email, password: password);

    final loggedInEmail = await apiService.getLoggedInUserEmail();
    return _buildUserFromServer(loggedInEmail);
  }

  Future<AppUserModel?> getCurrentUser() async {
    final isLoggedIn = await localStorage.isLoggedIn();
    if (!isLoggedIn) return null;

    try {
      final loggedInEmail = await apiService.getLoggedInUserEmail();
      return await _buildUserFromServer(loggedInEmail);
    } catch (_) {
      final email = await localStorage.getSavedEmail();
      final fullName = await localStorage.getSavedFullName();
      final userType = await localStorage.getSavedUserType();
      final rolesCsv = await localStorage.getSavedRolesCsv();
      final appRoleRaw = await localStorage.getSavedAppRole();

      if (email == null || email.isEmpty) return null;

      final roles = (rolesCsv ?? '')
          .split(',')
          .where((e) => e.trim().isNotEmpty)
          .toList();

      AppRole appRole;
      switch (appRoleRaw) {
        case 'admin':
          appRole = AppRole.admin;
          break;
        case 'hr':
          appRole = AppRole.hr;
          break;
        case 'sales':
          appRole = AppRole.sales;
          break;
        case 'customer':
          appRole = AppRole.customer;
          break;
        case 'employee':
          appRole = AppRole.employee;
          break;
        default:
          appRole = AppRole.unknown;
      }

      return AppUserModel(
        email: email,
        fullName: fullName ?? email,
        userType: userType ?? 'System User',
        roles: roles,
        appRole: appRole,
      );
    }
  }

  Future<void> logout() async {
    try {
      await apiService.logout();
    } catch (_) {}
    await localStorage.logout();
  }

  Future<void> customerRegister({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await apiService.customerSignUp(
      fullName: fullName,
      email: email,
      password: password,
    );
  }

  Future<AppPermissionModel?> getCurrentPermissions() async {
    final user = await getCurrentUser();
    if (user == null) return null;

    return AppPermissionModel.fromRole(user.appRole);
  }
}
