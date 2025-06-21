class AppRoutes {
  // Authentication Routes
  static const String splash = '/splash';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String resetPassword = '/reset-password';
  static const String verifyEmail = '/verify-email';
  
  // Main App Routes
  static const String dashboard = '/dashboard';
  static const String inventory_management = '/inventory-management';
  //customer analytics
  static const String customerManagement = '/customer-management';
  static const String customerAnalytics = '/customer-analytics';


  //

  


  static const String profile = '/profile';
  static const String settings = '/settings';


  //Sales Managenment
  static const String salesManagement = '/sales-management';

  
  
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
