import 'dart:developer';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:smartbecho/models/bill%20history/bill_history_model.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';

class BillHistoryController extends GetxController {
  final ApiServices _apiService = ApiServices();
  final AppConfig _config = AppConfig.instance;

  // Original data from API
  final RxList<Bill> allBills = <Bill>[].obs;
  // Filtered data for display
  final RxList<Bill> bills = <Bill>[].obs;

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxInt currentPage = 0.obs;
  final RxBool hasMore = true.obs;
  final RxInt totalElements = 0.obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxInt totalQty = 0.obs;

  // Filter options
  final RxString selectedCompany = ''.obs;
  final RxString selectedStatus = 'All'.obs;
  final RxString sortBy = 'billId'.obs;
  final RxString sortDir = 'asc'.obs;

  final TextEditingController searchController = TextEditingController();

  // Filter options
  final List<String> statusOptions = ['All', 'Paid', 'Pending'];
  final RxList<String> companyOptions = <String>['All'].obs;

  @override
  void onInit() {
    super.onInit();
    loadBills();

    debounce(
      searchQuery,
      (_) => onSearchChanged(),
      time: Duration(milliseconds: 500),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> loadBills({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 0;
      hasMore.value = true;
    }

    isLoading.value = true;
    error.value = '';

    try {
      final queryParams = <String, String>{
        'page': currentPage.value.toString(),
        'size': '10',
        'sortBy': sortBy.value,
        'sortDir': sortDir.value,
      };

      // Only apply search and company filter to API, not status
      if (searchQuery.value.isNotEmpty) {
        queryParams['search'] = searchQuery.value;
      }

      if (selectedCompany.value.isNotEmpty && selectedCompany.value != 'All') {
        queryParams['company'] = selectedCompany.value;
      }

      final response = await _apiService.requestGetForApi(
        url: _config.getAllBills,
        dictParameter: queryParams,
        authToken: true,
      );

      if (response == null || response.statusCode != 200) {
        error.value = 'Failed to load bills';
        _showErrorSnackbar('Failed to load bills');
      } else {
        final parsed = BillsResponse.fromJson(response.data);

        if (refresh) {
          allBills.clear();
        }

        allBills.addAll(parsed.content);
        totalElements.value = parsed.totalElements;
        totalAmount.value = parsed.totalAmount;
        totalQty.value = parsed.totalQty;
        hasMore.value = !parsed.last;
        log(totalAmount.value.toString());
        // Apply local filters after loading data
        _applyLocalFilters();

        // Update company filter options
        _updateCompanyOptions();
      }
    } catch (e) {
      error.value = 'Error: $e';
      _showErrorSnackbar('Error loading bills: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreBills() async {
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;
    currentPage.value++;

    try {
      final queryParams = <String, String>{
        'page': currentPage.value.toString(),
        'size': '10',
        'sortBy': sortBy.value,
        'sortDir': sortDir.value,
      };

      if (searchQuery.value.isNotEmpty) {
        queryParams['search'] = searchQuery.value;
      }

      if (selectedCompany.value.isNotEmpty && selectedCompany.value != 'All') {
        queryParams['company'] = selectedCompany.value;
      }

      final response = await _apiService.requestGetForApi(
        url: _config.getAllBills,
        dictParameter: queryParams,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final parsed = BillsResponse.fromJson(response.data);
        allBills.addAll(parsed.content);
        totalElements.value = parsed.totalElements;
        totalAmount.value = totalAmount.value + parsed.totalAmount;
        totalQty.value =totalQty.value+ parsed.totalQty;
        hasMore.value = !parsed.last;

        // Apply local filters after loading more data
        _applyLocalFilters();
      } else {
        currentPage.value--;
        _showErrorSnackbar('Failed to load more bills');
      }
    } catch (e) {
      currentPage.value--;
      _showErrorSnackbar('Error loading more bills: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  void onSearchChanged() {
    searchQuery.value = searchController.text;
    loadBills(refresh: true);
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    loadBills(refresh: true);
  }

  void onCompanyFilterChanged(String? company) {
    selectedCompany.value = company ?? 'All';
    loadBills(refresh: true);
  }

  void onStatusFilterChanged(String? status) {
    selectedStatus.value = status ?? 'All';
    _applyLocalFilters();
  }

  // New method to apply local filters
  void _applyLocalFilters() {
    List<Bill> filteredList = List.from(allBills);

    // Apply status filter locally
    if (selectedStatus.value != 'All') {
      if (selectedStatus.value == 'Paid') {
        filteredList =
            filteredList.where((bill) => bill.isPaid == true).toList();
      } else if (selectedStatus.value == 'Pending') {
        filteredList =
            filteredList.where((bill) => bill.isPaid == false).toList();
      }
    }

    bills.value = filteredList;
  }

  void onSortChanged(String field) {
    if (sortBy.value == field) {
      sortDir.value = sortDir.value == 'asc' ? 'desc' : 'asc';
    } else {
      sortBy.value = field;
      sortDir.value = 'asc';
    }
    loadBills(refresh: true);
  }

  Future<void> refreshBills() async {
    await loadBills(refresh: true);
  }

  void navigateToBillDetails(Bill bill) {
    Get.toNamed('/bill-details', arguments: bill);
  }

  void _updateCompanyOptions() {
    final companies = allBills.map((bill) => bill.companyName).toSet().toList();
    companies.sort();
    companyOptions.value = ['All', ...companies];
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  Color getStatusColor(Bill bill) {
    return bill.paid ? Color(0xFF10B981) : Color(0xFFF59E0B);
  }

  Color getCompanyColor(String company) {
    switch (company.toLowerCase()) {
      case 'apple':
        return Color(0xFF1E293B);
      case 'samsung':
        return Color(0xFF3B82F6);
      case 'xiaomi':
        return Color(0xFFF59E0B);
      case 'mix':
      case 'mixu':
        return Color(0xFF8B5CF6);
      default:
        return Color(0xFF6B7280);
    }
  }

  IconData getStatusIcon(Bill bill) {
    return bill.paid ? Icons.check_circle : Icons.pending;
  }

  IconData getCompanyIcon(String company) {
    switch (company.toLowerCase()) {
      case 'apple':
        return Icons.phone_iphone;
      case 'samsung':
        return Icons.smartphone;
      case 'xiaomi':
        return Icons.phone_android;
      default:
        return Icons.devices;
    }
  }
}
