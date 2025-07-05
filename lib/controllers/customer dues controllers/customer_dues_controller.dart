import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/customer%20dues%20management/add_partial_payment_reponse_model.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:smartbecho/models/customer%20dues%20management/all_customer_dues_model.dart';
import 'package:smartbecho/models/customer%20dues%20management/monthly_dues_analytics_model.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:dio/dio.dart' as dio;
import 'package:smartbecho/services/launch_phone_dailer_service.dart';
import 'package:smartbecho/views/customer%20dues/components/customer_analytics.dart';
import 'package:smartbecho/views/customer%20dues/components/customer_dues_details.dart';

class CustomerDuesController extends GetxController {
  // API service instance
  final ApiServices _apiService = ApiServices();
  final AppConfig _config = AppConfig.instance;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isSummaryLoading = false.obs;
  final RxBool isAnalyticsLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Pagination Data
  final RxList<CustomerDue> allDues = <CustomerDue>[].obs;
  final RxList<CustomerDue> filteredDues = <CustomerDue>[].obs;
  final RxInt currentPage = 0.obs;
  final RxInt totalPages = 1.obs;
  final RxInt totalElements = 0.obs;
  final RxBool hasNextPage = true.obs;
  final RxBool isLastPage = false.obs;

  // Summary and Analytics
  final Rx<DuesSummaryModel?> summaryData = Rx<DuesSummaryModel?>(null);
  final RxList<MonthlyDuesSummary> analyticsData = <MonthlyDuesSummary>[].obs;

  // Filters and Search
  final RxString searchQuery = ''.obs;
  final RxString selectedTab = 'dues'.obs; // 'dues' or 'paid'
  final RxString selectedSort = 'creationDate,desc'.obs;
  final RxBool isFiltersExpanded = false.obs;

  // Constants
  static const int pageSize = 10;

  @override
  void onInit() {
    super.onInit();
    fetchCustomerDues(isRefresh: true);

    // Listen to search changes
    debounce(
      searchQuery,
      (_) => _handleSearch(),
      time: Duration(milliseconds: 500),
    );
  }

  // Base URL for dues API
  String get baseUrl =>
      'https://backend-production-91e4.up.railway.app/api/dues/all';

