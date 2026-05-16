class AttendanceModel {
  final String name;
  final String employee;
  final String employeeName;
  final String attendanceDate;
  final String status;
  final String? company;

  const AttendanceModel({
    required this.name,
    required this.employee,
    required this.employeeName,
    required this.attendanceDate,
    required this.status,
    this.company,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      name: json['name'] ?? '',
      employee: json['employee'] ?? '',
      employeeName: json['employee_name'] ?? '',
      attendanceDate: json['attendance_date'] ?? '',
      status: json['status'] ?? '',
      company: json['company'],
    );
  }
}

class CreateAttendanceRequest {
  final String employee;
  final String attendanceDate;
  final String status;
  final String? company;

  const CreateAttendanceRequest({
    required this.employee,
    required this.attendanceDate,
    required this.status,
    this.company,
  });

  Map<String, dynamic> toJson() {
    return {
      'employee': employee,
      'attendance_date': attendanceDate,
      'status': status,
      if (company != null && company!.isNotEmpty) 'company': company,
    };
  }
}