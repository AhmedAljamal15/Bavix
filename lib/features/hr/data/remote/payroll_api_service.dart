import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:erp_sales/features/hr/data/models/payroll_model.dart';

class PayrollApiService {
  final Dio dio;

  PayrollApiService(this.dio);

  Future<List<SalarySlipModel>> getSalarySlips() async {
    final response = await dio.get(
      '/api/resource/Salary Slip',
      queryParameters: {
        'fields':
            '["name","employee","employee_name","start_date","end_date","status","company","net_pay"]',
        'order_by': 'modified desc',
        'limit_page_length': 100,
      },
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'] as List? ?? [];

    return data
        .map((e) => SalarySlipModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<PayrollEntryModel>> getPayrollEntries() async {
    final response = await dio.get(
      '/api/resource/Payroll Entry',
      queryParameters: {
        'fields':
            '["name","company","payroll_payable_account","start_date","end_date","status"]',
        'order_by': 'modified desc',
        'limit_page_length': 100,
      },
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'] as List? ?? [];

    return data
        .map((e) => PayrollEntryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> getSalarySlipDetails(String name) async {
    final response = await dio.get(
      '/api/resource/Salary Slip/$name',
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    return Map<String, dynamic>.from(response.data['data']);
  }

  Future<Map<String, dynamic>> getPayrollEntryDetails(String name) async {
    final response = await dio.get(
      '/api/resource/Payroll Entry/$name',
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    return Map<String, dynamic>.from(response.data['data']);
  }

  Future<void> createPayrollEntry(CreatePayrollEntryRequest request) async {
    final response = await dio.post(
      '/api/resource/Payroll Entry',
      data: request.toJson(),
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(response.data.toString());
    }
  }

  Future<List<String>> getCompanies() async {
    final response = await dio.get(
      '/api/resource/Company',
      queryParameters: {'fields': '["name"]', 'limit_page_length': 100},
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'] as List? ?? [];

    return data
        .map((e) => (e as Map<String, dynamic>)['name']?.toString() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<List<String>> getAccounts() async {
    final response = await dio.get(
      '/api/resource/Account',
      queryParameters: {
        'fields': '["name"]',
        'filters': '[["is_group","=",0]]',
        'limit_page_length': 200,
      },
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    final data = response.data['data'] as List? ?? [];

    return data
        .map((e) => (e as Map<String, dynamic>)['name']?.toString() ?? '')
        .where((e) => e.isNotEmpty)
        .toList();
  }

  Future<Map<String, dynamic>> runPayrollEntryMethod({
    required Map<String, dynamic> doc,
    required String method,
  }) async {
    final response = await dio.post(
      '/api/method/run_doc_method',
      data: FormData.fromMap({'docs': jsonEncode(doc), 'method': method}),
      options: Options(
        contentType: 'multipart/form-data',
        validateStatus: (_) => true,
      ),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    if (response.data is Map && response.data['exc'] != null) {
      throw Exception(response.data.toString());
    }

    final responseMap = Map<String, dynamic>.from(response.data as Map);

    final docs = responseMap['docs'];
    if (docs is! List || docs.isEmpty) {
      return responseMap;
    }

    final updatedDoc = Map<String, dynamic>.from(docs.first as Map);

    final saveResponse = await dio.post(
      '/api/method/frappe.client.save',
      data: {'doc': jsonEncode(updatedDoc)},
      options: Options(validateStatus: (_) => true),
    );

    if (saveResponse.statusCode != 200) {
      throw Exception(saveResponse.data.toString());
    }

    if (saveResponse.data is Map && saveResponse.data['exc'] != null) {
      throw Exception(saveResponse.data.toString());
    }

    return Map<String, dynamic>.from(saveResponse.data as Map);
  }

  Future<void> addEmployeeToPayrollEntry({
    required Map<String, dynamic> payrollDoc,
    required String employee,
    required String employeeName,
  }) async {
    final updatedDoc = Map<String, dynamic>.from(payrollDoc);

    updatedDoc['employees'] = [
      {
        'doctype': 'Payroll Employee Detail',
        'parent': updatedDoc['name'],
        'parenttype': 'Payroll Entry',
        'parentfield': 'employees',
        'idx': 1,
        'employee': employee,
        'employee_name': employeeName,
        'department': 'Accounts - S',
        'designation': 'Accountant',
        'is_salary_withheld': 0,
      },
    ];

    updatedDoc['number_of_employees'] = 1;

    final response = await dio.post(
      '/api/method/frappe.client.save',
      data: {'doc': jsonEncode(updatedDoc)},
      options: Options(validateStatus: (_) => true),
    );

    if (response.statusCode != 200) {
      throw Exception(response.data.toString());
    }

    if (response.data is Map && response.data['exc'] != null) {
      throw Exception(response.data.toString());
    }
  }
}
