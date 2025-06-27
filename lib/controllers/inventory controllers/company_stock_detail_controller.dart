// controllers/company_stock_details_controller.dart
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/inventory%20management/stock_item_model.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';

class CompanyStockDetailsController extends GetxController {
  // API service instance
  final ApiServices _apiService = ApiServices();
  final AppConfig _config = AppConfig.instance;

  // Observable variables
  var isLoading = false.obs;
  var stockItems = <StockItem>[].obs;
  var filteredItems = <StockItem>[].obs;

  // Lazy loading variables
  var displayedItems = <StockItem>[].obs;
  var hasMoreItems = false.obs;
  var currentPage = 0.obs;
  static const int itemsPerPage = 20;

  // Filter and search variables
  var selectedFilter = 'All'.obs;
  var searchQuery = ''.obs;
  var selectedSort = 'Model Name'.obs;
  final TextEditingController searchController = TextEditingController();

  // Company information
  var companyName = ''.obs;

  // Debounce timer for search
  Timer? _debounceTimer;
  static const Duration _debounceDuration = Duration(milliseconds: 500);

  // Filter and sort options
  final List<String> filterOptions = [
    'All',
    'In Stock',
    'Low Stock',
    'Out of Stock',
  ];

  final List<String> sortOptions = [
    'Model Name',
    'Stock (High to Low)',
    'Stock (Low to High)',
    'Price (High to Low)',
    'Price (Low to High)',
    'Recently Added',
  ];

  @override
  void onInit() {
    super.onInit();
    // Listen to changes in filter, search, and sort
    ever(selectedFilter, (_) => _updateFilteredItems());
    ever(searchQuery, (_) => _updateFilteredItems());
    ever(selectedSort, (_) => _updateFilteredItems());
    ever(stockItems, (_) => _updateFilteredItems());
    ever(filteredItems, (_) => _updateDisplayedItems());
  }

  @override
  void onClose() {
    searchController.dispose();
    _debounceTimer?.cancel();
    super.onClose();
  }

  // Initialize with company data
  void initializeWithCompany(String company, List<StockItem> items) {
    companyName.value = company;
    stockItems.value = items;
    _updateFilteredItems();
  }

  // Fetch stock items from API
  Future<void> fetchStockItems(String company) async {
    try {
      isLoading.value = true;
      companyName.value = company;

      dio.Response? response = await _apiService.requestGetForApi(
        url: '${_config.baseUrl}/inventory/filter?company=$company',
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final data =
            response.data is String
                ? json.decode(response.data)
                : response.data;

        List<dynamic> stockList;
        if (data is Map<String, dynamic> && data.containsKey('payload')) {
          stockList = data['payload'] as List<dynamic>;
        } else if (data is List<dynamic>) {
          stockList = data;
        } else {
          throw Exception('Unexpected response format');
        }

        stockItems.value =
            stockList.map((json) => StockItem.fromJson(json)).toList();

        log("Stock items loaded successfully for $company");
        log("Total items: ${stockItems.length}");
      }
    } catch (error) {
      log("❌ Error in fetchStockItems: $error");
      Get.snackbar('Error', 'Failed to fetch stock items');
    } finally {
      isLoading.value = false;
    }
  }