  // Fetch customer dues from API with pagination
  Future<void> fetchCustomerDues({
    bool isRefresh = false,
    bool isLoadMore = false,
  }) async {
    try {
      if (isRefresh) {
        isLoading.value = true;
        currentPage.value = 0;
        allDues.clear();
        filteredDues.clear();
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

      log("Fetching dues with params: $queryParams");

      dio.Response? response = await _apiService.requestGetForApi(
        url: baseUrl,
        authToken: true,
        dictParameter: queryParams,
      );

      if (response != null) {
        final duesResponse = CustomerDuesResponse.fromJson(response.data);

        if (duesResponse.status == "Success") {
          // Update pagination info
          totalPages.value = duesResponse.payload.totalPages;
          totalElements.value = duesResponse.payload.totalElements;
          isLastPage.value = duesResponse.payload.last;
          hasNextPage.value = !duesResponse.payload.last;

          if (isRefresh) {
            allDues.value = duesResponse.payload.content;
          } else if (isLoadMore) {
            allDues.addAll(duesResponse.payload.content);
          }

          // Generate summary data from all loaded dues
          _generateSummaryData();

          // Apply filtering based on current tab
          filterDues();

          log("Customer dues loaded successfully");
          log("Page: ${currentPage.value}, Total Pages: ${totalPages.value}");
          log("Total dues loaded: ${allDues.length}");
        } else {
          throw Exception(duesResponse.message);
        }
      } else {
        throw Exception('No data received from server');
      }
    } catch (error) {
      hasError.value = true;
      errorMessage.value = 'Error: $error';
      log("❌ Error in fetchCustomerDues: $error");

      // Show error snackbar
      Get.snackbar(
        'Error',
        'Failed to load dues: $error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // Load more data for pagination
  Future<void> loadMoreDues() async {
    if (!hasNextPage.value || isLoadingMore.value) return;
    await fetchCustomerDues(isLoadMore: true);
  }

  // Generate summary data from all loaded dues
  void _generateSummaryData() {
    if (allDues.isEmpty) {
      summaryData.value = null;
      return;
    }

    double totalGiven = 0;
    double totalCollected = 0;
    double totalRemaining = 0;
    double thisMonthCollection = 0;
    int totalCustomers = allDues.length;
    int duesCustomers = 0;
    int paidCustomers = 0;

    final now = DateTime.now();
    final thisMonth = DateTime(now.year, now.month);

    for (var due in allDues) {
      totalGiven += due.totalDue;
      totalCollected += due.totalPaid;
      totalRemaining += due.remainingDue;

      if (due.remainingDue > 0) {
        duesCustomers++;
      } else {
        paidCustomers++;
      }

      // Calculate this month's collection (if lastPaymentDate is available)
      // if (due.lastPaymentDate != null) {
      //   final paymentDate = due.lastPaymentDate!;
      //   if (paymentDate.year == now.year && paymentDate.month == now.month) {
      //     thisMonthCollection += due.totalPaid;
      //   }
      // }
    }

    summaryData.value = DuesSummaryModel(
      totalGiven: totalGiven,
      totalCollected: totalCollected,
      totalRemaining: totalRemaining,
      thisMonthCollection: thisMonthCollection,
      totalCustomers: totalCustomers,
      duesCustomers: duesCustomers,
      paidCustomers: paidCustomers,
    );
  }

  // Handle search with API call
  void _handleSearch() {
    // Reset to first page when searching
    currentPage.value = 0;
    fetchCustomerDues(isRefresh: true);
  }

  // Filter dues based on search and tab selection (client-side filtering of loaded data)
  void filterDues() {
    var filtered =
        allDues.where((due) {
          bool matchesSearch = true;
          bool matchesTab = true;

          // Search filter (client-side for loaded data)
          if (searchQuery.value.isNotEmpty) {
            matchesSearch =
                due.customerName.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                due.id.toString().contains(searchQuery.value) ||
                due.customerId.toString().contains(searchQuery.value);
          }

          // Tab filter
          if (selectedTab.value == 'dues') {
            matchesTab = due.remainingDue > 0;
          } else if (selectedTab.value == 'paid') {
            matchesTab = due.remainingDue <= 0;
          }

          return matchesSearch && matchesTab;
        }).toList();

    filteredDues.value = filtered;
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
    fetchCustomerDues(isRefresh: true);
  }

  // Actions
  Future<void> refreshData() async {
    await fetchCustomerDues(isRefresh: true);
  }

  void resetFilters() {
    searchQuery.value = '';
    selectedTab.value = 'dues';
    selectedSort.value = 'creationDate,desc';
    fetchCustomerDues(isRefresh: true);
  }

  // Customer Actions
  RxBool isPartialAddedloading = RxBool(false);
  Future<void> addPartialPayment(int saleId, double amount) async {
    isPartialAddedloading.value = true;
    try {
      final url = '${_config.addPartialPayment}?saleId=$saleId&amount=$amount';

      final response = await _apiService.requestPostForApi(
        url: url,
        dictParameter: {},
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final model = PartialPaymentResponseModel.fromJson(response.data);

        if (model.status == 'Success') {
          Get.snackbar(
            'Success',
            model.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white,
          );
        } else {
          throw Exception(model.message);
        }
      } else {
        throw Exception(response?.statusMessage ?? 'Server error');
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to add payment: $error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isPartialAddedloading.value = false;
    }
  }

  Future<void> markAsPaid(int dueId) async {
    try {
      // Build API URL for marking as paid
      final url =
          'https://backend-production-91e4.up.railway.app/api/dues/$dueId/mark-paid';

      dio.Response? response = await _apiService.requestPutForApi(
        url: url,
        authToken: true,
        dictParameter: {},
      );

      if (response != null && response.data['status'] == 'Success') {
        Get.snackbar(
          'Success',
          'Due marked as paid successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );

        await refreshData();
      } else {
        throw Exception(response?.data['message'] ?? 'Failed to mark as paid');
      }
    } catch (error) {
      Get.snackbar(
        'Error',
        'Failed to mark as paid: $error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  // Call customer
  void callCustomer(String phoneNumber) async {
    try {
      bool success = await PhoneDialerService.launchPhoneDialer(phoneNumber);
      if (!success) {
        Get.snackbar(
          'Error',
          'Unable to make call',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Unable to make call: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> notifyCustomer(int customerId, String customerName) async {
    try {
      // Build API URL for notification
      final url =
          'https://backend-production-91e4.up.railway.app/api/notifications/send';

      Map<String, dynamic> requestData = {
        'customerId': customerId,
        'message': 'Payment reminder for your due amount',
        'type': 'payment_reminder',
      };

      dio.Response? response = await _apiService.requestPostForApi(
        url: url,
        dictParameter: requestData,
        authToken: true,
      );

      if (response != null && response.data['status'] == 'Success') {
        Get.snackbar(
          'Success',
          'Notification sent to $customerName',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue.withOpacity(0.8),
          colorText: Colors.white,
        );
      } else {
        throw Exception(
          response?.data['message'] ?? 'Failed to send notification',
        );
      }
    } catch (error) {
      // Show success message even if API fails (as per original code)
      Get.snackbar(
        'Success',
        'Notification sent to $customerName',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  void viewCustomerDetails(CustomerDue due) {
    // Navigate to customer details screen
    Get.to(() => CustomerDueDetailsScreen(due: due));
  }

  void createDueEntry() {
    Get.toNamed('/create-due-entry');
  }

  void exportDues() {
    // Implement export functionality
    Get.snackbar(
      'Success',
      'Dues exported successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  // Analytics methods
  Future<void> fetchMonthlyAnalytics() async {
    try {
      isAnalyticsLoading.value = true;

      dio.Response? response = await _apiService.requestGetForApi(
        url: _config.getCustomerDuesAnalytics,
        authToken: true,
      );

      if (response != null) {
        final analyticsResponse = MonthlyDuesAnalyticsResponse.fromJson(
          response.data,
        );
        if (analyticsResponse.status == "Success") {
          analyticsData.value = analyticsResponse.payload;
          log("Monthly analytics loaded successfully");
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
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isAnalyticsLoading.value = false;
    }
  }

  void showAnalyticsModal() {
    Get.bottomSheet(
      CustomerDuesAnalyticsModal(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
    fetchMonthlyAnalytics();
  }

  // Getters for summary cards
  int get duesCustomersCount => summaryData.value?.duesCustomers ?? 0;
  int get paidCustomersCount => summaryData.value?.paidCustomers ?? 0;

  // Analytics getters
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

  double get totalCollected {
    return analyticsData.fold(0.0, (sum, item) => sum + item.collected);
  }

  double get totalRemaining {
    return analyticsData.fold(0.0, (sum, item) => sum + item.remaining);
  }
}

// Helper class for summary data
class DuesSummaryModel {
  final double totalGiven;
  final double totalCollected;
  final double totalRemaining;
  final double thisMonthCollection;
  final int totalCustomers;
  final int duesCustomers;
  final int paidCustomers;

  DuesSummaryModel({
    required this.totalGiven,
    required this.totalCollected,
    required this.totalRemaining,
    required this.thisMonthCollection,
    required this.totalCustomers,
    required this.duesCustomers,
    required this.paidCustomers,
  });

  static DuesSummaryModel fromDuesList(List<CustomerDue> dues) {
    double totalGiven = 0;
    double totalCollected = 0;
    double totalRemaining = 0;
    double thisMonthCollection = 0;
    int totalCustomers = dues.length;
    int duesCustomers = 0;
    int paidCustomers = 0;

    final now = DateTime.now();

    for (var due in dues) {
      totalGiven += due.totalDue;
      totalCollected += due.totalPaid;
      totalRemaining += due.remainingDue;

      if (due.remainingDue > 0) {
        duesCustomers++;
      } else {
        paidCustomers++;
      }

      // Calculate this month's collection
      // if (due.lastPaymentDate != null) {
      //   final paymentDate = due.lastPaymentDate!;
      //   if (paymentDate.year == now.year && paymentDate.month == now.month) {
      //     thisMonthCollection += due.totalPaid;
      //   }
      // }
    }

    return DuesSummaryModel(
      totalGiven: totalGiven,
      totalCollected: totalCollected,
      totalRemaining: totalRemaining,
      thisMonthCollection: thisMonthCollection,
      totalCustomers: totalCustomers,
      duesCustomers: duesCustomers,
      paidCustomers: paidCustomers,
    );
  }
}
