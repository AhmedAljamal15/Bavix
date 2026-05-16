import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:erp_sales/features/auth/data/repo/auth_repository.dart';
import 'package:erp_sales/features/customers/data/repo/customers_repository.dart';
import 'package:erp_sales/features/items/data/repo/items_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_orders_list_repository.dart';

part 'dashboard_state.dart';

/// Dashboard Cubit - manages dashboard state and business logic
class DashboardCubit extends Cubit<DashboardState> {
  final AuthRepository authRepository;
  final CustomersRepository customersRepository;
  final ItemsRepository itemsRepository;
  final SalesOrdersListRepository salesOrdersListRepository;

  DashboardCubit({
    required this.authRepository,
    required this.customersRepository,
    required this.itemsRepository,
    required this.salesOrdersListRepository,
  }) : super(DashboardInitial());

  /// Load dashboard data
  Future<void> loadDashboard() async {
    emit(DashboardLoading());
    try {
      final userFuture = authRepository.getCurrentUser();
      final customersFuture = customersRepository.getCustomers();
      final itemsFuture = itemsRepository.getItems();
      final ordersFuture = salesOrdersListRepository.getSalesOrders();

      await Future.wait([
        userFuture,
        customersFuture,
        itemsFuture,
        ordersFuture,
      ]);

      final user = await userFuture;
      final customers = await customersFuture;
      final items = await itemsFuture;
      final orders = await ordersFuture;

      emit(
        DashboardLoaded(
          welcomeMessage: 'Welcome, ${user?.fullName ?? 'User'}!',
          totalSalesOrders: orders.length,
          totalCustomers: customers.length,
          totalItems: items.length,
          totalRevenue: 0.0,
          pendingOrders: orders.length.toDouble(),
          recentActivities: orders.length,
        ),
      );
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  /// Refresh dashboard data
  Future<void> refresh() async {
    await loadDashboard();
  }
}
