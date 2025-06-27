import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/auth%20controllers/auth_controller.dart';
import 'package:smartbecho/models/inventory%20management/inventory_item_model.dart';
import 'package:smartbecho/models/inventory%20management/inventory_summary_model.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/services/secure_storage_service.dart';
import 'package:smartbecho/services/shared_preferences_services.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';

class InventoryController extends GetxController {
  // PlutoGrid Manager
  PlutoGridStateManager? stateManager;
  // API service instance
  final ApiServices _apiService = ApiServices();
  // App config instance
  final AppConfig _config = AppConfig.instance;

  // Observable variables for API data
  final RxList<InventoryItem> inventoryItems = <InventoryItem>[].obs;
  final RxList<InventoryItem> allFetchedItems =
      <InventoryItem>[].obs; // For frontend filtering

  // Search and filtering (frontend only)
  final RxString searchQuery = ''.obs;
  final RxString selectedCompany = ''.obs;
  final RxString selectedModel = 'Select Model'.obs;
  final RxString selectedStockAvailability = 'Stock Availa...'.obs;
  final RxString selectedRAM = 'Select RAM'.obs;
  final RxString selectedROM = 'Select ROM'.obs;
  final RxString selectedColor = 'Select Color'.obs;
  final RxBool isFiltersExpanded = false.obs;
  // Sorting
  final RxString sortBy = 'id'.obs;
  final RxString sortDirection = 'asc'.obs;

  // Pagination (API-based)
  final RxInt itemsPerPage = 10.obs;
  final RxInt currentPage = 0.obs;
  final RxInt totalItems = 0.obs;
  final RxInt totalPages = 0.obs;
  final RxBool isLoadingMore = false.obs;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isInventoryDataLoading = false.obs;
  final RxString inventoryDataerrorMessage = ''.obs;
  final RxBool hasInventoryDataError = false.obs;

  // ADD MOBILE FORM CONTROLLERS AND VARIABLES
  final GlobalKey<FormState> addMobileFormKey = GlobalKey<FormState>();

