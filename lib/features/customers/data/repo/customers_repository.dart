import '../models/customer_model.dart';
import '../models/create_customer_request.dart';
import '../remote/customers_api_service.dart';

class CustomersRepository {
  final CustomersApiService apiService;

  CustomersRepository(this.apiService);

  Future<List<CustomerModel>> getCustomers() async {
    return apiService.getCustomers();
  }

  Future<void> createCustomer(CreateCustomerRequest request) async {
    await apiService.createCustomer(request);
  }

  Future<dynamic> getCustomerByEmail(String email) async {
    return apiService.getCustomerByEmail(email);
  }
}
