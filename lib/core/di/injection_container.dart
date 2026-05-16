import 'package:dio/dio.dart';
import 'package:erp_sales/core/language/cubit/language_cubit.dart';
import 'package:erp_sales/core/language/language_local_storage.dart';
import 'package:erp_sales/core/network/dio_factory.dart';
import 'package:erp_sales/core/theme/theme_cubit.dart';
import 'package:erp_sales/core/theme/theme_local_storage.dart';
import 'package:erp_sales/features/ai_assistant/data/remote/ai_assistant_api_service.dart';
import 'package:erp_sales/features/ai_assistant/data/remote/ai_erp_lookup_api_service.dart';
import 'package:erp_sales/features/ai_assistant/data/repo/ai_assistant_repository.dart';
import 'package:erp_sales/features/auth/data/local/auth_local_storage.dart';
import 'package:erp_sales/features/auth/data/remote/access_request_admin_api_service.dart';
import 'package:erp_sales/features/auth/data/remote/access_request_api_service.dart';
import 'package:erp_sales/features/auth/data/remote/auth_api_service.dart';
import 'package:erp_sales/features/auth/data/remote/hr_users_api_service.dart';
import 'package:erp_sales/features/auth/data/repo/access_request_admin_repository.dart';
import 'package:erp_sales/features/auth/data/repo/access_request_repository.dart';
import 'package:erp_sales/features/auth/data/repo/auth_repository.dart';
import 'package:erp_sales/features/auth/data/repo/hr_users_repository.dart';
import 'package:erp_sales/features/customers/data/remote/customers_api_service.dart';
import 'package:erp_sales/features/customers/data/repo/customers_repository.dart';
import 'package:erp_sales/features/hr/data/remote/attendance_api_service.dart';
import 'package:erp_sales/features/hr/data/remote/employees_api_service.dart';
import 'package:erp_sales/features/hr/data/remote/leave_requests_api_service.dart';
import 'package:erp_sales/features/hr/data/remote/payroll_api_service.dart';
import 'package:erp_sales/features/hr/data/repo/attendance_repository.dart';
import 'package:erp_sales/features/hr/data/repo/employees_repository.dart';
import 'package:erp_sales/features/hr/data/repo/leave_requests_repository.dart';
import 'package:erp_sales/features/hr/data/repo/payroll_repository.dart';
import 'package:erp_sales/features/items/data/remote/create_stock_entry_api_service.dart';
import 'package:erp_sales/features/items/data/remote/item_details_api_service.dart';
import 'package:erp_sales/features/items/data/remote/items_api_service.dart';
import 'package:erp_sales/features/items/data/remote/stock_entries_api_service.dart';
import 'package:erp_sales/features/items/data/remote/warehouse_api_service.dart';
import 'package:erp_sales/features/items/data/repo/create_stock_entry_repository.dart';
import 'package:erp_sales/features/items/data/repo/item_details_repository.dart';
import 'package:erp_sales/features/items/data/repo/items_repository.dart';
import 'package:erp_sales/features/items/data/repo/stock_entries_repository.dart';
import 'package:erp_sales/features/items/data/repo/warehouse_repository.dart';
import 'package:erp_sales/features/sales_orders/data/remote/create_sales_order_api_service.dart';
import 'package:erp_sales/features/sales_orders/data/remote/delivery_note_api_service.dart';
import 'package:erp_sales/features/sales_orders/data/remote/delivery_note_details_api_service.dart';
import 'package:erp_sales/features/sales_orders/data/remote/delivery_notes_list_api_service.dart';
import 'package:erp_sales/features/sales_orders/data/remote/sales_invoice_api_service.dart';
import 'package:erp_sales/features/sales_orders/data/remote/sales_invoice_details_api_service.dart';
import 'package:erp_sales/features/sales_orders/data/remote/sales_invoices_list_api_service.dart';
import 'package:erp_sales/features/sales_orders/data/remote/sales_order_details_api_service.dart';
import 'package:erp_sales/features/sales_orders/data/remote/sales_orders_list_api_service.dart';
import 'package:erp_sales/features/sales_orders/data/repo/create_sales_order_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_note_details_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_note_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_notes_list_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoice_details_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoice_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoices_list_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_order_details_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_orders_list_repository.dart';
import 'package:erp_sales/features/search/data/remote/global_search_api_service.dart';
import 'package:erp_sales/features/search/data/repo/global_search_repository.dart';

/// Enterprise dependency injection container
/// Centralized setup for all services, repositories, and cubits
class InjectionContainer {
  static late Dio _dio;
  static late ThemeCubit _themeCubit;
  static late LanguageCubit _languageCubit;

  // Auth repositories
  static late AuthRepository _authRepository;
  static late HrUsersRepository _hrUsersRepository;
  static late AccessRequestRepository _accessRequestRepository;
  static late AccessRequestAdminRepository _accessRequestAdminRepository;

