import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/sales%20hisrory%20controllers/sales_history_comtroller.dart';
import 'package:smartbecho/models/sales%20history%20models/sales_history_reponse_model.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:smartbecho/utils/common_date_feild.dart';
import 'package:smartbecho/utils/common_month_year_dropdown.dart';
import 'package:smartbecho/utils/custom_appbar.dart';
import 'package:smartbecho/utils/custom_dropdown.dart';
import 'package:smartbecho/utils/generic_charts.dart';
import 'package:smartbecho/views/dashboard/charts/switchable_chart.dart';

class SalesManagementScreen extends GetView<SalesManagementController> {
  const SalesManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildTabs(),
            Expanded(
              child: Obx(() {
                switch (controller.selectedTab.value) {
                  case 'dashboard':
                    return _buildDashboardTab();
                  case 'history':
                    return _buildHistoryTab();
                  case 'insights':
                    return _buildInsightsTab();
                  default:
                    return _buildDashboardTab();
                }
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.mobileSalesForm),
        backgroundColor: Color(0xFF6C5CE7),
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          "Sell Product",
          style: AppStyles.custom(
            color: AppTheme.cardLight,
            size: 15,
            weight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return buildCustomAppBar(
      "Sales Management",
      isdark: true,
      actionItem: IconButton(
        onPressed: () => controller.refreshData(),
        icon: Icon(Icons.refresh, color: Colors.black),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: [
            _buildTabButton('dashboard', 'Dashboard', Icons.dashboard),
            _buildTabButton('history', 'Sales History', Icons.history),
            _buildTabButton('insights', 'Sales Insights', Icons.insights),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String tabValue, String label, IconData icon) {
    bool isSelected = controller.selectedTab.value == tabValue;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.onTabChanged(tabValue),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF6C5CE7) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 16,
              ),
              SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildStatsCards(),
          SizedBox(height: 16),
          _buildRecentSales(),
        ],
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              _buildStatCard(
                'Today\'s Sales',
                controller.formattedTotalSales,
                Icons.shopping_cart,
                Color(0xFF10B981),
                controller.isStatsLoading.value,
              ),
              SizedBox(width: 12),
              _buildStatCard(
                'UPI Payments',
                controller.formattedUpiAmount,
                Icons.qr_code,
                Color(0xFF3B82F6),
                controller.isStatsLoading.value,
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard(
                'Cash Payments',
                controller.formattedCashAmount,
                Icons.money,
                Color(0xFF8B5CF6),
                controller.isStatsLoading.value,
              ),
              SizedBox(width: 12),
              _buildStatCard(
                'Phones Sold',
                controller.totalPhonesSold.toString(),
                Icons.phone_android,
                Color(0xFFF59E0B),
                controller.isStatsLoading.value,
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard(
                'EMI Payments',
                controller.formattedTotalEmi,
                Icons.schedule,
                Color(0xFFEF4444),
                controller.isStatsLoading.value,
              ),
              SizedBox(width: 12),
              _buildStatCard(
                'Card Payments',
                controller.formattedCardAmount,
                Icons.credit_card,
                Color(0xFF06B6D4),
                controller.isStatsLoading.value,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isLoading,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha:0.08),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha:0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                Spacer(),
                if (isLoading)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: color,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSales() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Sales',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              TextButton(
                onPressed: () => controller.onTabChanged('history'),
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: Color(0xFF1E293B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Obx(() {
            if (controller.isLoading.value && controller.allSales.isEmpty) {
              return _buildLoadingCards();
            }

            if (controller.allSales.isEmpty) {
              return _buildEmptyRecentSales();
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount:
                  controller.allSales.length > 4
                      ? 4
                      : controller.allSales.length,
              itemBuilder: (context, index) {
                final sale = controller.allSales[index];
                return _buildSaleCard(sale);
              },
            );
          }),
        ],
      ),
    );
  }

 Widget _buildHistoryTab() {
  return Column(
    children: [
      _buildSearchAndFilters(),
      _buildHistoryStats(),
      Expanded(
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent &&
                !controller.isLoadingMore.value &&
                !controller.isLoading.value) {
              controller.loadMoreSales();
            }
            return false;
          },
          child: _buildSalesGrid(),
        ),
      ),
    ],
  );
}

