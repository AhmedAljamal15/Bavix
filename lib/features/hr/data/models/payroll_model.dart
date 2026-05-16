class SalarySlipModel {
  final String name;
  final String employee;
  final String employeeName;
  final String startDate;
  final String endDate;
  final String status;
  final String company;
  final double netPay;

  const SalarySlipModel({
    required this.name,
    required this.employee,
    required this.employeeName,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.company,
    required this.netPay,
  });

  factory SalarySlipModel.fromJson(Map<String, dynamic> json) {
    return SalarySlipModel(
      name: json['name'] ?? '',
      employee: json['employee'] ?? '',
      employeeName: json['employee_name'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      status: json['status'] ?? '',
      company: json['company'] ?? '',
      netPay: (json['net_pay'] ?? 0).toDouble(),
    );
  }
}

class PayrollEntryModel {
  final String name;
  final String company;
  final String payrollPayableAccount;
  final String startDate;
  final String endDate;
  final String status;

  const PayrollEntryModel({
    required this.name,
    required this.company,
    required this.payrollPayableAccount,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory PayrollEntryModel.fromJson(Map<String, dynamic> json) {
    return PayrollEntryModel(
      name: json['name'] ?? '',
      company: json['company'] ?? '',
      payrollPayableAccount: json['payroll_payable_account'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      status: json['status'] ?? '',
    );
  }
}

class CreatePayrollEntryRequest {
  final String company;
  final String startDate;
  final String endDate;
  final String postingDate;
  final String payrollPayableAccount;
  final String currency;
  final double exchangeRate;

  const CreatePayrollEntryRequest({
    required this.company,
    required this.startDate,
    required this.endDate,
    required this.postingDate,
    required this.payrollPayableAccount,
    required this.currency,
    required this.exchangeRate,
  });

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'payroll_frequency': 'Monthly',
      'start_date': startDate,
      'end_date': endDate,
      'posting_date': postingDate,
      'payroll_payable_account': payrollPayableAccount,
      'currency': currency,
      'exchange_rate': exchangeRate,
    };
  }
}