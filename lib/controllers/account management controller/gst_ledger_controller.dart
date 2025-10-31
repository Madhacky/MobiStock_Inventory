// controllers/account management controller/gst_ledger_controller.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/account%20management%20models/gst_ledger_model.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/utils/app_colors.dart';

class GstLedgerController extends GetxController {
  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  final ApiServices _apiService = ApiServices();
  final AppConfig _config = AppConfig.instance;

  // Form controllers
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  // Observable variables
  var isLoading = false.obs;
  var ledgerEntries = <GstLedgerEntry>[].obs;
  var filteredLedgerEntries = <GstLedgerEntry>[].obs;
  var currentPage = 0.obs;
  var totalPages = 0.obs;
  var totalElements = 0.obs;
  var hasMoreData = true.obs;

  // Filter variables
  var searchQuery = ''.obs;
  var selectedEntityName = 'All'.obs;
  var selectedTransactionType = 'All'.obs;
  var selectedHsnCode = 'All'.obs;
  var selectedMonth = DateTime.now().month.obs;
  var selectedYear = DateTime.now().year.obs;
  var isCustomDateRange = false.obs;

  // Available filter options
  var entityNames = <String>['All'].obs;
  var transactionTypes = <String>['All'].obs;
  var hsnCodes = <String>['All'].obs;

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
    loadDropdownData();
    loadLedgerEntries(refresh: true);
  }

  Future<void> loadDropdownData() async {
    try {
      final response = await _apiService.requestGetForApi(
        url: '${_config.baseUrl}/api/v1/gst-ledger/dropdowns',
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final dropdowns = GstLedgerDropdowns.fromJson(response.data);

        entityNames.value = ['All', ...dropdowns.entityNames];
        transactionTypes.value = ['All', ...dropdowns.transactionTypes];
        hsnCodes.value = ['All', ...dropdowns.hsnCodes];
      }
    } catch (e) {
      print('Error loading dropdown data: $e');
    }
  }

  Future<void> loadLedgerEntries({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 0;
        ledgerEntries.clear();
        hasMoreData.value = true;
      }

      if (!hasMoreData.value) return;

      isLoading.value = true;

      final query = <String, String>{
        'page': currentPage.value.toString(),
        'size': pageSize.toString(),
        'sortBy': 'id',
        'sortDir': 'desc',
      };

      // Add date filters
      if (isCustomDateRange.value &&
          startDateController.text.isNotEmpty &&
          endDateController.text.isNotEmpty) {
        query['startDate'] = startDateController.text;
        query['endDate'] = endDateController.text;
      } else {
        query['year'] = selectedYear.value.toString();
        query['month'] = selectedMonth.value.toString();
      }

      // Add other filters
      if (selectedEntityName.value != 'All') {
        query['entityName'] = selectedEntityName.value;
      }
      if (selectedTransactionType.value != 'All') {
        query['transactionType'] = selectedTransactionType.value;
      }
      if (selectedHsnCode.value != 'All') {
        query['hsnCode'] = selectedHsnCode.value;
      }

      final response = await _apiService.requestGetForApi(
        url: '${_config.baseUrl}/api/v1/gst-ledger',
        dictParameter: query,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final ledgerResponse = GstLedgerResponse.fromJson(response.data);

        if (refresh) {
          ledgerEntries.value = ledgerResponse.content;
        } else {
          ledgerEntries.addAll(ledgerResponse.content);
        }

        totalPages.value = ledgerResponse.totalPages;
        totalElements.value = ledgerResponse.totalElements;
        hasMoreData.value = !ledgerResponse.last;

        _applyFilters();
      } else {
        Get.snackbar(
          'Error',
          'Failed to load GST ledger entries',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorLight,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while loading data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorLight,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _applyFilters() {
    var filtered =
        ledgerEntries.where((entry) {
          // Search filter
          if (searchQuery.value.isNotEmpty) {
            final query = searchQuery.value.toLowerCase();
            if (!entry.relatedEntityName.toLowerCase().contains(query) &&
                !entry.transactionType.toLowerCase().contains(query) &&
                !entry.hsnCode.toLowerCase().contains(query) &&
                !entry.gstRateLabel.toLowerCase().contains(query)) {
              return false;
            }
          }

          return true;
        }).toList();

    filteredLedgerEntries.value = filtered;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void onEntityNameChanged(String entityName) {
    selectedEntityName.value = entityName;
    loadLedgerEntries(refresh: true);
  }

  void onTransactionTypeChanged(String transactionType) {
    selectedTransactionType.value = transactionType;
    loadLedgerEntries(refresh: true);
  }

  void onHsnCodeChanged(String hsnCode) {
    selectedHsnCode.value = hsnCode;
    loadLedgerEntries(refresh: true);
  }

  void onMonthChanged(int month) {
    selectedMonth.value = month;
    isCustomDateRange.value = false;
    startDateController.clear();
    endDateController.clear();
    loadLedgerEntries(refresh: true);
  }

  void onYearChanged(int year) {
    selectedYear.value = year;
    isCustomDateRange.value = false;
    startDateController.clear();
    endDateController.clear();
    loadLedgerEntries(refresh: true);
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF3B82F6),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      startDateController.text = picked.toIso8601String().split('T')[0];
      isCustomDateRange.value = true;
      if (endDateController.text.isNotEmpty) {
        loadLedgerEntries(refresh: true);
      }
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF3B82F6),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      endDateController.text = picked.toIso8601String().split('T')[0];
      isCustomDateRange.value = true;
      if (startDateController.text.isNotEmpty) {
        loadLedgerEntries(refresh: true);
      }
    }
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedEntityName.value = 'All';
    selectedTransactionType.value = 'All';
    selectedHsnCode.value = 'All';
    isCustomDateRange.value = false;
    startDateController.clear();
    endDateController.clear();
    _applyFilters();
    loadLedgerEntries(refresh: true);
  }

  void loadNextPage() {
    if (hasMoreData.value && !isLoading.value) {
      currentPage.value++;
      loadLedgerEntries();
    }
  }

  void refreshData() {
    loadLedgerEntries(refresh: true);
  }

  String getFilterSummary() {
    List<String> activeFilters = [];

    if (searchQuery.value.isNotEmpty) {
      activeFilters.add('Search: "${searchQuery.value}"');
    }
    if (selectedEntityName.value != 'All') {
      activeFilters.add('Entity: ${selectedEntityName.value}');
    }
    if (selectedTransactionType.value != 'All') {
      activeFilters.add('Type: ${selectedTransactionType.value}');
    }
    if (selectedHsnCode.value != 'All') {
      activeFilters.add('HSN: ${selectedHsnCode.value}');
    }
    if (isCustomDateRange.value) {
      activeFilters.add('Custom Date Range');
    }

    if (activeFilters.isEmpty) {
      return '${filteredLedgerEntries.length} entries found';
    }

    return '${activeFilters.join(' • ')} • ${filteredLedgerEntries.length} results';
  }

  bool get hasActiveFilters {
    return searchQuery.value.isNotEmpty ||
        selectedEntityName.value != 'All' ||
        selectedTransactionType.value != 'All' ||
        selectedHsnCode.value != 'All' ||
        isCustomDateRange.value;
  }

  Color getTransactionTypeColor(String transactionType) {
    switch (transactionType.toUpperCase()) {
      case 'CREDIT':
        return const Color(0xFF10B981);
      case 'DEBIT':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Color getEntityColor(String entityName) {
    switch (entityName.toUpperCase()) {
      case 'SALE':
        return const Color(0xFF10B981);
      case 'PURCHASE':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF6B7280);
    }
  }

  String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  double get totalTaxableAmount {
    return filteredLedgerEntries.fold(
      0.0,
      (sum, entry) => sum + entry.taxableAmount,
    );
  }

  double get totalGstAmount {
    return filteredLedgerEntries.fold(
      0.0,
      (sum, entry) =>
          sum + entry.cgstAmount + entry.sgstAmount + entry.igstAmount,
    );
  }

  Map<String, double> get entriesByTransactionType {
    final Map<String, double> result = {};
    for (var entry in filteredLedgerEntries) {
      result[entry.transactionType] =
          (result[entry.transactionType] ?? 0) + entry.taxableAmount;
    }
    return result;
  }

  Map<String, double> get entriesByEntity {
    final Map<String, double> result = {};
    for (var entry in filteredLedgerEntries) {
      result[entry.relatedEntityName] =
          (result[entry.relatedEntityName] ?? 0) + entry.taxableAmount;
    }
    return result;
  }

  Map<String, int> get entryCountByGstRate {
    final Map<String, int> result = {};
    for (var entry in filteredLedgerEntries) {
      result[entry.gstRateLabel] = (result[entry.gstRateLabel] ?? 0) + 1;
    }
    return result;
  }

  void exportData() {
    Get.snackbar(
      'Export',
      'Export functionality will be implemented soon',
      backgroundColor: const Color(0xFF6B7280),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void printReport() {
    Get.snackbar(
      'Print',
      'Print functionality will be implemented soon',
      backgroundColor: const Color(0xFF6B7280),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
