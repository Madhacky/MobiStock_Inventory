import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/sales%20history%20models/sales_details_model.dart';
import 'package:smartbecho/models/sales%20history%20models/sales_history_reponse_model.dart';
import 'package:smartbecho/models/sales%20history%20models/sales_stats_model.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:dio/dio.dart' as dio;
import 'dart:convert';
import 'dart:developer';

import 'package:smartbecho/services/pdf_downloader_service.dart';

class SalesManagementController extends GetxController {
  // API service instance
  final ApiServices _apiService = ApiServices();
  final AppConfig _config = AppConfig.instance;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isStatsLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Pagination Data
  final RxList<Sale> allSales = <Sale>[].obs;
  final RxList<Sale> filteredSales = <Sale>[].obs;
  final RxInt currentPage = 0.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalElements = 0.obs;
  final RxBool hasNextPage = true.obs;
  final RxBool isLastPage = false.obs;

  // Stats Data
  final Rx<SalesStats?> statsData = Rx<SalesStats?>(null);

  // Search and Filters
  final RxString searchQuery = ''.obs;
  final RxString selectedTab = 'dashboard'.obs; // 'dashboard', 'history', 'insights'
  final RxString selectedSort = 'saleDate,desc'.obs;
  final TextEditingController searchController = TextEditingController();


//sales detail 
final Rx<SaleDetailResponse?> saleDetail = Rx<SaleDetailResponse?>(null);
final RxBool isLoadingDetail = false.obs;
final RxBool hasDetailError = false.obs;
final RxString detailErrorMessage = ''.obs;

  // Constants
  static const int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    fetchSalesStats();
    fetchSalesHistory(isRefresh: true);

