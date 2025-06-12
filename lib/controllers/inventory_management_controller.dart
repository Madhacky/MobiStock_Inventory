import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobistock/controllers/auth_controller.dart';
import 'package:mobistock/models/inventory%20management/inventory_item_model.dart';
import 'package:mobistock/services/api_services.dart';
import 'package:mobistock/services/app_config.dart';
import 'package:mobistock/services/secure_storage_service.dart';
import 'package:mobistock/services/shared_preferences_services.dart';
import 'package:mobistock/utils/sample_constants.dart';
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
  // Observable variables
  final RxList<InventoryItem> inventoryItems = <InventoryItem>[].obs;
  final RxList<InventoryItem> allInventoryItems =
      <InventoryItem>[].obs; // Store all items
  final RxString selectedCompany = 'Select Com...'.obs;
  final RxString selectedModel = 'Select Model'.obs;
  final RxString selectedStockAvailability = 'Stock Availa...'.obs;
  final RxString selectedRAM = 'Select RAM'.obs;
  final RxString selectedROM = 'Select ROM'.obs;
  final RxString selectedColor = 'Select Color'.obs;
  final RxInt itemsPerPage = 10.obs;
  final RxInt currentPage = 0.obs; // Add current page tracking
  final RxBool isLoading = false.obs;

  // Statistics
  final RxInt totalStock = 186.obs;
  final RxInt totalCompanies = 19.obs;
  final RxInt lowStockAlert = 40.obs;
  final RxInt phonesSold = 67.obs;

  // Filter options
  final RxList<String> companies =
      ['Apple', 'Samsung', 'OnePlus', 'Xiaomi', 'Vivo', 'Oppo'].obs;
  final RxList<String> models =
      ['iPhone 14', 'Galaxy S23', 'OnePlus 11', 'Mi 13', 'V27 Pro'].obs;
  final RxList<String> stockOptions =
      ['In Stock', 'Low Stock', 'Out of Stock'].obs;
  final RxList<String> ramOptions = ['4GB', '6GB', '8GB', '12GB', '16GB'].obs;
  final RxList<String> romOptions =
      ['64GB', '128GB', '256GB', '512GB', '1TB'].obs;
  final RxList<String> colorOptions =
      ['Black', 'White', 'Blue', 'Red', 'Gold', 'Silver'].obs;

  // Computed properties for pagination
  int get totalPages => (filteredItems.length / itemsPerPage.value).ceil();
  int get totalItems => filteredItems.length;

  // Get filtered items based on current filters
  List<InventoryItem> get filteredItems {
    List<InventoryItem> filtered = List.from(allInventoryItems);

    if (selectedCompany.value != 'Select Com...') {
      filtered =
          filtered
              .where(
                (item) => item.company.toLowerCase().contains(
                  selectedCompany.value.toLowerCase(),
                ),
              )
              .toList();
    }

    if (selectedModel.value != 'Select Model') {
      filtered =
          filtered
              .where(
                (item) => item.model.toLowerCase().contains(
                  selectedModel.value.toLowerCase(),
                ),
              )
              .toList();
    }

    if (selectedColor.value != 'Select Color') {
      filtered =
          filtered
              .where(
                (item) => item.color.toLowerCase().contains(
                  selectedColor.value.toLowerCase(),
                ),
              )
              .toList();
    }

    return filtered;
  }

  // PlutoGrid Columns
  List<PlutoColumn> get columns => [
    PlutoColumn(
      title: 'ID',
      field: 'id',
      type: PlutoColumnType.text(),
      width: 80,
      minWidth: 60,
      enableSorting: true,
      enableColumnDrag: false,
      enableContextMenu: false,
      textAlign: PlutoColumnTextAlign.center,
    ),
    PlutoColumn(
      title: 'LOGO',
      field: 'logo',
      type: PlutoColumnType.text(),
      width: 80,
      minWidth: 60,
      enableSorting: false,
      enableColumnDrag: false,
      enableContextMenu: false,
      textAlign: PlutoColumnTextAlign.center,
    ),
    PlutoColumn(
      title: 'MODEL',
      field: 'model',
      type: PlutoColumnType.text(),
      width: 180,
      minWidth: 150,
      enableSorting: true,
      enableColumnDrag: false,
      enableContextMenu: false,
    ),
    PlutoColumn(
      title: 'RAM/ROM',
      field: 'ramRom',
      type: PlutoColumnType.text(),
      width: 120,
      minWidth: 100,
      enableSorting: true,
      enableColumnDrag: false,
      enableContextMenu: false,
      textAlign: PlutoColumnTextAlign.center,
    ),
    PlutoColumn(
      title: 'COLOR',
      field: 'color',
      type: PlutoColumnType.text(),
      width: 120,
      minWidth: 100,
      enableSorting: true,
      enableColumnDrag: false,
      enableContextMenu: false,
    ),
    PlutoColumn(
      title: 'SELLING PRICE',
      field: 'sellingPrice',
      type: PlutoColumnType.currency(symbol: '\$'),
      width: 140,
      minWidth: 120,
      enableSorting: true,
      enableColumnDrag: false,
      enableContextMenu: false,
      textAlign: PlutoColumnTextAlign.right,
    ),
    PlutoColumn(
      title: 'QUANTITY',
      field: 'quantity',
      type: PlutoColumnType.number(),
      width: 100,
      minWidth: 80,
      enableSorting: true,
      enableColumnDrag: false,
      enableContextMenu: false,
      textAlign: PlutoColumnTextAlign.center,
    ),
    PlutoColumn(
      title: 'COMPANY',
      field: 'company',
      type: PlutoColumnType.text(),
      width: 140,
      minWidth: 120,
      enableSorting: true,
      enableColumnDrag: false,
      enableContextMenu: false,
    ),
    PlutoColumn(
      title: 'ACTION',
      field: 'action',
      type: PlutoColumnType.text(),
      width: 100,
      minWidth: 80,
      enableSorting: false,
      enableColumnDrag: false,
      enableContextMenu: false,
      textAlign: PlutoColumnTextAlign.center,
      renderer: (rendererContext) {
        return Container(
          padding: EdgeInsets.all(4),
          child: PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, size: 16, color: Colors.grey[600]),
            onSelected: (String action) {
              final rowIdx = rendererContext.rowIdx;
              final item = inventoryItems[rowIdx];
              if (action == 'edit') {
                editItem(item);
              } else if (action == 'delete') {
                deleteItem(item.id.toString(), rowIdx);
              }
            },
            itemBuilder:
                (BuildContext context) => [
                  PopupMenuItem<String>(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 16, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Edit', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
          ),
        );
      },
    ),
  ];

  // PlutoGrid Rows - now returns paginated data
  List<PlutoRow> get rows {
    List<InventoryItem> paginatedItems = getPaginatedItems();
    return paginatedItems.map((item) {
      return PlutoRow(
        cells: {
          'id': PlutoCell(value: item.id),
          'logo': PlutoCell(value: item.logo),
          'model': PlutoCell(value: item.model),
          'ramRom': PlutoCell(value: item.ramRom),
          'color': PlutoCell(value: item.color),
          'sellingPrice': PlutoCell(value: item.sellingPrice),
          'quantity': PlutoCell(value: item.quantity),
          'company': PlutoCell(value: item.company),
          'action': PlutoCell(value: ''),
        },
      );
    }).toList();
  }

  // Get items for current page
  List<InventoryItem> getPaginatedItems() {
    List<InventoryItem> filtered = filteredItems;
    int startIndex = currentPage.value * itemsPerPage.value;
    int endIndex = (startIndex + itemsPerPage.value).clamp(0, filtered.length);

    if (startIndex >= filtered.length) {
      return [];
    }

    List<InventoryItem> paginatedItems = filtered.sublist(startIndex, endIndex);
    inventoryItems.assignAll(paginatedItems); // Update displayed items
    return paginatedItems;
  }

  @override
  void onInit() {
    super.onInit();
    fetchInventoryData();
  }

  void updateGridData() {
    if (stateManager != null) {
      stateManager!.removeAllRows();
      stateManager!.appendRows(rows);
    }
  }

  void onLoaded(PlutoGridOnLoadedEvent event) {
    stateManager = event.stateManager;
    stateManager!.setShowColumnFilter(true);
    // Don't use setPageSize here as we're handling pagination manually
  }

  void applyFilters() {
    currentPage.value = 0; // Reset to first page when filtering
    updateGridData();
  }

  void clearFilters() {
    selectedCompany.value = 'Select Com...';
    selectedModel.value = 'Select Model';
    selectedStockAvailability.value = 'Stock Availa...';
    selectedRAM.value = 'Select RAM';
    selectedROM.value = 'Select ROM';
    selectedColor.value = 'Select Color';

    currentPage.value = 0; // Reset to first page
    updateGridData();
  }

  // Pagination methods
  void onPageSizeChanged(int pageSize) {
    itemsPerPage.value = pageSize;
    currentPage.value = 0; // Reset to first page
    updateGridData();
  }

  void nextPage() {
    if (currentPage.value < totalPages - 1) {
      currentPage.value++;
      updateGridData();
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
      updateGridData();
    }
  }

  void goToPage(int page) {
    if (page >= 0 && page < totalPages) {
      currentPage.value = page;
      updateGridData();
    }
  }

  void addNewStock() {
    // Navigate to add stock screen
    Get.toNamed('/add-stock');
  }

  void bulkUpload() {
    // Handle bulk upload functionality
    Get.snackbar('Bulk Upload', 'Bulk upload functionality coming soon!');
  }

  // Add this to your controller
  Future<void> onRetry() async {
    await retryFetchInventoryData();
  }

  void exportData() {
    // Handle export functionality - can export PlutoGrid data
    if (stateManager != null) {
      // You can implement CSV export here
      final csvData = _generateCSV();
      Get.snackbar('Export', 'CSV data exported successfully!');
      print(csvData); // In real app, save to file or share
    }
  }

  String _generateCSV() {
    if (stateManager == null) return '';

    final headers = columns.map((col) => col.title).join(',');
    final rows = stateManager!.rows
        .map((row) {
          return columns
              .map((col) => row.cells[col.field]?.value?.toString() ?? '')
              .join(',');
        })
        .join('\n');

    return '$headers\n$rows';
  }

  void editItem(InventoryItem item) {
    // Navigate to edit screen
    Get.toNamed('/edit-stock', arguments: item);
  }

  void deleteItem(String itemId, int rowIndex) {
    Get.defaultDialog(
      title: 'Delete Item',
      middleText: 'Are you sure you want to delete this item?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      buttonColor: Colors.red,
      onConfirm: () {
        // Remove from all items
        allInventoryItems.removeWhere((item) => item.id == itemId);
        // Update grid
        updateGridData();
        Get.back();
        Get.snackbar('Deleted', 'Item deleted successfully');
      },
    );
  }

  //APIs
  //fetch inventory data
  RxBool isInventoryDataLoading = false.obs;
  var inventoryDataerrorMessage = ''.obs;
  var hasInventoryDataError = false.obs;
  // Future<void> fetchInventoryData() async {
  //   try {
  //     isInventoryDataLoading.value = true;
  //     hasInventoryDataError.value = false;
  //     inventoryDataerrorMessage.value = '';

  //     await Future.delayed(Duration(seconds: 1)); // simulate loading
  //     final jsessionId = await SharedPreferencesHelper.getJSessionId();
  //     log("jssessiom id :$jsessionId");
  //     dio.Response? response = await _apiService.requestGetWithJSessionId(
  //       url: _config.getInventoryData,
  //       authToken: true,
  //       jsessionId: jsessionId!,
  //     );

  //     if (response != null && response.statusCode == 200) {
  //       final data =
  //           response.data is String
  //               ? json.decode(response.data)
  //               : response.data;

  //       final List<dynamic> jsonList = data['payload']['content'];

  //       inventoryItems.value =
  //           jsonList.map((item) => InventoryItem.fromJson(item)).toList();
  //       allInventoryItems.assignAll([...inventoryItems]);
  //       log("Items loaded: ${inventoryItems.length}");

  //       // Reset pagination
  //       currentPage.value = 0;
  //       updateGridData();
  //       log("Items loaded: ${inventoryItems.length}");
  //     } else {
  //       hasInventoryDataError.value = true;
  //       inventoryDataerrorMessage.value =
  //           'Failed to fetch data. Status: ${response?.statusCode}';
  //     }
  //   } catch (error) {
  //     hasInventoryDataError.value = true;
  //     inventoryDataerrorMessage.value = 'Error: $error';
  //   } finally {
  //     isInventoryDataLoading.value = false;
  //   }
  // }

  Future<void> fetchInventoryData() async {
    try {
      isInventoryDataLoading.value = true;
      hasInventoryDataError.value = false;
      inventoryDataerrorMessage.value = '';

      await Future.delayed(Duration(seconds: 1)); // simulate loading

      // Get JSESSIONID from SecureStorage (not SharedPreferences)
      final jsessionId = await SecureStorageHelper.getJSessionId();
      log("jsessionId: $jsessionId");

      if (jsessionId == null || jsessionId.isEmpty) {
        hasInventoryDataError.value = true;
        inventoryDataerrorMessage.value =
            'No session found. Please login again.';
        return;
      }

      // Make the API call - the method will automatically use the latest session
      dio.Response? response = await _apiService.requestGetWithJSessionId(
        url: _config.getInventoryData,
        authToken: true,
        // No need to pass jsessionId - it will get the latest from storage
      );

      if (response != null) {
        if (response.statusCode == 200) {
          final data =
              response.data is String
                  ? json.decode(response.data)
                  : response.data;

          final List<dynamic> jsonList = data['payload']['content'];

          inventoryItems.value =
              jsonList.map((item) => InventoryItem.fromJson(item)).toList();
          allInventoryItems.assignAll([...inventoryItems]);
          log("Items loaded: ${inventoryItems.length}");

          // Reset pagination
          currentPage.value = 0;
          updateGridData();
          log("Items loaded: ${inventoryItems.length}");
        } else if (response.statusCode == 401 || response.statusCode == 403) {
          hasInventoryDataError.value = true;
          inventoryDataerrorMessage.value =
              'Session expired. Please login again.';
          // You might want to trigger re-login here
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

  // Helper method to handle session expiry
  Future<void> _handleSessionExpired() async {
    // Clear stored session
    await SecureStorageHelper.deleteJSessionId();

    // Navigate to login screen or show login dialog
    AuthController().logout(); // Replace with your login route

    // Or show a dialog asking user to re-login
    // _showReLoginDialog();
  }

  // Method to retry fetching data (useful for pull-to-refresh)
  Future<void> retryFetchInventoryData() async {
    // Check if we have a valid session
    if (await _apiService.isSessionValid()) {
      await fetchInventoryData();
    } else {
      hasInventoryDataError.value = true;
      inventoryDataerrorMessage.value = 'Please login again to continue.';
    }
  }
}
