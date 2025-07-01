import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:smartbecho/bindings/account%20management%20bimding/account_management_binding.dart';
import 'package:smartbecho/bindings/auth%20bindings/auth_binding.dart';
import 'package:smartbecho/bindings/bill%20history%20bindings/bill_history_bindings.dart';
import 'package:smartbecho/bindings/bill%20history%20bindings/bill_operation_binding.dart';
import 'package:smartbecho/bindings/customer%20dues%20bindings/customer_dues_management_binding.dart';
import 'package:smartbecho/bindings/customer%20management%20bindings/customer_details_binding.dart';
import 'package:smartbecho/bindings/customer%20management%20bindings/customer_management_binding.dart';
import 'package:smartbecho/bindings/dashboard_binding.dart';
import 'package:smartbecho/bindings/inventory%20management%20bindings/company_stock_details_binding.dart';
import 'package:smartbecho/bindings/inventory%20management%20bindings/inventory_management_binding.dart';
import 'package:smartbecho/bindings/inventory%20management%20bindings/sales_dashboard_binding.dart';
import 'package:smartbecho/bindings/profile/profile_binding.dart';
import 'package:smartbecho/controllers/inventory%20controllers/company_stock_detail_controller.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/views/account%20management/account_management.dart';
import 'package:smartbecho/views/auth/forgot_password_otp.dart';
import 'package:smartbecho/views/auth/login_screen.dart';
import 'package:smartbecho/views/auth/reset_password.dart';
import 'package:smartbecho/views/auth/signup_screen.dart';
import 'package:smartbecho/views/auth/verify_email.dart';
import 'package:smartbecho/views/bill%20history/bill_history.dart';
import 'package:smartbecho/views/bill%20history/components/add_bill.dart';
import 'package:smartbecho/views/bill%20history/components/bill_details.dart';
import 'package:smartbecho/views/customer%20dues/customer_dues_management.dart';
import 'package:smartbecho/views/customer/components/customer_card_view.dart';
import 'package:smartbecho/views/customer/customer.dart';
import 'package:smartbecho/views/customer/components/customer_analytics.dart';
import 'package:smartbecho/views/dashboard/dashboard_screen.dart';
import 'package:smartbecho/views/inventory/components/add_mobile_form.dart';
import 'package:smartbecho/views/inventory/inventory_management.dart';
import 'package:smartbecho/views/inventory/sales_dashboard.dart';
import 'package:smartbecho/views/inventory/components/company_stock_info.dart';
import 'package:smartbecho/views/profile/profile.dart';
import 'package:smartbecho/views/splash/splash_screen.dart';

class AppPages {
  static const String initial = AppRoutes.splash;

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
    //main screens
    GetPage(
      name: AppRoutes.dashboard,
      page: () => InventoryDashboard(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: DashboardBinding(),
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
      page: () => MobileInventoryForm(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 500),
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
      name: AppRoutes.customerDetails,
      page: () => CustomerDetailsPage(),
      transition: Transition.leftToRight,
      transitionDuration: Duration(milliseconds: 300),
      binding: CustomerDetailsBinding(),
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
      name: AppRoutes.billDetails,
      page: () => BillDetailsPage(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.addBill,
      page: () => AddBillForm(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
      binding: BillOperationBinding(),
    ),

    //customer dues management
    GetPage(
      name: AppRoutes.customerDuesManagement,
      page: () => CustomerDuesManagementScreen(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 300),
      binding: CustomerDuesManagementBinding(),
    ),

    //account management
        GetPage(
      name: AppRoutes.accountManagement,
      page: () => AccountManagementScreen(),
      transition: Transition.fade,
      transitionDuration: Duration(milliseconds: 300),
      binding: AccountManagementBinding(),
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
