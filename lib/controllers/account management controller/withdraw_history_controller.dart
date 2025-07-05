import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:smartbecho/models/account%20management%20models/withdraw_history_model.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/utils/app_colors.dart';

class WithdrawController extends GetxController {
  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    // Form controllers
    dateController.dispose();
    amountController.dispose();
    withdrawnByController.dispose();
    purposeController.dispose();
    notesController.dispose();
    super.dispose();
  }

  final ApiServices _apiService = ApiServices();
  final AppConfig _config = AppConfig.instance;

  // Form controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController withdrawnByController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  // Form state
  var isFormLoading = false.obs;
  var selectedSource = 'CASH'.obs;

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
    dateController.text = DateTime.now().toIso8601String().split('T')[0];
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
              primary: Color(0xFFEF4444),
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

  // Save withdrawal
  Future<void> saveWithdrawal() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isFormLoading.value = true;
      
      final withdrawalData = {
        'date': dateController.text,
        'amount': double.parse(amountController.text),
        'withdrawnBy': withdrawnByController.text,
        'purpose': purposeController.text,
        'notes': notesController.text.isEmpty ? '' : notesController.text,
        'paymentMode': selectedSource.value,
      };

      final response = await _apiService.requestPostForApi(
        url: '${_config.baseUrl}/api/withdrawals',
        dictParameter: withdrawalData,
        authToken: true,
      );

      if (response != null && response.statusCode == 201) {
      
        
        clearForm();
          Get.snackbar(
          'Success',
          'Withdrawal recorded successfully!',
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
        );
        loadWithdrawals(refresh: true);
        
        // Get.back();
      } else {
        String errorMessage = 'Failed to record withdrawal';
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
      print('Error saving withdrawal: $e');
      Get.snackbar(
        'Error',
        'Failed to record withdrawal: ${e.toString()}',
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
    amountController.clear();
    withdrawnByController.clear();
    purposeController.clear();
    notesController.clear();
    selectedSource.value = 'CASH';
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

        _updateFilterOptions();

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
      'alice johnson': const Color(0xFFEF4444),
      'bob wilson': const Color(0xFF8B5CF6),
      'charlie brown': const Color(0xFFF59E0B),
      'diana prince': const Color(0xFFEC4899),
      'eve adams': const Color(0xFF06B6D4),
      'frank miller': const Color(0xFF84CC16),
    };

    return colors[withdrawnBy.toLowerCase()] ?? const Color(0xFF6B7280);
  }

  Color getPurposeColor(String purpose) {
    final colors = {
      'office supplies': const Color(0xFF3B82F6),
      'travel expenses': const Color(0xFF10B981),
      'utilities': const Color(0xFFEF4444),
      'marketing': const Color(0xFF8B5CF6),
      'maintenance': const Color(0xFFF59E0B),
      'equipment': const Color(0xFFEC4899),
      'petty cash': const Color(0xFF06B6D4),
      'miscellaneous': const Color(0xFF84CC16),
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
<<<<<<< HEAD
}
=======

  String formatCurrency(double amount) {
    return '₹${amount.toStringAsFixed(2)}';
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  double get totalWithdrawnAmount {
    return filteredWithdrawals.fold(0.0, (sum, withdrawal) => sum + withdrawal.amount);
  }

  Map<String, double> get withdrawalsByPaymentMode {
    final Map<String, double> result = {};
    for (var withdrawal in filteredWithdrawals) {
      result[withdrawal.paymentMode] = (result[withdrawal.paymentMode] ?? 0) + withdrawal.amount;
    }
    return result;
  }

  Map<String, double> get withdrawalsByPurpose {
    final Map<String, double> result = {};
    for (var withdrawal in filteredWithdrawals) {
      result[withdrawal.purpose] = (result[withdrawal.purpose] ?? 0) + withdrawal.amount;
    }
    return result;
  }

  Map<String, int> get withdrawalCountByPerson {
    final Map<String, int> result = {};
    for (var withdrawal in filteredWithdrawals) {
      result[withdrawal.withdrawnBy] = (result[withdrawal.withdrawnBy] ?? 0) + 1;
    }
    return result;
  }

  void exportData() {
    // Implementation for exporting data
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
    // Implementation for printing report
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
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
