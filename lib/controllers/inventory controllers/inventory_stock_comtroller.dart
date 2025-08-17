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
  var isLoadingCategories = false.obs; // Loading state for categories
  var lowStockAlerts = Rx<LowStockAlertModel?>(null);
  var companyStocks = <CompanyStockModel>[].obs;
  var businessSummary = Rx<BusinessSummaryModel?>(null);
  final Rx<BusinessSummaryModel?> businessSummaryCardsData =
      Rx<BusinessSummaryModel?>(null);

  var currentCategory = 'CHARGER'.obs; // Track current category
  RxList<String> itemCategory = RxList<String>(); // Categories from API

  @override
  void onInit() {
    super.onInit();
    // fetchBusinesssummaryegories();
    // Fetch categories first, then inventory data
    fetchItemCategories().then((_) {
      fetchInventoryData();
       fetchBusinesssummaryegories();
    });
  }

  final RxBool isbusinessSummaryCardsLoading = false.obs;
  final RxBool hasbusinessSummaryCardsError = false.obs;
  // final RxString businessSummaryCardsErrorMessage = ''.obs;
  final RxString businessSummaryCardsErrorMessage = ''.obs;

  Future<void> fetchBusinesssummaryegories() async {
    try {
      isbusinessSummaryCardsLoading.value = true;
      hasbusinessSummaryCardsError.value = false;
      businessSummaryCardsErrorMessage.value = '';

      log("🔄 Fetching item categories from API");

      dio.Response? response = await _apiService.requestGetForApi(
        url:
            "${_config.baseUrl}/inventory/business-summary", // Add this to your AppConfig
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
       
        final summaryResponse = BusinessSummaryModel.fromJson(response.data);
        businessSummaryCardsData.value = summaryResponse;
        log(
          "Summary Cards loaded successfully gskjgshbkakbgabgabg ${businessSummaryCardsData.value}}",
        );
      } else {
        hasbusinessSummaryCardsError.value = true;
        businessSummaryCardsErrorMessage.value =
            'Failed to fetch summary data. Status: ${response?.statusCode}';

        log("❌ No response received for item categories");
      }
    } catch (error) {
      hasbusinessSummaryCardsError.value = true;
      businessSummaryCardsErrorMessage.value = 'Error: $error';
      log("❌ Error in fetchItemCategories: $error");
      // Use fallback categories on error
    } finally {
      isbusinessSummaryCardsLoading.value = false;
    }
  }

  // Fixed getter methods for easy access to summary data
  int get totalCompaniesAvailable =>
      businessSummaryCardsData.value?.payload.totalCompanies ?? 0;
  int get totalStockAvailable =>
      businessSummaryCardsData.value?.payload.totalStockAvailable ?? 0;
  int get totalModelsAvailable =>
      businessSummaryCardsData.value?.payload.totalModelsAvailable ?? 0;
  int get monthlyPhoneSold =>
      businessSummaryCardsData.value?.payload.totalUnitsSold ?? 0;
  String get topSellingBrandAndModel =>
      businessSummaryCardsData.value?.payload.topSellingBrandAndModel ?? '';
  double get totalRevenue =>
      businessSummaryCardsData.value?.payload.totalRevenue ?? 0.0;

  // New method to fetch item categories from API
  Future<void> fetchItemCategories() async {
    try {
      isLoadingCategories.value = true;
      log("🔄 Fetching item categories from API");

      dio.Response? response = await _apiService.requestGetForApi(
        url:
            "${_config.baseUrl}/inventory/item-types", // Add this to your AppConfig
        authToken: true,
      );

      if (response != null) {
        if (response.statusCode == 200) {
          final data =
              response.data is String
                  ? json.decode(response.data)
                  : response.data;

          if (data is List) {
            // Clear existing categories and add new ones
            itemCategory.clear();
            itemCategory.addAll(data.cast<String>());

            // Set default category if current category is not in the list
            if (itemCategory.isNotEmpty) {
              if (!itemCategory.contains(currentCategory.value)) {
                currentCategory.value = itemCategory.first;
              }
            }

            log("✅ Item categories loaded successfully");
            log("Categories: ${itemCategory.join(', ')}");
            log("Current category set to: ${currentCategory.value}");
          } else {
            throw Exception(
              'Expected List<String> but got ${data.runtimeType}',
            );
          }
        } else {
          log("❌ Failed to fetch categories. Status: ${response.statusCode}");
          // Use fallback categories if API fails
          _setFallbackCategories();
        }
      } else {
        log("❌ No response received for item categories");
        _setFallbackCategories();
      }
    } catch (error) {
      log("❌ Error in fetchItemCategories: $error");
      // Use fallback categories on error
      _setFallbackCategories();
      Get.snackbar(
        'Warning',
        'Failed to fetch categories. Using default categories.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoadingCategories.value = false;
    }
  }

  // Fallback categories in case API fails
  void _setFallbackCategories() {
    itemCategory.clear();
    itemCategory.addAll([
      'SMARTPHONE',
      'CHARGER',
      'EARPHONES',
      'HEADPHONES',
      'BLUETOOTH_SPEAKER',
      'COVER',
      'SCREEN_GUARD',
      'USB_CABLE',
      'POWER_BANK',
    ]);
    currentCategory.value = 'SMARTPHONE';
    log("📦 Using fallback categories");
  }

  Future<void> fetchInventoryData() async {
    try {
      isLoading.value = true;
      // Simulate API calls
      await Future.wait([
        fetchLowStockAlerts(),
        fetchCompanyStocksByCategory(currentCategory.value),
      ]);

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

  // Updated method to fetch company stocks by category
  Future<void> fetchCompanyStocksByCategory(String itemCategory) async {
    try {
      isLoading.value = true;
      currentCategory.value = itemCategory;

      log("🔄 Fetching company stocks for category: $itemCategory");

      dio.Response? response = await _apiService.requestGetForApi(
        url: "${_config.getCompanyStocks}?itemCategory=$itemCategory",
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

          log("✅ Company Stocks loaded successfully for $itemCategory");
          log("Total companies: ${companyStocks.length}");
          log("Companies: ${companyStocks.map((e) => e.company).join(', ')}");

          // Recalculate business summary after fetching new data
          calculateBusinessSummary();
        } else {
          log(
            "❌ Failed to fetch company stocks. Status: ${response.statusCode}",
          );
          Get.snackbar(
            'Error',
            'Failed to fetch company stocks for $itemCategory',
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else {
        log("❌ No response received for company stocks");
        Get.snackbar(
          'Error',
          'No response from server',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error) {
      log("❌ Error in fetchCompanyStocksByCategory: $error");
      Get.snackbar(
        'Error',
        'Failed to fetch company stocks: ${error.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Legacy method for backward compatibility
  Future<void> fetchCompanyStocks() async {
    await fetchCompanyStocksByCategory(currentCategory.value);
  }

  void calculateBusinessSummary() {
    if (companyStocks.isEmpty) {
      businessSummary.value = null;
      return;
    }

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

    log("📊 Business Summary calculated for ${currentCategory.value}:");
    log("Total Companies: $totalCompanies");
    log("Total Models: $totalModels");
    log("Total Stock: $totalStock");
    log("Top Brand: ${topBrand.company}");
  }

  // Method to change category and refresh data
  Future<void> changeCategoryAndRefresh(String newCategory) async {
    if (newCategory != currentCategory.value) {
      await fetchCompanyStocksByCategory(newCategory);
    }
  }

  // Method to refresh categories from API
  Future<void> refreshCategories() async {
    await fetchItemCategories();
  }

  // Helper methods
  int get totalCriticalAlerts =>
      lowStockAlerts.value?.payload.critical.length ?? 0;
  int get totalLowStockAlerts => lowStockAlerts.value?.payload.low.length ?? 0;
  int get totalOutOfStockAlerts =>
      lowStockAlerts.value?.payload.outOfStock.length ?? 0;
  int get totalAlerts =>
      totalCriticalAlerts + totalLowStockAlerts + totalOutOfStockAlerts;

  // Get companies with low stock for current category
  List<CompanyStockModel> get lowStockCompanies =>
      companyStocks.where((company) => company.lowStockModels > 0).toList();

  // Get companies with good stock for current category
  List<CompanyStockModel> get goodStockCompanies =>
      companyStocks
          .where(
            (company) => company.lowStockModels == 0 && company.totalStock > 50,
          )
          .toList();

  // Get companies with high stock for current category
  List<CompanyStockModel> get highStockCompanies =>
      companyStocks.where((company) => company.totalStock > 100).toList();

  void refreshData() {
    isLoading.value = false;
    businessSummary.value = null;
    fetchInventoryData();
  }

  // Method to refresh data for current category
  void refreshCurrentCategory() {
    fetchCompanyStocksByCategory(currentCategory.value);
  }
}
