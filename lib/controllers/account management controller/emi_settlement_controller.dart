import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/account%20management%20models/emi%20settlement/emi_settlement_chart_model.dart';
import 'package:smartbecho/models/account%20management%20models/emi%20settlement/emi_settlement_model.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/utils/app_colors.dart';

class EmiSettlementController extends GetxController {
  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    // Form controllers
    dateController.dispose();
    companyNameController.dispose();
    amountController.dispose();
    confirmedByController.dispose();
    super.dispose();
  }

  final ApiServices _apiService = ApiServices();
  final AppConfig _config = AppConfig.instance;

  // Form controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController confirmedByController = TextEditingController();

  // Form state
  var isFormLoading = false.obs;

  // Observable variables
  var isLoading = false.obs;
  var settlements = <EmiSettlement>[].obs;
  var filteredSettlements = <EmiSettlement>[].obs;
  var currentPage = 0.obs;
  var totalPages = 0.obs;
  var totalElements = 0.obs;
  var hasMoreData = true.obs;
  var isFilterExpanded = false.obs;

  // Chart data
  var isChartLoading = false.obs;
  final RxList<MonthlyEmiData> chartData = <MonthlyEmiData>[].obs;
  var chartYear = DateTime.now().year.obs;

  // Filter variables
  var searchQuery = ''.obs;
  var selectedCompany = 'All'.obs;
  var selectedConfirmedBy = 'All'.obs;
  var selectedMonth = DateTime.now().month.obs;
  var selectedYear = DateTime.now().year.obs;

  // Available filter options
  var companyOptions = <String>['All'].obs;
  var confirmedByOptions = <String>['All'].obs;

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
    loadSettlements(refresh: true);
    dateController.text = DateTime.now().toIso8601String().split('T')[0];

    // Setup scroll controller for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadNextPage();
      }
    });
  }

  // Form validation methods
  String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Amount is required';
    }
    final amount = double.tryParse(value);
    if (amount == null || amount <= 0) {
      return 'Enter a valid amount';
    }
    return null;
  }

  // Date picker
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
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
      dateController.text = picked.toIso8601String().split('T')[0];
    }
  }

  // Save EMI settlement
  Future<void> saveEmiSettlement() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isFormLoading.value = true;

      // Create request body
      final requestBody = {
        'companyName': companyNameController.text,
        'amount': double.parse(amountController.text),
        'confirmedBy': confirmedByController.text,
        'date':
            DateTime.parse(
              dateController.text,
            ).toUtc().toIso8601String().split('T')[0],
      };

      final response = await _apiService.requestPostForApi(
        url: '${_config.baseUrl}/api/emi-settlements',
        dictParameter: requestBody,
        authToken: true,
      );

      if (response != null && response.statusCode == 201) {
        clearForm();
        Get.snackbar(
          'Success',
          'EMI settlement recorded successfully!',
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
        );
        loadSettlements(refresh: true);
      } else {
        String errorMessage = 'Failed to record EMI settlement';
        if (response?.data != null && response!.data['message'] != null) {
          errorMessage = response.data['message'];
        }

        Get.snackbar(
          'Error',
          errorMessage,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error saving EMI settlement: $e');
      Get.snackbar(
        'Error',
        'Failed to record EMI settlement: ${e.toString()}',
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isFormLoading.value = false;
    }
  }

  // Clear form
  void clearForm() {
    dateController.text = DateTime.now().toIso8601String().split('T')[0];
    companyNameController.clear();
    amountController.clear();
    confirmedByController.clear();
  }

  // Reset form
  void resetForm() {
    clearForm();
    Get.snackbar(
      'Reset',
      'Form has been reset',
      backgroundColor: const Color(0xFF6B7280),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> loadSettlements({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 0;
        settlements.clear();
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
        url: '${_config.baseUrl}/api/emi-settlements',
        dictParameter: query,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final settlementsResponse = EmiSettlementsResponse.fromJson(
          response.data,
        );

        if (refresh) {
          settlements.value = settlementsResponse.content;
        } else {
          settlements.addAll(settlementsResponse.content);
        }

        totalPages.value = settlementsResponse.totalPages;
        totalElements.value = settlementsResponse.totalElements;
        hasMoreData.value = !settlementsResponse.last;

        // Update filter options
        _updateFilterOptions();

        // Apply current filters
        _applyFilters();
      } else {
        Get.snackbar(
          'Error',
          'Failed to load EMI settlements',
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

  //load chart
  Future<void> loadChartData({int? year}) async {
    try {
      isChartLoading.value = true;
      final targetYear = year ?? chartYear.value;
      final query = {'year': targetYear.toString()};

      final response = await _apiService.requestGetForApi(
        url: '${_config.baseUrl}/api/emi-settlements/monthly-summary/chart',
        dictParameter: query,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final chartResponse = EmiSettlementChartResponse.fromJson(
          response.data,
        );

        // Clear existing data and add new data
        chartData.clear();
        chartData.addAll(chartResponse.payload);

        chartYear.value = targetYear;
      } else {
        Get.snackbar(
          'Error',
          'Failed to load chart data',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorLight,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error loading chart data: $e');
      Get.snackbar(
        'Error',
        'An error occurred while loading chart data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorLight,
        colorText: Colors.white,
      );
    } finally {
      isChartLoading.value = false;
    }
  }

  void onChartYearChanged(int year) {
    if (year != chartYear.value) {
      loadChartData(year: year);
    }
  }

  // Helper method to check if chart has data
  bool get hasChartData =>
      chartData.isNotEmpty && chartData.any((item) => item.amount > 0);

  void _updateFilterOptions() {
    // Update company options
    final companySet =
        settlements.map((settlement) => settlement.companyName).toSet();
    companyOptions.value = ['All', ...companySet.toList()..sort()];

    // Update confirmed by options
    final confirmedBySet =
        settlements.map((settlement) => settlement.confirmedBy).toSet();
    confirmedByOptions.value = ['All', ...confirmedBySet.toList()..sort()];
  }

  void _applyFilters() {
    var filtered =
        settlements.where((settlement) {
          // Search filter
          if (searchQuery.value.isNotEmpty) {
            final query = searchQuery.value.toLowerCase();
            if (!settlement.companyName.toLowerCase().contains(query) &&
                !settlement.confirmedBy.toLowerCase().contains(query) &&
                !settlement.shopId.toLowerCase().contains(query)) {
              return false;
            }
          }

          // Company filter
          if (selectedCompany.value != 'All' &&
              settlement.companyName != selectedCompany.value) {
            return false;
          }

          // Confirmed by filter
          if (selectedConfirmedBy.value != 'All' &&
              settlement.confirmedBy != selectedConfirmedBy.value) {
            return false;
          }

          return true;
        }).toList();

    filteredSettlements.value = filtered;
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void onCompanyChanged(String? company) {
    if (company != null) {
      selectedCompany.value = company;
      _applyFilters();
    }
  }

  void onConfirmedByChanged(String? confirmedBy) {
    if (confirmedBy != null) {
      selectedConfirmedBy.value = confirmedBy;
      _applyFilters();
    }
  }

  void onMonthChanged(int? month) {
    if (month != null) {
      selectedMonth.value = month;
      loadSettlements(refresh: true);
    }
  }

  void onYearChanged(int? year) {
    if (year != null) {
      selectedYear.value = year;
      loadSettlements(refresh: true);
    }
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedCompany.value = 'All';
    selectedConfirmedBy.value = 'All';
    _applyFilters();
  }

  void loadNextPage() {
    if (hasMoreData.value && !isLoading.value) {
      currentPage.value++;
      loadSettlements();
    }
  }

  void refreshData() {
    loadSettlements(refresh: true);
  }

  String getFilterSummary() {
    List<String> activeFilters = [];

    if (searchQuery.value.isNotEmpty) {
      activeFilters.add('Search: "${searchQuery.value}"');
    }
    if (selectedCompany.value != 'All') {
      activeFilters.add('Company: ${selectedCompany.value}');
    }
    if (selectedConfirmedBy.value != 'All') {
      activeFilters.add('Confirmed By: ${selectedConfirmedBy.value}');
    }

    if (activeFilters.isEmpty) {
      return '${filteredSettlements.length} settlements found';
    }

    return '${activeFilters.join(' • ')} • ${filteredSettlements.length} results';
  }

  bool get hasActiveFilters {
    return searchQuery.value.isNotEmpty ||
        selectedCompany.value != 'All' ||
        selectedConfirmedBy.value != 'All';
  }

  Color getCompanyColor(String company) {
    final colors = {
      'nokia': const Color(0xFF3B82F6),
      'lava': const Color(0xFF10B981),
      'samsung': const Color(0xFF8B5CF6),
      'hdfc': const Color(0xFFF59E0B),
      'icici': const Color(0xFFEF4444),
      'sbi': const Color(0xFF06B6D4),
      'axis': const Color(0xFFF97316),
    };

    return colors[company.toLowerCase()] ?? const Color(0xFF6366F1);
  }

  Color getConfirmedByColor(String confirmedBy) {
    final colors = {
      'nishant': const Color(0xFF10B981),
      'raja bhiya': const Color(0xFF3B82F6),
      'jane smith': const Color(0xFF8B5CF6),
      'john doe': const Color(0xFFF59E0B),
      'praveen': const Color(0xFFEF4444),
      'ranmu': const Color(0xFF06B6D4),
    };

    return colors[confirmedBy.toLowerCase()] ?? const Color(0xFF6B7280);
  }

  IconData getCompanyIcon(String company) {
    final icons = {
      'nokia': Icons.phone_android,
      'lava': Icons.phone_android,
      'samsung': Icons.phone_android,
      'hdfc': Icons.account_balance,
      'icici': Icons.account_balance,
      'sbi': Icons.account_balance,
      'axis': Icons.account_balance,
    };

    return icons[company.toLowerCase()] ?? Icons.business;
  }
}
