import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/account%20management%20models/pay_bill_model.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';

class PayBillsController extends GetxController {
  final ApiServices _apiService = ApiServices();
  final AppConfig _config = AppConfig.instance;

  // Observable variables
  var isLoading = false.obs;
  var payBills = <PayBill>[].obs;
  var filteredPayBills = <PayBill>[].obs;
  var currentPage = 0.obs;
  var totalPages = 0.obs;
  var totalElements = 0.obs;
  var hasMoreData = true.obs;

  // Filter variables
  var searchQuery = ''.obs;
  var selectedCompany = 'All'.obs;
  var selectedPurpose = 'All'.obs;
  var selectedPaymentMode = 'All'.obs;
  var selectedMonth = DateTime.now().month.obs;
  var selectedYear = DateTime.now().year.obs;

  // Available filter options
  var companies = <String>['All'].obs;
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
    loadPayBills(refresh: true);
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadPayBills({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 0;
        payBills.clear();
        filteredPayBills.clear();
        hasMoreData.value = true;
      }

      if (!hasMoreData.value) return;

      isLoading.value = true;

      // Build query parameters including filters
      final query = <String, String>{
        'page': currentPage.value.toString(),
        'size': pageSize.toString(),
        'year': selectedYear.value.toString(),
        'month': selectedMonth.value.toString(),
      };

      // Add optional filters
      if (searchQuery.value.isNotEmpty) {
        query['search'] = searchQuery.value;
      }
      if (selectedCompany.value != 'All') {
        query['company'] = selectedCompany.value;
      }
      if (selectedPurpose.value != 'All') {
        query['purpose'] = selectedPurpose.value;
      }
      if (selectedPaymentMode.value != 'All') {
        query['paymentMode'] = selectedPaymentMode.value;
      }

      final response = await _apiService.requestGetForApi(
        url: '${_config.baseUrl}/api/pay-bills', // Updated URL
        dictParameter: query,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final payBillsResponse = PayBillsResponse.fromJson(response.data);

        if (refresh) {
          payBills.value = payBillsResponse.content;
          filteredPayBills.value = payBillsResponse.content;
        } else {
          payBills.addAll(payBillsResponse.content);
          filteredPayBills.addAll(payBillsResponse.content);
        }

        totalPages.value = payBillsResponse.totalPages;
        totalElements.value = payBillsResponse.totalElements;
        hasMoreData.value = !payBillsResponse.last;

        // Update filter options only on refresh or first load
        if (refresh || currentPage.value == 0) {
          _updateFilterOptions();
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to load pay bills',
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

  void _updateFilterOptions() {
    // Update companies
    final companySet = payBills.map((bill) => bill.company).toSet();
    companies.value = ['All', ...companySet.toList()..sort()];

    // Update purposes
    final purposeSet = payBills.map((bill) => bill.purpose).toSet();
    purposes.value = ['All', ...purposeSet.toList()..sort()];

    // Update payment modes
    final paymentModeSet = payBills.map((bill) => bill.paymentMode).toSet();
    paymentModes.value = ['All', ...paymentModeSet.toList()..sort()];
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void onCompanyChanged(String company) {
    selectedCompany.value = company;
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
    _applyFilters();
  }

  void onYearChanged(int year) {
    selectedYear.value = year;
    _applyFilters();
  }

  void _applyFilters() {
    // Since we're now filtering from API, we need to refresh data
    loadPayBills(refresh: true);
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedCompany.value = 'All';
    selectedPurpose.value = 'All';
    selectedPaymentMode.value = 'All';
    selectedMonth.value = DateTime.now().month;
    selectedYear.value = DateTime.now().year;
    searchController.clear();
    loadPayBills(refresh: true);
  }

  void loadNextPage() {
    if (hasMoreData.value && !isLoading.value) {
      currentPage.value++;
      loadPayBills();
    }
  }

  void refreshData() {
    loadPayBills(refresh: true);
  }

  String getFilterSummary() {
    List<String> activeFilters = [];

    if (searchQuery.value.isNotEmpty) {
      activeFilters.add('Search: "${searchQuery.value}"');
    }
    if (selectedCompany.value != 'All') {
      activeFilters.add('Company: ${selectedCompany.value}');
    }
    if (selectedPurpose.value != 'All') {
      activeFilters.add('Purpose: ${selectedPurpose.value}');
    }
    if (selectedPaymentMode.value != 'All') {
      activeFilters.add('Payment: ${selectedPaymentMode.value}');
    }

    // Always show current month/year
    final monthName = months[selectedMonth.value - 1];
    activeFilters.add('$monthName ${selectedYear.value}');

    return '${activeFilters.join(' • ')} • ${filteredPayBills.length} results';
  }

  bool get hasActiveFilters {
    return searchQuery.value.isNotEmpty ||
        selectedCompany.value != 'All' ||
        selectedPurpose.value != 'All' ||
        selectedPaymentMode.value != 'All' ||
        selectedMonth.value != DateTime.now().month ||
        selectedYear.value != DateTime.now().year;
  }

  String get monthDisplayText {
    return months[selectedMonth.value - 1];
  }

  Color getCompanyColor(String company) {
    final colors = {
      'apple': const Color(0xFF007AFF),
      'samsung': const Color(0xFF1428A0),
      'google': const Color(0xFF4285F4),
      'xiaomi': const Color(0xFFFF6900),
      'oneplus': const Color(0xFFEB0028),
      'realme': const Color(0xFFFFC900),
      'oppo': const Color(0xFF1BA784),
      'vivo': const Color(0xFF4A90E2),
      'nokia': const Color(0xFF124191),
      'honor': const Color(0xFF2C5BFF),
      'gst': const Color(0xFF8B5CF6),
      'vendor a': const Color(0xFF10B981),
      'vendor b': const Color(0xFFF59E0B),
      'vendor c': const Color(0xFFEF4444),
    };

    return colors[company.toLowerCase()] ?? const Color(0xFF6366F1);
  }

  Color getPurposeColor(String purpose) {
    final colors = {
      'salary': const Color(0xFF10B981),
      'utility bill': const Color(0xFF3B82F6),
      'rent': const Color(0xFF8B5CF6),
      'office stationery': const Color(0xFFF59E0B),
      'maintenance': const Color(0xFFEF4444),
      'internet': const Color(0xFF06B6D4),
      'electricity': const Color(0xFFF97316),
      'other': const Color(0xFF6B7280),
    };

    return colors[purpose.toLowerCase()] ?? const Color(0xFF6B7280);
  }
}