Widget _buildSearchAndFilters() {
  return Container(
    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withValues(alpha:0.05),
          spreadRadius: 0,
          blurRadius: 10,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        Row(
          children: [
            Icon(Icons.search, color: Color(0xFF1E293B), size: 18),
            SizedBox(width: 8),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(2),
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.withValues(alpha:0.2)),
                ),
                child: TextField(
                  controller: controller.searchController,
                  onChanged: (_) => controller.onSearchChanged(),
                  decoration: InputDecoration(
                    hintText: 'Search sales by customer, invoice...',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                    suffixIcon: Obx(
                      () => controller.searchQuery.value.isNotEmpty
                          ? IconButton(
                              onPressed: controller.clearSearch,
                              icon: Icon(
                                Icons.clear,
                                size: 16,
                                color: Colors.grey[400],
                              ),
                            )
                          : SizedBox(),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            // Filter Button
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: controller.hasActiveFilters 
                    ? Color(0xFF1E293B) 
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.withValues(alpha:0.2)),
              ),
              child: IconButton(
                onPressed: () => _showFilterBottomSheet(Get.context!),
                icon: Obx(() => Icon(
                  Icons.tune,
                  size: 18,
                  color: controller.hasActiveFilters 
                      ? Colors.white 
                      : Color(0xFF1E293B),
                )),
                tooltip: 'Filter',
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              onPressed: () => controller.refreshData(),
              icon: Icon(Icons.refresh, size: 18, color: Color(0xFF1E293B)),
              tooltip: 'Refresh',
            ),
          ],
        ),
      ],
    ),
  );
}

// Filter Bottom Sheet Modal
void _showFilterBottomSheet(BuildContext context) {
  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Filter & Sort',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.close),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey.withValues(alpha:0.1),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Company and Payment Method Row
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => buildStyledDropdown(
                    labelText: 'Company',
                    hintText: 'Select Company',
                    value: controller.selectedCompany.value?.isEmpty == true 
                        ? null 
                        : controller.selectedCompany.value,
                    items: controller.companyOptions,
                    onChanged: controller.onCompanyChanged,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => buildStyledDropdown(
                    labelText: 'Payment Method',
                    hintText: 'Select Method',
                    value: controller.selectedPaymentMethod.value?.isEmpty == true 
                        ? null 
                        : controller.selectedPaymentMethod.value,
                    items: controller.paymentMethodOptions,
                    onChanged: controller.onPaymentMethodChanged,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Item Category and Payment Mode Row
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => buildStyledDropdown(
                    labelText: 'Item Category',
                    hintText: 'Select Category',
                    value: controller.selectedItemCategory.value?.isEmpty == true 
                        ? null 
                        : controller.selectedItemCategory.value,
                    items: controller.itemCategoryOptions,
                    onChanged: controller.onItemCategoryChanged,
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Obx(
                  () => buildStyledDropdown(
                    labelText: 'Payment Mode',
                    hintText: 'Select Mode',
                    value: controller.selectedPaymentMode.value?.isEmpty == true 
                        ? null 
                        : controller.selectedPaymentMode.value,
                    items: controller.paymentModeOptions,
                    onChanged: controller.onPaymentModeChanged,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Date Period Type Selector
          Obx(
            () => buildStyledDropdown(
              labelText: 'Date Filter Type',
              hintText: 'Select Date Type',
              value: controller.dateFilterType.value,
              items: ['Month/Year', 'Date Range'],
              onChanged: controller.onDateFilterTypeChanged,
            ),
          ),

          SizedBox(height: 16),

          // Date Selection based on Date Filter Type
          Obx(() {
            if (controller.dateFilterType.value == 'Month/Year') {
              return _buildMonthYearSelection();
            } else {
              return _buildCustomDateSelection(context);
            }
          }),

          SizedBox(height: 16),

          // Sort Option
          Obx(
            () => buildStyledDropdown(
              labelText: 'Sort By',
              hintText: 'Select Sort Field',
              value: controller.selectedSortBy.value,
              items: controller.sortByOptions,
              onChanged: controller.onSortByChanged,
              suffixIcon: GestureDetector(
                onTap: controller.toggleSortDirection,
                child: Icon(
                  controller.selectedSortDir.value == 'asc'
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 16,
                  color: Color(0xFF1E293B),
                ),
              ),
            ),
          ),

          SizedBox(height: 24),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _resetFilters,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Color(0xFF1E293B),
                    side: BorderSide(color: Color(0xFF1E293B)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Reset'),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    controller.applyFilters();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1E293B),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Apply'),
                ),
              ),
            ],
          ),

          SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

void _resetFilters() {
  controller.resetAllFilters();
  Get.back();
}

Widget _buildMonthYearSelection() {
  return Obx(
    () => MonthYearDropdown(
      selectedMonth: controller.selectedMonth.value,
      selectedYear: controller.selectedYear.value,
      onMonthChanged: controller.onMonthChanged,
      onYearChanged: controller.onYearChanged,
      showAllOption: true,
      monthLabel: 'Month',
      yearLabel: 'Year',
    ),
  );
}

Widget _buildCustomDateSelection(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: buildDateField(
          labelText: 'Start Date',
          controller: controller.startDateController,
          onTap: () => _selectDate(context, true),
        ),
      ),
      SizedBox(width: 12),
      Expanded(
        child: buildDateField(
          labelText: 'End Date',
          controller: controller.endDateController,
          onTap: () => _selectDate(context, false),
        ),
      ),
    ],
  );
}




