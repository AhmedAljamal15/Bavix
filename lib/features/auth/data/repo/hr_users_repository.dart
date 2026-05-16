import 'package:erp_sales/features/auth/data/models/hr_user_model.dart';
import 'package:erp_sales/features/auth/data/remote/hr_users_api_service.dart';

class HrUsersRepository {
  final HrUsersApiService apiService;

  HrUsersRepository(this.apiService);

  Future<List<HrUserModel>> getUsers() async {
    return apiService.getUsers();
  }
}