import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/auth/data/models/access_request.dart';
import 'package:erp_sales/features/auth/data/repo/access_request_repository.dart';
import 'access_request_state.dart';

class AccessRequestCubit extends Cubit<AccessRequestState> {
  final AccessRequestRepository repository;

  AccessRequestCubit(this.repository) : super(const AccessRequestInitial());

  Future<void> submitRequest(AccessRequest request) async {
    emit(const AccessRequestLoading());

    try {
      final leadName = await repository.createAccessRequest(request);
      emit(AccessRequestSuccess(leadName));
    } catch (e) {
      emit(AccessRequestError(e.toString()));
    }
  }
}
