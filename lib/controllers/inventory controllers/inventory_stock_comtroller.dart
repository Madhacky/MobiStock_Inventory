// controllers/inventory_controller.dart
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;

import 'package:get/get.dart';
import 'package:smartbecho/models/inventory%20management/business_summary_model.dart';
import 'package:smartbecho/models/inventory%20management/company_stock_model.dart';
import 'package:smartbecho/models/inventory%20management/low_stock_alert_model.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';

class InventorySalesStockController extends GetxController {
  // API service instance
  final ApiServices _apiService = ApiServices();
  // App config instance
  final AppConfig _config = AppConfig.instance;
  // Observable variables
  var isLoading = false.obs;
  var lowStockAlerts = Rx<LowStockAlertModel?>(null);
  var companyStocks = <CompanyStockModel>[].obs;
  var businessSummary = Rx<BusinessSummaryModel?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchInventoryData();
  }

  Future<void> fetchInventoryData() async {
    try {
      isLoading.value = true;
      // Simulate API calls
      await Future.wait([fetchLowStockAlerts(), fetchCompanyStocks()]);

      calculateBusinessSummary();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch inventory data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLowStockAlerts() async {
    try {
      dio.Response? response = await _apiService.requestGetForApi(
        url: _config.getLowStockAlerts, // Update with your actual endpoint
        authToken: true,
      );

      if (response != null) {
        if (response.statusCode == 200) {
          final data =
              response.data is String
                  ? json.decode(response.data)
                  : response.data;

          // Parse the response using the model
          lowStockAlerts.value = LowStockAlertModel.fromJson(data);

          log("Low Stock Alerts loaded successfully");
          log(
            "Critical items: ${lowStockAlerts.value?.payload.critical.length ?? 0}",
          );
          log(
            "Low stock items: ${lowStockAlerts.value?.payload.low.length ?? 0}",
          );
          log(
            "Out of stock items: ${lowStockAlerts.value?.payload.outOfStock.length ?? 0}",
          );
        }
      }
    } catch (error) {
      log("❌ Error in fetchLowStockAlerts: $error");
    }
  }

  //get company stocks
  Future<void> fetchCompanyStocks() async {
    try {
      dio.Response? response = await _apiService.requestGetForApi(
        url: _config.getCompanyStocks,
        authToken: true,
      );

      if (response != null) {
        if (response.statusCode == 200) {
          final data =
              response.data is String
                  ? json.decode(response.data)
                  : response.data;
          List<dynamic> stockList;
          if (data is Map<String, dynamic> && data.containsKey('payload')) {
            stockList = data['payload'] as List<dynamic>;
          } else if (data is List<dynamic>) {
            stockList = data;
          } else {
            throw Exception('Unexpected response format');
          }

          companyStocks.value =
              stockList
                  .map((json) => CompanyStockModel.fromJson(json))
                  .toList();

          log("Company Stocks loaded successfully");
          log("Total companies: ${companyStocks.length}");
          log("Companies: ${companyStocks.map((e) => e.company).join(', ')}");
        }
      }
    } catch (error) {
      log("❌ Error in fetchCompanyStocks: $error");
    }
  }

  void calculateBusinessSummary() {
    if (companyStocks.isEmpty) return;

    final totalCompanies = companyStocks.length;
    final totalModels = companyStocks.fold<int>(
      0,
      (sum, company) => sum + company.totalModels,
    );
    final totalStock = companyStocks.fold<int>(
      0,
      (sum, company) => sum + company.totalStock,
    );

    // Find top selling brand (company with highest stock for this example)
    final topBrand = companyStocks.reduce(
      (a, b) => a.totalStock > b.totalStock ? a : b,
    );

    businessSummary.value = BusinessSummaryModel(
      totalCompanies: totalCompanies,
      totalModelsAvailable: totalModels,
      totalStockAvailable: totalStock,
      totalSoldUnits: 67, // Mock data
      topSellingBrand: topBrand.company,
      totalRevenue: 3982500.0, // Mock data
    );
  }

  // Helper methods
  int get totalCriticalAlerts =>
      lowStockAlerts.value?.payload.critical.length ?? 0;
  int get totalLowStockAlerts => lowStockAlerts.value?.payload.low.length ?? 0;
  int get totalOutOfStockAlerts =>
      lowStockAlerts.value?.payload.outOfStock.length ?? 0;
  int get totalAlerts =>
      totalCriticalAlerts + totalLowStockAlerts + totalOutOfStockAlerts;

  void refreshData() {
    isLoading.value=false;
businessSummary.value = null;
    fetchInventoryData();
  }
}
