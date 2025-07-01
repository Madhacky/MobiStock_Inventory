import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

class AppConfig {
  // Private constructor
  AppConfig._();

  // Singleton instance
  static final AppConfig _instance = AppConfig._();
  static AppConfig get instance => _instance;

  // Environment variables getters
  String get baseUrl =>
      dotenv.env['BASE_URL'] ??
      'https://backend-production-91e4.up.railway.app';
  bool get isDebugMode => dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';
  String get appName => dotenv.env['APP_NAME'] ?? 'Flutter App';
  String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0';

  // Specific endpoints
  String get loginEndpoint => '$baseUrl/login/jwt';
  String get resetPasswordUrl => '$baseUrl/users/forgot-password';
  String get resetPasswordOTPUrl => '$baseUrl/users/verify-otp-reset-password';
  String get profile => '$baseUrl/users/current-user';
  String get updateProfile => '$baseUrl/users/update/1';

  String get signupEndpoint => '$baseUrl/users/createUser';
  String get registerEndpoint => '$baseUrl/auth/register';
  String get profileEndpoint => '$baseUrl/user/profile';
  String get logoutEndpoint => '$baseUrl/auth/logout';
  String get todaysalessummary => '$baseUrl/api/sales/today-sales-summary';
  String get todaysalesCard => '$baseUrl/api/sales/today';
  String get stockSummary => '$baseUrl/api/mobiles/stock-details';
  String get monthlyRevenueChart => '$baseUrl/api/sales/revenue/monthly';
  String get topSellingModelsChart =>
      '$baseUrl/api/sales/top-models?month=3&year=2024';
  String get monthlyEmiDuesChart => '$baseUrl/api/dues/monthly-summary';
  String get duesCollectionStatusChart => '$baseUrl/api/dues/overall-summary';

  //inventory management endpoints
  String get getInventoryData => '$baseUrl/inventory/shop';
  String get getInventorySummaryCards => '$baseUrl/api/mobiles/shop-summary';
  String get getLowStockAlerts => '$baseUrl/inventory/low-stock-alerts';
  String get getCompanyStocks => '$baseUrl/inventory/summary';
  String get addInventoryItem => '$baseUrl/api/mobiles/create';

  //Bill History
  String get getAllBills => '$baseUrl/bill/all';

  //customer dues management
  String get getAllCustomerDues => '$baseUrl/api/dues/all';
  String get getCustomerDuesAnalytics => '$baseUrl/api/dues/monthly-summary';
  // String get getCustomerDuesDetails => '$baseUrl/api/dues/customer';
  // String get getCustomerDuesPayment => '$baseUrl/api/dues/pay';
  // String get getCustomerDuesReminder => '$baseUrl/api/dues/reminder';
  // String get getCustomerDuesReport => '$baseUrl/api/dues/report';
  // String get getCustomerDuesReportDetails => '$baseUrl/api/dues/report-details';
  // String get getCustomerDuesReportSummary => '$baseUrl/api/dues/report-summary';

  //customer management endpoints
  String get getMonthlyNewCustomerEndpoint =>
      '$baseUrl/api/customers/count/monthly';
  String get getVillageDistributionEndpoint =>
      '$baseUrl/api/customers/count/location';
  String get getMonthlyRepeatCustomerEndpoint =>
      '$baseUrl/api/sales/count/monthly/repeated';
  String get getTopCustomerOverviewEndpoint =>
      '$baseUrl/api/sales/top-customers';
  String get getTopStatsCardsDataEndpoint => '$baseUrl/api/customers/stats';

  // Utility methods
  static bool get isSmallScreen => Get.width < 360;
  static bool get isMediumScreen => Get.width >= 360 && Get.width < 400;
  static double get screenWidth => Get.width;
  static double get screenHeight => Get.height;

  // Debug print method
  void printConfig() {
    if (isDebugMode) {
      print('=== APP CONFIG ===');
      print('Base URL: $baseUrl');
      print('App Version: $appVersion');
      print('Debug Mode: $isDebugMode');
      print('App Name: $appName');
      print('==================');
    }
  }
}
