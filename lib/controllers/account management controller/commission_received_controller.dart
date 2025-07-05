import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:smartbecho/models/account%20management%20models/commission_received_model.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';
<<<<<<< HEAD
import 'package:smartbecho/utils/app_colors.dart';
=======
import 'package:file_picker/file_picker.dart';
import 'dart:io';
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628

class CommissionReceivedController extends GetxController {
  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    // Form controllers
    dateController.dispose();
    companyController.dispose();
    amountController.dispose();
    confirmedByController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  final ApiServices _apiService = ApiServices();
  final AppConfig _config = AppConfig.instance;

  // Form controllers
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController confirmedByController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  // Form state
  var isFormLoading = false.obs;
  var selectedReceivedModeForm = 'cash'.obs; // For form submission
  var selectedFile = Rxn<File>();

  // Observable variables
  var isLoading = false.obs;
  var commissions = <Commission>[].obs;
  var filteredCommissions = <Commission>[].obs;
  var currentPage = 0.obs;
  var totalPages = 0.obs;
  var totalElements = 0.obs;
  var hasMoreData = true.obs;
  var isFilterExpanded = false.obs;

  // Filter variables
  var searchQuery = ''.obs;
  var selectedCompany = 'All'.obs;
  var selectedConfirmedBy = 'All'.obs;
  var selectedReceivedMode = 'All'.obs; // For filtering
  var selectedMonth = DateTime.now().month.obs;
  var selectedYear = DateTime.now().year.obs;

  // Available filter options
  var companyOptions = <String>['All'].obs;
  var confirmedByOptions = <String>['All'].obs;
  var receivedModeOptions = <String>['All'].obs;

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
    loadCommissions(refresh: true);
<<<<<<< HEAD

=======
    dateController.text = DateTime.now().toIso8601String().split('T')[0];
    
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
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
              primary: Color(0xFF10B981),
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