  // Update search query with debouncing
  void updateSearchQueryWithDebounce(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      searchQuery.value = query;
    });
  }

  // Update search query immediately
  void updateSearchQuery(String query) {
    searchQuery.value = query;
  }

  // Update filter
  void updateFilter(String filter) {
    selectedFilter.value = filter;
  }

  // Update sort
  void updateSort(String sort) {
    selectedSort.value = sort;
  }

  // Private method to update filtered items
  void _updateFilteredItems() {
    List<StockItem> items = List.from(stockItems);

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      items =
          items
              .where(
                (item) =>
                    item.model.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ||
                    item.color.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ),
              )
              .toList();
    }

    // Apply category filter
    if (selectedFilter.value != 'All') {
      items =
          items.where((item) {
            switch (selectedFilter.value) {
              case 'In Stock':
                return !item.isOutOfStock && !item.isLowStock;
              case 'Low Stock':
                return item.isLowStock && !item.isOutOfStock;
              case 'Out of Stock':
                return item.isOutOfStock;
              default:
                return true;
            }
          }).toList();
    }

    // Apply sorting
    items.sort((a, b) {
      switch (selectedSort.value) {
        case 'Model Name':
          return a.model.compareTo(b.model);
        case 'Stock (High to Low)':
          return b.qty.compareTo(a.qty);
        case 'Stock (Low to High)':
          return a.qty.compareTo(b.qty);
        case 'Price (High to Low)':
          return b.sellingPrice.compareTo(a.sellingPrice);
        case 'Price (Low to High)':
          return a.sellingPrice.compareTo(b.sellingPrice);
        case 'Recently Added':
          return b.dateCreated.compareTo(a.dateCreated);
        default:
          return 0;
      }
    });

    filteredItems.value = items;
  }

  // Update displayed items for lazy loading
  void _updateDisplayedItems() {
    currentPage.value = 0;

    if (filteredItems.isEmpty) {
      displayedItems.value = [];
      hasMoreItems.value = false;
      return;
    }

    final int endIndex = itemsPerPage.clamp(0, filteredItems.length);
    displayedItems.value = filteredItems.take(endIndex).toList();
    hasMoreItems.value = filteredItems.length > itemsPerPage;
  }

  // Load more items for pagination
  void loadMoreItems() {
    if (!hasMoreItems.value || isLoading.value) return;

    final int nextPage = currentPage.value + 1;
    final int startIndex = nextPage * itemsPerPage;
    final int endIndex = (startIndex + itemsPerPage).clamp(
      0,
      filteredItems.length,
    );

    if (startIndex < filteredItems.length) {
      final newItems = filteredItems.sublist(startIndex, endIndex);
      displayedItems.addAll(newItems);
      currentPage.value = nextPage;

      // Check if there are more items
      hasMoreItems.value = endIndex < filteredItems.length;
    } else {
      hasMoreItems.value = false;
    }
  }

  // Getters for UI
  int get totalStock => stockItems.fold(0, (sum, item) => sum + item.qty);

  int get lowStockCount =>
      stockItems.where((item) => item.isLowStock && !item.isOutOfStock).length;

  int get outOfStockCount =>
      stockItems.where((item) => item.isOutOfStock).length;

  Color get totalStockColor {
    if (totalStock == 0) return const Color(0xFFEF4444);
    if (totalStock < 50) return const Color(0xFFF59E0B);
    return const Color(0xFF10B981);
  }

  // Helper methods for UI
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
      'infinix': const Color(0xFF00D4FF),
    };
    return colors[company.toLowerCase()] ?? const Color(0xFF8B5CF6);
  }

  Color getColorForVariant(String color) {
    final colors = {
      'black': const Color(0xFF1F2937),
      'white': const Color(0xFF9CA3AF),
      'blue': const Color(0xFF3B82F6),
      'red': const Color(0xFFEF4444),
      'green': const Color(0xFF10B981),
      'grey': const Color(0xFF6B7280),
      'gray': const Color(0xFF6B7280),
      'gold': const Color(0xFFF59E0B),
      'silver': const Color(0xFF9CA3AF),
      'purple': const Color(0xFF8B5CF6),
      'pink': const Color(0xFFEC4899),
      'orange': const Color(0xFFF97316),
      'cyan': const Color(0xFF06B6D4),
      'navy': const Color(0xFF1E40AF),
      'skylight': const Color(0xFF0EA5E9),
      'cyber': const Color(0xFF1F2937),
    };

    for (String key in colors.keys) {
      if (color.toLowerCase().contains(key)) {
        return colors[key]!;
      }
    }
    return const Color(0xFF6B7280);
  }

  Color getStockStatusColor(StockItem item) {
    if (item.isOutOfStock) return const Color(0xFFEF4444);
    if (item.isLowStock) return const Color(0xFFF59E0B);
    return const Color(0xFF10B981);
  }

  IconData getStockStatusIcon(StockItem item) {
    if (item.isOutOfStock) return Icons.error;
    if (item.isLowStock) return Icons.warning;
    return Icons.check_circle;
  }

  Widget getFilterIcon(String filter) {
    switch (filter) {
      case 'All':
        return const Icon(Icons.apps, size: 16, color: Color(0xFF6B7280));
      case 'In Stock':
        return const Icon(
          Icons.check_circle,
          size: 16,
          color: Color(0xFF10B981),
        );
      case 'Low Stock':
        return const Icon(Icons.warning, size: 16, color: Color(0xFFF59E0B));
      case 'Out of Stock':
        return const Icon(Icons.error, size: 16, color: Color(0xFFEF4444));
      default:
        return const Icon(
          Icons.filter_list,
          size: 16,
          color: Color(0xFF6B7280),
        );
    }
  }

  // Action methods
  void updateStock(StockItem item) {
    // Implement update stock functionality
    log("Update stock for ${item.model}");
    // You can show a dialog or navigate to update screen
    Get.dialog(
      AlertDialog(
        title: Text('Update Stock'),
        content: Text('Update stock for ${item.model}?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              // Add your update stock logic here
              Get.back();
              Get.snackbar('Success', 'Stock updated successfully');
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  void sellItem(StockItem item) {
    // Implement sell functionality
    log("Sell ${item.model}");
    Get.dialog(
      AlertDialog(
        title: Text('Sell Item'),
        content: Text('Sell ${item.model}?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          TextButton(
            onPressed: () {
              // Add your sell logic here
              Get.back();
              Get.snackbar('Success', 'Item sold successfully');
            },
            child: Text('Sell'),
          ),
        ],
      ),
    );
  }

  void viewDetails(StockItem item) {
    // Implement view details functionality
    log("View details for ${item.model}");
    Get.dialog(
      AlertDialog(
        title: Text('Item Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Model: ${item.model}'),
            Text('Company: ${item.company}'),
            Text('Color: ${item.color}'),
            Text('RAM/ROM: ${item.ramRomDisplay}'),
            Text('Stock: ${item.qty}'),
            Text('Price: ${item.formattedPrice}'),
            Text('Status: ${item.stockStatus}'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Close')),
        ],
      ),
    );
  }

  void refreshData() {
    if (companyName.value.isNotEmpty) {
      fetchStockItems(companyName.value);
    }
  }

  // Method to reset filters
  void resetFilters() {
    selectedFilter.value = 'All';
    selectedSort.value = 'Model Name';
    searchController.clear();
    searchQuery.value = '';
  }

  // Method to apply multiple filters at once
  void applyFilters({String? filter, String? sort, String? search}) {
    if (filter != null) selectedFilter.value = filter;
    if (sort != null) selectedSort.value = sort;
    if (search != null) {
      searchController.text = search;
      searchQuery.value = search;
    }
  }
}
