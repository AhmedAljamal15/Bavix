class AccessRequest {
  final String fullName;
  final String email;
  final String requestedRole;
  final String note;

  const AccessRequest({
    required this.fullName,
    required this.email,
    required this.requestedRole,
    required this.note,
  });

  Map<String, dynamic> toJson() {
    return {'lead_name': fullName, 'email_id': email, 'status': 'Open'};
  }
}
