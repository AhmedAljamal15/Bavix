import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Smartel ERP'**
  String get appTitle;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get items;

  /// No description provided for @salesOrders.
  ///
  /// In en, this message translates to:
  /// **'Sales Orders'**
  String get salesOrders;

  /// No description provided for @salesInvoices.
  ///
  /// In en, this message translates to:
  /// **'Sales Invoices'**
  String get salesInvoices;

  /// No description provided for @deliveryNotes.
  ///
  /// In en, this message translates to:
  /// **'Delivery Notes'**
  String get deliveryNotes;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @requestAccess.
  ///
  /// In en, this message translates to:
  /// **'Request Access'**
  String get requestAccess;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @userType.
  ///
  /// In en, this message translates to:
  /// **'User Type'**
  String get userType;

  /// No description provided for @roles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get roles;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @lightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @followSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow System'**
  String get followSystem;

  /// No description provided for @adminDashboard.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboard;

  /// No description provided for @salesDashboard.
  ///
  /// In en, this message translates to:
  /// **'Sales Dashboard'**
  String get salesDashboard;

  /// No description provided for @customerDashboard.
  ///
  /// In en, this message translates to:
  /// **'Customer Dashboard'**
  String get customerDashboard;

  /// No description provided for @hrDashboard.
  ///
  /// In en, this message translates to:
  /// **'HR Dashboard'**
  String get hrDashboard;

  /// No description provided for @accountInformation.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @noCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No customers found'**
  String get noCustomersFound;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFound;

  /// No description provided for @noSalesInvoicesFound.
  ///
  /// In en, this message translates to:
  /// **'No sales invoices found'**
  String get noSalesInvoicesFound;

  /// No description provided for @noDeliveryNotesFound.
  ///
  /// In en, this message translates to:
  /// **'No delivery notes found'**
  String get noDeliveryNotesFound;

  /// No description provided for @noOrdersFound.
  ///
  /// In en, this message translates to:
  /// **'No orders found'**
  String get noOrdersFound;

  /// No description provided for @erpSalesDashboard.
  ///
  /// In en, this message translates to:
  /// **'ERP Sales Dashboard'**
  String get erpSalesDashboard;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue to your ERP system'**
  String get signInToContinue;

  /// No description provided for @requestAccessButton.
  ///
  /// In en, this message translates to:
  /// **'Request Access'**
  String get requestAccessButton;

  /// No description provided for @createCustomerAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Customer Account'**
  String get createCustomerAccount;

  /// No description provided for @welcomeToYourErp.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Your ERP'**
  String get welcomeToYourErp;

  /// No description provided for @manageYourSalesEfficiently.
  ///
  /// In en, this message translates to:
  /// **'Manage your sales operations efficiently. Track items, customers, orders, and invoices all in one place.'**
  String get manageYourSalesEfficiently;

  /// No description provided for @manageItems.
  ///
  /// In en, this message translates to:
  /// **'Manage Items'**
  String get manageItems;

  /// No description provided for @trackProductsAndInventory.
  ///
  /// In en, this message translates to:
  /// **'Track products & inventory'**
  String get trackProductsAndInventory;

  /// No description provided for @manageCustomers.
  ///
  /// In en, this message translates to:
  /// **'Manage Customers'**
  String get manageCustomers;

  /// No description provided for @organizeClientInformation.
  ///
  /// In en, this message translates to:
  /// **'Organize client information'**
  String get organizeClientInformation;

  /// No description provided for @trackOrders.
  ///
  /// In en, this message translates to:
  /// **'Track Orders'**
  String get trackOrders;

  /// No description provided for @monitorSalesAndDelivery.
  ///
  /// In en, this message translates to:
  /// **'Monitor sales & delivery'**
  String get monitorSalesAndDelivery;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @allRoles.
  ///
  /// In en, this message translates to:
  /// **'All Roles'**
  String get allRoles;

  /// No description provided for @basicAccess.
  ///
  /// In en, this message translates to:
  /// **'Basic Access'**
  String get basicAccess;

  /// No description provided for @viewAllRoles.
  ///
  /// In en, this message translates to:
  /// **'View All Roles'**
  String get viewAllRoles;

  /// No description provided for @chooseAppearance.
  ///
  /// In en, this message translates to:
  /// **'Choose Appearance'**
  String get chooseAppearance;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @arabic.
  ///
  /// In en, this message translates to:
  /// **'العربية'**
  String get arabic;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @adminDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Admin Dashboard'**
  String get adminDashboardTitle;

  /// No description provided for @controlCenter.
  ///
  /// In en, this message translates to:
  /// **'Control Center'**
  String get controlCenter;

  /// No description provided for @monitorUsersCustomersProductsOrdersInvoicesAndDeliveries.
  ///
  /// In en, this message translates to:
  /// **'Monitor users, customers, products, orders, invoices, and deliveries'**
  String get monitorUsersCustomersProductsOrdersInvoicesAndDeliveries;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @userOverview.
  ///
  /// In en, this message translates to:
  /// **'User Overview'**
  String get userOverview;

  /// No description provided for @enabledUsers.
  ///
  /// In en, this message translates to:
  /// **'Enabled Users'**
  String get enabledUsers;

  /// No description provided for @systemUsers.
  ///
  /// In en, this message translates to:
  /// **'System Users'**
  String get systemUsers;

  /// No description provided for @websiteUsers.
  ///
  /// In en, this message translates to:
  /// **'Website Users'**
  String get websiteUsers;

  /// No description provided for @businessSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Business Snapshot'**
  String get businessSnapshot;

  /// No description provided for @totalInvoiceValue.
  ///
  /// In en, this message translates to:
  /// **'Total Invoice Value'**
  String get totalInvoiceValue;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get quickAccess;

  /// No description provided for @salesDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales Dashboard'**
  String get salesDashboardTitle;

  /// No description provided for @salesOperations.
  ///
  /// In en, this message translates to:
  /// **'Sales Operations'**
  String get salesOperations;

  /// No description provided for @manageCustomersProductsOrdersDeliveriesAndInvoices.
  ///
  /// In en, this message translates to:
  /// **'Manage customers, products, orders, deliveries, and invoices'**
  String get manageCustomersProductsOrdersDeliveriesAndInvoices;

  /// No description provided for @productCatalog.
  ///
  /// In en, this message translates to:
  /// **'Product Catalog'**
  String get productCatalog;

  /// No description provided for @clientDirectory.
  ///
  /// In en, this message translates to:
  /// **'Client Directory'**
  String get clientDirectory;

  /// No description provided for @orderManagement.
  ///
  /// In en, this message translates to:
  /// **'Order Management'**
  String get orderManagement;

  /// No description provided for @shipmentTracking.
  ///
  /// In en, this message translates to:
  /// **'Shipment Tracking'**
  String get shipmentTracking;

  /// No description provided for @hrDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'HR Dashboard'**
  String get hrDashboardTitle;

  /// No description provided for @humanResources.
  ///
  /// In en, this message translates to:
  /// **'Human Resources'**
  String get humanResources;

  /// No description provided for @manageUserAccessAndReviewWorkforceAccounts.
  ///
  /// In en, this message translates to:
  /// **'Manage user access and review workforce accounts'**
  String get manageUserAccessAndReviewWorkforceAccounts;

  /// No description provided for @totalUsers.
  ///
  /// In en, this message translates to:
  /// **'Total Users'**
  String get totalUsers;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @recentUsers.
  ///
  /// In en, this message translates to:
  /// **'Recent Users'**
  String get recentUsers;

  /// No description provided for @customerDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Dashboard'**
  String get customerDashboardTitle;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {name}'**
  String welcomeUser(String name);

  /// No description provided for @noLinkedCustomerProfileFound.
  ///
  /// In en, this message translates to:
  /// **'No linked customer profile found for this account'**
  String get noLinkedCustomerProfileFound;

  /// No description provided for @trackYourOrdersInvoicesAndDeliveries.
  ///
  /// In en, this message translates to:
  /// **'Track your orders, invoices, and deliveries'**
  String get trackYourOrdersInvoicesAndDeliveries;

  /// No description provided for @recentOrders.
  ///
  /// In en, this message translates to:
  /// **'Recent Orders'**
  String get recentOrders;

  /// No description provided for @recentInvoices.
  ///
  /// In en, this message translates to:
  /// **'Recent Invoices'**
  String get recentInvoices;

  /// No description provided for @recentDeliveryNotes.
  ///
  /// In en, this message translates to:
  /// **'Recent Delivery Notes'**
  String get recentDeliveryNotes;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @addCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get addCustomer;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @type.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @territory.
  ///
  /// In en, this message translates to:
  /// **'Territory'**
  String get territory;

  /// No description provided for @notSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notSet;

  /// No description provided for @accountInformationSection.
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformationSection;

  /// No description provided for @appSettingsSection.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettingsSection;

  /// No description provided for @createCustomerAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Customer Account'**
  String get createCustomerAccountTitle;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// No description provided for @enterCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Enter customer name'**
  String get enterCustomerName;

  /// No description provided for @enterCustomerEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter customer email'**
  String get enterCustomerEmail;

  /// No description provided for @customerType.
  ///
  /// In en, this message translates to:
  /// **'Customer Type'**
  String get customerType;

  /// No description provided for @individual.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get individual;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @createCustomerButton.
  ///
  /// In en, this message translates to:
  /// **'Create Customer'**
  String get createCustomerButton;

  /// No description provided for @customerCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Customer created successfully!'**
  String get customerCreatedSuccessfully;

  /// No description provided for @customerNameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Customer name is required'**
  String get customerNameIsRequired;

  /// No description provided for @customerNameMustBeAtLeast2Characters.
  ///
  /// In en, this message translates to:
  /// **'Customer name must be at least 2 characters'**
  String get customerNameMustBeAtLeast2Characters;

  /// No description provided for @emailIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailIsRequired;

  /// No description provided for @enterValidEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get enterValidEmail;

  /// No description provided for @errorInitializingApp.
  ///
  /// In en, this message translates to:
  /// **'Error initializing app: {error}'**
  String errorInitializingApp(String error);

  /// No description provided for @itemCode.
  ///
  /// In en, this message translates to:
  /// **'Item Code'**
  String get itemCode;

  /// No description provided for @enterItemCode.
  ///
  /// In en, this message translates to:
  /// **'Enter item code'**
  String get enterItemCode;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// No description provided for @enterItemName.
  ///
  /// In en, this message translates to:
  /// **'Enter item name'**
  String get enterItemName;

  /// No description provided for @itemGroup.
  ///
  /// In en, this message translates to:
  /// **'Item Group'**
  String get itemGroup;

  /// No description provided for @enterItemGroup.
  ///
  /// In en, this message translates to:
  /// **'Enter item group'**
  String get enterItemGroup;

  /// No description provided for @stockUom.
  ///
  /// In en, this message translates to:
  /// **'Stock UOM'**
  String get stockUom;

  /// No description provided for @enterStockUom.
  ///
  /// In en, this message translates to:
  /// **'Enter stock UOM'**
  String get enterStockUom;

  /// No description provided for @countryOfOrigin.
  ///
  /// In en, this message translates to:
  /// **'Country of Origin'**
  String get countryOfOrigin;

  /// No description provided for @enterCountryOfOrigin.
  ///
  /// In en, this message translates to:
  /// **'Enter country of origin'**
  String get enterCountryOfOrigin;

  /// No description provided for @isStockItem.
  ///
  /// In en, this message translates to:
  /// **'Is Stock Item'**
  String get isStockItem;

  /// No description provided for @isSalesItem.
  ///
  /// In en, this message translates to:
  /// **'Is Sales Item'**
  String get isSalesItem;

  /// No description provided for @createItem.
  ///
  /// In en, this message translates to:
  /// **'Create Item'**
  String get createItem;

  /// No description provided for @itemCreatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Item created successfully!'**
  String get itemCreatedSuccessfully;

  /// No description provided for @fieldIsRequired.
  ///
  /// In en, this message translates to:
  /// **'{label} is required'**
  String fieldIsRequired(String label);

  /// No description provided for @fieldMustBeAtLeast2Characters.
  ///
  /// In en, this message translates to:
  /// **'{label} must be at least 2 characters'**
  String fieldMustBeAtLeast2Characters(String label);

  /// No description provided for @itemDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Item Details'**
  String get itemDetailsTitle;

  /// No description provided for @basicInformation.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformation;

  /// No description provided for @pricingAndRates.
  ///
  /// In en, this message translates to:
  /// **'Pricing & Rates'**
  String get pricingAndRates;

  /// No description provided for @statusAndFlags.
  ///
  /// In en, this message translates to:
  /// **'Status & Flags'**
  String get statusAndFlags;

  /// No description provided for @standardRate.
  ///
  /// In en, this message translates to:
  /// **'Standard Rate'**
  String get standardRate;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @salesItem.
  ///
  /// In en, this message translates to:
  /// **'Sales Item'**
  String get salesItem;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @createStockEntry.
  ///
  /// In en, this message translates to:
  /// **'Create Stock Entry'**
  String get createStockEntry;

  /// No description provided for @uom.
  ///
  /// In en, this message translates to:
  /// **'UOM'**
  String get uom;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @stockItem.
  ///
  /// In en, this message translates to:
  /// **'Stock Item'**
  String get stockItem;

  /// No description provided for @notStockItem.
  ///
  /// In en, this message translates to:
  /// **'Not Stock Item'**
  String get notStockItem;

  /// No description provided for @notSalesItem.
  ///
  /// In en, this message translates to:
  /// **'Not Sales Item'**
  String get notSalesItem;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @createItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Item'**
  String get createItemTitle;

  /// No description provided for @createStockEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Stock Entry'**
  String get createStockEntryTitle;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @targetWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Target Warehouse'**
  String get targetWarehouse;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @basicRate.
  ///
  /// In en, this message translates to:
  /// **'Basic Rate'**
  String get basicRate;

  /// No description provided for @createStockEntryButton.
  ///
  /// In en, this message translates to:
  /// **'Create Stock Entry'**
  String get createStockEntryButton;

  /// No description provided for @pleaseSelectAnItem.
  ///
  /// In en, this message translates to:
  /// **'Please select an item'**
  String get pleaseSelectAnItem;

  /// No description provided for @pleaseSelectAWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Please select a warehouse'**
  String get pleaseSelectAWarehouse;

  /// No description provided for @pleaseEnterValidQuantity.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid quantity'**
  String get pleaseEnterValidQuantity;

  /// No description provided for @pleaseEnterValidBasicRate.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid basic rate'**
  String get pleaseEnterValidBasicRate;

  /// No description provided for @stockEntrySubmitted.
  ///
  /// In en, this message translates to:
  /// **'Stock Entry submitted: {name}'**
  String stockEntrySubmitted(String name);

  /// No description provided for @salesOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales Orders'**
  String get salesOrdersTitle;

  /// No description provided for @orderItems.
  ///
  /// In en, this message translates to:
  /// **'Order Items'**
  String get orderItems;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String customer(String name);

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String date(String date);

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery: {date}'**
  String delivery(String date);

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total: {amount}'**
  String total(String amount);

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// No description provided for @submitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submitted;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @orderDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get orderDetailsTitle;

  /// No description provided for @deliveryDate.
  ///
  /// In en, this message translates to:
  /// **'Delivery Date'**
  String get deliveryDate;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @orderSummary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// No description provided for @totalQty.
  ///
  /// In en, this message translates to:
  /// **'Total Qty'**
  String get totalQty;

  /// No description provided for @grandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get grandTotal;

  /// No description provided for @billingStatus.
  ///
  /// In en, this message translates to:
  /// **'Billing Status'**
  String get billingStatus;

  /// No description provided for @deliveryStatus.
  ///
  /// In en, this message translates to:
  /// **'Delivery Status'**
  String get deliveryStatus;

  /// No description provided for @createDeliveryNote.
  ///
  /// In en, this message translates to:
  /// **'Create Delivery Note'**
  String get createDeliveryNote;

  /// No description provided for @viewSalesInvoice.
  ///
  /// In en, this message translates to:
  /// **'View Sales Invoice'**
  String get viewSalesInvoice;

  /// No description provided for @submitDeliveryNote.
  ///
  /// In en, this message translates to:
  /// **'Submit: {name}'**
  String submitDeliveryNote(String name);

  /// No description provided for @deliveryNoteDraftCreated.
  ///
  /// In en, this message translates to:
  /// **'Delivery Note draft created: {name}'**
  String deliveryNoteDraftCreated(String name);

  /// No description provided for @deliveryNoteSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Delivery Note submitted successfully'**
  String get deliveryNoteSubmittedSuccessfully;

  /// No description provided for @salesInvoicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales Invoices'**
  String get salesInvoicesTitle;

  /// No description provided for @postingDate.
  ///
  /// In en, this message translates to:
  /// **'Posting Date: {date}'**
  String postingDate(String date);

  /// No description provided for @grandTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Grand Total: {amount} {currency}'**
  String grandTotalAmount(String amount, String currency);

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @invoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice - {orderId}'**
  String invoiceTitle(String orderId);

  /// No description provided for @invoiceDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoice Details'**
  String get invoiceDetailsTitle;

  /// No description provided for @invoiceItems.
  ///
  /// In en, this message translates to:
  /// **'Invoice Items'**
  String get invoiceItems;

  /// No description provided for @noItemsFoundInInvoice.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noItemsFoundInInvoice;

  /// No description provided for @invoiceCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer: {name}'**
  String invoiceCustomer(String name);

  /// No description provided for @invoiceStatus.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String invoiceStatus(String status);

  /// No description provided for @invoiceCompany.
  ///
  /// In en, this message translates to:
  /// **'Company: {name}'**
  String invoiceCompany(String name);

  /// No description provided for @invoiceCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency: {currency}'**
  String invoiceCurrency(String currency);

  /// No description provided for @invoiceTotalQty.
  ///
  /// In en, this message translates to:
  /// **'Total Qty: {qty}'**
  String invoiceTotalQty(int qty);

  /// No description provided for @invoiceGrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total: {amount}'**
  String invoiceGrandTotal(String amount);

  /// No description provided for @deliveryNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery Notes'**
  String get deliveryNotesTitle;

  /// No description provided for @deliveryNoteItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get deliveryNoteItems;

  /// No description provided for @deliveryNoteStatus.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String deliveryNoteStatus(String status);

  /// No description provided for @toBill.
  ///
  /// In en, this message translates to:
  /// **'To Bill'**
  String get toBill;

  /// No description provided for @registrationSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully. Please check your email to complete registration and set your password.'**
  String get registrationSuccessful;

  /// No description provided for @fullNameIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameIsRequired;

  /// No description provided for @enterValidFullName.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid full name'**
  String get enterValidFullName;

  /// No description provided for @passwordIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordIsRequired;

  /// No description provided for @passwordMustBeAtLeast6Characters.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6Characters;

  /// No description provided for @pleaseConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm password'**
  String get pleaseConfirmPassword;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @afterRegistrationCheckYourEmailToCompleteAccountSetup.
  ///
  /// In en, this message translates to:
  /// **'After registration, check your email to complete account setup.'**
  String get afterRegistrationCheckYourEmailToCompleteAccountSetup;

  /// No description provided for @requestAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Request Access'**
  String get requestAccessTitle;

  /// No description provided for @requestedRole.
  ///
  /// In en, this message translates to:
  /// **'Requested Role'**
  String get requestedRole;

  /// No description provided for @whyDoYouNeedAccess.
  ///
  /// In en, this message translates to:
  /// **'Why do you need access?'**
  String get whyDoYouNeedAccess;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @accessRequestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Access request submitted: {leadName}'**
  String accessRequestSubmitted(String leadName);

  /// No description provided for @hrPanel.
  ///
  /// In en, this message translates to:
  /// **'HR Panel'**
  String get hrPanel;

  /// No description provided for @salesPanel.
  ///
  /// In en, this message translates to:
  /// **'Sales Panel'**
  String get salesPanel;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @invoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get invoices;

  /// No description provided for @customerLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerLabel;

  /// No description provided for @ordersLabel.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersLabel;

  /// No description provided for @noRecentOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders found'**
  String get noRecentOrders;

  /// No description provided for @noRecentInvoices.
  ///
  /// In en, this message translates to:
  /// **'No invoices found'**
  String get noRecentInvoices;

  /// No description provided for @noRecentDeliveryNotes.
  ///
  /// In en, this message translates to:
  /// **'No delivery notes found'**
  String get noRecentDeliveryNotes;

  /// No description provided for @orderControlCenter.
  ///
  /// In en, this message translates to:
  /// **'Order Control Center'**
  String get orderControlCenter;

  /// No description provided for @trackOrdersDescription.
  ///
  /// In en, this message translates to:
  /// **'Track customer orders, delivery dates, totals, and document status.'**
  String get trackOrdersDescription;

  /// No description provided for @ordersLoaded.
  ///
  /// In en, this message translates to:
  /// **'{count} orders loaded'**
  String ordersLoaded(int count);

  /// No description provided for @noSalesOrdersFound.
  ///
  /// In en, this message translates to:
  /// **'No sales orders found'**
  String get noSalesOrdersFound;

  /// No description provided for @salesOrdersWillAppearHere.
  ///
  /// In en, this message translates to:
  /// **'Sales orders will appear here once created.'**
  String get salesOrdersWillAppearHere;

  /// No description provided for @noMatchingOrders.
  ///
  /// In en, this message translates to:
  /// **'No matching orders'**
  String get noMatchingOrders;

  /// No description provided for @trySearchingOrders.
  ///
  /// In en, this message translates to:
  /// **'Try searching with another order, customer, or status.'**
  String get trySearchingOrders;

  /// No description provided for @searchOrders.
  ///
  /// In en, this message translates to:
  /// **'Search orders...'**
  String get searchOrders;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @productControlCenter.
  ///
  /// In en, this message translates to:
  /// **'Product Control Center'**
  String get productControlCenter;

  /// No description provided for @manageProductCatalogDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your product catalog, stock items, rates, and sales availability.'**
  String get manageProductCatalogDescription;

  /// No description provided for @itemsLoaded.
  ///
  /// In en, this message translates to:
  /// **'{count} items loaded'**
  String itemsLoaded(int count);

  /// No description provided for @noMatchingItems.
  ///
  /// In en, this message translates to:
  /// **'No matching items'**
  String get noMatchingItems;

  /// No description provided for @trySearchingItems.
  ///
  /// In en, this message translates to:
  /// **'Try searching with another item name, code, group, or UOM.'**
  String get trySearchingItems;

  /// No description provided for @createFirstItem.
  ///
  /// In en, this message translates to:
  /// **'Create your first item to start managing products.'**
  String get createFirstItem;

  /// No description provided for @searchItems.
  ///
  /// In en, this message translates to:
  /// **'Search items...'**
  String get searchItems;

  /// No description provided for @groupLabel.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get groupLabel;

  /// No description provided for @rateLabel.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rateLabel;

  /// No description provided for @typeLabel.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get typeLabel;

  /// No description provided for @stockLabel.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stockLabel;

  /// No description provided for @nonStock.
  ///
  /// In en, this message translates to:
  /// **'Non-stock'**
  String get nonStock;

  /// No description provided for @notStock.
  ///
  /// In en, this message translates to:
  /// **'Not Stock'**
  String get notStock;

  /// No description provided for @notSales.
  ///
  /// In en, this message translates to:
  /// **'Not Sales'**
  String get notSales;

  /// No description provided for @inventoryDashboard.
  ///
  /// In en, this message translates to:
  /// **'Inventory Dashboard'**
  String get inventoryDashboard;

  /// No description provided for @stockControlCenter.
  ///
  /// In en, this message translates to:
  /// **'Stock Control Center'**
  String get stockControlCenter;

  /// No description provided for @trackInventoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Track products, warehouses and stock movements in one place.'**
  String get trackInventoryDescription;

  /// No description provided for @warehouses.
  ///
  /// In en, this message translates to:
  /// **'Warehouses'**
  String get warehouses;

  /// No description provided for @lowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get lowStock;

  /// No description provided for @outOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get outOfStock;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @createItemAction.
  ///
  /// In en, this message translates to:
  /// **'Create Item'**
  String get createItemAction;

  /// No description provided for @addNewProduct.
  ///
  /// In en, this message translates to:
  /// **'Add new product'**
  String get addNewProduct;

  /// No description provided for @stockEntryAction.
  ///
  /// In en, this message translates to:
  /// **'Stock Entry'**
  String get stockEntryAction;

  /// No description provided for @receiveIssueStock.
  ///
  /// In en, this message translates to:
  /// **'Receive / issue stock'**
  String get receiveIssueStock;

  /// No description provided for @itemsList.
  ///
  /// In en, this message translates to:
  /// **'Items List'**
  String get itemsList;

  /// No description provided for @openProducts.
  ///
  /// In en, this message translates to:
  /// **'Open products'**
  String get openProducts;

  /// No description provided for @stockByWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Stock by Warehouse'**
  String get stockByWarehouse;

  /// No description provided for @totalQuantity.
  ///
  /// In en, this message translates to:
  /// **'Total quantity'**
  String get totalQuantity;

  /// No description provided for @noWarehouseStockFound.
  ///
  /// In en, this message translates to:
  /// **'No warehouse stock data found'**
  String get noWarehouseStockFound;

  /// No description provided for @lowStockItems.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Items'**
  String get lowStockItems;

  /// No description provided for @noLowStockFound.
  ///
  /// In en, this message translates to:
  /// **'No low stock items found'**
  String get noLowStockFound;

  /// No description provided for @recentStockMovements.
  ///
  /// In en, this message translates to:
  /// **'Recent Stock Movements'**
  String get recentStockMovements;

  /// No description provided for @noStockMovementsFound.
  ///
  /// In en, this message translates to:
  /// **'No stock movements found'**
  String get noStockMovementsFound;

  /// No description provided for @attendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendance;

  /// No description provided for @attendanceManagement.
  ///
  /// In en, this message translates to:
  /// **'Attendance Management'**
  String get attendanceManagement;

  /// No description provided for @trackAttendanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Track daily employee attendance, absence, half days and leave status.'**
  String get trackAttendanceDescription;

  /// No description provided for @attendanceRecordsLoaded.
  ///
  /// In en, this message translates to:
  /// **'{count} attendance records loaded'**
  String attendanceRecordsLoaded(int count);

  /// No description provided for @newAttendance.
  ///
  /// In en, this message translates to:
  /// **'New Attendance'**
  String get newAttendance;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @absent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get absent;

  /// No description provided for @halfDay.
  ///
  /// In en, this message translates to:
  /// **'Half Day'**
  String get halfDay;

  /// No description provided for @onLeave.
  ///
  /// In en, this message translates to:
  /// **'On Leave'**
  String get onLeave;

  /// No description provided for @searchAttendance.
  ///
  /// In en, this message translates to:
  /// **'Search attendance...'**
  String get searchAttendance;

  /// No description provided for @noAttendanceFound.
  ///
  /// In en, this message translates to:
  /// **'No attendance records found'**
  String get noAttendanceFound;

  /// No description provided for @createAttendanceOrFilter.
  ///
  /// In en, this message translates to:
  /// **'Create a new attendance record or change your filter.'**
  String get createAttendanceOrFilter;

  /// No description provided for @employee.
  ///
  /// In en, this message translates to:
  /// **'Employee'**
  String get employee;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @payroll.
  ///
  /// In en, this message translates to:
  /// **'Payroll'**
  String get payroll;

  /// No description provided for @payrollManagement.
  ///
  /// In en, this message translates to:
  /// **'Payroll Management'**
  String get payrollManagement;

  /// No description provided for @trackPayrollDescription.
  ///
  /// In en, this message translates to:
  /// **'Track salary slips and payroll entries from ERPNext.'**
  String get trackPayrollDescription;

  /// No description provided for @salarySlips.
  ///
  /// In en, this message translates to:
  /// **'Salary Slips'**
  String get salarySlips;

  /// No description provided for @payrollEntries.
  ///
  /// In en, this message translates to:
  /// **'Payroll Entries'**
  String get payrollEntries;

  /// No description provided for @newEntry.
  ///
  /// In en, this message translates to:
  /// **'New Entry'**
  String get newEntry;

  /// No description provided for @noSalarySlipsYet.
  ///
  /// In en, this message translates to:
  /// **'No salary slips yet'**
  String get noSalarySlipsYet;

  /// No description provided for @salarySlipsAppearAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Salary slips created in ERPNext will appear here automatically.'**
  String get salarySlipsAppearAutomatically;

  /// No description provided for @noPayrollEntriesYet.
  ///
  /// In en, this message translates to:
  /// **'No payroll entries yet'**
  String get noPayrollEntriesYet;

  /// No description provided for @payrollEntriesAppearAutomatically.
  ///
  /// In en, this message translates to:
  /// **'Payroll entries created in ERPNext will appear here automatically.'**
  String get payrollEntriesAppearAutomatically;

  /// No description provided for @netPay.
  ///
  /// In en, this message translates to:
  /// **'Net Pay: {amount}'**
  String netPay(String amount);

  /// No description provided for @payrollEntry.
  ///
  /// In en, this message translates to:
  /// **'Payroll Entry'**
  String get payrollEntry;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @generateInvoice.
  ///
  /// In en, this message translates to:
  /// **'Generate Invoice'**
  String get generateInvoice;

  /// No description provided for @invoiceItemsSection.
  ///
  /// In en, this message translates to:
  /// **'Invoice Items'**
  String get invoiceItemsSection;

  /// No description provided for @noOrderItems.
  ///
  /// In en, this message translates to:
  /// **'No items found'**
  String get noOrderItems;

  /// No description provided for @thisOrderHasNoItems.
  ///
  /// In en, this message translates to:
  /// **'This order has no items.'**
  String get thisOrderHasNoItems;

  /// No description provided for @customerLabel2.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customerLabel2;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @itemsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get itemsCountLabel;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @allInvoices.
  ///
  /// In en, this message translates to:
  /// **'All invoices'**
  String get allInvoices;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @reject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @newRequest.
  ///
  /// In en, this message translates to:
  /// **'New Request'**
  String get newRequest;

  /// No description provided for @noPermission.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to view this page'**
  String get noPermission;

  /// No description provided for @sales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// No description provided for @hr.
  ///
  /// In en, this message translates to:
  /// **'HR'**
  String get hr;

  /// No description provided for @createPayrollEntryTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Payroll Entry'**
  String get createPayrollEntryTitle;

  /// No description provided for @addEmployee.
  ///
  /// In en, this message translates to:
  /// **'Add Employee'**
  String get addEmployee;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @qtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get qtyLabel;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @leaveRequests.
  ///
  /// In en, this message translates to:
  /// **'Leave Requests'**
  String get leaveRequests;

  /// No description provided for @stockEntryCreated.
  ///
  /// In en, this message translates to:
  /// **'Stock Entry {name} created successfully'**
  String stockEntryCreated(String name);

  /// No description provided for @warehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get warehouse;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
