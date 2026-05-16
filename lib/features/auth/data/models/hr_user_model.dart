class HrUserModel {
  final String name;
  final String fullName;
  final String userType;
  final bool enabled;

  const HrUserModel({
    required this.name,
    required this.fullName,
    required this.userType,
    required this.enabled,
  });

  factory HrUserModel.fromJson(Map<String, dynamic> json) {
    return HrUserModel(
      name: json['name'] ?? '',
      fullName: json['full_name'] ?? '',
      userType: json['user_type'] ?? '',
      enabled: (json['enabled'] as int? ?? 0) == 1,
    );
  }
}