  // Customers repositories
  static late CustomersRepository _customersRepository;

  // Items repositories
  static late ItemsRepository _itemsRepository;
  static late ItemDetailsRepository _itemDetailsRepository;
  static late StockEntriesRepository _stockEntriesRepository;
  static late WarehouseRepository _warehouseRepository;
  static late CreateStockEntryRepository _createStockEntryRepository;

  // Sales repositories
  static late SalesOrdersListRepository _salesOrdersListRepository;
  static late SalesOrderDetailsRepository _salesOrderDetailsRepository;
  static late DeliveryNoteRepository _deliveryNoteRepository;
  static late DeliveryNotesListRepository _deliveryNotesListRepository;
  static late DeliveryNoteDetailsRepository _deliveryNoteDetailsRepository;
  static late SalesInvoiceRepository _salesInvoiceRepository;
  static late SalesInvoicesListRepository _salesInvoicesListRepository;
  static late SalesInvoiceDetailsRepository _salesInvoiceDetailsRepository;
  static late CreateSalesOrderRepository _createSalesOrderRepository;
  static late AiAssistantRepository _aiAssistantRepository;

  // Search repositories
  static late GlobalSearchRepository _globalSearchRepository;

  // HR repositories
  static late LeaveRequestsRepository _leaveRequestsRepository;
  static late AttendanceRepository _attendanceRepository;
  static late EmployeesRepository _employeesRepository;
  static late PayrollRepository _payrollRepository;

  /// Initialize all dependencies
  static Future<void> init() async {
    // Initialize HTTP client
    _dio = await DioFactory.createDio();

    // Initialize theme and language
    await _initializeCubits();

    // Initialize repositories
    _initializeAuthRepositories();
    _initializeCustomerRepositories();
    _initializeItemRepositories();
    _initializeSalesRepositories();
    _initializeSearchRepositories();
    _initializeHrRepositories();
  }

  static Future<void> _initializeCubits() async {
    final themeLocalStorage = ThemeLocalStorage();
    _themeCubit = ThemeCubit(themeLocalStorage);
    await _themeCubit.loadTheme();

    final languageLocalStorage = LanguageLocalStorage();
    _languageCubit = LanguageCubit(languageLocalStorage);
    await _languageCubit.loadLanguage();
  }

  static void _initializeAuthRepositories() {
    // API Services
    final authApiService = AuthApiService(_dio);
    final hrUsersApiService = HrUsersApiService(_dio);
    final accessRequestApiService = AccessRequestApiService(_dio);
    final accessRequestAdminApiService = AccessRequestAdminApiService(_dio);

    // Local Storage
    final authLocalStorage = AuthLocalStorage();

    // Create customers repository (needed by auth)
    final customersApiService = CustomersApiService(_dio);
    _customersRepository = CustomersRepository(customersApiService);

    // Repositories
    _authRepository = AuthRepository(
      apiService: authApiService,
      localStorage: authLocalStorage,
      customersRepository: _customersRepository,
    );
    _hrUsersRepository = HrUsersRepository(hrUsersApiService);
    _accessRequestRepository = AccessRequestRepository(accessRequestApiService);
    _accessRequestAdminRepository = AccessRequestAdminRepository(
      accessRequestAdminApiService,
    );
  }

  static void _initializeCustomerRepositories() {
    final customersApiService = CustomersApiService(_dio);
    _customersRepository = CustomersRepository(customersApiService);
  }

  static void _initializeItemRepositories() {
    // API Services
    final itemsApiService = ItemsApiService(_dio);
    final itemDetailsApiService = ItemDetailsApiService(_dio);
    final stockEntriesApiService = StockEntriesApiService(_dio);
    final warehouseApiService = WarehouseApiService(_dio);
    final createStockEntryApiService = CreateStockEntryApiService(_dio);

    // Repositories
    _itemsRepository = ItemsRepository(itemsApiService);
    _itemDetailsRepository = ItemDetailsRepository(itemDetailsApiService);
    _stockEntriesRepository = StockEntriesRepository(stockEntriesApiService);
    _warehouseRepository = WarehouseRepository(warehouseApiService);
    _createStockEntryRepository = CreateStockEntryRepository(
      createStockEntryApiService,
    );
  }

