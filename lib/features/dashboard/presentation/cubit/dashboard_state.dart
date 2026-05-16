part of 'dashboard_cubit.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final String welcomeMessage;
  final int totalSalesOrders;
  final int totalCustomers;
  final int totalItems;
  final double totalRevenue;
  final double pendingOrders;
  final int recentActivities;

  const DashboardLoaded({
    required this.welcomeMessage,
    required this.totalSalesOrders,
    required this.totalCustomers,
    required this.totalItems,
    required this.totalRevenue,
    required this.pendingOrders,
    required this.recentActivities,
  });

  @override
  List<Object?> get props => [
    welcomeMessage,
    totalSalesOrders,
    totalCustomers,
    totalItems,
    totalRevenue,
    pendingOrders,
    recentActivities,
  ];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
