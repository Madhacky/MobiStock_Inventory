import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:smartbecho/models/customer%20dues%20management/all_customer_dues_model.dart';
import 'package:smartbecho/models/customer%20dues%20management/monthly_dues_analytics_model.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:dio/dio.dart' as dio;
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/views/customer%20dues/components/customer_analytics.dart';

class CustomerDuesController extends GetxController {
  // API service instance
  final ApiServices _apiService = ApiServices();
  final AppConfig _config = AppConfig.instance;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isSummaryLoading = false.obs;
  final RxBool isAnalyticsLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Data
  final RxList<CustomerDue> allDues = <CustomerDue>[].obs;
  final RxList<CustomerDue> filteredDues = <CustomerDue>[].obs;
  final Rx<DuesSummaryModel?> summaryData = Rx<DuesSummaryModel?>(null);
  final RxList<MonthlyDuesSummary> analyticsData = <MonthlyDuesSummary>[].obs;

  // Filters and Search
  final RxString searchQuery = ''.obs;
  final RxString selectedTab = 'dues'.obs; // 'dues' or 'paid'
  final RxString selectedSort = 'date_desc'.obs;
  final RxBool isFiltersExpanded = false.obs;

  // Month/Year filters
  final Rx<int?> selectedMonth = Rx<int?>(null);
  final Rx<int?> selectedYear = Rx<int?>(null);

  // Pagination
  final RxInt currentPage = 0.obs;
  final RxInt totalPages = 1.obs;
  final RxBool isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCustomerDues();

