import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/bill%20history/monthly_purchase_chart_reponse_model.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:dio/dio.dart' as dio;
import 'package:intl/intl.dart';

class BillAnalyticsController extends GetxController {
  // API service instance
  final ApiServices _apiService = ApiServices();
  final AppConfig _config = AppConfig.instance;

  // Loading states
  final RxBool isAnalyticsLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Analytics data
  final RxList<BillAnalyticsModel> analyticsData = <BillAnalyticsModel>[].obs;

  // Filter states
  final RxString selectedCompany = ''.obs;
  final RxString selectedMonth = ''.obs;
  final RxString selectedYear = ''.obs;
  final RxString timePeriodType = 'Month/Year'.obs;

  // Date controllers for custom date selection
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final Rx<DateTime?> startDate = Rx<DateTime?>(null);
  final Rx<DateTime?> endDate = Rx<DateTime?>(null);

  // Available filter options
  final RxList<String> availableCompanies = <String>[
    'All Companies',
    'Apple',
    'Samsung', 
    'Xiaomi',
    'OnePlus',
    'Vivo',
    'Oppo',
    'Realme',
    'Google',
    'Nothing'
  ].obs;
  
  final RxList<String> availableMonths = <String>[
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ].obs;
  
  final RxList<String> availableYears = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFilters();
    fetchBillAnalytics();
  }

  @override
  void onClose() {
    startDateController.dispose();
    endDateController.dispose();
    super.onClose();
  }

  void _initializeFilters() {
    // Initialize years (current year and previous years)
    final currentYear = DateTime.now().year;
    availableYears.addAll([
      for (int i = currentYear; i >= currentYear - 5; i--) i.toString()
    ]);
    
    // Set default values
    selectedYear.value = currentYear.toString();
    selectedMonth.value = _getMonthName(DateTime.now().month);
    selectedCompany.value = 'All Companies';
    timePeriodType.value = 'Month/Year';
  }

  String _getMonthName(int monthNumber) {
    const months = [
      '', 'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[monthNumber];
  }

  int _getMonthNumber(String monthName) {
    const months = {
      'January': 1, 'February': 2, 'March': 3, 'April': 4,
      'May': 5, 'June': 6, 'July': 7, 'August': 8,
      'September': 9, 'October': 10, 'November': 11, 'December': 12
    };
    return months[monthName] ?? 1;
  }

  // Date selection methods
  void onStartDateChanged(DateTime date) {
    startDate.value = date;
    startDateController.text = DateFormat('dd/MM/yyyy').format(date);
    if (timePeriodType.value == 'Custom Date') {
      fetchBillAnalytics();
    }
  }

  void onEndDateChanged(DateTime date) {
    endDate.value = date;
    endDateController.text = DateFormat('dd/MM/yyyy').format(date);
    if (timePeriodType.value == 'Custom Date') {
      fetchBillAnalytics();
    }
  }

  void onTimePeriodTypeChanged(String? type) {
    if (type != null) {
      timePeriodType.value = type;
      
      // Clear custom dates when switching to Month/Year
      if (type == 'Month/Year') {
        startDate.value = null;
        endDate.value = null;
        startDateController.clear();
        endDateController.clear();
      }
      
      fetchBillAnalytics();
    }
  }

  // Fetch bill analytics from API
  Future<void> fetchBillAnalytics() async {
    try {
      isAnalyticsLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Build query parameters based on time period type
      Map<String, dynamic> queryParams = {};

      if (timePeriodType.value == 'Month/Year') {
        queryParams['year'] = selectedYear.value;
        queryParams['month'] = _getMonthNumber(selectedMonth.value);
      } else if (timePeriodType.value == 'Custom Date' && 
                 startDate.value != null && endDate.value != null) {
        queryParams['startDate'] = DateFormat('yyyy-MM-dd').format(startDate.value!);
        queryParams['endDate'] = DateFormat('yyyy-MM-dd').format(endDate.value!);
      }

      // Add company filter if not "All Companies"
      if (selectedCompany.value.isNotEmpty && 
          selectedCompany.value != 'All Companies') {
        queryParams['companyName'] = selectedCompany.value;
      }

      log("Fetching bill analytics with params: $queryParams");

      // API endpoint
      final url = 'https://backend-production-91e4.up.railway.app/api/purchase-bills/monthly-summary';

      dio.Response? response = await _apiService.requestGetForApi(
        url: url,
        authToken: true,
        dictParameter: queryParams,
      );

      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;
        analyticsData.value = data
            .map((item) => BillAnalyticsModel.fromJson(item))
            .toList();

  
        
        // Force update observables
        analyticsData.refresh();
      } else {
        throw Exception('Failed to load bill analytics');
      }
    } catch (error) {
      hasError.value = true;
      errorMessage.value = 'Error: $error';
      log("❌ Error in fetchBillAnalytics: $error");

      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to load analytics: $error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withValues(alpha:0.8),
        colorText: Colors.white,
      );
    } finally {
      isAnalyticsLoading.value = false;
    }
  }

  // Filter methods
  void onCompanyChanged(String? company) {
    if (company != null) {
      selectedCompany.value = company;
      fetchBillAnalytics();
    }
  }

  void onMonthChanged(String? month) {
    if (month != null) {
      selectedMonth.value = month;
      fetchBillAnalytics();
    }
  }

  void onYearChanged(String? year) {
    if (year != null) {
      selectedYear.value = year;
      fetchBillAnalytics();
    }
  }

  void clearFilters() {
    selectedCompany.value = 'All Companies';
    selectedMonth.value = _getMonthName(DateTime.now().month);
    selectedYear.value = DateTime.now().year.toString();
    timePeriodType.value = 'Month/Year';
    startDate.value = null;
    endDate.value = null;
    startDateController.clear();
    endDateController.clear();
    fetchBillAnalytics();
  }

  void applyFilters() {
    fetchBillAnalytics();
  }

  // Chart data getters
  Map<String, double> get purchaseData {
    Map<String, double> data = {};
    for (var item in analyticsData) {
      // Use month name or a combination of month/year as key
      String key = item.month ?? item.monthShort ?? 'Unknown';
      data[key] = item.totalPurchase ?? 0.0;
    }
    log("Purchase data for chart: $data");
    return data;
  }

  Map<String, double> get paidData {
    Map<String, double> data = {};
    for (var item in analyticsData) {
      // Use month name or a combination of month/year as key
      String key = item.month ?? item.monthShort ?? 'Unknown';
      data[key] = item.totalPaid ?? 0.0;
    }
    log("Paid data for chart: $data");
    return data;
  }

  // Summary calculations
  double get totalPurchaseAmount {
    double total = analyticsData.fold(0.0, (sum, item) => sum + (item.totalPurchase ?? 0.0));
    log("Total purchase amount: $total");
    return total;
  }

  double get totalPaidAmount {
    double total = analyticsData.fold(0.0, (sum, item) => sum + (item.totalPaid ?? 0.0));
    log("Total paid amount: $total");
    return total;
  }

  double get totalOutstanding {
    double outstanding = totalPurchaseAmount - totalPaidAmount;
    log("Total outstanding: $outstanding");
    return outstanding;
  }

  // Refresh data
  Future<void> refreshData() async {
    await fetchBillAnalytics();
  }
}