import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/account%20management%20models/withdraw_history_model.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/utils/app_colors.dart';

class WithdrawController extends GetxController {
  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  final ApiServices _apiService = ApiServices();
  final AppConfig _config = AppConfig.instance;

  // Observable variables
  var isLoading = false.obs;
  var withdrawals = <Withdraw>[].obs;
  var filteredWithdrawals = <Withdraw>[].obs;
  var currentPage = 0.obs;
  var totalPages = 0.obs;
  var totalElements = 0.obs;
  var hasMoreData = true.obs;

  // Filter variables
  var searchQuery = ''.obs;
  var selectedWithdrawnBy = 'All'.obs;
  var selectedPurpose = 'All'.obs;
  var selectedPaymentMode = 'All'.obs;
  var selectedMonth = DateTime.now().month.obs;
  var selectedYear = DateTime.now().year.obs;

  // Available filter options
  var withdrawnByOptions = <String>['All'].obs;
  var purposes = <String>['All'].obs;
  var paymentModes = <String>['All'].obs;

  final TextEditingController searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  final int pageSize = 10;

  final List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  @override
  void onInit() {
    super.onInit();
    loadWithdrawals(refresh: true);
  }

  Future<void> loadWithdrawals({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 0;
        withdrawals.clear();
        hasMoreData.value = true;
      }

      if (!hasMoreData.value) return;

      isLoading.value = true;

      final query = {
        'page': currentPage.value.toString(),
        'size': pageSize.toString(),
        'year': selectedYear.value.toString(),
        'month': selectedMonth.value.toString(),
      };

      final response = await _apiService.requestGetForApi(
        url: '${_config.baseUrl}/api/withdrawals',
        dictParameter: query,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final withdrawalsResponse = WithdrawalsResponse.fromJson(response.data);

        if (refresh) {
          withdrawals.value = withdrawalsResponse.content;
        } else {
          withdrawals.addAll(withdrawalsResponse.content);
        }

        totalPages.value = withdrawalsResponse.totalPages;
        totalElements.value = withdrawalsResponse.totalElements;
        hasMoreData.value = !withdrawalsResponse.last;

        // Update filter options
        _updateFilterOptions();

        // Apply current filters
        _applyFilters();
      } else {
        Get.snackbar(
          'Error',
          'Failed to load withdrawals',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppTheme.primaryRed,
          colorText: AppTheme.backgroundLight,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while loading data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppTheme.primaryRed,
        colorText: AppTheme.backgroundLight,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _updateFilterOptions() {
    // Update withdrawn by options
    final withdrawnBySet =
        withdrawals.map((withdrawal) => withdrawal.withdrawnBy).toSet();
    withdrawnByOptions.value = ['All', ...withdrawnBySet.toList()..sort()];

    // Update purposes
    final purposeSet =
        withdrawals.map((withdrawal) => withdrawal.purpose).toSet();
    purposes.value = ['All', ...purposeSet.toList()..sort()];

    // Update payment modes
    final paymentModeSet =
        withdrawals.map((withdrawal) => withdrawal.paymentMode).toSet();
    paymentModes.value = ['All', ...paymentModeSet.toList()..sort()];
  }

  void _applyFilters() {
    var filtered =
        withdrawals.where((withdrawal) {
          // Search filter
          if (searchQuery.value.isNotEmpty) {
            final query = searchQuery.value.toLowerCase();
            if (!withdrawal.withdrawnBy.toLowerCase().contains(query) &&
                !withdrawal.purpose.toLowerCase().contains(query) &&
                !withdrawal.notes.toLowerCase().contains(query) &&
                !withdrawal.paymentMode.toLowerCase().contains(query)) {
              return false;
            }
          }

          // Withdrawn by filter
          if (selectedWithdrawnBy.value != 'All' &&
              withdrawal.withdrawnBy != selectedWithdrawnBy.value) {
            return false;
          }

          // Purpose filter
          if (selectedPurpose.value != 'All' &&
              withdrawal.purpose != selectedPurpose.value) {
            return false;
          }

          // Payment mode filter
          if (selectedPaymentMode.value != 'All' &&
              withdrawal.paymentMode != selectedPaymentMode.value) {
            return false;
          }

          return true;
        }).toList();

    filteredWithdrawals.value = filtered;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void onWithdrawnByChanged(String withdrawnBy) {
    selectedWithdrawnBy.value = withdrawnBy;
    _applyFilters();
  }

  void onPurposeChanged(String purpose) {
    selectedPurpose.value = purpose;
    _applyFilters();
  }

  void onPaymentModeChanged(String paymentMode) {
    selectedPaymentMode.value = paymentMode;
    _applyFilters();
  }

  void onMonthChanged(int month) {
    selectedMonth.value = month;
    loadWithdrawals(refresh: true);
  }

  void onYearChanged(int year) {
    selectedYear.value = year;
    loadWithdrawals(refresh: true);
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedWithdrawnBy.value = 'All';
    selectedPurpose.value = 'All';
    selectedPaymentMode.value = 'All';
    _applyFilters();
  }

  void loadNextPage() {
    if (hasMoreData.value && !isLoading.value) {
      currentPage.value++;
      loadWithdrawals();
    }
  }

  void refreshData() {
    loadWithdrawals(refresh: true);
  }

  String getFilterSummary() {
    List<String> activeFilters = [];

    if (searchQuery.value.isNotEmpty) {
      activeFilters.add('Search: "${searchQuery.value}"');
    }
    if (selectedWithdrawnBy.value != 'All') {
      activeFilters.add('Withdrawn By: ${selectedWithdrawnBy.value}');
    }
    if (selectedPurpose.value != 'All') {
      activeFilters.add('Purpose: ${selectedPurpose.value}');
    }
    if (selectedPaymentMode.value != 'All') {
      activeFilters.add('Payment: ${selectedPaymentMode.value}');
    }

    if (activeFilters.isEmpty) {
      return '${filteredWithdrawals.length} withdrawals found';
    }

    return '${activeFilters.join(' • ')} • ${filteredWithdrawals.length} results';
  }

  bool get hasActiveFilters {
    return searchQuery.value.isNotEmpty ||
        selectedWithdrawnBy.value != 'All' ||
        selectedPurpose.value != 'All' ||
        selectedPaymentMode.value != 'All';
  }

  Color getWithdrawnByColor(String withdrawnBy) {
    final colors = {
      'jane smith': const Color(0xFF3B82F6),
      'john doe': const Color(0xFF10B981),
      'emily davis': const Color(0xFF8B5CF6),
      'mike johnson': const Color(0xFFF59E0B),
      'sarah wilson': const Color(0xFFEF4444),
      'david brown': const Color(0xFF06B6D4),
      'lisa anderson': const Color(0xFFF97316),
    };

    return colors[withdrawnBy.toLowerCase()] ?? const Color(0xFF6366F1);
  }

  Color getPurposeColor(String purpose) {
    final colors = {
      'salary': const Color(0xFF10B981),
      'petty cash': const Color(0xFF3B82F6),
      'vendor payment': const Color(0xFF8B5CF6),
      'personal use': const Color(0xFFF59E0B),
      'office expenses': const Color(0xFFEF4444),
      'maintenance': const Color(0xFF06B6D4),
      'utilities': const Color(0xFFF97316),
      'other': const Color(0xFF6B7280),
    };

    return colors[purpose.toLowerCase()] ?? const Color(0xFF6B7280);
  }

  Color getPaymentModeColor(String paymentMode) {
    final colors = {
      'cash': const Color(0xFF10B981),
      'account': const Color(0xFF3B82F6),
      'card': const Color(0xFF8B5CF6),
      'upi': const Color(0xFFF59E0B),
      'cheque': const Color(0xFFEF4444),
    };

    return colors[paymentMode.toLowerCase()] ?? const Color(0xFF6B7280);
  }
}