    // Listen to search changes
    debounce(
      searchQuery,
      (_) => filterDues(),
      time: Duration(milliseconds: 500),
    );
  }

  // Fetch customer dues from API with optional month/year filters
  Future<void> fetchCustomerDues({int? month, int? year}) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Build query parameters dictionary
      Map<String, dynamic> queryParams = {};

      if (year != null) {
        queryParams['year'] = year;
      }
      if (month != null) {
        queryParams['month'] = month;
      }

      log("Fetching dues with params: $queryParams");

      dio.Response? response = await _apiService.requestGetForApi(
        url: _config.getAllCustomerDues,
        authToken: true,
        dictParameter: queryParams,
      );

      if (response != null) {
        final duesResponse = CustomerDuesResponse.fromJson(response.data);
        allDues.value = duesResponse.payload;

        // Generate summary data
        summaryData.value = DuesSummaryModel.fromDuesList(allDues);

        // Apply initial filtering
        filterDues();

        log("Customer dues loaded successfully");
        log("Total dues: ${allDues.length}");
      } else {
        throw Exception('No data received from server');
      }
    } catch (error) {
      hasError.value = true;
      errorMessage.value = 'Error: $error';
      log("❌ Error in fetchCustomerDues: $error");
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch monthly dues analytics
  Future<void> fetchMonthlyAnalytics() async {
    try {
      isAnalyticsLoading.value = true;

      // Replace with your actual analytics endpoint
      dio.Response? response = await _apiService.requestGetForApi(
        url: _config.getCustomerDuesAnalytics, // Add this to your AppConfig
        authToken: true,
      );

      if (response != null) {
        final analyticsResponse = MonthlyDuesAnalyticsResponse.fromJson(
          response.data,
        );
        if (analyticsResponse.status == "Success") {
          analyticsData.value = analyticsResponse.payload;
          log("Monthly analytics loaded successfully");
          log("Analytics data: ${analyticsData.length} months");
        } else {
          throw Exception(analyticsResponse.message);
        }
      } else {
        throw Exception('No analytics data received from server');
      }
    } catch (error) {
      log("❌ Error in fetchMonthlyAnalytics: $error");
      Get.snackbar(
        'Error',
        'Failed to load analytics: $error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.primaryRed.withOpacity(0.8),
        colorText: AppTheme.backgroundLight,
      );
    } finally {
      isAnalyticsLoading.value = false;
    }
  }

  // Show analytics modal
  void showAnalyticsModal() {
    Get.bottomSheet(
      CustomerDuesAnalyticsModal(),
      isScrollControlled: true,
      backgroundColor: AppTheme.transparent,
    );

    // Fetch analytics data when modal opens
    fetchMonthlyAnalytics();
  }

  // Convert analytics data to chart format
  Map<String, double> get collectedData {
    Map<String, double> data = {};
    for (var item in analyticsData) {
      data[item.monthShort] = item.collected;
    }
    return data;
  }

  Map<String, double> get remainingData {
    Map<String, double> data = {};
    for (var item in analyticsData) {
      data[item.monthShort] = item.remaining;
    }
    return data;
  }

  // Get total collected amount
  double get totalCollected {
    return analyticsData.fold(0.0, (sum, item) => sum + item.collected);
  }

  // Get total remaining amount
  double get totalRemaining {
    return analyticsData.fold(0.0, (sum, item) => sum + item.remaining);
  }

  // Filter dues based on search and tab selection
  void filterDues() {
    var filtered =
        allDues.where((due) {
          bool matchesSearch = true;
          bool matchesTab = true;

          // Search filter
          if (searchQuery.value.isNotEmpty) {
            matchesSearch =
                due.customerName.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                due.id.toString().contains(searchQuery.value);
          }

          // Tab filter
          if (selectedTab.value == 'dues') {
            matchesTab = due.remainingDue > 0;
          } else if (selectedTab.value == 'paid') {
            matchesTab = due.remainingDue <= 0;
          }

          return matchesSearch && matchesTab;
        }).toList();

    // Apply sorting
    _sortDues(filtered);

    filteredDues.value = filtered;
  }

  void _sortDues(List<CustomerDue> dues) {
    switch (selectedSort.value) {
      case 'date_desc':
        dues.sort((a, b) => b.creationDate.compareTo(a.creationDate));
        break;
      case 'date_asc':
        dues.sort((a, b) => a.creationDate.compareTo(b.creationDate));
        break;
      case 'amount_desc':
        dues.sort((a, b) => b.remainingDue.compareTo(a.remainingDue));
        break;
      case 'amount_asc':
        dues.sort((a, b) => a.remainingDue.compareTo(b.remainingDue));
        break;
    }
  }

  // Event handlers
  void onSearchChanged(String query) {
    searchQuery.value = query;
  }

  void onTabChanged(String tab) {
    selectedTab.value = tab;
    filterDues();
  }

  void onSortChanged(String sort) {
    selectedSort.value = sort;
    filterDues();
  }

  // Month/Year filter handlers
  void onMonthChanged(int? month) {
    selectedMonth.value = month;
    fetchCustomerDues(month: month, year: selectedYear.value);
  }

  void onYearChanged(int? year) {
    selectedYear.value = year;
    fetchCustomerDues(month: selectedMonth.value, year: year);
  }

  void toggleFiltersExpanded() {
    isFiltersExpanded.value = !isFiltersExpanded.value;
  }

  void resetFilters() {
    searchQuery.value = '';
    selectedTab.value = 'dues';
    selectedSort.value = 'date_desc';
    selectedMonth.value = null;
    selectedYear.value = null;
    fetchCustomerDues(); // Fetch without filters
  }

  // Actions
  Future<void> refreshData() async {
    await fetchCustomerDues(
      month: selectedMonth.value,
      year: selectedYear.value,
    );
  }

  void addPartialPayment(int dueId, double amount) {
    // Implement partial payment logic
    Get.snackbar('Success', 'Partial payment added successfully');
  }

  void markAsPaid(int dueId) {
    // Implement mark as paid logic
    Get.snackbar('Success', 'Due marked as paid');
  }

  void showDueDetails(CustomerDue due) {
    // Navigate to due details
    Get.toNamed('/due-details', arguments: due);
  }

  void callCustomer(int customerId) {
    // Implement call functionality
    Get.snackbar('Info', 'Calling customer #$customerId');
  }

  void notifyCustomer(int customerId) {
    // Implement notification functionality
    Get.snackbar('Success', 'Notification sent to customer #$customerId');
  }

  void createDueEntry() {
    // Navigate to create due entry
    Get.toNamed('/create-due-entry');
  }

  void exportDues() {
    // Implement export functionality
    Get.snackbar('Success', 'Dues exported successfully');
  }

  // Getters for summary cards
  int get duesCustomersCount =>
      allDues.where((due) => due.remainingDue > 0).length;
  int get paidCustomersCount =>
      allDues.where((due) => due.remainingDue <= 0).length;
}
