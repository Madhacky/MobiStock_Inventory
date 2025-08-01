import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/views/inventory/widgets/inventory_shimmer.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:smartbecho/controllers/customer%20controllers/customer_controller.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:smartbecho/utils/custom_appbar.dart';
import 'package:smartbecho/views/dashboard/widgets/error_cards.dart';
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
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              buildCustomAppBar("Customer Management", isdark: true),
              _buildStatsCards(),
              _buildAdvancedSearchAndFilters(),
              _buildCustomerAnalyticsCard(context),
              _buildCustomerDataGrid(),
              _buildLoadMoreButton(),
            ],
          ),
        ),
      ),
    );
  }

 // Update your _buildStatsCards method in CustomerManagementScreen

Widget _buildStatsCards() {
  return Container(
    height: 130,
    margin: EdgeInsets.symmetric(vertical: 5),
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
              'icon': Icons.people_outline,
              'color': Color(0xFF6C5CE7),
              'trend': '+12%',
              'trendUp': true,
              'onTap': () => print('Total customers tapped'),
            },
            {
              'title': 'Repeat Customers',
              'value': controller.repeatedCustomers.value.toString(),
              'icon': Icons.refresh_outlined,
              'color': Color(0xFFFF9500),
              'trend': '+8%',
              'trendUp': true,
              'onTap': () => controller.showRepeatedCustomersModal(),
            },
            {
              'title': 'New This Month',
              'value': controller.newCustomersThisMonth.value.toString(),
              'icon': Icons.person_add_outlined,
              'color': Color(0xFF51CF66),
              'trend': '+24%',
              'trendUp': true,
              'onTap': () => print('New this month tapped'),
            },
          ];

          return Container(
            width: 200,
            margin: EdgeInsets.only(right: index == 3 ? 0 : 12),
            child: _buildEnhancedStatCard(
              stats[index]['title'] as String,
              stats[index]['value'] as String,
              stats[index]['icon'] as IconData,
              stats[index]['color'] as Color,
              stats[index]['trend'] as String,
              stats[index]['trendUp'] as bool,
              stats[index]['onTap'] as VoidCallback,
            ),
          );
        });
      },
    ),
  );
}

// Update your _buildEnhancedStatCard method to include tap functionality

