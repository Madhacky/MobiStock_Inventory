import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobistock/models/customer%20management/chart/montly_new_customer_model.dart';
import 'package:mobistock/models/customer%20management/chart/top_customer_model.dart';
import 'package:mobistock/services/api_services.dart';
import 'package:mobistock/services/app_config.dart';
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

  // Customer statistics
  var totalCustomers = 12345.obs;
  var repeatedCustomers = 31.obs;
  var newCustomersThisMonth = 12.obs;
  var totalPurchases = 43.obs;

  // Customer data for Pluto Grid
  var allCustomers = <Map<String, dynamic>>[].obs;
  var filteredCustomers = <Map<String, dynamic>>[].obs;

  // Search and filters
  var searchQuery = ''.obs;
  var selectedFilter = 'All Customers'.obs;
  var filterOptions =
      [
        'All Customers',
        'New Customers',
        'Repeated Customers',
        'VIP Customers',
      ].obs;

  // Pluto Grid
  PlutoGridStateManager? plutoGridStateManager;
  List<PlutoColumn> columns = [];
  RxList<PlutoRow> rows = <PlutoRow>[].obs;
  var selectedCustomer = Rxn<Map<String, dynamic>>();

  @override
  void onInit() {
    super.onInit();
    _initializeColumns();
    loadCustomerData();
  }

  void _initializeColumns() {
    columns = [
      PlutoColumn(
        title: 'ID',
        field: 'id',
        type: PlutoColumnType.number(),
        width: 80,
        enableRowDrag: false,
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
          final customer = allCustomers.firstWhere(
            (c) =>
                c['id'].toString() ==
                rendererContext.row.cells['id']?.value.toString(),
            orElse: () => {},
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
                if (customer.isNotEmpty && customer['email'] != null)
                  Text(
                    customer['email'],
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
        title: 'Last Invoice',
        field: 'invoice',
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
        title: 'Amount',
        field: 'amount',
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
                color: amount > 3000 ? Color(0xFF51CF66) : Colors.black87,
              ),
            ),
          );
        },
      ),
      PlutoColumn(
        title: 'Last Purchase',
        field: 'date',
        type: PlutoColumnType.date(),
        width: 120,
        enableSorting: true,
        renderer: (rendererContext) {
          return Container(
            padding: EdgeInsets.all(8),
            alignment: Alignment.center,
            child: Text(
              rendererContext.cell.value.toString(),
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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

  Map<String, dynamic> _getCustomerFromRow(PlutoRow row) {
    return allCustomers.firstWhere(
      (customer) =>
          customer['id'].toString() == row.cells['id']?.value.toString(),
      orElse: () => {},
    );
  }

  void loadCustomerData() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      // Simulate API call
      await Future.delayed(Duration(seconds: 1));

      // Mock customer data with more comprehensive information
      allCustomers.value = [
        {
          'id': 1,
          'name': 'John Doe',
          'phone': '+91 98765 43210',
          'email': 'john.doe@email.com',
          'invoice': 'INV-1001',
          'amount': 2500,
          'date': '2024-06-10',
          'type': 'Regular',
          'address': '123 Main St, City',
          'purchaseCount': 5,
        },
        {
          'id': 2,
          'name': 'Jane Smith',
          'phone': '+91 98765 43211',
          'email': 'jane.smith@email.com',
          'invoice': 'INV-1002',
          'amount': 4300,
          'date': '2024-06-09',
          'type': 'VIP',
          'address': '456 Oak Ave, Town',
          'purchaseCount': 12,
        },
        {
          'id': 3,
          'name': 'Michael Johnson',
          'phone': '+91 98765 43212',
          'email': 'michael.j@email.com',
          'invoice': 'INV-1003',
          'amount': 1200,
          'date': '2024-06-08',
          'type': 'New',
          'address': '789 Pine Rd, Village',
          'purchaseCount': 1,
        },
        {
          'id': 4,
          'name': 'Emily Davis',
          'phone': '+91 98765 43213',
          'email': 'emily.davis@email.com',
          'invoice': 'INV-1004',
          'amount': 3100,
          'date': '2024-06-07',
          'type': 'Repeated',
          'address': '321 Elm St, District',
          'purchaseCount': 8,
        },
        {
          'id': 5,
          'name': 'Chris Wilson',
          'phone': '+91 98765 43214',
          'email': 'chris.wilson@email.com',
          'invoice': 'INV-1005',
          'amount': 2900,
          'date': '2024-06-06',
          'type': 'Regular',
          'address': '654 Maple Dr, County',
          'purchaseCount': 6,
        },
        {
          'id': 6,
          'name': 'Sarah Brown',
          'phone': '+91 98765 43215',
          'email': 'sarah.brown@email.com',
          'invoice': 'INV-1006',
          'amount': 1800,
          'date': '2024-06-05',
          'type': 'New',
          'address': '987 Cedar Ln, Area',
          'purchaseCount': 2,
        },
        {
          'id': 7,
          'name': 'David Miller',
          'phone': '+91 98765 43216',
          'email': 'david@hotmail.com',
          'invoice': 'INV-1006',
          'amount': 1800,
          'date': '2024-06-05',
          'type': 'New',
          'address': '987 Cedar Ln, Area',
          'purchaseCount': 2,
        },
        {
          'id': 8,
          'name': 'Laura Wilson',
          'phone': '+91 98765 43217',
          'email': 'laura.wilson@email.com',
          'invoice': 'INV-1008',
          'amount': 2300,
          'date': '2024-06-03',
          'type': 'Repeated',
          'address': '432 Birch Blvd, Area',
          'purchaseCount': 7,
        },
      ];

      // Initially filtered list is full list
      filteredCustomers.assignAll(allCustomers);

      _generateRows();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load customers';
    } finally {
      isLoading.value = false;
    }
  }

  void _generateRows() {
    rows.clear();
    for (var customer in filteredCustomers) {
      rows.add(
        PlutoRow(
          cells: {
            'id': PlutoCell(value: customer['id']),
            'name': PlutoCell(value: customer['name']),
            'phone': PlutoCell(value: customer['phone']),
            'invoice': PlutoCell(value: customer['invoice']),
            'amount': PlutoCell(value: customer['amount']),
            'date': PlutoCell(value: customer['date']),
            'type': PlutoCell(value: customer['type']),
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

    filteredCustomers.assignAll(
      allCustomers.where((customer) {
        final name = customer['name']?.toLowerCase() ?? '';
        final email = customer['email']?.toLowerCase() ?? '';
        final phone = customer['phone']?.toLowerCase() ?? '';
        final type = customer['type']?.toLowerCase() ?? '';

        final matchesQuery =
            name.contains(query) ||
            email.contains(query) ||
            phone.contains(query);

        final matchesType =
            selected == 'All Customers' ||
            (selected == 'New Customers' && type == 'new') ||
            (selected == 'Repeated Customers' && type == 'repeated') ||
            (selected == 'VIP Customers' && type == 'vip');

        return matchesQuery && matchesType;
      }),
    );

    _generateRows();
  }

  void viewCustomerDetails(Map<String, dynamic> customer) {
    selectedCustomer.value = customer;
    // Open detail view logic
    print('Viewing: ${customer['name']}');
  }

  void editCustomer(Map<String, dynamic> customer) {
    selectedCustomer.value = customer;
    // Navigate to edit screen
    print('Editing: ${customer['name']}');
  }

  void deleteCustomer(Map<String, dynamic> customer) {
    allCustomers.removeWhere((c) => c['id'] == customer['id']);
    filterCustomers();
    print('Deleted: ${customer['name']}');
  }

  String formatCurrency(int value) {
    return '₹${value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}';
  }

  //APIs

  //monthly new customer
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


  //village distributon
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
      final responseData = CustomerMonthlyDataResponse.fromJson(response.data);
      villageDistributionPayload.value = Map<String, double>.from(responseData.payload);
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
RxMap<String, double> monthlyRepeatCustomerPayload = RxMap<String, double>({});

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
      final responseData = CustomerMonthlyDataResponse.fromJson(response.data);
      monthlyRepeatCustomerPayload.value = Map<String, double>.from(responseData.payload);
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
RxList<Map<String, dynamic>> topCustomerChartData = <Map<String, dynamic>>[].obs;

Future<void> fetchTopCustomerChart() async {
  try {
    isTopCustomerChartLoading.value = true;
    hasTopCustomerChartError.value = false;
    topCustomerChartErrorMessage.value = '';

    await Future.delayed(Duration(seconds: 2)); // Simulated delay

    dio.Response? response = await _apiService.requestGetForApi(
      url: _config.getTopCustomerOverviewEndpoint, // your real endpoint
      authToken: true,
    );

    if (response != null && response.statusCode == 200) {
      final responseData = TopCustomersResponse.fromJson(response.data);

      // Transform response to List<Map<String, dynamic>>
      final List<Map<String, dynamic>> transformedList = responseData.payload.map((customer) {
        return {
          "name": customer.name,
          "totalSales": customer.totalSales,
        };
      }).toList();

      topCustomerChartData.assignAll(transformedList);
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



}
