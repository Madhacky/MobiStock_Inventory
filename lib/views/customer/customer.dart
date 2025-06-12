import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mobistock/routes/app_routes.dart';
import 'package:mobistock/views/inventory%20management/inventory_shimmer.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:mobistock/controllers/customer_controller.dart';
import 'package:mobistock/services/app_config.dart';
import 'package:mobistock/utils/app_styles.dart';
import 'package:mobistock/utils/custom_appbar.dart';
import 'package:mobistock/views/dashboard/widgets/error_cards.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class CustomerManagementScreen extends StatelessWidget {
  final CustomerController controller = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      floatingActionButton: buildFloatingActionButtons(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildCustomAppBar("Customer Management", isdark: true),
              _buildStatsCards(),
              _buildSearchAndFilters(),
              _buildCustomerAnalyticsCard(context),
              _buildCustomerDataGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: 3,
        itemBuilder: (context, index) {
          return Obx(() {
            final stats = [
              {
                'title': 'Total Customers',
                'value': controller.totalCustomers.value.toString(),
                'subtitle': 'Registered Customers',
                'icon': Icons.people,
                'color': Color(0xFF6C5CE7),
              },
              {
                'title': 'Repeated Customers',
                'value': controller.repeatedCustomers.value.toString(),
                'subtitle': 'Loyal Customers',
                'icon': Icons.refresh,
                'color': Color(0xFFFF9500),
              },
              {
                'title': 'New Customers This Month',
                'value': controller.newCustomersThisMonth.value.toString(),
                'subtitle': 'Monthly Growth',
                'icon': Icons.person_add,
                'color': Color(0xFF51CF66),
              },
              // {
              //   'title': 'Total Purchases',
              //   'value': controller.totalPurchases.value.toString(),
              //   'subtitle': 'Recent Activity',
              //   'icon': Icons.shopping_cart,
              //   'color': Color(0xFF00CEC9),
              // },
            ];

            return Container(
              width: 180,
              margin: EdgeInsets.only(right: index == 3 ? 0 : 12),
              child: _buildStatCard(
                stats[index]['title'] as String,
                stats[index]['value'] as String,
                stats[index]['subtitle'] as String,
                stats[index]['icon'] as IconData,
                stats[index]['color'] as Color,
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search & Filters',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 40,
                  child: TextField(
                    // onChanged: controller.searchCustomers,
                    decoration: InputDecoration(
                      hintText: 'Search customers...',
                      hintStyle: TextStyle(fontSize: 12),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 18,
                        color: Color(0xFF6C5CE7),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Color(0xFF6C5CE7).withOpacity(0.3),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: Color(0xFF6C5CE7).withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Color(0xFF6C5CE7)),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                flex: 1,
                child: Obx(
                  () => Container(
                    height: 40,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFF6C5CE7).withOpacity(0.3),
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[50],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: controller.selectedFilter.value,
                        items:
                            controller.filterOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: 12),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            //  controller.applyFilter(newValue);
                          }
                        },
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF6C5CE7),
                          size: 18,
                        ),
                        isExpanded: true,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerAnalyticsCard(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.customerAnalytics);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 60,
              height: 70,
              child: Lottie.asset(
                'assets/customer analytics.json',
              ),
            ),
            SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Customer Analytics',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Tap to view engagement insights, repeat visits, and more.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),

            Icon(Icons.chevron_right, color: Colors.grey[500]),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerDataGrid() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0xFF6C5CE7).withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.people, color: Color(0xFF6C5CE7), size: 20),
                SizedBox(width: 8),
                Text(
                  'Customer Data',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Spacer(),
                Obx(
                  () => Text(
                    '${controller.filteredCustomers.length} customers',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
              ],
            ),
          ),

          // Pluto Grid
          Obx(() {
            if (controller.isLoading.value) {
              return SizedBox(
                height: 400,
                child: Center(
                  child:buildPlutoGridShimmer()
                ),
              );
            }

            if (controller.hasError.value) {
              return buildErrorCard(
                controller.errorMessage,
                AppConfig.screenWidth,
                400,
                AppConfig.isSmallScreen,
              );
            }

            return Container(
              height: 400,
              child: PlutoGrid(
                columns: controller.columns,
                rows: controller.rows,
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  controller.plutoGridStateManager = event.stateManager;
                  controller.plutoGridStateManager?.setShowColumnFilter(true);
                },
                // onChanged: (PlutoGridOnChangedEvent event) {
                //   controller.onGridChanged(event);
                // },
                // onSelected: (PlutoGridOnSelectedEvent event) {
                //   controller.onRowSelected(event);
                // },
                configuration: PlutoGridConfiguration(
                  style: PlutoGridStyleConfig(
                    gridBorderColor: Colors.grey[300]!,
                    gridBorderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    columnTextStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                    cellTextStyle: TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                    rowColor: Colors.white,
                    evenRowColor: Colors.grey[50],
                    activatedColor: Color(0xFF6C5CE7).withOpacity(0.1),
                    gridBackgroundColor: Colors.white,
                    borderColor: Colors.grey[200]!,
                    activatedBorderColor: Color(0xFF6C5CE7),
                    inactivatedBorderColor: Colors.grey[300]!,
                    iconColor: Colors.grey[600]!,
                    disabledIconColor: Colors.grey[400]!,
                    columnHeight: 45,
                    rowHeight: 50,
                  ),
                  columnFilter: PlutoGridColumnFilterConfig(
                    filters: const [...FilterHelper.defaultFilters],
                    resolveDefaultColumnFilter: (column, resolver) {
                      if (column.field == 'amount') {
                        return resolver<PlutoFilterTypeGreaterThan>()
                            as PlutoFilterType;
                      }
                      return resolver<PlutoFilterTypeContains>()
                          as PlutoFilterType;
                    },
                  ),
                  localeText: PlutoGridLocaleText(
                    filterColumn: 'Filter',
                    filterType: 'Type',
                    filterValue: 'Value',
                    filterAllColumns: 'All Columns',
                    filterContains: 'Contains',
                    filterEquals: 'Equals',
                    filterStartsWith: 'Starts with',
                    filterEndsWith: 'Ends with',
                    filterGreaterThan: 'Greater than',
                    filterGreaterThanOrEqualTo: 'Greater than or equal to',
                    filterLessThan: 'Less than',
                    filterLessThanOrEqualTo: 'Less than or equal to',
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget buildFloatingActionButtons() {
    return SpeedDial(
      icon: Icons.menu,
      activeIcon: Icons.close,
      backgroundColor: Color(0xFF6C5CE7),
      foregroundColor: Colors.white,
      children: [
        SpeedDialChild(
          child: Icon(Icons.person_add),
          label: 'Add New Customer',
          //  onTap: controller.addNewCustomer,
          backgroundColor: Color(0xFF6C5CE7),
        ),
        SpeedDialChild(
          child: Icon(Icons.edit),
          label: 'Edit Selected',
          // onTap: controller.editSelectedCustomer,
          backgroundColor: Color(0xFFFF9500),
        ),
        SpeedDialChild(
          child: Icon(Icons.delete),
          label: 'Delete Selected',
          // onTap: controller.deleteSelectedCustomer,
          backgroundColor: Color(0xFFE74C3C),
        ),
        SpeedDialChild(
          child: Icon(Icons.download),
          label: 'Export Data',
          //onTap: controller.exportCustomerData,
          backgroundColor: Color(0xFF00CEC9),
        ),
        SpeedDialChild(
          child: Icon(Icons.refresh),
          label: 'Refresh',
          //  onTap: controller.refreshData,
          backgroundColor: Color(0xFF51CF66),
        ),
      ],
    );
  }
}