Widget _buildEnhancedStatCard(
  String title,
  String value,
  IconData icon,
  Color color,
  String trend,
  bool trendUp,
  VoidCallback onTap,
) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color:
                      trendUp
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trendUp ? Icons.trending_up : Icons.trending_down,
                      size: 12,
                      color: trendUp ? Colors.green : Colors.red,
                    ),
                    SizedBox(width: 2),
                    Text(
                      trend,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: trendUp ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    ),
  );
}

  Widget _buildAdvancedSearchAndFilters() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with expand/collapse functionality
          InkWell(
            onTap: () => controller.toggleFiltersExpanded(),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                
                  Text(
                    'Search & Filters',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  // Active filter indicator
                  Obx(() {
                    bool hasActiveFilters =
                        controller.searchQuery.value.isNotEmpty ||
                        controller.selectedFilter.value != 'All Customers';

                    return hasActiveFilters
                        ? Container(
                          margin: EdgeInsets.only(left: 8),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Color(0xFF6C5CE7),
                            shape: BoxShape.circle,
                          ),
                        )
                        : SizedBox();
                  }),

                  Spacer(),

                  Obx(() {
                    bool hasActiveFilters =
                        controller.searchQuery.value.isNotEmpty ||
                        controller.selectedFilter.value != 'All Customers';

                    return (controller.isFiltersExpanded.value ||
                            hasActiveFilters)
                        ? TextButton.icon(
                          onPressed: () => controller.resetFilters(),
                          icon: Icon(Icons.clear_all, size: 14),
                          label: Text('Clear', style: TextStyle(fontSize: 11)),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.grey[600],
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                        )
                        : SizedBox();
                  }),

                  SizedBox(width: 8),

                  // Expand/collapse arrow
                  Obx(
                    () => AnimatedRotation(
                      turns: controller.isFiltersExpanded.value ? 0.5 : 0,
                      duration: Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Collapsible content
          Obx(
            () => AnimatedContainer(
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              height: controller.isFiltersExpanded.value ? null : 0,
              child:
                  controller.isFiltersExpanded.value
                      ? Container(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 16,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(color: Colors.grey[200], height: 1),
                            SizedBox(height: 16),

                            // Search bar with enhanced design
                            Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                ),
                              ),
                              child: TextField(
                                onChanged: controller.onSearchChanged,
                                decoration: InputDecoration(
                                  hintText:
                                      'Search by name, phone, location...',
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[500],
                                  ),
                                  prefixIcon: Container(
                                    padding: EdgeInsets.all(10),
                                    child: Icon(
                                      Icons.search,
                                      size: 18,
                                      color: Color(0xFF6C5CE7),
                                    ),
                                  ),
                                  suffixIcon: Obx(
                                    () =>
                                        controller.searchQuery.value.isNotEmpty
                                            ? IconButton(
                                              onPressed: () {
                                                controller.searchQuery.value =
                                                    '';
                                                controller.filterCustomers();
                                              },
                                              icon: Icon(
                                                Icons.clear,
                                                size: 16,
                                                color: Colors.grey[400],
                                              ),
                                            )
                                            : SizedBox(),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 12),

                            // Filter chips
                            Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [
                                _buildFilterChip('All', 'All Customers'),
                                _buildFilterChip('New', 'New Customers'),
                                _buildFilterChip(
                                  'Regular',
                                  'Regular Customers',
                                ),
                                _buildFilterChip(
                                  'Repeated',
                                  'Repeated Customers',
                                ),
                                _buildFilterChip('VIP', 'VIP Customers'),
                              ],
                            ),
                          ],
                        ),
                      )
                      : SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    return Obx(
      () => FilterChip(
        label: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color:
                controller.selectedFilter.value == value
                    ? Colors.white
                    : Colors.grey[700],
          ),
        ),
        selected: controller.selectedFilter.value == value,
        onSelected: (selected) => controller.onFilterChanged(value),
        selectedColor: Color(0xFF6C5CE7),
        backgroundColor: Colors.grey[100],
        checkmarkColor: Colors.white,
        side: BorderSide.none,
        elevation: 0,
        pressElevation: 1,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildCustomerAnalyticsCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFF8B7ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6C5CE7).withOpacity(0.3),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          /// Left Section: Analytics
          Expanded(
            child: InkWell(
              onTap: () => Get.toNamed(AppRoutes.customerAnalytics),
              borderRadius: BorderRadius.circular(16),
              child: Row(
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: Lottie.asset(
                      'assets/lottie/customer analytics.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Analytics',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Customer trends & growth',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// Divider between two sections
          Container(
            width: 1,
            height: 90,
            margin: EdgeInsets.symmetric(horizontal: 12),
            color: Colors.white.withOpacity(0.3),
          ),

          /// Right Section: Details
          Expanded(
            child: InkWell(
              onTap: () => Get.toNamed(AppRoutes.customerCardView),
              borderRadius: BorderRadius.circular(16),
              child: Row(
                children: [
                  Icon(Icons.person_outline, color: Colors.white, size: 32),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Card View',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'View all customer records',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerDataGrid() {
    return Container(
      margin: EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Enhanced Header
          Container(
            height: 60,
            padding: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              border: Border(
                bottom: BorderSide(color: Colors.grey[200]!, width: 1),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFF6C5CE7).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.people_outline,
                    color: Color(0xFF6C5CE7),
                    size: 20,
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Customer Database',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Obx(
                      () => Text(
                        '${controller.filteredApiCustomers.length} customers found',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => controller.refreshData(),
                      icon: Icon(Icons.refresh_outlined, size: 20),
                      tooltip: 'Refresh Data',
                    ),
                    IconButton(
                      onPressed: () => controller.exportCustomersToCSV(),
                      icon: Icon(Icons.download_outlined, size: 20),
                      tooltip: 'Export Data',
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Enhanced Pluto Grid
          Obx(() {
            if (controller.isLoading.value) {
              return Container(
                height: 400,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Color(0xFF6C5CE7),
                        strokeWidth: 3,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Loading customer data...',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (controller.hasError.value) {
              return Container(
                height: 400,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red[300],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Failed to load customer data',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        controller.errorMessage.value,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () => controller.refreshData(),
                        icon: Icon(Icons.refresh, size: 16),
                        label: Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6C5CE7),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (controller.filteredApiCustomers.isEmpty) {
              return Container(
                height: 400,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No customers found',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Try adjusting your search criteria or add new customers',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => print('Add Customer'),
                        icon: Icon(Icons.person_add, size: 16),
                        label: Text('Add First Customer'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6C5CE7),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Container(
              height: 500,
              child: PlutoGrid(
                columns: controller.columns,
                rows: controller.rows,
                onLoaded: (PlutoGridOnLoadedEvent event) {
                  controller.plutoGridStateManager = event.stateManager;
                  controller.plutoGridStateManager?.setShowColumnFilter(true);
                },
                onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent event) {
                  // final customer = controller._getCustomerFromRow(event.row);
                  // controller.viewCustomerDetails(customer);
                },
                configuration: PlutoGridConfiguration(
                  style: PlutoGridStyleConfig(
                    gridBorderColor: Colors.grey[200]!,
                    gridBorderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    columnTextStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[700],
                    ),
                    cellTextStyle: TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                    rowColor: Colors.white,
                    evenRowColor: Colors.grey[25],
                    activatedColor: Color(0xFF6C5CE7).withOpacity(0.08),
                    gridBackgroundColor: Colors.white,
                    borderColor: Colors.grey[200]!,
                    activatedBorderColor: Color(0xFF6C5CE7),
                    inactivatedBorderColor: Colors.grey[300]!,
                    iconColor: Colors.grey[600]!,
                    disabledIconColor: Colors.grey[400]!,
                    columnHeight: 50,
                    rowHeight: 55,
                  ),
                  columnFilter: PlutoGridColumnFilterConfig(
                    filters: const [...FilterHelper.defaultFilters],
                    resolveDefaultColumnFilter: (column, resolver) {
                      if (column.field == 'totalPurchase' ||
                          column.field == 'totalDues') {
                        return resolver<PlutoFilterTypeGreaterThan>()
                            as PlutoFilterType;
                      }
                      return resolver<PlutoFilterTypeContains>()
                          as PlutoFilterType;
                    },
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Obx(() {
      if (controller.currentPage.value >= controller.totalPages.value - 1) {
        return SizedBox.shrink();
      }

      return Container(
        margin: EdgeInsets.fromLTRB(16, 0, 16, 20),
        width: double.infinity,
        child: ElevatedButton(
          onPressed:
              controller.isLoadingMore.value
                  ? null
                  : controller.loadMoreCustomers,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Color(0xFF6C5CE7),
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Color(0xFF6C5CE7).withOpacity(0.3)),
            ),
            elevation: 0,
          ),
          child:
              controller.isLoadingMore.value
                  ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Color(0xFF6C5CE7),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('Loading more customers...'),
                    ],
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.expand_more, size: 20),
                      SizedBox(width: 8),
                      Text('Load More Customers'),
                    ],
                  ),
        ),
      );
    });
  }

  Widget buildFloatingActionButtons() {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: Color(0xFF6C5CE7),
      foregroundColor: const Color.fromARGB(255, 219, 153, 153),
      overlayColor: Colors.black,
      overlayOpacity: 0.4,
      spacing: 12,
      spaceBetweenChildren: 12,
      buttonSize: Size(56, 56),
      childrenButtonSize: Size(56, 56),
      animationCurve: Curves.easeInOutCubic,
      animationDuration: Duration(milliseconds: 300),
      children: [
        SpeedDialChild(
          child: Icon(Icons.person_add_outlined, size: 24),
          label: 'Add New Customer',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          backgroundColor: Color(0xFF6C5CE7),
          foregroundColor: Colors.white,
          onTap: () => Get.toNamed(AppRoutes.addCustomer),
        ),
        SpeedDialChild(
          child: Icon(Icons.edit_outlined, size: 24),
          label: 'Edit Selected',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          backgroundColor: Color(0xFFFF9500),
          foregroundColor: Colors.white,
          onTap: () => print('Edit Customer'),
        ),
        SpeedDialChild(
          child: Icon(Icons.upload_file_outlined, size: 24),
          label: 'Import Data',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          backgroundColor: Color(0xFF00CEC9),
          foregroundColor: Colors.white,
          onTap: () => print('Import Data'),
        ),
        SpeedDialChild(
          child: Icon(Icons.download_outlined, size: 24),
          label: 'Export Data',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          backgroundColor: Color(0xFF51CF66),
          foregroundColor: Colors.white,
          onTap: () => controller.exportCustomersToCSV(),
        ),
        SpeedDialChild(
          child: Icon(Icons.refresh_outlined, size: 24),
          label: 'Refresh',
          labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          backgroundColor: Color(0xFF8B7ED8),
          foregroundColor: Colors.white,
          onTap: () => controller.refreshData(),
        ),
      ],
    );
  }
}




