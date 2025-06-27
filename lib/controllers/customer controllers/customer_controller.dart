import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/models/customer%20management/chart/montly_new_customer_model.dart';
import 'package:smartbecho/models/customer%20management/chart/top_customer_model.dart';
import 'package:smartbecho/models/customer%20management/customer_data_model.dart';
import 'package:smartbecho/models/customer%20management/top_stats_card_model.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/services/api_services.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/views/customer/components/customer_card_view.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:dio/dio.dart' as dio;

class CustomerController extends GetxController {
  // API service instance
  final ApiServices _apiService = ApiServices();

  // App config instance
  final AppConfig _config = AppConfig.instance;

  // Observable variables for customer data
  var isLoading = false.obs;
  var hasError = false.obs;
  var errorMessage = ''.obs;

  // View toggle
  var isTableView = true.obs;

  // Customer statistics
  var totalCustomers = 0.obs;
  var repeatedCustomers = 0.obs;
  var newCustomersThisMonth = 0.obs;
  var totalPurchases = 0.obs;

  // API Customer data
  var apiCustomers = <Customer>[].obs;
  var filteredApiCustomers = <Customer>[].obs;

  // Pagination
  var currentPage = 0.obs;
  var totalPages = 0.obs;
  var totalElements = 0.obs;
  var pageSize = 10.obs;
  var isLoadingMore = false.obs;

  // Search and filters
  var searchQuery = ''.obs;
  var selectedFilter = 'All Customers'.obs;
  var filterOptions =
      [
        'All Customers',
        'New Customers',
        'Regular Customers',
        'Repeated Customers',
        'VIP Customers',
      ].obs;
  // Add this to your controller
  final RxBool isFiltersExpanded = false.obs;

  void toggleFiltersExpanded() {
    isFiltersExpanded.value = !isFiltersExpanded.value;
  }

  // Pluto Grid
  PlutoGridStateManager? plutoGridStateManager;
  List<PlutoColumn> columns = [];
  RxList<PlutoRow> rows = <PlutoRow>[].obs;
  var selectedCustomer = Rxn<Customer>();

  @override
  void onInit() {
    super.onInit();
    _initializeColumns();
    getTopCardStats();
    loadCustomersFromApi();
  }

  void toggleView() {
    isTableView.value = !isTableView.value;
  }

