import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/account%20management%20models/financial_year_summary_model.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';

class ViewHistoryController extends GetxController {
  final ApiServices _apiService = ApiServices();
  final AppConfig _config = AppConfig.instance;

  // Observable variables
  var isLoading = false.obs;
  var selectedYear = DateTime.now().year.obs;
  var selectedAnalyticsTab = 'monthly'.obs;
  var financialData = <FinancialSummaryModel>[].obs;
  var availableYears = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initializeYears();
    loadFinancialSummary();
  }

  void _initializeYears() {
    final currentYear = DateTime.now().year;
    // Add years from 2020 to current year + 1
    for (int year = 2020; year <= currentYear + 1; year++) {
      availableYears.add(year);
    }
  }

  Future<void> loadFinancialSummary() async {
    try {
      isLoading.value = true;
      final query = {
        'year': selectedYear.value.toString(),
      };

      final response = await _apiService.requestGetForApi(
        url: '${_config.baseUrl}/api/commissions/financial-summary',
        dictParameter: query,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final parsed = FinancialSummaryResponse.fromJson(response.data);
        financialData.value = parsed.payload;
      } else {
        Get.snackbar(
          'Error',
          'Failed to load financial summary',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while loading data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onYearChanged(int year) {
    selectedYear.value = year;
    loadFinancialSummary();
  }

  void onAnalyticsTabChanged(String tabId) {
    selectedAnalyticsTab.value = tabId;
  }

  String formatAmount(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)}Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }

  double getMaxValue() {
    if (financialData.isEmpty) return 100.0; // Return default value instead of 0
    
    double maxBills = financialData.map((e) => e.totalBillsPaid).reduce((a, b) => a > b ? a : b);
    double maxSales = financialData.map((e) => e.totalSalesAmount).reduce((a, b) => a > b ? a : b);
    double maxCommissions = financialData.map((e) => e.totalCommissions).reduce((a, b) => a > b ? a : b);
    
    double maxValue = [maxBills, maxSales, maxCommissions].reduce((a, b) => a > b ? a : b);
    
    // Return a minimum value if all data is zero to prevent division by zero
    return maxValue > 0 ? maxValue : 100.0;
  }

  // Add this method to get horizontal interval safely
  double getHorizontalInterval() {
    double maxValue = getMaxValue();
    return maxValue / 5;
  }

  void refreshData() {
    loadFinancialSummary();
  }
}