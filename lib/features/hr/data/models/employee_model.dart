class CreateEmployeeRequest {
  final String firstName;
  final String? lastName;
  final String gender;
  final String dateOfJoining;
  final String dateOfBirth;
  final String company;
  final String? department;
  final String? designation;

  const CreateEmployeeRequest({
    required this.firstName,
    this.lastName,
    required this.gender,
    required this.dateOfJoining,
    required this.dateOfBirth,
    required this.company,
    this.department,
    this.designation,
  });

  Map<String, dynamic> toJson() {
    final fullName = lastName != null && lastName!.isNotEmpty
        ? '$firstName $lastName'
        : firstName;

    return {
      'naming_series': 'HR-EMP-',
      'first_name': firstName,
      'employee_name': fullName,
      'gender': gender,
      'date_of_joining': dateOfJoining,
      'date_of_birth': dateOfBirth,
      'status': 'Active',
      'company': company,
      if (lastName != null && lastName!.isNotEmpty)
        'last_name': lastName,
      if (department != null && department!.isNotEmpty)
        'department': department,
      if (designation != null && designation!.isNotEmpty)
        'designation': designation,
    };
  }
}