    // Listen to search changes
    debounce(
      searchQuery,
      (_) => _handleSearch(),
      time: Duration(milliseconds: 500),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // Base URLs for sales API
  String get salesHistoryUrl => 'https://backend-production-91e4.up.railway.app/api/sales/shop-history';
  String get salesStatsUrl => 'https://backend-production-91e4.up.railway.app/api/sales/stats/today';

  // Fetch sales stats from API
  Future<void> fetchSalesStats() async {
    try {
      isStatsLoading.value = true;

      log("Fetching sales stats...");

      dio.Response? response = await _apiService.requestGetForApi(
        url: salesStatsUrl,
        authToken: true,
      );

      if (response != null) {
        final statsResponse = SalesStatsResponse.fromJson(response.data);

        if (statsResponse.status == "Success") {
          statsData.value = statsResponse.payload;
          log("Sales stats loaded successfully");
        } else {
          throw Exception(statsResponse.message);
        }
      } else {
        throw Exception('No stats data received from server');
      }
    } catch (error) {
      log("❌ Error in fetchSalesStats: $error");
      Get.snackbar(
        'Error',
        'Failed to load sales stats: $error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isStatsLoading.value = false;
    }
  }

  // Fetch sales history from API with pagination
  Future<void> fetchSalesHistory({
    bool isRefresh = false,
    bool isLoadMore = false,
  }) async {
    try {
      if (isRefresh) {
        isLoading.value = true;
        currentPage.value = 0;
        allSales.clear();
        filteredSales.clear();
        hasError.value = false;
        errorMessage.value = '';
      } else if (isLoadMore) {
        if (isLastPage.value || isLoadingMore.value) return;
        isLoadingMore.value = true;
        currentPage.value++;
      }

      // Build query parameters
      Map<String, dynamic> queryParams = {
        'page': currentPage.value,
        'size': pageSize,
        'sort': selectedSort.value,
      };

      // Add search query if present
      if (searchQuery.value.isNotEmpty) {
        queryParams['search'] = searchQuery.value;
      }

      log("Fetching sales history with params: $queryParams");

      dio.Response? response = await _apiService.requestGetForApi(
        url: salesHistoryUrl,
        authToken: true,
        dictParameter: queryParams,
      );

      if (response != null) {
        final salesResponse = SalesHistoryResponse.fromJson(response.data);

        if (salesResponse.status == "Success") {
          // Update pagination info
          totalPages.value = salesResponse.payload.totalPages;
          totalElements.value = salesResponse.payload.totalElements;
          isLastPage.value = salesResponse.payload.last;
          hasNextPage.value = !salesResponse.payload.last;

          if (isRefresh) {
            allSales.value = salesResponse.payload.content;
          } else if (isLoadMore) {
            allSales.addAll(salesResponse.payload.content);
          }

          // Apply filtering
          filterSales();

          log("Sales history loaded successfully");
          log("Page: ${currentPage.value}, Total Pages: ${totalPages.value}");
          log("Total sales loaded: ${allSales.length}");
        } else {
          throw Exception(salesResponse.message);
        }
      } else {
        throw Exception('No data received from server');
      }
    } catch (error) {
      hasError.value = true;
      errorMessage.value = 'Error: $error';
      log("❌ Error in fetchSalesHistory: $error");

      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to load sales history: $error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  //fetch sales details
  Future<void> fetchSaleDetail(int saleId) async {
  try {
    isLoadingDetail.value = true;
    hasDetailError.value = false;
    detailErrorMessage.value = '';
    
    
    log("Fetching sale detail for ID: $saleId");
    
    dio.Response? response = await _apiService.requestGetForApi(
      url:"${_config.saleDetail}/$saleId",
      authToken: true,
    );

    if (response != null) {
      log("Sale detail response: ${response.data}");
      saleDetail.value = SaleDetailResponse.fromJson(response.data);
      log("Sale detail loaded successfully");
    } else {
      throw Exception('No sale detail data received from server');
    }
  } catch (error) {
    hasDetailError.value = true;
    detailErrorMessage.value = 'Error: $error';
    log("❌ Error in fetchSaleDetail: $error");
    
    Get.snackbar(
      'Error',
      'Failed to load sale details: $error',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.8),
      colorText: Colors.white,
    );
  } finally {
    isLoadingDetail.value = false;
  }
}

  // Load more data for pagination
  Future<void> loadMoreSales() async {
    if (!hasNextPage.value || isLoadingMore.value) return;
    await fetchSalesHistory(isLoadMore: true);
  }

  // Handle search with API call
  void _handleSearch() {
    currentPage.value = 0;
    fetchSalesHistory(isRefresh: true);
  }

  // Filter sales based on search (client-side filtering of loaded data)
  void filterSales() {
    var filtered = allSales.where((sale) {
      bool matchesSearch = true;

      if (searchQuery.value.isNotEmpty) {
        matchesSearch = sale.customerName.toLowerCase().contains(
          searchQuery.value.toLowerCase(),
        ) ||
        sale.invoiceNumber.toLowerCase().contains(
          searchQuery.value.toLowerCase(),
        ) ||
        sale.companName.toLowerCase().contains(
          searchQuery.value.toLowerCase(),
        ) ||
        sale.companyModel.toLowerCase().contains(
          searchQuery.value.toLowerCase(),
        );
      }

      return matchesSearch;
    }).toList();

    filteredSales.value = filtered;
  }

  // Event handlers
  void onSearchChanged() {
    searchQuery.value = searchController.text;
  }

  void onTabChanged(String tab) {
    selectedTab.value = tab;
  }

  void onSortChanged(String sort) {
    selectedSort.value = sort;
    fetchSalesHistory(isRefresh: true);
  }

  // Actions
  Future<void> refreshData() async {
    await Future.wait([
      fetchSalesStats(),
      fetchSalesHistory(isRefresh: true),
    ]);
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  void resetFilters() {
    searchQuery.value = '';
    selectedSort.value = 'saleDate,desc';
    searchController.clear();
    fetchSalesHistory(isRefresh: true);
  }

  // Helper methods
  Color getCompanyColor(String companyName) {
    switch (companyName.toLowerCase()) {
      case 'samsung':
        return Color(0xFF1428A0);
      case 'apple':
        return Color(0xFF007AFF);
      case 'vivo':
        return Color(0xFF4285F4);
      case 'oppo':
        return Color(0xFF07C160);
      case 'xiaomi':
        return Color(0xFFFF6900);
      case 'realme':
        return Color(0xFFFFD60A);
      case 'oneplus':
        return Color(0xFFEB1700);
      default:
        return Color(0xFF1E293B);
    }
  }

  Color getPaymentMethodColor(String paymentMethod) {
    switch (paymentMethod.toLowerCase()) {
      case 'upi':
        return Color(0xFF10B981);
      case 'cash':
        return Color(0xFF3B82F6);
      case 'card':
        return Color(0xFF8B5CF6);
      case 'emi':
        return Color(0xFFF59E0B);
      default:
        return Color(0xFF6B7280);
    }
  }

  IconData getPaymentMethodIcon(String paymentMethod) {
    switch (paymentMethod.toLowerCase()) {
      case 'upi':
        return Icons.qr_code;
      case 'cash':
        return Icons.money;
      case 'card':
        return Icons.credit_card;
      case 'emi':
        return Icons.schedule;
      default:
        return Icons.payment;
    }
  }

  // Navigation methods
  void navigateToSaleDetails(Sale sale) {
    Get.toNamed(AppRoutes.salesDetails, arguments: sale.saleId);
  }

  void downloadInvoice(Sale sale) {
  log(sale.invoicePdfUrl);
  
  // Extract filename from URL or create a custom one
  String fileName = 'invoice_${sale.invoiceNumber}.pdf';
  
  // Download the PDF
  PDFDownloadService.downloadPDF(
    url: sale.invoicePdfUrl,
    fileName: fileName,
    customPath: 'Invoices',
    openAfterDownload: true,
    onDownloadComplete: () {
      // Optional: Additional actions after download
      print('Invoice ${sale.invoiceNumber} downloaded successfully');
    },
  );
}

  // Getters for stats
  double get totalSales => statsData.value?.totalSaleAmount ?? 0.0;
  double get totalEmi => statsData.value?.totalEmiAmount ?? 0.0;
  double get upiAmount => statsData.value?.upiAmount ?? 0.0;
  double get cashAmount => statsData.value?.cashAmount ?? 0.0;
  double get cardAmount => statsData.value?.cardAmount ?? 0.0;
  int get totalPhonesSold => statsData.value?.totalPhonesSold ?? 0;

  String get formattedTotalSales => '₹${totalSales.toStringAsFixed(2)}';
  String get formattedTotalEmi => '₹${totalEmi.toStringAsFixed(2)}';
  String get formattedUpiAmount => '₹${upiAmount.toStringAsFixed(2)}';
  String get formattedCashAmount => '₹${cashAmount.toStringAsFixed(2)}';
  String get formattedCardAmount => '₹${cardAmount.toStringAsFixed(2)}';
}
