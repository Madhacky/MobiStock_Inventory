

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
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';

class InventoryController extends GetxController {
  // PlutoGrid Manager
  PlutoGridStateManager? stateManager;
  // API service instance
  final ApiServices _apiService = ApiServices();
  // App config instance
  final AppConfig _config = AppConfig.instance;

  // Observable variables for API data
  final RxList<InventoryItem> inventoryItems = <InventoryItem>[].obs;
  final RxList<InventoryItem> allFetchedItems = <InventoryItem>[].obs;

  // Search and filtering (API-based)
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

  // Lazy loading variables (replacing pagination)
  final RxInt itemsPerPage = 20.obs;  // Items to load per batch
  final RxInt currentPage = 0.obs;    // Current batch
  final RxInt totalItems = 0.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  late ScrollController scrollController;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isInventoryDataLoading = false.obs;
  final RxString inventoryDataerrorMessage = ''.obs;
  final RxBool hasInventoryDataError = false.obs;

  // Search debounce timer
  Worker? _searchDebouncer;

  // Filter options
  final RxList<String> filterCompanies = ['Apple', 'Samsung', 'OnePlus', 'Xiaomi', 'Vivo', 'Oppo'].obs;
  final RxList<String> filterModels = ['iPhone 14', 'Galaxy S23', 'OnePlus 11', 'Mi 13', 'V27 Pro'].obs;
  final RxList<String> stockOptions = ['In Stock', 'Low Stock', 'Out of Stock'].obs;
  final RxList<String> ramFilterOptions = ['4GB', '6GB', '8GB', '12GB', '16GB'].obs;
  final RxList<String> romFilterOptions = ['64GB', '128GB', '256GB', '512GB', '1TB'].obs;
  final RxList<String> colorFilterOptions = ['Black', 'White', 'Blue', 'Red', 'Gold', 'Silver'].obs;

  @override
  void onInit() {
    super.onInit();
    
    // Initialize scroll controller for lazy loading
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    
    // Set up search debouncer for API calls
    _searchDebouncer = debounce(
      searchQuery,
      (String query) => _onSearchChanged(query),
      time: const Duration(milliseconds: 800),
    );
    
    // Set up listeners for other filters
    ever(selectedCompany, (_) => _onFiltersChanged());
    ever(selectedModel, (_) => _onFiltersChanged());
    ever(selectedStockAvailability, (_) => _onFiltersChanged());
    ever(selectedRAM, (_) => _onFiltersChanged());
    ever(selectedROM, (_) => _onFiltersChanged());
    ever(selectedColor, (_) => _onFiltersChanged());

    // Initial data fetch
    fetchInventoryData(isInitial: true);
    getSummaryCards();
  }

  @override
  void onClose() {
    // Dispose controllers and workers
    scrollController.dispose();
    _searchDebouncer?.dispose();

    super.onClose();
  }

