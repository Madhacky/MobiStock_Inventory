import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:smartbecho/bindings/account%20management%20bimding/account_management_binding.dart';
import 'package:smartbecho/bindings/auth%20bindings/auth_binding.dart';
import 'package:smartbecho/bindings/bill%20history%20bindings/bill_history_bindings.dart';
import 'package:smartbecho/bindings/bill%20history%20bindings/bill_operation_binding.dart';
import 'package:smartbecho/bindings/bill%20history%20bindings/online_added_product_added_binding.dart';
import 'package:smartbecho/bindings/bill%20history%20bindings/this_month_added_stock_binding.dart';
import 'package:smartbecho/bindings/customer%20dues%20bindings/customer_dues_management_binding.dart';
import 'package:smartbecho/bindings/customer%20dues%20bindings/customer_dues_operations_binding.dart';
import 'package:smartbecho/bindings/customer%20dues%20bindings/todays_retrieval_dues_binding.dart';
import 'package:smartbecho/bindings/customer%20management%20bindings/customer_card_view_binding.dart';
import 'package:smartbecho/bindings/customer%20management%20bindings/customer_details_binding.dart';
import 'package:smartbecho/bindings/customer%20management%20bindings/customer_management_binding.dart';
import 'package:smartbecho/bindings/customer%20management%20bindings/customer_operations_binding.dart';
import 'package:smartbecho/bindings/customer%20management%20bindings/invoice_details_binding.dart';
import 'package:smartbecho/bindings/dashboard_binding.dart';
import 'package:smartbecho/bindings/generate%20inventory%20binding/generate_inventory_binding.dart';
import 'package:smartbecho/bindings/inventory%20management%20bindings/company_stock_details_binding.dart';
import 'package:smartbecho/bindings/inventory%20management%20bindings/inventory_crud_operations_bindings.dart';
import 'package:smartbecho/bindings/inventory%20management%20bindings/inventory_management_binding.dart';
import 'package:smartbecho/bindings/inventory%20management%20bindings/sales_dashboard_binding.dart';
import 'package:smartbecho/bindings/profile/profile_binding.dart';
import 'package:smartbecho/bindings/sales%20history%20binding/sales_management_binding.dart';
import 'package:smartbecho/bottom_navigation_screen.dart';
import 'package:smartbecho/controllers/inventory%20controllers/company_stock_detail_controller.dart';
import 'package:smartbecho/middlewares/auth_middleware.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/views/account%20management/account_management.dart';
import 'package:smartbecho/views/auth/forgot_password_otp.dart';
import 'package:smartbecho/views/auth/login_screen.dart';
import 'package:smartbecho/views/auth/reset_password.dart';
import 'package:smartbecho/views/auth/signup_screen.dart';
import 'package:smartbecho/views/auth/verify_email.dart';
import 'package:smartbecho/views/bill%20history/bill_history.dart';
import 'package:smartbecho/views/bill%20history/components/bill_analytics.dart';
import 'package:smartbecho/views/bill%20history/components/online_added_product_page.dart';
import 'package:smartbecho/views/bill%20history/components/stock_history.dart';
import 'package:smartbecho/views/bill%20history/components/this_month_aaded_page.dart';
import 'package:smartbecho/views/customer%20dues/components/customer_dues_details.dart';
import 'package:smartbecho/views/customer/components/customer%20details/customer_details.dart';
import 'package:smartbecho/views/customer/components/customer%20details/customer_invoice_details.dart';
import 'package:smartbecho/views/generate%20inventory/generate_inventory.dart';
import 'package:smartbecho/views/hsn-code/presentation/hsn_code_screen.dart';
import 'package:smartbecho/views/inventory/components/add_new_stock.dart';
import 'package:smartbecho/views/bill%20history/components/bill_details.dart';
import 'package:smartbecho/views/customer%20dues/components/add_customer_due.dart';
import 'package:smartbecho/views/customer%20dues/components/todays_due_retrieval.dart';
import 'package:smartbecho/views/customer%20dues/customer_dues_management.dart';
import 'package:smartbecho/views/customer/components/add_customer.dart';
import 'package:smartbecho/views/customer/components/customer_card_view.dart';
import 'package:smartbecho/views/customer/customer.dart';
import 'package:smartbecho/views/customer/components/customer_analytics.dart';
import 'package:smartbecho/views/dashboard/dashboard_screen.dart';
import 'package:smartbecho/views/inventory/components/add_mobile_form.dart';
import 'package:smartbecho/views/inventory/inventory_management.dart';
import 'package:smartbecho/views/inventory/sales_dashboard.dart';
import 'package:smartbecho/views/inventory/components/company_stock_info.dart';
import 'package:smartbecho/views/profile/profile.dart';
import 'package:smartbecho/views/sales%20management/components/add_mobile_sales_form.dart';
import 'package:smartbecho/views/sales%20management/components/sales_details.dart';
import 'package:smartbecho/views/sales%20management/sales_managenment_screen.dart';
import 'package:smartbecho/views/splash/splash_screen.dart';

