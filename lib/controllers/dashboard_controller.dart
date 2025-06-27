// File: controllers/dashboard_controller.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/dashboard_models/charts/monthly_emi_dues_model.dart';
import 'package:smartbecho/models/dashboard_models/charts/monthly_revenue_model.dart';
import 'package:smartbecho/models/dashboard_models/charts/top_selling_models.dart';
import 'package:smartbecho/models/dashboard_models/sales_summary_model.dart';
import 'package:smartbecho/models/dashboard_models/stock_summary_model.dart';
import 'package:smartbecho/models/dashboard_models/today_sales_header_model.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:dio/dio.dart' as dio;
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/services/user_preference.dart';

class DashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Animation Controller
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  // Reactive variables
  var selectedIndex = 0.obs;
  var searchQuery = ''.obs;
  var isLoading = false.obs;

  // Dashboard data
  Rx<SalesSummary>? salesSummary;
  late Rx<StockSummary> stockSummary;
  late Rx<EMISummary> emiSummary;
  late RxList<StatItem> topStats;
  late RxList<QuickActionButton> quickActions;

  // API service instance
  final ApiServices _apiService = ApiServices();

  // App config instance
  final AppConfig _config = AppConfig.instance;
  // Add view mode toggle
  RxBool isGridView = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _initializeData();
    _startAnimations();
    fetchSalesSummary();
    fetchTodaysSalesCard();
    fetchStockSummary();
    fetchMonthlyRevenueChart();
    fetchisTopSellingModelChart();
    fetchMonthlyEmiDuesChart();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  //get dash board data

  void _initializeAnimations() {
    animationController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );

    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOutBack),
    );
  }

  void _startAnimations() {
    animationController.forward();
  }

  void _initializeData() {
    // Initialize quick actions
    quickActions =
        <QuickActionButton>[
          QuickActionButton(
            title: 'Sell a Phone',
            icon: Icons.phone_android_rounded,
            colors: [Color(0xFF00CEC9), Color(0xFF55EFC4)],
            route: '/sell-phone',
          ),
          QuickActionButton(
            title: 'Add Stock',
            icon: Icons.add_box_rounded,
            colors: [Color(0xFFFF7675), Color(0xFFFF9FF3)],
            route: '/add-stock',
          ),
          QuickActionButton(
            title: 'View EMI Records',
            icon: Icons.receipt_long_rounded,
            colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
            route: '/emi-records',
          ),
          QuickActionButton(
            title: 'Generate Reports',
            icon: Icons.analytics_rounded,
            colors: [Color(0xFF00B894), Color(0xFF55EFC4)],
            route: '/reports',
          ),
          QuickActionButton(
            title: 'Sale History',
            icon: Icons.history_rounded,
            colors: [Color(0xFF9B59B6), Color(0xFFE84393)],
            route: '/sale-history',
          ),
        ].obs;

    // Initialize EMI summary
    emiSummary =
        EMISummary(
          totalEMIDue: '₹12,000',
          phonesSoldOnEMI: 8,
          pendingPayments: '15,000',
          emiPhones: {
            'iPhone 12': '₹5,000',
            'Samsung Galaxy S21': '₹4,000',
            'OnePlus 8T': '₹3,000',
            'Vivo X60': '₹3,000',
          },
        ).obs;
  }

  // Methods
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  void updateSelectedIndex(int index) {
    selectedIndex.value = index;
  }

  void handleQuickAction(String actionTitle) {
    switch (actionTitle) {
      case 'Sell a Phone':
        _showSuccessSnackbar('Navigating to Sell Phone', Color(0xFF6C5CE7));
        // Get.toNamed('/sell-phone');
        break;
      case 'Add Stock':
        _showSuccessSnackbar('Navigating to Add Stock', Color(0xFF00CEC9));
        // Get.toNamed('/add-stock');
        break;
      case 'View EMI Records':
        _showSuccessSnackbar('Navigating to EMI Records', Color(0xFF74B9FF));
        // Get.toNamed('/emi-records');
        break;
      case 'Generate Reports':
        _showSuccessSnackbar('Generating Reports', Color(0xFF00B894));
        // Get.toNamed('/reports');
        break;
      case 'Sale History':
        _showSuccessSnackbar('Navigating to Sale History', Color(0xFFFF7675));
        // Get.toNamed('/sale-history');
        break;
      default:
        break;
    }
  }

  void _showSuccessSnackbar(String message, Color color) {
    Get.snackbar(
      'Action',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
      margin: EdgeInsets.all(16),
      borderRadius: 8,
    );
  }

  // Data refresh methods
  Future<void> refreshDashboardData() async {
    isLoading.value = true;
    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Update data here with API response
      _updateDashboardStats();

      _showSuccessSnackbar('Dashboard refreshed', Color(0xFF00B894));
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to refresh dashboard data',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _updateDashboardStats() {
    // Update with fresh data from API
    // This is where you would update the reactive variables with new data
  }

  // Utility methods
  bool get isSmallScreen => Get.width < 360;
  bool get isMediumScreen => Get.width >= 360 && Get.width < 400;
  double get screenWidth => Get.width;
  double get screenHeight => Get.height;

  //APIs
  // Sales Summary API
  RxBool isSalesSummaryLoading = false.obs;
  var errorMessage = ''.obs;
  var hasSalesSummaryError = false.obs;
  Future<void> fetchSalesSummary() async {
    try {
      isSalesSummaryLoading.value = true;
      hasSalesSummaryError.value = false;
      errorMessage.value = '';
      await Future.delayed(Duration(seconds: 3));
      dio.Response? response = await _apiService.requestGetForApi(
        url: _config.todaysalessummary,
        authToken: true, // Set based on your authentication requirement
      );

      if (response != null && response.statusCode == 200) {
        final responseData = SalesApiResponse.fromJson(response.data);
        log(
          "Data salss  : ${responseData.payload!.totalSaleAmountToday.toString()}",
        );
        log(
          "Data sals  : ${responseData.payload!.totalSaleAmountToday.toString()}",
        );
        salesSummary =
            SalesSummary(
              totalSales: responseData.payload!.totalSaleAmountToday.toString(),
              smartphonesSold: responseData.payload!.totalItemsSoldToday,
              totalTransactions: responseData.payload!.totalTransactionsToday,
              paymentBreakdown: {
                'UPI': PaymentDetail('₹7,20,000', 30),
                'Cash': PaymentDetail('₹7,15,000', 20),
                'EMI': PaymentDetail('₹1,10,000', 15),
                'Card': PaymentDetail('₹15,000', 10),
              },
            ).obs;
      } else {
        hasSalesSummaryError.value = true;
        errorMessage.value =
            'Failed to fetch data. Status: ${response?.statusCode}';
      }
    } catch (error) {
      hasSalesSummaryError.value = true;
      errorMessage.value = 'Error: $error';
      print("Sales Summary API Error: $error");
    } finally {
      isSalesSummaryLoading.value = false;
    }
  }

  //todays sales card api
  RxBool isTodaysSalesCardLoading = false.obs;
  var todaysSalesCarderrorMessage = ''.obs;
  var hasTodaysSalesCardError = false.obs;
  Future<void> fetchTodaysSalesCard() async {
    try {
      isTodaysSalesCardLoading.value = true;
      hasTodaysSalesCardError.value = false;
      todaysSalesCarderrorMessage.value = '';
      await Future.delayed(Duration(seconds: 3));
      dio.Response? response = await _apiService.requestGetForApi(
        url: _config.todaysalesCard,
        authToken: true, // Set based on your authentication requirement
      );

      if (response != null && response.statusCode == 200) {
        final responseData = TodaysSaleCardModel.fromJson(response.data);
        log("Data salss  : ${responseData.payload.availableStock.toString()}");

        topStats =
            <StatItem>[
              StatItem(
                title: "Today's Sale (₹)",
                value: responseData.payload.todaySaleAmount.toString(),
                icon: Icons.currency_rupee_rounded,
                colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
              ),
              StatItem(
                title: 'Units Sold Today',
                value: responseData.payload.todayUnitsSold.toString(),
                icon: Icons.inventory_2_rounded,
                colors: [Color(0xFFFF7675), Color(0xFFFF9FF3)],
              ),
              StatItem(
                title: 'Available Stock',
                value: responseData.payload.availableStock.toString(),
                icon: Icons.inventory_sharp,
                colors: [Color(0xFF74B9FF), Color(0xFF0984E3)],
              ),
            ].obs;
      } else {
        hasTodaysSalesCardError.value = true;
        todaysSalesCarderrorMessage.value =
            'Failed to fetch data. Status: ${response?.statusCode}';
      }
    } catch (error) {
      hasTodaysSalesCardError.value = true;
      todaysSalesCarderrorMessage.value = 'Error: $error';
    } finally {
      isTodaysSalesCardLoading.value = false;
    }
  }

  //stock summary api
  RxBool isStockSummaryLoading = false.obs;
  var stockSummaryerrorMessage = ''.obs;
  var hasStockSummaryError = false.obs;
  Future<void> fetchStockSummary() async {
    try {
      isStockSummaryLoading.value = true;
      hasStockSummaryError.value = false;
      stockSummaryerrorMessage.value = '';
      await Future.delayed(Duration(seconds: 3));
      dio.Response? response = await _apiService.requestGetForApi(
        url: _config.stockSummary,
        authToken: true, // Set based on your authentication requirement
      );

      if (response != null && response.statusCode == 200) {
        final responseData = StockSummaryModel.fromJson(response.data);
        log("Data salss  : ${responseData.payload.totalStock.toString()}");
        // Convert Map<String, int> to Map<String, String> if needed
        final companyStockMap = responseData.payload.companyWiseStock.map(
          (key, value) => MapEntry(key, value),
        );

        final lowStockList =
            responseData.payload.lowStockDetails
                .map((e) => '${e.company} - ${e.model} (${e.qty})')
                .toList();
        stockSummary =
            StockSummary(
              totalStock: responseData.payload.totalStock.toString(),
              companyStock: companyStockMap,
              lowStockAlerts: lowStockList,
            ).obs;
      } else {
        hasStockSummaryError.value = true;
        stockSummaryerrorMessage.value =
            'Failed to fetch data. Status: ${response?.statusCode}';
      }
    } catch (error) {
      hasStockSummaryError.value = true;
      stockSummaryerrorMessage.value = 'Error: $error';
    } finally {
      isStockSummaryLoading.value = false;
    }
  }

  //charts api
  RxBool isMonthlyRevenueChartLoading = false.obs;
  var monthlyRevenueCharterrorMessage = ''.obs;
  var hasMonthlyRevenueChartError = false.obs;
  RxMap<String, double> monthlyRevenueChartPayload = RxMap<String, double>({});
  Future<void> fetchMonthlyRevenueChart() async {
    try {
      isMonthlyRevenueChartLoading.value = true;
      hasMonthlyRevenueChartError.value = false;
      monthlyRevenueCharterrorMessage.value = '';
      await Future.delayed(Duration(seconds: 3));
      dio.Response? response = await _apiService.requestGetForApi(
        url: _config.monthlyRevenueChart,
        authToken: true, // Set based on your authentication requirement
      );

      if (response != null && response.statusCode == 200) {
        final responseData = MonthlyRevenueChartModel.fromJson(response.data);
        log("${responseData.payload.toString()}");
        monthlyRevenueChartPayload!.value = Map<String, double>.from(
          responseData.payload,
        );
      } else {
        hasMonthlyRevenueChartError.value = true;
        monthlyRevenueCharterrorMessage.value =
            'Failed to fetch data. Status: ${response?.statusCode}';
      }
    } catch (error) {
      hasMonthlyRevenueChartError.value = true;
      monthlyRevenueCharterrorMessage.value = 'Error: $error';
    } finally {
      isMonthlyRevenueChartLoading.value = false;
    }
  }

  //top selling model
  RxBool isTopSellingModelChartLoading = false.obs;
  var topSellingModelCharterrorMessage = ''.obs;
  var hasisTopSellingModelChartError = false.obs;
  RxMap<String, double> topSellingModelChartPayload = RxMap<String, double>({});
  Future<void> fetchisTopSellingModelChart() async {
    try {
      isTopSellingModelChartLoading.value = true;
      hasisTopSellingModelChartError.value = false;
      topSellingModelCharterrorMessage.value = '';
      await Future.delayed(Duration(seconds: 3));
      dio.Response? response = await _apiService.requestGetForApi(
        url: _config.topSellingModelsChart,
        authToken: true, // Set based on your authentication requirement
      );

      if (response != null && response.statusCode == 200) {
        final responseData = TopSellingModelsResponse.fromJson(response.data);
        log("${responseData.payload.toString()}");
        topSellingModelChartPayload.value = Map<String, double>.from(
          responseData.chartData,
        );
      } else {
        hasisTopSellingModelChartError.value = true;
        topSellingModelCharterrorMessage.value =
            'Failed to fetch data. Status: ${response?.statusCode}';
      }
    } catch (error) {
      hasisTopSellingModelChartError.value = true;
      topSellingModelCharterrorMessage.value = 'Error: $error';
    } finally {
      isTopSellingModelChartLoading.value = false;
    }
  }

  //Monthly Emi Dues
  RxBool isMonthlyEmiDuesChartLoading = false.obs;
  var monthlyEmiDuesCharterrorMessage = ''.obs;
  var hasmonthlyEmiDuesChartError = false.obs;
  RxMap<String, double> monthlyEmiDuesChartPayload = RxMap<String, double>({});
  Future<void> fetchMonthlyEmiDuesChart() async {
    try {
      isMonthlyEmiDuesChartLoading.value = true;
      hasmonthlyEmiDuesChartError.value = false;
      monthlyEmiDuesCharterrorMessage.value = '';
      await Future.delayed(Duration(seconds: 3));
      dio.Response? response = await _apiService.requestGetForApi(
        url: _config.monthlyEmiDuesChart,
        authToken: true, // Set based on your authentication requirement
      );

      if (response != null && response.statusCode == 200) {
        final responseData = MonthlyDuesResponse.fromJson(response.data);
        log("${responseData.payload.toString()}");
        monthlyEmiDuesChartPayload.value = Map<String, double>.from(
          responseData.chartDataRemaining,
        );
      } else {
        hasmonthlyEmiDuesChartError.value = true;
        monthlyEmiDuesCharterrorMessage.value =
            'Failed to fetch data. Status: ${response?.statusCode}';
      }
    } catch (error) {
      hasmonthlyEmiDuesChartError.value = true;
      monthlyEmiDuesCharterrorMessage.value = 'Error: $error';
    } finally {
      isMonthlyEmiDuesChartLoading.value = false;
    }
  }
}
