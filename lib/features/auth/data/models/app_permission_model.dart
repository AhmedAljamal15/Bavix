import 'package:erp_sales/features/auth/data/models/app_user_model.dart';

class AppPermissionModel {
  final bool canViewAdminDashboard;
  final bool canViewSalesDashboard;
  final bool canViewHrDashboard;
  final bool canViewCustomerDashboard;
  final bool canViewInventory;
  final bool canManageAccessRequests;
  final bool canViewCustomers;
  final bool canViewItems;
  final bool canViewOrders;
  final bool canViewInvoices;
  final bool canViewDeliveryNotes;

  const AppPermissionModel({
    required this.canViewAdminDashboard,
    required this.canViewSalesDashboard,
    required this.canViewHrDashboard,
    required this.canViewCustomerDashboard,
    required this.canViewInventory,
    required this.canManageAccessRequests,
    required this.canViewCustomers,
    required this.canViewItems,
    required this.canViewOrders,
    required this.canViewInvoices,
    required this.canViewDeliveryNotes,
  });

  factory AppPermissionModel.fromRole(AppRole role) {
    switch (role) {
      case AppRole.admin:
        return const AppPermissionModel(
          canViewAdminDashboard: true,
          canViewSalesDashboard: true,
          canViewHrDashboard: true,
          canViewCustomerDashboard: true,
          canViewInventory: true,
          canManageAccessRequests: true,
          canViewCustomers: true,
          canViewItems: true,
          canViewOrders: true,
          canViewInvoices: true,
          canViewDeliveryNotes: true,
        );

      case AppRole.sales:
        return const AppPermissionModel(
          canViewAdminDashboard: false,
          canViewSalesDashboard: true,
          canViewHrDashboard: false,
          canViewCustomerDashboard: false,
          canViewInventory: true,
          canManageAccessRequests: false,
          canViewCustomers: true,
          canViewItems: true,
          canViewOrders: true,
          canViewInvoices: true,
          canViewDeliveryNotes: true,
        );

      case AppRole.hr:
        return const AppPermissionModel(
          canViewAdminDashboard: false,
          canViewSalesDashboard: false,
          canViewHrDashboard: true,
          canViewCustomerDashboard: false,
          canViewInventory: false,
          canManageAccessRequests: true,
          canViewCustomers: false,
          canViewItems: false,
          canViewOrders: false,
          canViewInvoices: false,
          canViewDeliveryNotes: false,
        );

      case AppRole.customer:
        return const AppPermissionModel(
          canViewAdminDashboard: false,
          canViewSalesDashboard: false,
          canViewHrDashboard: false,
          canViewCustomerDashboard: true,
          canViewInventory: false,
          canManageAccessRequests: false,
          canViewCustomers: false,
          canViewItems: false,
          canViewOrders: false,
          canViewInvoices: false,
          canViewDeliveryNotes: false,
        );

      case AppRole.employee:
      case AppRole.unknown:
        return const AppPermissionModel(
          canViewAdminDashboard: false,
          canViewSalesDashboard: true,
          canViewHrDashboard: false,
          canViewCustomerDashboard: false,
          canViewInventory: false,
          canManageAccessRequests: false,
          canViewCustomers: true,
          canViewItems: true,
          canViewOrders: true,
          canViewInvoices: true,
          canViewDeliveryNotes: true,
        );
    }
  }
}