class AppPages {
  static const String initial = AppRoutes.bottomNavigation;

  static final routes = [
    // // Splash Screen
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 500),
    ),

    // Authentication Routes
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 400),
      binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.signup,
      page: () => SignupScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 400),
      binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.resetPassword,
      page: () => ResetPasswordScreen(),
      transition: Transition.upToDown,
      transitionDuration: Duration(milliseconds: 400),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPasswordOtp,
      page: () => OTPVerificationScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.verifyEmail,
      page: () => VerifyEmailScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
      binding: ProfileBinding(),
    ),
    //bottomNavigation
    GetPage(
      name: AppRoutes.bottomNavigation,
      page: () => BottomNavigationScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
      middlewares: [AuthMiddleware()],
    ),
    //main screens
    GetPage(
      name: AppRoutes.dashboard,
      page: () => InventoryDashboard(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: DashboardBinding(),
      middlewares: [AuthMiddleware()],
    ),

    /// inventory management
    GetPage(
      name: AppRoutes.inventory_management,
      page: () => InventoryManagementScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 500),
      binding: InventoryManagementBinding(),
    ),
    GetPage(
      name: AppRoutes.salesStockDashboard,
      page: () => SalesStockDashboard(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: Duration(milliseconds: 500),
      binding: SalesDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.companyStockDetails,
      page: () => CompanyStockDetailsPage(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 500),
      binding: CompanyStockDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.addNewItem,
      page: () => AddNewMobileInventoryForm(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 500),
      binding: InventoryCrudOperationsBindings(),
    ),

    //customer analytics
    GetPage(
      name: AppRoutes.customerManagement,
      page: () => CustomerManagementScreen(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
      binding: CustomerManagementBinding(),
    ),

    GetPage(
      name: AppRoutes.customerAnalytics,
      page: () => CustomerAnalytics(),
      transition: Transition.leftToRight,
      transitionDuration: Duration(milliseconds: 300),
      binding: CustomerManagementBinding(),
    ),
    GetPage(
      name: AppRoutes.customerCardView,
      page: () => CustomerCardViewPage(),
      transition: Transition.leftToRight,
      transitionDuration: Duration(milliseconds: 300),
      binding: CustomerCardViewBinding(),
    ),
        GetPage(
      name: AppRoutes.invoiceDetails,
      page: () => InvoiceDetailsPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: InvoiceDetailsBinding(),
    ),
        GetPage(
      name: AppRoutes.customerDetails,
      page: () => CustomerDetailsScreen(),
      transition: Transition.leftToRight,
      transitionDuration: Duration(milliseconds: 300),
      binding: CustomerDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.addCustomer,
      page: () => AddCustomerForm(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300),
      binding: CustomerOperationsBinding(),
    ),

    //bill history
    GetPage(
      name: AppRoutes.billHistory,
      page: () => BillsHistoryPage(),
      transition: Transition.leftToRight,
      transitionDuration: Duration(milliseconds: 300),
      binding: BillHistoryBindings(),
    ),
      GetPage(
      name: AppRoutes.thisMonthAddedStock,
      page: () => ThisMonthStockScreen(),
      transition: Transition.leftToRight,
      transitionDuration: Duration(milliseconds: 300),
      binding: ThisMonthStockBinding(),
    ),
    GetPage(
      name: AppRoutes.billDetails,
      page: () => BillDetailsPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.addNewStock,
      page: () => AddNewStockForm(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: AddNewStockOperationBinding(),
    ),
      GetPage(
      name: AppRoutes.stockList,
      page: () => StockHistoryPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      
    ),
      GetPage(
      name: AppRoutes.billAnalytics,
      page: () => BillAnalyticsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      
    ),
    GetPage(
      name: AppRoutes.onlineAddedProducts,
      page: () => OnlineProductsPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: OnlineAddedProductBinding(),
    ),
    //customer dues management
    GetPage(
      name: AppRoutes.customerDuesManagement,
      page: () => CustomerDuesManagementScreen(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 300),
      binding: CustomerDuesManagementBinding(),
    ),
    GetPage(
      name: AppRoutes.todaysRetrievalDues,
      page: () => TodaysRetrievalDuesScreen(),
      transition: Transition.downToUp,
      transitionDuration: Duration(milliseconds: 300),
      binding: TodaysRetrievalDuesBinding(),
    ),
    GetPage(
      name: AppRoutes.addCustomerDue,
      page: () => AddDuesPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: CustomerDuesOperationsBinding(),
    ),

    //account management
    GetPage(
      name: AppRoutes.accountManagement,
      page: () => AccountManagementScreen(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 300),
      binding: AccountManagementBinding(),
    ),
     GetPage(
      name: AppRoutes.hsnCodeManagement,
      page: () => HsnCodeScreen(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 300),
      middlewares:[ AuthMiddleware()],
    ),
    //sales  management
    GetPage(
      name: AppRoutes.salesManagement,
      page: () => SalesManagementScreen(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 300),
      binding: SalesManagementBinding(),
    ),
    GetPage(
      name: AppRoutes.salesDetails,
      page: () => SaleDetailsPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
       GetPage(
      name: AppRoutes.mobileSalesForm,
      page: () => MobileSalesForm(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),

    //generate inventory
       GetPage(
      name: AppRoutes.generateInventory,
      page: () => GenerateInventoryScreen(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 300),
      binding: GenerateInventoryBinding(),
      middlewares:[ AuthMiddleware()]
    ),
  ];

  //   // Main App Routes

  //   GetPage(
  //     name: AppRoutes.profile,
  //     page: () => ProfileScreen(),
  //     transition: Transition.rightToLeft,
  //     transitionDuration: Duration(milliseconds: 300),
  //   ),

  //   GetPage(
  //     name: AppRoutes.settings,
  //     page: () => SettingsScreen(),
  //     transition: Transition.rightToLeft,
  //     transitionDuration: Duration(milliseconds: 300),
  //   ),

  //   // Error Routes
  //   GetPage(
  //     name: AppRoutes.notFound,
  //     page: () => NotFoundScreen(),
  //     transition: Transition.fadeIn,
  //   ),

  //   GetPage(
  //     name: AppRoutes.error,
  //     page: () => ErrorScreen(),
  //     transition: Transition.fadeIn,
  //   ),

  // // Unknown Route Handler
  // static Route<dynamic> onUnknownRoute(RouteSettings settings) {
  //   return GetPageRoute(
  //     settings: settings,
  //     page: () => NotFoundScreen(),
  //     transition: Transition.fadeIn,
  //   );
  // }
}
