import 'package:erp_sales/features/hr/data/models/payroll_model.dart';
import 'package:erp_sales/features/hr/data/remote/payroll_api_service.dart';

class PayrollRepository {
  final PayrollApiService apiService;

  PayrollRepository(this.apiService);

  Future<List<SalarySlipModel>> getSalarySlips() async {
    return apiService.getSalarySlips();
  }

  Future<List<PayrollEntryModel>> getPayrollEntries() async {
    return apiService.getPayrollEntries();
  }

  Future<Map<String, dynamic>> getSalarySlipDetails(String name) async {
    return apiService.getSalarySlipDetails(name);
  }

  Future<Map<String, dynamic>> getPayrollEntryDetails(String name) async {
    return apiService.getPayrollEntryDetails(name);
  }

  Future<void> createPayrollEntry(CreatePayrollEntryRequest request) async {
    await apiService.createPayrollEntry(request);
  }

  Future<List<String>> getCompanies() async {
    return apiService.getCompanies();
  }

  Future<List<String>> getAccounts() async {
    return apiService.getAccounts();
  }

  Future<void> createSalarySlips(Map<String, dynamic> doc) async {
    await apiService.runPayrollEntryMethod(
      doc: doc,
      method: 'create_salary_slips',
    );
  }

  Future<void> submitSalarySlips(Map<String, dynamic> doc) async {
    await apiService.runPayrollEntryMethod(
      doc: doc,
      method: 'submit_salary_slips',
    );
  }

  Future<void> makeBankEntry({
    required Map<String, dynamic> doc,
    required String paymentAccount,
  }) async {
    await apiService.runPayrollEntryMethod(doc: doc, method: 'make_bank_entry');
  }

  Future<void> getEmployees(Map<String, dynamic> doc) async {
    await apiService.runPayrollEntryMethod(
      doc: doc,
      method: 'fill_employee_details',
    );
  }

  Future<void> addEmployeeToPayrollEntry(
    Map<String, dynamic> payrollDoc,
  ) async {
    await apiService.addEmployeeToPayrollEntry(
      payrollDoc: payrollDoc,
      employee: 'HR-EMP-00001',
      employeeName: 'Ahmed Gad',
    );
  }
}
