import 'package:erp_sales/features/hr/data/models/employee_model.dart';
import 'package:erp_sales/features/hr/data/remote/employees_api_service.dart';

class EmployeesRepository {
  final EmployeesApiService apiService;

  EmployeesRepository(this.apiService);

  Future<void> createEmployee(CreateEmployeeRequest request) async {
    await apiService.createEmployee(request);
  }

  Future<List<String>> getCompanies() async {
    return apiService.getCompanies();
  }

  Future<List<String>> getDepartments() async {
    return apiService.getDepartments();
  }

  Future<List<String>> getDesignations() async {
    return apiService.getDesignations();
  }


  Future<void> debugEmployeePermission() async {
  await apiService.debugEmployeePermission();
}
}