  /// Handle scroll for lazy loading
  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
      if (!isLoadingMore.value && hasMoreData.value && !isInventoryDataLoading.value) {
        loadMoreData();
      }
    }
  }

  /// Handle search query changes with API call
  void _onSearchChanged(String query) {
    if (query.trim().isNotEmpty) {
      // Reset pagination for new search
      _resetPagination();
      _searchByCompany(query.trim());
    } else {
      // If search is cleared, fetch all data
      _resetPagination();
      fetchInventoryData(isInitial: true);
    }
  }

  /// Handle other filter changes
  void _onFiltersChanged() {
    // Apply local filters to current data
    _applyLocalFilters();
  }

  /// Search by company using filter API
  Future<void> _searchByCompany(String company) async {
    try {
      isInventoryDataLoading.value = true;
      hasInventoryDataError.value = false;
      inventoryDataerrorMessage.value = '';

      final jsessionId = await SecureStorageHelper.getJSessionId();
      log("jsessionId: $jsessionId");

      if (jsessionId == null || jsessionId.isEmpty) {
        hasInventoryDataError.value = true;
        inventoryDataerrorMessage.value = 'No session found. Please login again.';
        return;
      }

      // Use filter API for company search
      String apiUrl = '${_config.baseUrl}/inventory/filter?company=${company.toLowerCase()}';
      log("Searching company from URL: $apiUrl");

      dio.Response? response = await _apiService.requestGetWithJSessionId(
        url: apiUrl,
        authToken: true,
      );

<<<<<<< HEAD
      if (response != null && response.statusCode == 201) {
        // Handle successful response
        Get.snackbar(
          'Success',
          'Mobile added to inventory successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF10B981),
          colorText: AppTheme.backgroundLight,
          icon: const Icon(Icons.check_circle, color: AppTheme.backgroundLight),
        );
=======
      if (response != null) {
        if (response.statusCode == 200) {
          final data = InventoryResponse.fromJson(response.data);
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628


          List<InventoryItem> fetchedItems = data.payload;

          // Reset and update data
          allFetchedItems.assignAll(fetchedItems);
          totalItems.value = fetchedItems.length;
          hasMoreData.value = false; // No pagination for search results
          
          log("Search results loaded: ${allFetchedItems.length}");
          
          // Apply other filters to search results
          _applyLocalFilters();
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          hasInventoryDataError.value = true;
          inventoryDataerrorMessage.value = 'Session expired. Please login again.';
          await _handleSessionExpired();
        } else {
          hasInventoryDataError.value = true;
          inventoryDataerrorMessage.value = 'Failed to search. Status: ${response.statusCode}';
        }
      } else {
        hasInventoryDataError.value = true;
        inventoryDataerrorMessage.value = 'Network error. Please try again.';
      }
    } catch (error) {
<<<<<<< HEAD
      hasAddMobileError.value = true;
      addMobileErrorMessage.value = 'Error adding mobile: $error';
      log("❌ Error in addMobileToInventory: $error");

      Get.snackbar(
        'Error',
        'Failed to add mobile to inventory. Please try again.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppTheme.primaryRed,
        colorText: AppTheme.backgroundLight,
        icon: const Icon(Icons.error, color: AppTheme.backgroundLight),
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
=======
      hasInventoryDataError.value = true;
      inventoryDataerrorMessage.value = 'Error: $error';
      log("❌ Error in _searchByCompany: $error");
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
    } finally {
      isInventoryDataLoading.value = false;
    }
  }

  /// Apply local filters to current data (non-search filters)
  void _applyLocalFilters() {
    List<InventoryItem> filtered = List.from(allFetchedItems);

    // Apply model filter
    if (selectedModel.value.isNotEmpty && selectedModel.value != 'Select Model') {
      filtered = filtered.where((item) => 
        item.model.toLowerCase().contains(selectedModel.value.toLowerCase())
      ).toList();
    }

    // Apply RAM filter
    if (selectedRAM.value.isNotEmpty && selectedRAM.value != 'Select RAM') {
      filtered = filtered.where((item) => 
        item.ram.toLowerCase().contains(selectedRAM.value.toLowerCase())
      ).toList();
    }

    // Apply ROM filter
    if (selectedROM.value.isNotEmpty && selectedROM.value != 'Select ROM') {
      filtered = filtered.where((item) => 
        item.rom.toLowerCase().contains(selectedROM.value.toLowerCase())
      ).toList();
    }

    // Apply color filter
    if (selectedColor.value.isNotEmpty && selectedColor.value != 'Select Color') {
      filtered = filtered.where((item) => 
        item.color.toLowerCase().contains(selectedColor.value.toLowerCase())
      ).toList();
    }

    // Apply stock availability filter
    if (selectedStockAvailability.value.isNotEmpty && selectedStockAvailability.value != 'Stock Availa...') {
      filtered = filtered.where((item) {
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

  /// Reset pagination variables
  void _resetPagination() {
    currentPage.value = 0;
    hasMoreData.value = true;
    allFetchedItems.clear();
    inventoryItems.clear();
  }

  /// Load more data for lazy loading
  Future<void> loadMoreData() async {
    if (searchQuery.value.trim().isNotEmpty) {
      // Don't load more for search results
      return;
    }
    
    currentPage.value++;
    await fetchInventoryData(isLoadMore: true);
  }

  /// Modified fetch inventory data for lazy loading
  Future<void> fetchInventoryData({bool isInitial = false, bool isLoadMore = false}) async {
    try {
      if (isInitial) {
        isInventoryDataLoading.value = true;
        _resetPagination();
      } else if (isLoadMore) {
        isLoadingMore.value = true;
      }
      
      hasInventoryDataError.value = false;
      inventoryDataerrorMessage.value = '';

      final jsessionId = await SecureStorageHelper.getJSessionId();
      log("jsessionId: $jsessionId");

      if (jsessionId == null || jsessionId.isEmpty) {
        hasInventoryDataError.value = true;
        inventoryDataerrorMessage.value = 'No session found. Please login again.';
        return;
      }

      // Construct the paginated API URL
      String apiUrl = '${_config.getInventoryData}?page=${currentPage.value}&size=${itemsPerPage.value}&sortBy=${sortBy.value}';
      log("Fetching from URL: $apiUrl");

      dio.Response? response = await _apiService.requestGetWithJSessionId(
        url: apiUrl,
        authToken: true,
      );

      if (response != null) {
        if (response.statusCode == 200) {
          final data = response.data is String ? json.decode(response.data) : response.data;
          final payload = data['payload'];
          final List<dynamic> jsonList = payload['content'];

          // Extract pagination info
          totalItems.value = payload['totalElements'] ?? 0;
          int totalPages = payload['totalPages'] ?? 0;
          
          // Check if there's more data
          hasMoreData.value = currentPage.value < totalPages - 1;

          List<InventoryItem> fetchedItems = jsonList.map((item) => InventoryItem.fromJson(item)).toList();

          if (isInitial) {
            allFetchedItems.assignAll(fetchedItems);
          } else if (isLoadMore) {
            allFetchedItems.addAll(fetchedItems);
          }

          log("Items loaded: ${fetchedItems.length}, Total: ${allFetchedItems.length}");
          log("Has more data: ${hasMoreData.value}");

          // Apply local filters to the data
          _applyLocalFilters();
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          hasInventoryDataError.value = true;
          inventoryDataerrorMessage.value = 'Session expired. Please login again.';
          await _handleSessionExpired();
        } else if (response.statusCode == 404) {
          hasInventoryDataError.value = true;
          inventoryDataerrorMessage.value = 'Data not found. Session may have expired.';
        } else {
          hasInventoryDataError.value = true;
          inventoryDataerrorMessage.value = 'Failed to fetch data. Status: ${response.statusCode}';
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
      isLoadingMore.value = false;
    }
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
    
    // Refresh data after clearing filters
    refreshData();
  }

  // Apply filters (triggers local filtering)
  void applyFilters() {
    _applyLocalFilters();
  }

  // Refresh data method
  Future<void> refreshData() async {
    _resetPagination();
    await fetchInventoryData(isInitial: true);
  }

  // Action methods for modern UI
  void addNewItem() {
    Get.toNamed(AppRoutes.addNewItem);
  }

<<<<<<< HEAD
  void showAdvancedFilters() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Advanced Filters',
              style: AppStyles.custom(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
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
=======
  void addNewStocks() {
   Get.toNamed(AppRoutes.addNewStock);
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
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
      confirmTextColor: AppTheme.backgroundLight,
      buttonColor: AppTheme.primaryRed,
      onConfirm: () {
        // Remove from both lists
        allFetchedItems.removeWhere((item) => item.id.toString() == itemId);
        inventoryItems.removeWhere((item) => item.id.toString() == itemId);
        Get.back();
        Get.snackbar('Deleted', 'Item deleted successfully');
      },
    );
  }

  // Legacy methods for compatibility
  List<InventoryItem> get filteredItems => inventoryItems;
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

  // Summary cards methods...
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
        summaryCardsErrorMessage.value = 'No session found. Please login again.';
        return;
      }

      dio.Response? response = await _apiService.requestGetWithJSessionId(
        url: _config.getInventorySummaryCards,
        authToken: true,
      );

      if (response != null) {
        if (response.statusCode == 200) {
          final data = response.data is String ? json.decode(response.data) : response.data;
          final summaryResponse = SummaryCardsResponse.fromJson(data);
          summaryCardsData.value = summaryResponse.payload;
          log("Summary Cards loaded successfully");
          log("Total Companies: ${summaryCardsData.value?.totalCompanies}");
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          hasSummaryCardsError.value = true;
          summaryCardsErrorMessage.value = 'Session expired. Please login again.';
          await _handleSessionExpired();
        } else if (response.statusCode == 404) {
          hasSummaryCardsError.value = true;
          summaryCardsErrorMessage.value = 'Summary data not found. Session may have expired.';
        } else {
          hasSummaryCardsError.value = true;
          summaryCardsErrorMessage.value = 'Failed to fetch summary data. Status: ${response.statusCode}';
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
<<<<<<< HEAD
  int get totalCompaniesAvailable =>
      summaryCardsData.value?.totalCompanies ?? 0;

  int get totalStockAvailable => summaryCardsData.value?.totalStock ?? 0;
  int get lowStockAlert => summaryCardsData.value?.lowStockCount ?? 0;
  int get monthlyPhoneSold => summaryCardsData.value?.totalPhonesSold ?? 0;

  //check session expiry
=======
  int get totalCompaniesAvailable => summaryCardsData.value?.totalCompanies ?? 0;
  int get totalStockAvailable => summaryCardsData.value?.totalStock ?? 0;
  int get lowStockAlert => summaryCardsData.value?.lowStockCount ?? 0;
  int get monthlyPhoneSold => summaryCardsData.value?.totalPhonesSold ?? 0;
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628

  // Session handling
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
