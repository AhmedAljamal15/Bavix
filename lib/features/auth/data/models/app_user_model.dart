enum AppRole {
  admin,
  hr,
  sales,
  customer,
  employee,
  unknown,
}

class AppUserModel {
  final String email;
  final String fullName;
  final String userType;
  final List<String> roles;
  final AppRole appRole;

  const AppUserModel({
    required this.email,
    required this.fullName,
    required this.userType,
    required this.roles,
    required this.appRole,
  });
}