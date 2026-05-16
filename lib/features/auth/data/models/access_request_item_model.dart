class AccessRequestItemModel {
  final String id;
  final String fullName;
  final String email;
  final String status;
  final String owner;

  const AccessRequestItemModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.status,
    required this.owner,
  });

  factory AccessRequestItemModel.fromJson(Map<String, dynamic> json) {
    return AccessRequestItemModel(
      id: json['name'] ?? '',
      fullName: json['lead_name'] ?? '',
      email: json['email_id'] ?? '',
      status: json['status'] ?? '',
      owner: json['owner'] ?? '',
    );
  }
}