  static void _initializeSalesRepositories() {
    // API Services
    final salesOrdersListApiService = SalesOrdersListApiService(_dio);
    final salesOrderDetailsApiService = SalesOrderDetailsApiService(_dio);
    final deliveryNoteApiService = DeliveryNoteApiService(_dio);
    final deliveryNotesListApiService = DeliveryNotesListApiService(_dio);
    final deliveryNoteDetailsApiService = DeliveryNoteDetailsApiService(_dio);
    final salesInvoiceApiService = SalesInvoiceApiService(_dio);
    final salesInvoicesListApiService = SalesInvoicesListApiService(_dio);
    final salesInvoiceDetailsApiService = SalesInvoiceDetailsApiService(_dio);
    final createSalesOrderApiService = CreateSalesOrderApiService(_dio);
    final aiAssistantApiService = AiAssistantApiService();
    final aiErpLookupApiService = AiErpLookupApiService(_dio);

    // Repositories
    _salesOrdersListRepository = SalesOrdersListRepository(
      salesOrdersListApiService,
    );
    _salesOrderDetailsRepository = SalesOrderDetailsRepository(
      salesOrderDetailsApiService,
    );
    _deliveryNoteRepository = DeliveryNoteRepository(deliveryNoteApiService);
    _deliveryNotesListRepository = DeliveryNotesListRepository(
      deliveryNotesListApiService,
    );
    _deliveryNoteDetailsRepository = DeliveryNoteDetailsRepository(
      deliveryNoteDetailsApiService,
    );
    _salesInvoiceRepository = SalesInvoiceRepository(salesInvoiceApiService);
    _salesInvoicesListRepository = SalesInvoicesListRepository(
      salesInvoicesListApiService,
    );
    _salesInvoiceDetailsRepository = SalesInvoiceDetailsRepository(
      salesInvoiceDetailsApiService,
    );
    _createSalesOrderRepository = CreateSalesOrderRepository(
      createSalesOrderApiService,
    );

    _aiAssistantRepository = AiAssistantRepository(
      aiApiService: aiAssistantApiService,
      lookupApiService: aiErpLookupApiService,
      createSalesOrderRepository: _createSalesOrderRepository,
    );
  }

  static void _initializeSearchRepositories() {
    final globalSearchApiService = GlobalSearchApiService(_dio);
    _globalSearchRepository = GlobalSearchRepository(globalSearchApiService);
  }

  static void _initializeHrRepositories() {
    final leaveRequestsApiService = LeaveRequestsApiService(_dio);
    final attendanceApiService = AttendanceApiService(_dio);
    final employeesApiService = EmployeesApiService(_dio);
    final payrollApiService = PayrollApiService(_dio);

    _leaveRequestsRepository = LeaveRequestsRepository(leaveRequestsApiService);
    _attendanceRepository = AttendanceRepository(attendanceApiService);
    _employeesRepository = EmployeesRepository(employeesApiService);
    _payrollRepository = PayrollRepository(payrollApiService);
  }

  // Getters for all repositories
  static Dio get dio => _dio;
  static ThemeCubit get themeCubit => _themeCubit;
  static LanguageCubit get languageCubit => _languageCubit;

  static AuthRepository get authRepository => _authRepository;
  static HrUsersRepository get hrUsersRepository => _hrUsersRepository;

  static AccessRequestRepository get accessRequestRepository =>
      _accessRequestRepository;

  static AccessRequestAdminRepository get accessRequestAdminRepository =>
      _accessRequestAdminRepository;

  static CustomersRepository get customersRepository => _customersRepository;

  static ItemsRepository get itemsRepository => _itemsRepository;

  static ItemDetailsRepository get itemDetailsRepository =>
      _itemDetailsRepository;

  static StockEntriesRepository get stockEntriesRepository =>
      _stockEntriesRepository;

  static WarehouseRepository get warehouseRepository => _warehouseRepository;

  static CreateStockEntryRepository get createStockEntryRepository =>
      _createStockEntryRepository;

  static SalesOrdersListRepository get salesOrdersListRepository =>
      _salesOrdersListRepository;

  static SalesOrderDetailsRepository get salesOrderDetailsRepository =>
      _salesOrderDetailsRepository;

  static DeliveryNoteRepository get deliveryNoteRepository =>
      _deliveryNoteRepository;

  static DeliveryNotesListRepository get deliveryNotesListRepository =>
      _deliveryNotesListRepository;

  static DeliveryNoteDetailsRepository get deliveryNoteDetailsRepository =>
      _deliveryNoteDetailsRepository;

  static SalesInvoiceRepository get salesInvoiceRepository =>
      _salesInvoiceRepository;

  static SalesInvoicesListRepository get salesInvoicesListRepository =>
      _salesInvoicesListRepository;

  static SalesInvoiceDetailsRepository get salesInvoiceDetailsRepository =>
      _salesInvoiceDetailsRepository;

  static GlobalSearchRepository get globalSearchRepository =>
      _globalSearchRepository;

  static LeaveRequestsRepository get leaveRequestsRepository =>
      _leaveRequestsRepository;

  static AttendanceRepository get attendanceRepository => _attendanceRepository;

  static EmployeesRepository get employeesRepository => _employeesRepository;
  static PayrollRepository get payrollRepository => _payrollRepository;

  static CreateSalesOrderRepository get createSalesOrderRepository =>
      _createSalesOrderRepository;

  static AiAssistantRepository get aiAssistantRepository =>
      _aiAssistantRepository;
}
