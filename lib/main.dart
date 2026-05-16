import 'package:device_preview/device_preview.dart';
import 'package:erp_sales/core/di/injection_container.dart';
import 'package:erp_sales/core/helpers/app_navigator.dart';
import 'package:erp_sales/core/language/cubit/language_cubit.dart';
import 'package:erp_sales/core/language/cubit/language_state.dart';
import 'package:erp_sales/core/theme/build_theme.dart';
import 'package:erp_sales/core/theme/theme_cubit.dart';
import 'package:erp_sales/core/theme/theme_state.dart';
import 'package:erp_sales/features/ai_assistant/data/repo/ai_assistant_repository.dart';
import 'package:erp_sales/features/auth/data/repo/access_request_admin_repository.dart';
import 'package:erp_sales/features/auth/data/repo/access_request_repository.dart';
import 'package:erp_sales/features/auth/data/repo/auth_repository.dart';
import 'package:erp_sales/features/auth/data/repo/hr_users_repository.dart';
import 'package:erp_sales/features/auth/presentation/screens/splash_screen.dart';
import 'package:erp_sales/features/customers/data/repo/customers_repository.dart';
import 'package:erp_sales/features/hr/data/repo/attendance_repository.dart';
import 'package:erp_sales/features/hr/data/repo/employees_repository.dart';
import 'package:erp_sales/features/hr/data/repo/leave_requests_repository.dart';
import 'package:erp_sales/features/hr/data/repo/payroll_repository.dart';
import 'package:erp_sales/features/items/data/repo/create_stock_entry_repository.dart';
import 'package:erp_sales/features/items/data/repo/item_details_repository.dart';
import 'package:erp_sales/features/items/data/repo/items_repository.dart';
import 'package:erp_sales/features/items/data/repo/stock_entries_repository.dart';
import 'package:erp_sales/features/items/data/repo/warehouse_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/create_sales_order_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_note_details_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_note_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/delivery_notes_list_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoice_details_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoice_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_invoices_list_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_order_details_repository.dart';
import 'package:erp_sales/features/sales_orders/data/repo/sales_orders_list_repository.dart';
import 'package:erp_sales/features/search/data/repo/global_search_repository.dart';
import 'package:erp_sales/firebase_options.dart';
import 'package:erp_sales/l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await dotenv.load(fileName: ".env");
  await InjectionContainer.init();
  await InjectionContainer.themeCubit.loadTheme();
  await InjectionContainer.languageCubit.loadLanguage();
  runApp(DevicePreview(enabled: true, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>.value(
          value: InjectionContainer.authRepository,
        ),
        RepositoryProvider<HrUsersRepository>.value(
          value: InjectionContainer.hrUsersRepository,
        ),
        RepositoryProvider<AccessRequestRepository>.value(
          value: InjectionContainer.accessRequestRepository,
        ),
        RepositoryProvider<AccessRequestAdminRepository>.value(
          value: InjectionContainer.accessRequestAdminRepository,
        ),
        RepositoryProvider<CustomersRepository>.value(
          value: InjectionContainer.customersRepository,
        ),
        RepositoryProvider<ItemsRepository>.value(
          value: InjectionContainer.itemsRepository,
        ),
        RepositoryProvider<ItemDetailsRepository>.value(
          value: InjectionContainer.itemDetailsRepository,
        ),
        RepositoryProvider<StockEntriesRepository>.value(
          value: InjectionContainer.stockEntriesRepository,
        ),
        RepositoryProvider<WarehouseRepository>.value(
          value: InjectionContainer.warehouseRepository,
        ),
        RepositoryProvider<CreateStockEntryRepository>.value(
          value: InjectionContainer.createStockEntryRepository,
        ),
        RepositoryProvider<SalesOrdersListRepository>.value(
          value: InjectionContainer.salesOrdersListRepository,
        ),
        RepositoryProvider<SalesOrderDetailsRepository>.value(
          value: InjectionContainer.salesOrderDetailsRepository,
        ),
        RepositoryProvider<DeliveryNoteRepository>.value(
          value: InjectionContainer.deliveryNoteRepository,
        ),
        RepositoryProvider<DeliveryNotesListRepository>.value(
          value: InjectionContainer.deliveryNotesListRepository,
        ),
        RepositoryProvider<DeliveryNoteDetailsRepository>.value(
          value: InjectionContainer.deliveryNoteDetailsRepository,
        ),
        RepositoryProvider<SalesInvoiceRepository>.value(
          value: InjectionContainer.salesInvoiceRepository,
        ),
        RepositoryProvider<SalesInvoicesListRepository>.value(
          value: InjectionContainer.salesInvoicesListRepository,
        ),
        RepositoryProvider<SalesInvoiceDetailsRepository>.value(
          value: InjectionContainer.salesInvoiceDetailsRepository,
        ),
        RepositoryProvider<GlobalSearchRepository>.value(
          value: InjectionContainer.globalSearchRepository,
        ),
        RepositoryProvider<LeaveRequestsRepository>.value(
          value: InjectionContainer.leaveRequestsRepository,
        ),
        RepositoryProvider<AttendanceRepository>.value(
          value: InjectionContainer.attendanceRepository,
        ),
        RepositoryProvider<EmployeesRepository>.value(
          value: InjectionContainer.employeesRepository,
        ),
        RepositoryProvider<PayrollRepository>.value(
          value: InjectionContainer.payrollRepository,
        ),
        RepositoryProvider<CreateSalesOrderRepository>.value(
  value: InjectionContainer.createSalesOrderRepository,
),
RepositoryProvider<AiAssistantRepository>.value(
  value: InjectionContainer.aiAssistantRepository,
),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>.value(value: InjectionContainer.themeCubit),
          BlocProvider<LanguageCubit>.value(
            value: InjectionContainer.languageCubit,
          ),
        ],
        child: BlocBuilder<LanguageCubit, LanguageState>(
          builder: (context, languageState) {
            return BlocBuilder<ThemeCubit, ThemeState>(
              builder: (context, themeState) {
                return MaterialApp(
                  locale: languageState.locale,
                  builder: DevicePreview.appBuilder,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: const [Locale('en'), Locale('ar')],
                  onGenerateTitle: (context) =>
                      AppLocalizations.of(context)!.appTitle,
                  debugShowCheckedModeBanner: false,
                  themeMode: themeState.themeMode,
                  theme: buildLightTheme(),
                  darkTheme: buildDarkTheme(),
                  home: SplashScreen(
                    authRepository: InjectionContainer.authRepository,
                  ),
                  navigatorKey: AppNavigator.navigatorKey,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
