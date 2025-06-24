class AppRoutes {
  // Authentication Routes
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String resetPassword = '/reset-password';
  static const String forgotPasswordOtp = '/forgot-password-OTP';


  static const String verifyEmail = '/verify-email';
  
  // Main App Routes
  static const String dashboard = '/dashboard';

  //inventory managemnet
  static const String inventory_management = '/inventory-management';
  static const String salesStockDashboard = '/sales-stock-dashboard';
  static const String companyStockDetails = '/company-stock-details';
  static const String addNewItem = '/add-new-item';



  //customer management
  static const String customerManagement = '/customer-management';
  static const String customerAnalytics = '/customer-analytics';
  static const String customerDetails = '/customer-details';

//bill managemanet
  static const String billHistory = '/bill-history';
  static const String billDetails = '/bill-details';
  static const String addBill = '/add-bill';



  


  static const String profile = '/profile';
  static const String settings = '/settings';
  
  // Error Routes
  static const String notFound = '/404';
  static const String error = '/error';
  
  // Get all routes as a list for easy reference
  static List<String> get allRoutes => [
    splash,
    welcome,
    login,
    signup,
    resetPassword,
    verifyEmail,
    dashboard,
    profile,
    settings,
    notFound,
    error,
    inventory_management,
    customerManagement
  ];
}
