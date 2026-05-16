class LeaveRequestModel {
  final String name;
  final String employee;
  final String employeeName;
  final String leaveType;
  final String fromDate;
  final String toDate;
  final String status;
  final String? reason;

  const LeaveRequestModel({
    required this.name,
    required this.employee,
    required this.employeeName,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    required this.status,
    this.reason,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    return LeaveRequestModel(
      name: json['name'] ?? '',
      employee: json['employee'] ?? '',
      employeeName: json['employee_name'] ?? '',
      leaveType: json['leave_type'] ?? '',
      fromDate: json['from_date'] ?? '',
      toDate: json['to_date'] ?? '',
      status: json['status'] ?? '',
      reason: json['reason'],
    );
  }
}

class CreateLeaveRequestRequest {
  final String employee;
  final String leaveType;
  final String fromDate;
  final String toDate;
  final String? reason;

  const CreateLeaveRequestRequest({
    required this.employee,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'employee': employee,
      'leave_type': leaveType,
      'from_date': fromDate,
      'to_date': toDate,
      'description': reason ?? '',
    };
  }
}