  void _initializeColumns() {
    columns = [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.number(),
        width: 80,
        enableRowDrag: false,
        hide: true,
        enableRowChecked: false,
        enableSorting: true,
        enableHideColumnMenuItem: false,
        renderer: (rendererContext) {
          return Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              rendererContext.cell.value.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6C5CE7),
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Customer Name',
        field: 'name',
        type: PlutoColumnType.text(),
        width: 180,
        enableSorting: true,
        renderer: (rendererContext) {
          final customer = apiCustomers.firstWhere(
            (c) =>
                c.id.toString() ==
                rendererContext.row.cells['id']?.value.toString(),
            orElse:
                () => Customer(
                  id: 0,
                  name: '',
                  primaryPhone: '',
                  primaryAddress: '',
                  location: '',
                  profilePhotoUrl: '',
                  alternatePhones: [],
                  totalDues: 0.0,
                  totalPurchase: 0.0,
                ),
          );

          return Container(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  rendererContext.cell.value.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (customer.id != 0)
                  Text(
                    customer.location,
                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Phone',
        field: 'phone',
        type: PlutoColumnType.text(),
        width: 130,
        enableSorting: true,
        renderer: (rendererContext) {
          return Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.centerLeft,
            child: Text(
              rendererContext.cell.value.toString(),
              style: TextStyle(fontSize: 12, color: Colors.black87),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Location',
        field: 'location',
        type: PlutoColumnType.text(),
        width: 120,
        enableSorting: true,
        renderer: (rendererContext) {
          return Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Color(0xFF6C5CE7).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                rendererContext.cell.value.toString(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF6C5CE7),
                ),
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Total Purchase',
        field: 'totalPurchase',
        type: PlutoColumnType.currency(symbol: '₹', decimalDigits: 0),
        width: 120,
        enableSorting: true,
        textAlign: PlutoColumnTextAlign.right,
        renderer: (rendererContext) {
          final amount = rendererContext.cell.value as num;
          return Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            child: Text(
              formatCurrency(amount.toInt()),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: amount > 20000 ? Color(0xFF51CF66) : Colors.black87,
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Total Dues',
        field: 'totalDues',
        type: PlutoColumnType.currency(symbol: '₹', decimalDigits: 0),
        width: 120,
        enableSorting: true,
        textAlign: PlutoColumnTextAlign.right,
        renderer: (rendererContext) {
          final amount = rendererContext.cell.value as num;
          return Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.centerRight,
            child: Text(
              formatCurrency(amount.toInt()),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: amount > 0 ? Color(0xFFE74C3C) : Colors.black87,
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Customer Type',
        field: 'type',
        type: PlutoColumnType.select(['New', 'Regular', 'VIP', 'Repeated']),
        width: 110,
        enableSorting: true,
        renderer: (rendererContext) {
          final type = rendererContext.cell.value.toString();
          Color typeColor;
          Color bgColor;

          switch (type) {
            case 'VIP':
              typeColor = Color(0xFFFF9500);
              bgColor = Color(0xFFFF9500).withOpacity(0.1);
              break;
            case 'Repeated':
              typeColor = Color(0xFF51CF66);
              bgColor = Color(0xFF51CF66).withOpacity(0.1);
              break;
            case 'Regular':
              typeColor = Color(0xFF00CEC9);
              bgColor = Color(0xFF00CEC9).withOpacity(0.1);
              break;
            default:
              typeColor = Color(0xFF6C5CE7);
              bgColor = Color(0xFF6C5CE7).withOpacity(0.1);
          }

          return Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                type,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: typeColor,
                ),
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Actions',
        field: 'actions',
        type: PlutoColumnType.text(),
        width: 120,
        enableSorting: false,
        enableColumnDrag: false,
        enableContextMenu: false,
        renderer: (rendererContext) {
          return Container(
            padding: EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    final customer = _getCustomerFromRow(rendererContext.row);
                    viewCustomerDetails(customer);
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Color(0xFF6C5CE7).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.visibility,
                      size: 16,
                      color: Color(0xFF6C5CE7),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    final customer = _getCustomerFromRow(rendererContext.row);
                    editCustomer(customer);
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Color(0xFFFF9500).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(Icons.edit, size: 16, color: Color(0xFFFF9500)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    final customer = _getCustomerFromRow(rendererContext.row);
                    deleteCustomer(customer);
                  },
                  child: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Color(0xFFE74C3C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(
                      Icons.delete,
                      size: 16,
                      color: Color(0xFFE74C3C),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ];
  }

  Customer _getCustomerFromRow(PlutoRow row) {
    return apiCustomers.firstWhere(
      (customer) => customer.id.toString() == row.cells['id']?.value.toString(),
      orElse:
          () => Customer(
            id: 0,
            name: '',
            primaryPhone: '',
            primaryAddress: '',
            location: '',
            profilePhotoUrl: '',
            alternatePhones: [],
            totalDues: 0.0,
            totalPurchase: 0.0,
          ),
    );
  }

  CustomerResponse? customerResponse;
  Future<void> loadCustomersFromApi({bool loadMore = false}) async {
    try {
      if (loadMore) {
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        hasError.value = false;
        currentPage.value = 0;
      }

      // Add your actual API endpoint here
      dio.Response? response = await _apiService.requestGetForApi(
        url:
            '${_config.baseUrl}/api/customers/all/paginated?page=${currentPage.value}&size=${pageSize.value}&sortBy=name&direction=asc',
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        customerResponse = CustomerResponse.fromJson(response.data);

        if (loadMore) {
          apiCustomers.addAll(customerResponse!.payload.content);
        } else {
          apiCustomers.assignAll(customerResponse!.payload.content);
        }

        // Update pagination info
        totalPages.value = customerResponse!.payload.totalPages;
        totalElements.value = customerResponse!.payload.totalElements;

        // Apply current filters
        filterCustomers();
      } else {
        hasError.value = true;
        errorMessage.value =
            'Failed to load customers. Status: ${response?.statusCode}';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Error loading customers: $e';
      log('Error loading customers: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  void loadMoreCustomers() {
    if (currentPage.value < totalPages.value - 1 && !isLoadingMore.value) {
      currentPage.value++;
      loadCustomersFromApi(loadMore: true);
    }
  }

  void _generateRows() {
    rows.clear();
    for (var customer in filteredApiCustomers) {
      rows.add(
        PlutoRow(
          cells: {
            'id': PlutoCell(value: customer.id),
            'name': PlutoCell(value: customer.name),
            'phone': PlutoCell(value: customer.primaryPhone),
            'location': PlutoCell(value: customer.location),
            'totalPurchase': PlutoCell(value: customer.totalPurchase),
            'totalDues': PlutoCell(value: customer.totalDues),
            'type': PlutoCell(value: customer.customerType),
            'actions': PlutoCell(value: ''), // Placeholder for actions
          },
        ),
      );
    }
    plutoGridStateManager?.notifyListeners();
  }

  void filterCustomers() {
    final query = searchQuery.value.toLowerCase();
    final selected = selectedFilter.value;

    filteredApiCustomers.assignAll(
      apiCustomers.where((customer) {
        final name = customer.name.toLowerCase();
        final phone = customer.primaryPhone.toLowerCase();
        final location = customer.location.toLowerCase();
        final address = customer.primaryAddress.toLowerCase();
        final type = customer.customerType.toLowerCase();

        final matchesQuery =
            name.contains(query) ||
            phone.contains(query) ||
            location.contains(query) ||
            address.contains(query);

        final matchesType =
            selected == 'All Customers' ||
            (selected == 'New Customers' && type == 'new') ||
            (selected == 'Regular Customers' && type == 'regular') ||
            (selected == 'Repeated Customers' && type == 'repeated') ||
            (selected == 'VIP Customers' && type == 'vip');

        return matchesQuery && matchesType;
      }),
    );

    _generateRows();
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    filterCustomers();
  }

  void onFilterChanged(String filter) {
    selectedFilter.value = filter;
    filterCustomers();
  }

  void viewCustomerDetails(Customer customer) {
    selectedCustomer.value = customer;
    // Navigate to detail view
    print('Viewing: ${customer.name}');
  }

  void editCustomer(Customer customer) {
    selectedCustomer.value = customer;
    // Navigate to edit screen
    print('Editing: ${customer.name}');
  }

  void deleteCustomer(Customer customer) {
    // Call delete API first, then update local data
    apiCustomers.removeWhere((c) => c.id == customer.id);
    filterCustomers();
    print('Deleted: ${customer.name}');
  }

  String formatCurrency(int value) {
    return '₹${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  void refreshData() {
    loadCustomersFromApi();
  }

  // Existing API methods for charts...
  RxBool isMonthlyNewCustomerChartLoading = false.obs;
  var monthlyNewCustomerCharterrorMessage = ''.obs;
  var hasMonthlyNewCustomerChartError = false.obs;
  RxMap<String, double> monthlyNewCustomerPayload = RxMap<String, double>({});

  Future<void> fetchMonthlyNewCustomerChart() async {
    try {
      isMonthlyNewCustomerChartLoading.value = true;
      hasMonthlyNewCustomerChartError.value = false;
      monthlyNewCustomerCharterrorMessage.value = '';

      dio.Response? response = await _apiService.requestGetForApi(
        url: _config.getMonthlyNewCustomerEndpoint,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final responseData = CustomerMonthlyDataResponse.fromJson(
          response.data,
        );
        monthlyNewCustomerPayload.value = Map<String, double>.from(
          responseData.payload,
        );
      } else {
        hasMonthlyNewCustomerChartError.value = true;
        monthlyNewCustomerCharterrorMessage.value =
            'Failed to fetch data. Status: ${response?.statusCode}';
      }
    } catch (error) {
      hasMonthlyNewCustomerChartError.value = true;
      monthlyNewCustomerCharterrorMessage.value = 'Error: $error';
    } finally {
      isMonthlyNewCustomerChartLoading.value = false;
    }
  }

  // Village distribution
  RxBool isVillageDistributionChartLoading = false.obs;
  var villageDistributionChartErrorMessage = ''.obs;
  var hasVillageDistributionChartError = false.obs;
  RxMap<String, double> villageDistributionPayload = RxMap<String, double>({});

  Future<void> fetchVillageDistributionChart() async {
    try {
      isVillageDistributionChartLoading.value = true;
      hasVillageDistributionChartError.value = false;
      villageDistributionChartErrorMessage.value = '';

      dio.Response? response = await _apiService.requestGetForApi(
        url: _config.getVillageDistributionEndpoint,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final responseData = CustomerMonthlyDataResponse.fromJson(
          response.data,
        );
        villageDistributionPayload.value = Map<String, double>.from(
          responseData.payload,
        );
      } else {
        hasVillageDistributionChartError.value = true;
        villageDistributionChartErrorMessage.value =
            'Failed to fetch data. Status: ${response?.statusCode}';
      }
    } catch (error) {
      hasVillageDistributionChartError.value = true;
      villageDistributionChartErrorMessage.value = 'Error: $error';
    } finally {
      isVillageDistributionChartLoading.value = false;
    }
  }

  // Monthly Repeat Customer
  RxBool isMonthlyRepeatCustomerChartLoading = false.obs;
  var monthlyRepeatCustomerChartErrorMessage = ''.obs;
  var hasMonthlyRepeatCustomerChartError = false.obs;
  RxMap<String, double> monthlyRepeatCustomerPayload = RxMap<String, double>(
    {},
  );

  Future<void> fetchMonthlyRepeatCustomerChart() async {
    try {
      isMonthlyRepeatCustomerChartLoading.value = true;
      hasMonthlyRepeatCustomerChartError.value = false;
      monthlyRepeatCustomerChartErrorMessage.value = '';

      dio.Response? response = await _apiService.requestGetForApi(
        url: _config.getMonthlyRepeatCustomerEndpoint,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final responseData = CustomerMonthlyDataResponse.fromJson(
          response.data,
        );
        monthlyRepeatCustomerPayload.value = Map<String, double>.from(
          responseData.payload,
        );
      } else {
        hasMonthlyRepeatCustomerChartError.value = true;
        monthlyRepeatCustomerChartErrorMessage.value =
            'Failed to fetch data. Status: ${response?.statusCode}';
      }
    } catch (error) {
      hasMonthlyRepeatCustomerChartError.value = true;
      monthlyRepeatCustomerChartErrorMessage.value = 'Error: $error';
    } finally {
      isMonthlyRepeatCustomerChartLoading.value = false;
    }
  }

  // Top Customer Overview
  RxBool isTopCustomerChartLoading = false.obs;
  var topCustomerChartErrorMessage = ''.obs;
  var hasTopCustomerChartError = false.obs;
  RxList<Map<String, dynamic>> topCustomerChartData =
      <Map<String, dynamic>>[].obs;

  Future<void> fetchTopCustomerChart() async {
    try {
      isTopCustomerChartLoading.value = true;
      hasTopCustomerChartError.value = false;
      topCustomerChartErrorMessage.value = '';

      dio.Response? response = await _apiService.requestGetForApi(
        url: _config.getTopCustomerOverviewEndpoint,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final responseData = TopCustomersResponse.fromJson(response.data);
        topCustomerChartData.value =
            responseData.payload
                .map(
                  (customer) => {
                    'customerId': customer.customerId,
                    'totalSales': customer.totalSales,
                    'name': customer.name,
                  },
                )
                .toList();
      } else {
        hasTopCustomerChartError.value = true;
        topCustomerChartErrorMessage.value =
            'Failed to fetch data. Status: ${response?.statusCode}';
      }
    } catch (error) {
      hasTopCustomerChartError.value = true;
      topCustomerChartErrorMessage.value = 'Error: $error';
    } finally {
      isTopCustomerChartLoading.value = false;
    }
  }

  // Additional utility methods
  void sortCustomersByName() {
    apiCustomers.sort((a, b) => a.name.compareTo(b.name));
    filterCustomers();
  }

  void sortCustomersByPurchase() {
    apiCustomers.sort((a, b) => b.totalPurchase.compareTo(a.totalPurchase));
    filterCustomers();
  }

  void sortCustomersByDues() {
    apiCustomers.sort((a, b) => b.totalDues.compareTo(a.totalDues));
    filterCustomers();
  }

  // Export functionality
  Future<void> exportCustomersToCSV() async {
    try {
      // Implementation for CSV export
      List<List<String>> csvData = [
        [
          'ID',
          'Name',
          'Phone',
          'Location',
          'Total Purchase',
          'Total Dues',
          'Type',
        ],
      ];

      for (var customer in filteredApiCustomers) {
        csvData.add([
          customer.id.toString(),
          customer.name,
          customer.primaryPhone,
          customer.location,
          customer.totalPurchase.toString(),
          customer.totalDues.toString(),
          customer.customerType,
        ]);
      }

      // Here you would implement the actual CSV export logic
      print('Exporting ${csvData.length - 1} customers to CSV');
    } catch (e) {
      print('Error exporting to CSV: $e');
    }
  }

  //go to all customer screen
  void gotoAllCustomerPage() {
    Get.toNamed(AppRoutes.customerDetails);
  }

  // Bulk operations
  Future<void> bulkDeleteCustomers(List<int> customerIds) async {
    try {
      isLoading.value = true;

      for (int id in customerIds) {
        dio.Response? response = await _apiService.requestPostForApi(
          url: '${_config.baseUrl}/customers/$id',
          authToken: true,
          dictParameter: {},
        );

        if (response?.statusCode == 200) {
          apiCustomers.removeWhere((customer) => customer.id == id);
        }
      }

      filterCustomers();
    } catch (e) {
      print('Error in bulk delete: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Customer creation
  Future<bool> createCustomer(Map<String, dynamic> customerData) async {
    try {
      isLoading.value = true;

      dio.Response? response = await _apiService.requestPostForApi(
        url: '${_config.baseUrl}/customers',
        dictParameter: customerData,
        authToken: true,
      );

      if (response != null && response.statusCode == 201) {
        // Refresh the customer list
        await loadCustomersFromApi();
        return true;
      }
      return false;
    } catch (e) {
      print('Error creating customer: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Customer update
  Future<bool> updateCustomer(
    int customerId,
    Map<String, dynamic> customerData,
  ) async {
    try {
      isLoading.value = true;

      dio.Response? response = await _apiService.requestPostForApi(
        url: '${_config.baseUrl}/customers/$customerId',
        dictParameter: customerData,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        // Update local data
        final index = apiCustomers.indexWhere(
          (customer) => customer.id == customerId,
        );
        if (index != -1) {
          // Update the customer in the list
          await loadCustomersFromApi();
        }
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating customer: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Customer details by ID
  Future<Customer?> getCustomerById(int customerId) async {
    try {
      dio.Response? response = await _apiService.requestGetForApi(
        url: '${_config.baseUrl}/customers/$customerId',
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        return Customer.fromJson(response.data['payload']);
      }
      return null;
    } catch (e) {
      print('Error fetching customer by ID: $e');
      return null;
    }
  }

  //get top cards stats
  Future getTopCardStats() async {
    try {
      dio.Response? response = await _apiService.requestGetForApi(
        url: _config.getTopStatsCardsDataEndpoint,
        authToken: true,
      );

      if (response != null && response.statusCode == 200) {
        final cardData = CustomerStatsResponse.fromJson(response.data);
        totalCustomers.value = cardData.payload.totalCustomers;
        repeatedCustomers.value = cardData.payload.repeatedCustomers;
        newCustomersThisMonth.value = cardData.payload.newCustomersThisMonth;
      }
      return null;
    } catch (e) {
      print('Error fetching customer by ID: $e');
      return null;
    }
  }

  // Advanced search with multiple criteria
  void advancedSearch({
    String? name,
    String? phone,
    String? location,
    String? customerType,
    double? minPurchase,
    double? maxPurchase,
    double? minDues,
    double? maxDues,
  }) {
    filteredApiCustomers.assignAll(
      apiCustomers.where((customer) {
        bool matches = true;

        if (name != null && name.isNotEmpty) {
          matches =
              matches &&
              customer.name.toLowerCase().contains(name.toLowerCase());
        }

        if (phone != null && phone.isNotEmpty) {
          matches = matches && customer.primaryPhone.contains(phone);
        }

        if (location != null && location.isNotEmpty) {
          matches =
              matches &&
              customer.location.toLowerCase().contains(location.toLowerCase());
        }

        if (customerType != null &&
            customerType.isNotEmpty &&
            customerType != 'All') {
          matches =
              matches &&
              customer.customerType.toLowerCase() == customerType.toLowerCase();
        }

        if (minPurchase != null) {
          matches = matches && customer.totalPurchase >= minPurchase;
        }

        if (maxPurchase != null) {
          matches = matches && customer.totalPurchase <= maxPurchase;
        }

        if (minDues != null) {
          matches = matches && customer.totalDues >= minDues;
        }

        if (maxDues != null) {
          matches = matches && customer.totalDues <= maxDues;
        }

        return matches;
      }),
    );

    _generateRows();
  }

  // Reset all filters
  void resetFilters() {
    searchQuery.value = '';
    selectedFilter.value = 'All Customers';
    filteredApiCustomers.assignAll(apiCustomers);
    _generateRows();
  }

  // Method to handle PlutoGrid state manager
  void onPlutoGridLoaded(PlutoGridOnLoadedEvent event) {
    plutoGridStateManager = event.stateManager;
    _generateRows();
  }

  // Method to handle row selection
  void onRowSelected(PlutoGridOnSelectedEvent event) {
    if (event.row != null) {
      final customer = _getCustomerFromRow(event.row!);
      selectedCustomer.value = customer;
    }
  }

  // Method to handle double tap on row
  void onRowDoubleTap(PlutoGridOnRowDoubleTapEvent event) {
    final customer = _getCustomerFromRow(event.row);
    viewCustomerDetails(customer);
  }
}
