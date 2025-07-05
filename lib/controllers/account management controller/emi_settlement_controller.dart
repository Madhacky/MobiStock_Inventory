import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/account%20management%20models/emi%20settlement/emi_settlement_chart_model.dart';
import 'package:smartbecho/models/account%20management%20models/emi%20settlement/emi_settlement_model.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';

class EmiSettlementController extends GetxController {
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

    // Setup scroll controller for pagination
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        loadNextPage();
      }
    });
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
        final chartResponse = EmiSettlementChartResponse.fromJson(response.data);
        
        // Clear existing data and add new data
        chartData.clear();
        chartData.addAll(chartResponse.payload);
        
        chartYear.value = targetYear;
      } else {
        Get.snackbar(
          'Error',
          'Failed to load chart data',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error loading chart data: $e');
      Get.snackbar(
        'Error',
        'An error occurred while loading chart data: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
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
  bool get hasChartData => chartData.isNotEmpty && chartData.any((item) => item.amount > 0);

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
