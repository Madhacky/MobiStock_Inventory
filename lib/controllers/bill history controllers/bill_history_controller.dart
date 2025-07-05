import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:smartbecho/models/bill%20history/bill_history_model.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/utils/app_colors.dart';

class BillHistoryController extends GetxController {
  final ApiServices _apiService = ApiServices();

  // App config instance
  final AppConfig _config = AppConfig.instance;
  final RxList<Bill> bills = <Bill>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxInt currentPage = 0.obs;
  final RxBool hasMore = true.obs;
  final RxInt totalElements = 0.obs;

  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadBills();

    // debounce(
    //   searchQuery,
    //   (_) => onSearchChanged(),
    //   time: Duration(milliseconds: 500),
    // );
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

    final query = {
      'page': currentPage.value.toString(),
      'size': '10',
      'sort': 'billId',
    };

    // if (searchQuery.value.isNotEmpty) {
    //   query['search'] = searchQuery.value;
    // }

    final response = await _apiService.requestGetForApi(
      url: _config.getAllBills,
      dictParameter: query,
      authToken: true,
    );

    if (response == null || response.statusCode != 200) {
      error.value = 'Failed to load bills';
      Get.snackbar(
        'Error',
        'Failed to load bills',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.primaryRed,
        colorText: AppTheme.backgroundLight,
      );
    } else {
      try {
        final parsed = BillsResponse.fromJson(response.data);

        if (refresh) {
          bills.clear();
        }

        bills.addAll(parsed.content);
        totalElements.value = parsed.totalElements;
        hasMore.value = !parsed.last;
      } catch (e) {
        error.value = 'Parsing error: $e';
      }
    }

    isLoading.value = false;
  }

  Future<void> loadMoreBills() async {
    if (isLoadingMore.value || !hasMore.value) return;

    isLoadingMore.value = true;
    currentPage.value++;

    final query = {
      'page': currentPage.value.toString(),
      'size': '10',
      'sort': 'billId',
    };

    if (searchQuery.value.isNotEmpty) {
      query['search'] = searchQuery.value;
    }

    final response = await _apiService.requestGetForApi(
      url: _config.getAllBills,
      dictParameter: query,
      authToken: true,
    );

    if (response != null && response.statusCode == 200) {
      final parsed = BillsResponse.fromJson(response.data);
      bills.addAll(parsed.content);
      hasMore.value = !parsed.last;
    } else {
      currentPage.value--;
      Get.snackbar(
        'Error',
        'Failed to load more bills',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.primaryRed,
        colorText: AppTheme.backgroundLight,
      );
    }

    isLoadingMore.value = false;
  }

  void onSearchChanged() {
    // searchQuery.value = searchController.text;
    // loadBills(refresh: true);
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    loadBills(refresh: true);
  }

  Future<void> refreshBills() async {
    await loadBills(refresh: true);
  }

  void navigateToBillDetails(Bill bill) {
    Get.toNamed('/bill-details', arguments: bill);
  }

  Color getStatusColor(Bill bill) {
    return bill.paid ? AppTheme.primaryGreen : AppTheme.primaryOrange;
  }

  Color getCompanyColor(String company) {
    switch (company.toLowerCase()) {
      case 'apple':
        return AppTheme.grey800;
      case 'samsung':
        return AppTheme.primaryBlue;
      case 'xiaomi':
        return AppTheme.primaryOrange;
      default:
        return AppTheme.primaryPurple;
    }
  }

  IconData getStatusIcon(Bill bill) {
    return bill.paid ? Icons.check_circle : Icons.pending;
  }
}