  // File picker
  Future<void> pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        selectedFile.value = File(result.files.single.path!);
        Get.snackbar(
          'File Selected',
          'File selected successfully: ${result.files.single.name}',
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick file: ${e.toString()}',
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Save commission
  Future<void> saveCommission() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isFormLoading.value = true;
      
      // Create form data
      final formData = dio.FormData();
      formData.fields.add(MapEntry('company', companyController.text));
      formData.fields.add(MapEntry('amount', amountController.text));
      formData.fields.add(MapEntry('receivedMode', selectedReceivedModeForm.value));
      formData.fields.add(MapEntry('confirmedBy', confirmedByController.text));
      formData.fields.add(MapEntry('description', descriptionController.text));
      formData.fields.add(MapEntry('date', DateTime.parse(dateController.text).toUtc().toIso8601String()));

      // Add file if selected
      if (selectedFile.value != null) {
        formData.files.add(MapEntry(
          'file',
          await dio.MultipartFile.fromFile(
            selectedFile.value!.path,
            filename: selectedFile.value!.path.split('/').last,
          ),
        ));
      }

      final response = await _apiService.requestMultipartApi(
        url: '${_config.baseUrl}/api/commissions',
        formData: formData,
        authToken: true,
      );

      if (response != null && response.statusCode == 201) {
        clearForm();
        Get.snackbar(
          'Success',
          'Commission recorded successfully!',
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
        );
        loadCommissions(refresh: true);
      } else {
        String errorMessage = 'Failed to record commission';
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
      print('Error saving commission: $e');
      Get.snackbar(
        'Error',
        'Failed to record commission: ${e.toString()}',
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
    companyController.clear();
    amountController.clear();
    confirmedByController.clear();
    descriptionController.clear();
    selectedReceivedModeForm.value = 'cash';
    selectedFile.value = null;
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

  Future<void> loadCommissions({bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 0;
        commissions.clear();
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
        url: '${_config.baseUrl}/api/commissions',
        dictParameter: query,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final commissionsResponse = CommissionsResponse.fromJson(response.data);

        if (refresh) {
          commissions.value = commissionsResponse.content;
        } else {
          commissions.addAll(commissionsResponse.content);
        }

        totalPages.value = commissionsResponse.totalPages;
        totalElements.value = commissionsResponse.totalElements;
        hasMoreData.value = !commissionsResponse.last;

        // Update filter options
        _updateFilterOptions();

        // Apply current filters
        _applyFilters();
      } else {
        Get.snackbar(
          'Error',
          'Failed to load commissions',
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
    // Update company options
    final companySet =
        commissions.map((commission) => commission.company).toSet();
    companyOptions.value = ['All', ...companySet.toList()..sort()];

    // Update confirmed by options
    final confirmedBySet =
        commissions.map((commission) => commission.confirmedBy).toSet();
    confirmedByOptions.value = ['All', ...confirmedBySet.toList()..sort()];

    // Update received mode options
    final receivedModeSet =
        commissions.map((commission) => commission.receivedMode).toSet();
    receivedModeOptions.value = ['All', ...receivedModeSet.toList()..sort()];
  }

  void _applyFilters() {
    var filtered =
        commissions.where((commission) {
          // Search filter
          if (searchQuery.value.isNotEmpty) {
            final query = searchQuery.value.toLowerCase();
            if (!commission.company.toLowerCase().contains(query) &&
                !commission.confirmedBy.toLowerCase().contains(query) &&
                !commission.description.toLowerCase().contains(query) &&
                !commission.receivedMode.toLowerCase().contains(query)) {
              return false;
            }
          }

          // Company filter
          if (selectedCompany.value != 'All' &&
              commission.company != selectedCompany.value) {
            return false;
          }

          // Confirmed by filter
          if (selectedConfirmedBy.value != 'All' &&
              commission.confirmedBy != selectedConfirmedBy.value) {
            return false;
          }

          // Received mode filter
          if (selectedReceivedMode.value != 'All' &&
              commission.receivedMode != selectedReceivedMode.value) {
            return false;
          }

          return true;
        }).toList();

    filteredCommissions.value = filtered;
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

  void onReceivedModeChanged(String? receivedMode) {
    if (receivedMode != null) {
      selectedReceivedMode.value = receivedMode;
      _applyFilters();
    }
  }

  void onMonthChanged(int? month) {
    if (month != null) {
      selectedMonth.value = month;
      loadCommissions(refresh: true);
    }
  }

  void onYearChanged(int? year) {
    if (year != null) {
      selectedYear.value = year;
      loadCommissions(refresh: true);
    }
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedCompany.value = 'All';
    selectedConfirmedBy.value = 'All';
    selectedReceivedMode.value = 'All';
    _applyFilters();
  }

  void loadNextPage() {
    if (hasMoreData.value && !isLoading.value) {
      currentPage.value++;
      loadCommissions();
    }
  }

  void refreshData() {
    loadCommissions(refresh: true);
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
    if (selectedReceivedMode.value != 'All') {
      activeFilters.add('Payment: ${selectedReceivedMode.value}');
    }

    if (activeFilters.isEmpty) {
      return '${filteredCommissions.length} commissions found';
    }

    return '${activeFilters.join(' • ')} • ${filteredCommissions.length} results';
  }

  bool get hasActiveFilters {
    return searchQuery.value.isNotEmpty ||
        selectedCompany.value != 'All' ||
        selectedConfirmedBy.value != 'All' ||
        selectedReceivedMode.value != 'All';
  }

  Color getCompanyColor(String company) {
    final colors = {
      'nokia': const Color(0xFF3B82F6),
      'vivo': const Color(0xFF10B981),
      'samsung': const Color(0xFF8B5CF6),
      'pepsie': const Color(0xFFF59E0B),
      'oppo': const Color(0xFFEF4444),
      'apple': const Color(0xFF06B6D4),
      'xiaomi': const Color(0xFFF97316),
      'realme': const Color(0xFF10B981),
    };

    return colors[company.toLowerCase()] ?? const Color(0xFF6366F1);
  }

  Color getConfirmedByColor(String confirmedBy) {
    final colors = {
      'nishant': const Color(0xFF10B981),
      'robert johnson': const Color(0xFF3B82F6),
      'jane smith': const Color(0xFF8B5CF6),
      'john doe': const Color(0xFFF59E0B),
      'praveen': const Color(0xFFEF4444),
      'ranmu': const Color(0xFF06B6D4),
      'shahzad': const Color(0xFF8B5CF6),
    };

    return colors[confirmedBy.toLowerCase()] ?? const Color(0xFF6B7280);
  }

  Color getReceivedModeColor(String receivedMode) {
    final colors = {
      'cash': const Color(0xFF10B981),
      'neft': const Color(0xFF3B82F6),
      'upi': const Color(0xFF8B5CF6),
      'cheque': const Color(0xFFF59E0B),
      'rtgs': const Color(0xFFEF4444),
      'account': const Color(0xFF3B82F6),
    };

    return colors[receivedMode.toLowerCase()] ?? const Color(0xFF6B7280);
  }

  IconData getReceivedModeIcon(String receivedMode) {
    final icons = {
      'cash': Icons.money,
      'neft': Icons.account_balance,
      'upi': Icons.phone_android,
      'cheque': Icons.note,
      'rtgs': Icons.account_balance_wallet,
      'account': Icons.account_balance,
    };

    return icons[receivedMode.toLowerCase()] ?? Icons.payments;
  }
}