  // Form Controllers
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  // Form Values
  final RxString selectedAddCompany = ''.obs;
  final RxString selectedAddModel = ''.obs;
  final RxString selectedAddRam = ''.obs;
  final RxString selectedAddStorage = ''.obs;
  final RxString selectedAddColor = ''.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);

  // Form Loading States
  final RxBool isAddingMobile = false.obs;
  final RxBool hasAddMobileError = false.obs;
  final RxString addMobileErrorMessage = ''.obs;

  // Sample data for dropdowns
  final RxList<String> companies =
      [
        'Apple',
        'Samsung',
        'Google',
        'OnePlus',
        'Xiaomi',
        'Oppo',
        'Vivo',
        'Realme',
      ].obs;
  final Map<String, List<String>> models = {
    'Apple': [
      'iPhone 15 Pro',
      'iPhone 15',
      'iPhone 14 Pro',
      'iPhone 14',
      'iPhone 13',
    ],
    'Samsung': [
      'Galaxy S24 Ultra',
      'Galaxy S24',
      'Galaxy S23',
      'Galaxy A54',
      'Galaxy A34',
    ],
    'Google': ['Pixel 8 Pro', 'Pixel 8', 'Pixel 7 Pro', 'Pixel 7', 'Pixel 6a'],
    'OnePlus': [
      'OnePlus 12',
      'OnePlus 11',
      'OnePlus Nord 3',
      'OnePlus Nord CE 3',
    ],
    'Xiaomi': ['Xiaomi 14', 'Xiaomi 13', 'Redmi Note 13', 'Redmi Note 12'],
  };
  final RxList<String> ramOptions = ['4GB', '6GB', '8GB', '12GB', '16GB'].obs;
  final RxList<String> storageOptions =
      ['64GB', '128GB', '256GB', '512GB', '1TB'].obs;
  final RxList<String> colorOptions =
      [
        'Black',
        'White',
        'Blue',
        'Red',
        'Green',
        'Gold',
        'Silver',
        'Purple',
        'Pink',
      ].obs;

  // Filter options
  final RxList<String> filterCompanies =
      ['Apple', 'Samsung', 'OnePlus', 'Xiaomi', 'Vivo', 'Oppo'].obs;
  final RxList<String> filterModels =
      ['iPhone 14', 'Galaxy S23', 'OnePlus 11', 'Mi 13', 'V27 Pro'].obs;
  final RxList<String> stockOptions =
      ['In Stock', 'Low Stock', 'Out of Stock'].obs;
  final RxList<String> ramFilterOptions =
      ['4GB', '6GB', '8GB', '12GB', '16GB'].obs;
  final RxList<String> romFilterOptions =
      ['64GB', '128GB', '256GB', '512GB', '1TB'].obs;
  final RxList<String> colorFilterOptions =
      ['Black', 'White', 'Blue', 'Red', 'Gold', 'Silver'].obs;

  @override
  void onInit() {
    super.onInit();
    // Set up listeners for frontend filtering only
    ever(searchQuery, (_) => _applyFrontendFilters());
    ever(selectedCompany, (_) => _applyFrontendFilters());
    ever(selectedModel, (_) => _applyFrontendFilters());
    ever(selectedStockAvailability, (_) => _applyFrontendFilters());
    ever(selectedRAM, (_) => _applyFrontendFilters());
    ever(selectedROM, (_) => _applyFrontendFilters());
    ever(selectedColor, (_) => _applyFrontendFilters());

    // Initial data fetch
    fetchInventoryData();
    getSummaryCards();
  }

  @override
  void onClose() {
    // Dispose form controllers
    quantityController.dispose();
    priceController.dispose();
    super.onClose();
  }

  // ADD MOBILE FORM METHODS

  /// Get company brand color for UI theming
  Color getCompanyColor(String? company) {
    switch (company?.toLowerCase()) {
      case 'apple':
        return const Color(0xFF1D1D1F);
      case 'samsung':
        return const Color(0xFF1428A0);
      case 'google':
        return const Color(0xFF4285F4);
      case 'oneplus':
        return const Color(0xFFEB0028);
      case 'xiaomi':
        return const Color(0xFFFF6900);
      default:
        return const Color(0xFF6B7280);
    }
  }

  /// Get available models for selected company
  List<String> getModelsForCompany(String? company) {
    if (company == null) {
      return [];
    }
    return models[company] ?? [];
  }

  /// Check if model selection is enabled
  bool get isModelSelectionEnabled => selectedAddCompany.value.isNotEmpty;

  /// Get formatted device name for display
  String get formattedDeviceName {
    if (selectedAddCompany.value.isNotEmpty &&
        selectedAddModel.value.isNotEmpty) {
      return '${selectedAddCompany.value} ${selectedAddModel.value}';
    }
    return 'Select Company & Model';
  }

  /// Get formatted device specs for display
  String get formattedDeviceSpecs {
    if (selectedAddRam.value.isNotEmpty &&
        selectedAddStorage.value.isNotEmpty) {
      return '${selectedAddRam.value} RAM • ${selectedAddStorage.value} Storage';
    }
    return 'RAM & Storage will appear here';
  }

  /// Handle company selection
  void onAddCompanyChanged(String company) {
    selectedAddCompany.value = company;
    selectedAddModel.value = ''; // Reset model when company changes
  }

  /// Handle model selection
  void onAddModelChanged(String model) {
    selectedAddModel.value = model;
  }

  /// Handle RAM selection
  void onAddRamChanged(String ram) {
    selectedAddRam.value = ram;
  }

  /// Handle storage selection
  void onAddStorageChanged(String storage) {
    selectedAddStorage.value = storage;
  }

  /// Handle color selection
  void onAddColorChanged(String color) {
    selectedAddColor.value = color;
  }

  /// Handle image selection
  void onImageSelected(File? image) {
    selectedImage.value = image;
  }

  /// Validate form fields
  String? validateCompany(String? value) {
    return value == null || value.isEmpty ? 'Please select a company' : null;
  }

  String? validateModel(String? value) {
    return value == null || value.isEmpty ? 'Please select a model' : null;
  }

  String? validateRam(String? value) {
    return value == null || value.isEmpty ? 'Please select RAM' : null;
  }

  String? validateStorage(String? value) {
    return value == null || value.isEmpty ? 'Please select storage' : null;
  }

  String? validateColor(String? value) {
    return value == null || value.isEmpty ? 'Please select a color' : null;
  }

  String? validatePrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter selling price';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter valid price';
    }
    return null;
  }

  String? validateQuantity(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter quantity';
    }
    if (int.tryParse(value) == null) {
      return 'Please enter valid quantity';
    }
    return null;
  }

  /// Reset add mobile form
  void resetAddMobileForm() {
    addMobileFormKey.currentState?.reset();
    selectedAddCompany.value = '';
    selectedAddModel.value = '';
    selectedAddRam.value = '';
    selectedAddStorage.value = '';
    selectedAddColor.value = '';
    selectedImage.value = null;
    quantityController.clear();
    priceController.clear();
    hasAddMobileError.value = false;
    addMobileErrorMessage.value = '';
  }

  /// Add mobile to inventory
  Future<void> addMobileToInventory() async {
    if (!addMobileFormKey.currentState!.validate()) {
      return;
    }

    try {
      isAddingMobile.value = true;
      hasAddMobileError.value = false;
      addMobileErrorMessage.value = '';

      // Prepare the data
      final mobileData = {
        'company': selectedAddCompany.value,
        'model': selectedAddModel.value,
        'ram': selectedAddRam.value,
        'rom': selectedAddStorage.value,
        'color': selectedAddColor.value,
        'qty': int.parse(quantityController.text),
        'sellingPrice': double.parse(priceController.text),
        "logo":
            "${selectedAddCompany + selectedAddColor.value + quantityController.text}.png",
      };

      dio.Response? response = await _apiService.requestPostForApi(
        url: _config.addInventoryItem, // Add this endpoint to your config
        dictParameter: mobileData,
        authToken: true,
      );

      if (response != null && response.statusCode == 201) {
        // Handle successful response
        Get.snackbar(
          'Success',
          'Mobile added to inventory successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );

        // Refresh inventory data if needed
        await fetchInventoryData();
        // Reset form
        resetAddMobileForm();
      } else {
        throw Exception('Failed to add mobile to inventory');
      }
    } catch (error) {
      hasAddMobileError.value = true;
      addMobileErrorMessage.value = 'Error adding mobile: $error';
      log("❌ Error in addMobileToInventory: $error");

      Get.snackbar(
        'Error',
        'Failed to add mobile to inventory. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isAddingMobile.value = false;
    }
  }

  /// Cancel add mobile form
  void cancelAddMobile() {
    resetAddMobileForm();
    Get.back();
  }

  // EXISTING INVENTORY MANAGEMENT METHODS (unchanged)

  // Apply frontend filters to currently loaded data
  void _applyFrontendFilters() {
    List<InventoryItem> filtered = List.from(allFetchedItems);

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      String query = searchQuery.value.toLowerCase();
      filtered =
          filtered.where((item) {
            return item.model.toLowerCase().contains(query) ||
                item.company.toLowerCase().contains(query) ||
                item.ram.toLowerCase().contains(query) ||
                item.rom.toLowerCase().contains(query) ||
                item.color.toLowerCase().contains(query);
          }).toList();
    }

    // Apply company filter
    if (selectedCompany.value.isNotEmpty &&
        selectedCompany.value != 'All' &&
        selectedCompany.value != 'Select Company') {
      filtered =
          filtered
              .where(
                (item) =>
                    item.company.toLowerCase() ==
                    selectedCompany.value.toLowerCase(),
              )
              .toList();
    }

    // Apply model filter
    if (selectedModel.value.isNotEmpty &&
        selectedModel.value != 'Select Model') {
      filtered =
          filtered
              .where(
                (item) => item.model.toLowerCase().contains(
                  selectedModel.value.toLowerCase(),
                ),
              )
              .toList();
    }

    // Apply RAM filter
    if (selectedRAM.value.isNotEmpty && selectedRAM.value != 'Select RAM') {
      filtered =
          filtered
              .where(
                (item) => item.ram.toLowerCase().contains(
                  selectedRAM.value.toLowerCase(),
                ),
              )
              .toList();
    }

    // Apply ROM filter
    if (selectedROM.value.isNotEmpty && selectedROM.value != 'Select ROM') {
      filtered =
          filtered
              .where(
                (item) => item.rom.toLowerCase().contains(
                  selectedROM.value.toLowerCase(),
                ),
              )
              .toList();
    }

    // Apply color filter
    if (selectedColor.value.isNotEmpty &&
        selectedColor.value != 'Select Color') {
      filtered =
          filtered
              .where(
                (item) => item.color.toLowerCase().contains(
                  selectedColor.value.toLowerCase(),
                ),
              )
              .toList();
    }

    // Apply stock availability filter
    if (selectedStockAvailability.value.isNotEmpty &&
        selectedStockAvailability.value != 'Stock Availa...') {
      filtered =
          filtered.where((item) {
            int quantity = item.quantity;
            switch (selectedStockAvailability.value) {
              case 'In Stock':
                return quantity > 20;
              case 'Low Stock':
                return quantity > 0 && quantity <= 20;
              case 'Out of Stock':
                return quantity == 0;
              default:
                return true;
            }
          }).toList();
    }

    // Update the displayed items
    inventoryItems.assignAll(filtered);
  }

  // Pagination methods with API calls
  Future<void> nextPage() async {
    if (currentPage.value < totalPages.value - 1) {
      currentPage.value++;
      await fetchInventoryData();
    }
  }

  Future<void> previousPage() async {
    if (currentPage.value > 0) {
      currentPage.value--;
      await fetchInventoryData();
    }
  }

  Future<void> goToPage(int page) async {
    if (page >= 0 && page < totalPages.value) {
      currentPage.value = page;
      await fetchInventoryData();
    }
  }

  Future<void> changeItemsPerPage(int newSize) async {
    itemsPerPage.value = newSize;
    currentPage.value = 0;
    await fetchInventoryData();
  }

  // Filter methods for modern UI
  void onCompanyFilterChanged(String company) {
    selectedCompany.value = company;
  }

  void onModelFilterChanged(String model) {
    selectedModel.value = model;
  }

  void onStockFilterChanged(String stock) {
    selectedStockAvailability.value = stock;
  }

  void onRAMFilterChanged(String ram) {
    selectedRAM.value = ram;
  }

  void onROMFilterChanged(String rom) {
    selectedROM.value = rom;
  }

  void onColorFilterChanged(String color) {
    selectedColor.value = color;
  }

  void clearFilters() {
    searchQuery.value = '';
    selectedCompany.value = '';
    selectedModel.value = 'Select Model';
    selectedStockAvailability.value = 'Stock Availa...';
    selectedRAM.value = 'Select RAM';
    selectedROM.value = 'Select ROM';
    selectedColor.value = 'Select Color';
    sortBy.value = 'id';
    sortDirection.value = 'asc';
  }

  // Apply filters (just trigger frontend filtering)
  void applyFilters() {
    _applyFrontendFilters();
  }

  // Refresh data method
  Future<void> refreshData() async {
    currentPage.value = 0;
    await fetchInventoryData();
  }

  // Action methods for modern UI
  void addNewItem() {
    Get.toNamed(AppRoutes.addNewItem);
  }

  void showAdvancedFilters() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Advanced Filters',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back();
                _applyFrontendFilters();
              },
              child: Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }

  void exportData() {
    Get.snackbar('Export', 'Exporting ${inventoryItems.length} items...');
  }

  void editItem(InventoryItem item) {
    Get.toNamed('/edit-stock', arguments: item);
  }

  void deleteItem(String itemId, int index) {
    Get.defaultDialog(
      title: 'Delete Item',
      middleText: 'Are you sure you want to delete this item?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        // Remove from both lists
        allFetchedItems.removeWhere((item) => item.id.toString() == itemId);
        inventoryItems.removeWhere((item) => item.id.toString() == itemId);
        Get.back();
        Get.snackbar('Deleted', 'Item deleted successfully');
      },
    );
  }

  void onPageSizeChanged(int pageSize) {
    changeItemsPerPage(pageSize);
  }

  // Legacy methods for compatibility
  List<InventoryItem> get filteredItems => inventoryItems;
  int get totalPages_legacy => totalPages.value;
  int get totalItems_legacy => totalItems.value;

  List<InventoryItem> getPaginatedItems() {
    return inventoryItems;
  }

  void addNewStock() {
    addNewItem();
  }

  void bulkUpload() {
    Get.snackbar('Bulk Upload', 'Bulk upload functionality coming soon!');
  }

  Future<void> onRetry() async {
    await retryFetchInventoryData();
  }

  // API Methods
  Future<void> fetchInventoryData() async {
    try {
      isInventoryDataLoading.value = true;
      hasInventoryDataError.value = false;
      inventoryDataerrorMessage.value = '';

      final jsessionId = await SecureStorageHelper.getJSessionId();
      log("jsessionId: $jsessionId");

      if (jsessionId == null || jsessionId.isEmpty) {
        hasInventoryDataError.value = true;
        inventoryDataerrorMessage.value =
            'No session found. Please login again.';
        return;
      }

      // Construct the paginated API URL
      String apiUrl =
          '${_config.getInventoryData}?page=${currentPage.value}&size=${itemsPerPage.value}&sortBy=${sortBy.value}';
      log("Fetching from URL: $apiUrl");

      dio.Response? response = await _apiService.requestGetWithJSessionId(
        url: apiUrl,
        authToken: true,
      );

      if (response != null) {
        if (response.statusCode == 200) {
          final data =
              response.data is String
                  ? json.decode(response.data)
                  : response.data;

          final payload = data['payload'];
          final List<dynamic> jsonList = payload['content'];

          // Extract pagination info
          totalItems.value = payload['totalElements'] ?? 0;
          totalPages.value = payload['totalPages'] ?? 0;

          List<InventoryItem> fetchedItems =
              jsonList.map((item) => InventoryItem.fromJson(item)).toList();

          // Store both raw data and filtered data
          allFetchedItems.assignAll(fetchedItems);

          log("Items loaded: ${allFetchedItems.length}");
          log(
            "Total items: ${totalItems.value}, Total pages: ${totalPages.value}",
          );

          // Apply frontend filters to the newly fetched data
          _applyFrontendFilters();
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          hasInventoryDataError.value = true;
          inventoryDataerrorMessage.value =
              'Session expired. Please login again.';
          await _handleSessionExpired();
        } else if (response.statusCode == 404) {
          hasInventoryDataError.value = true;
          inventoryDataerrorMessage.value =
              'Data not found. Session may have expired.';
        } else {
          hasInventoryDataError.value = true;
          inventoryDataerrorMessage.value =
              'Failed to fetch data. Status: ${response.statusCode}';
        }
      } else {
        hasInventoryDataError.value = true;
        inventoryDataerrorMessage.value = 'Network error. Please try again.';
      }
    } catch (error) {
      hasInventoryDataError.value = true;
      inventoryDataerrorMessage.value = 'Error: $error';
      log("❌ Error in fetchInventoryData: $error");
    } finally {
      isInventoryDataLoading.value = false;
    }
  }

  //get summary cards
  final RxBool isSummaryCardsLoading = false.obs;
  final RxBool hasSummaryCardsError = false.obs;
  final RxString summaryCardsErrorMessage = ''.obs;
  final Rx<SummaryCardsModel?> summaryCardsData = Rx<SummaryCardsModel?>(null);

  Future<void> getSummaryCards() async {
    try {
      isSummaryCardsLoading.value = true;
      hasSummaryCardsError.value = false;
      summaryCardsErrorMessage.value = '';

      final jsessionId = await SecureStorageHelper.getJSessionId();
      log("jsessionId: $jsessionId");

      if (jsessionId == null || jsessionId.isEmpty) {
        hasSummaryCardsError.value = true;
        summaryCardsErrorMessage.value =
            'No session found. Please login again.';
        return;
      }

      dio.Response? response = await _apiService.requestGetWithJSessionId(
        url: _config.getInventorySummaryCards,
        authToken: true,
      );

      if (response != null) {
        if (response.statusCode == 200) {
          final data =
              response.data is String
                  ? json.decode(response.data)
                  : response.data;

          // Parse the response using the model
          final summaryResponse = SummaryCardsResponse.fromJson(data);

          // Store the summary data
          summaryCardsData.value = summaryResponse.payload;

          log("Summary Cards loaded successfully");
          log("Total Companies: ${summaryCardsData.value?.totalCompanies}");
          log("Total Revenue: ${summaryCardsData.value?.totalRevenue}");
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          hasSummaryCardsError.value = true;
          summaryCardsErrorMessage.value =
              'Session expired. Please login again.';
          await _handleSessionExpired();
        } else if (response.statusCode == 404) {
          hasSummaryCardsError.value = true;
          summaryCardsErrorMessage.value =
              'Summary data not found. Session may have expired.';
        } else {
          hasSummaryCardsError.value = true;
          summaryCardsErrorMessage.value =
              'Failed to fetch summary data. Status: ${response.statusCode}';
        }
      } else {
        hasSummaryCardsError.value = true;
        summaryCardsErrorMessage.value = 'Network error. Please try again.';
      }
    } catch (error) {
      hasSummaryCardsError.value = true;
      summaryCardsErrorMessage.value = 'Error: $error';
      log("❌ Error in getSummaryCards: $error");
    } finally {
      isSummaryCardsLoading.value = false;
    }
  }

  // Getter methods for easy access to summary data
  int get totalCompaniesAvailable =>
      summaryCardsData.value?.totalCompanies ?? 0;
  int get totalModelsAvailable =>
      summaryCardsData.value?.totalModelsAvailable ?? 0;
  int get totalStockAvailable =>
      summaryCardsData.value?.totalStockAvailable ?? 0;
  int get totalUnitsSold => summaryCardsData.value?.totalUnitsSold ?? 0;
  String get topSellingBrandAndModel =>
      summaryCardsData.value?.topSellingBrandAndModel ?? '';
  double get totalRevenue => summaryCardsData.value?.totalRevenue ?? 0.0;

  // Formatted revenue for display
  String get formattedTotalRevenue {
    final revenue = totalRevenue;
    if (revenue >= 1000000) {
      return '₹${(revenue / 1000000).toStringAsFixed(1)}M';
    } else if (revenue >= 1000) {
      return '₹${(revenue / 1000).toStringAsFixed(1)}K';
    } else {
      return '₹${revenue.toStringAsFixed(0)}';
    }
  }

  //check session expiry

  Future<void> _handleSessionExpired() async {
    await SecureStorageHelper.deleteJSessionId();
    AuthController().logout();
  }

  Future<void> retryFetchInventoryData() async {
    if (await _apiService.isSessionValid()) {
      await fetchInventoryData();
    } else {
      hasInventoryDataError.value = true;
      inventoryDataerrorMessage.value = 'Please login again to continue.';
    }
  }
}