Future<void> _selectDate(BuildContext context, bool isStartDate) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime.now().add(Duration(days: 365)),
  );
  
  if (picked != null) {
    if (isStartDate) {
      controller.onStartDateChanged(picked);
    } else {
      controller.onEndDateChanged(picked);
    }
  }
}

  Widget _buildHistoryStats() {
    return Container(
      height: 60,
      margin: EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Obx(
        () => Row(
          children: [
            _buildCompactStatItem(
              'Total Sales',
              controller.totalElements.value.toString(),
              Icons.receipt_long,
              Color(0xFF1E293B),
            ),
            _buildCompactStatItem(
              'Loaded',
              controller.allSales.length.toString(),
              Icons.download_done,
              Color(0xFF10B981),
            ),
            _buildCompactStatItem(
              'UPI',
              controller.allSales
                  .where((sale) => sale.paymentMethod == 'UPI')
                  .length
                  .toString(),
              Icons.qr_code,
              Color(0xFF3B82F6),
            ),
            _buildCompactStatItem(
              'Cash',
              controller.allSales
                  .where((sale) => sale.paymentMethod == 'Cash')
                  .length
                  .toString(),
              Icons.money,
              Color(0xFF8B5CF6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactStatItem(
    String label,
    String count,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 6),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha:0.05),
              blurRadius: 6,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: color, size: 12),
                SizedBox(width: 4),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesGrid() {
    return Obx(() {
      if (controller.hasError.value && controller.allSales.isEmpty) {
        return _buildErrorState();
      }

      if (controller.isLoading.value && controller.allSales.isEmpty) {
        return _buildLoadingState();
      }

      if (controller.allSales.isEmpty) {
        return _buildEmptyState();
      }

      return CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == controller.allSales.length) {
                    return controller.isLoadingMore.value
                        ? Container(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF1E293B),
                              strokeWidth: 2,
                            ),
                          ),
                        )
                        : SizedBox.shrink();
                  }

                  final sale = controller.allSales[index];
                  return _buildSaleCard(sale);
                },
                childCount:
                    controller.allSales.length +
                    (controller.isLoadingMore.value ? 1 : 0),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSaleCard(Sale sale) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.06),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: controller.getCompanyColor(sale.companName).withValues(alpha:0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top section with company logo and payment method
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      controller.getCompanyColor(sale.companName),
                      controller
                          .getCompanyColor(sale.companName)
                          .withValues(alpha:0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.phone_android, color: Colors.white, size: 18),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: controller
                      .getPaymentMethodColor(sale.paymentMethod)
                      .withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: controller
                        .getPaymentMethodColor(sale.paymentMethod)
                        .withValues(alpha:0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      controller.getPaymentMethodIcon(sale.paymentMethod),
                      size: 8,
                      color: controller.getPaymentMethodColor(
                        sale.paymentMethod,
                      ),
                    ),
                    SizedBox(width: 2),
                    Text(
                      sale.paymentMethod,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: controller.getPaymentMethodColor(
                          sale.paymentMethod,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          // Invoice number
          Text(
            '#${sale.invoiceNumber}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 6),

          // Customer name
          Text(
            sale.customerName,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 4),

          // Company and model
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: controller.getCompanyColor(sale.companName),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${sale.companName} ${sale.companyModel}',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          SizedBox(height: 4),

          // Date and time
          Row(
            children: [
              Icon(Icons.calendar_today, size: 10, color: Colors.grey[500]),
              SizedBox(width: 4),
              Text(
                '${sale.formattedDate} ${sale.formattedTime}',
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              ),
            ],
          ),

          Spacer(),

          // Amount section
          Container(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Amount',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  sale.formattedAmount,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () => controller.navigateToSaleDetails(sale),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF1E293B).withValues(alpha:0.1),
                      foregroundColor: Color(0xFF1E293B),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(Icons.visibility, size: 12),
                  ),
                ),
              ),
              SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () => controller.downloadInvoice(sale),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3B82F6).withValues(alpha:0.1),
                      foregroundColor: Color(0xFF3B82F6),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: Icon(Icons.download, size: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildInsightsHeader(),
          SizedBox(height: 16),

          _buildPaymentMethodInsights(),
          SizedBox(height: 16),
          _buildCompanyInsights(),
          SizedBox(height: 16),
          _buildInsightsOverview(),
          SizedBox(height: 16),

          SizedBox(height: 16),
          GestureDetector(
            onTap: () => Get.toNamed(AppRoutes.salesInsightsAnalytics),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                'View All Insights',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          _buildInsightsOverviewChart(),
          SizedBox(height: 16),
          _buildTopCustomers(),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildInsightsOverviewChart() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SwitchableChartWidget(
        payload: {
           "Monthly Revenue": controller.totalSaleAmount,
          //  "Monthly Revenue": controller.totalUnitsSoldGrowth,
          //  "Monthly Revenue": controller.totalSaleAmount,
          //   "Monthly EMI Sales": controller.totalEmiSalesAmount,  
          //   "Monthly EMI Sales": controller.totalEmiSalesAmount,  
        },
        title: "Monthly Revenue Performance",
        screenWidth: controller.screenWidth,
        screenHeight: controller.screenHeight,
        isSmallScreen: controller.isSmallScreen,
        initialChartType: "barchart", // Start with bar chart
        chartDataType: ChartDataType.revenue,
      ),
    );
  }

  Widget _buildInsightsOverview() {
    return Obx(() {
      log(controller.insightsStatsData.string);

      if (controller.hasError.value &&
          controller.insightsStatsData.value == null) {
        return _buildErrorState();
      }

      if (controller.isLoading.value &&
          controller.insightsStatsData.value == null) {
        return _buildLoadingState();
      }

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                _buildStatCard(
                  'Total Revenue',
                  controller.formattedTotalSaleAmount,
                  Icons.shopping_cart,
                  Color(0xFF10B981),
                  controller.isStatsLoading.value,
                ),
                SizedBox(width: 12),
                _buildStatCard(
                  'Units Sold',
                  controller.formattedTotalUnitsSold,
                  Icons.phone_android,
                  Color(0xFFF59E0B),
                  controller.isStatsLoading.value,
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                _buildStatCard(
                  'EMI Sales',
                  controller.formattedTotalEmiSalesAmount,
                  Icons.credit_card,
                  Color(0xFF8B5CF6),
                  controller.isStatsLoading.value,
                ),
                SizedBox(width: 12),
                _buildStatCard(
                  'Avg. Sale Value',
                  controller.formattedAverageSaleAmount,
                  Icons.money,
                  Color(0xFF00BAD1),
                  controller.isStatsLoading.value,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInsightsHeader() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF334155)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.analytics, color: Colors.white, size: 32),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sales Insights',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Performance analytics and trends',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha:0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodInsights() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.08),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method Distribution',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 16),
          Obx(() {
            if (controller.allSales.isEmpty) {
              return Center(
                child: Text(
                  'No data available',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              );
            }

            Map<String, int> paymentCounts = {};
            for (var sale in controller.allSales) {
              paymentCounts[sale.paymentMethod] =
                  (paymentCounts[sale.paymentMethod] ?? 0) + 1;
            }

            return Column(
              children:
                  paymentCounts.entries.map((entry) {
                    double percentage =
                        (entry.value / controller.allSales.length) * 100;
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: controller.getPaymentMethodColor(
                                entry.key,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: LinearProgressIndicator(
                              value: percentage / 100,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                controller.getPaymentMethodColor(entry.key),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${entry.value} (${percentage.toStringAsFixed(1)}%)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: controller.getPaymentMethodColor(
                                entry.key,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            );
          }),
        ],
      ),
    );
  }

  // Continuing from _buildCompanyInsights()...
  Widget _buildCompanyInsights() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.08),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Phone Brands',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 16),
          Obx(() {
            if (controller.allSales.isEmpty) {
              return Center(
                child: Text(
                  'No data available',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              );
            }

            Map<String, int> companyCounts = {};
            for (var sale in controller.allSales) {
              companyCounts[sale.companName] =
                  (companyCounts[sale.companName] ?? 0) + 1;
            }

            var sortedCompanies =
                companyCounts.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value));

            return Column(
              children:
                  sortedCompanies.take(5).map((entry) {
                    double percentage =
                        (entry.value / controller.allSales.length) * 100;
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: controller.getCompanyColor(entry.key),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: LinearProgressIndicator(
                              value: percentage / 100,
                              backgroundColor: Colors.grey[200],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                controller.getCompanyColor(entry.key),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '${entry.value} (${percentage.toStringAsFixed(1)}%)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: controller.getCompanyColor(entry.key),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTopCustomers() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.08),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Customers',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 16),
          Obx(() {
            if (controller.allSales.isEmpty) {
              return Center(
                child: Text(
                  'No data available',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              );
            }

            Map<String, double> customerAmounts = {};
            for (var sale in controller.allSales) {
              customerAmounts[sale.customerName] =
                  (customerAmounts[sale.customerName] ?? 0) + sale.amount;
            }

            var sortedCustomers =
                customerAmounts.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value));

            return Column(
              children:
                  sortedCustomers.take(5).map((entry) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 12),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.withValues(alpha:0.1)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Color(0xFF1E293B),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                entry.key.substring(0, 1).toUpperCase(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.key,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Total purchases',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '₹${entry.value.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF10B981),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLoadingCards() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha:0.06),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 50,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                width: double.infinity,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: 100,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: 120,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Spacer(),
              Container(
                width: double.infinity,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyRecentSales() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No Recent Sales',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start adding sales to see them here',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Get.toNamed('/add-sale'),
            icon: Icon(Icons.add),
            label: Text('Add First Sale'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E293B),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF1E293B)),
          SizedBox(height: 16),
          Text(
            'Loading sales history...',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          SizedBox(height: 16),
          Text(
            'Error Loading Sales',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red[600],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              controller.errorMessage.value,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => controller.refreshData(),
            icon: Icon(Icons.refresh),
            label: Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E293B),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            'No Sales Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            controller.searchQuery.value.isNotEmpty
                ? 'No sales match your search criteria'
                : 'No sales available',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          if (controller.searchQuery.value.isNotEmpty)
            ElevatedButton.icon(
              onPressed: () => controller.clearSearch(),
              icon: Icon(Icons.clear),
              label: Text('Clear Search'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E293B),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: () => Get.toNamed('/add-sale'),
              icon: Icon(Icons.add),
              label: Text('Add Sale'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E293B),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
