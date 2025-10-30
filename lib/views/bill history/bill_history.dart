import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:smartbecho/bottom_navigation_screen.dart';
import 'package:smartbecho/controllers/bill%20history%20controllers/bill_history_controller.dart';
import 'package:smartbecho/models/bill%20history/bill_history_model.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/utils/common_date_feild.dart';
import 'package:smartbecho/utils/common_speed_dial_fl_button_widegt.dart';
import 'package:smartbecho/utils/custom_appbar.dart';
import 'package:smartbecho/views/bill%20history/components/show_stats_info.dart';

class BillsHistoryPage extends GetView<BillHistoryController> {
  const BillsHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(
        title: "Purchase Bills",
        // isdark: true,
        onPressed: () {
          final bottomNavController = Get.find<BottomNavigationController>();
          bottomNavController.setIndex(0);
        },
        actionItem: IconButton(
          onPressed: controller.showAnalyticsModal,
          
          icon: Icon(Icons.analytics_outlined),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // buildCustomAppBar(
            //   "Purchase Bills",
            //   isdark: true,
            //   onPressed: () {
            //     final bottomNavController =
            //         Get.find<BottomNavigationController>();
            //     bottomNavController.setIndex(0);
            //   },
            //   actionItem: IconButton(
            //     onPressed: controller.showAnalyticsModal,
            //     icon: Icon(Icons.analytics_outlined),
            //   ),
            // ),

            // Loading indicator
            Obx(
              () =>
                  controller.isLoading.value && controller.bills.isEmpty
                      ? LinearProgressIndicator(
                        backgroundColor: Colors.grey[200],
                        color: Color(0xFF1E293B),
                      )
                      : SizedBox.shrink(),
            ),

            // Stats section
            _buildStatsSection(context),

            // Filter button
            _buildFilterButton(context),

            // Bills grid with lazy loading
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scrollInfo) {
                  if (scrollInfo.metrics.pixels >=
                          scrollInfo.metrics.maxScrollExtent - 200 &&
                      !controller.isLoadingMore.value &&
                      !controller.isLoading.value) {
                    controller.loadMoreBills();
                  }
                  return false;
                },
                child: _buildBillsGrid(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: buildFloatingActionButtons(),
    );
  }

  Widget _buildStatsSection(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      height: 130, // Fixed height for the stats section
      child: Obx(() {
        if (controller.isLoadingStats.value) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1E293B),
                strokeWidth: 2,
              ),
            ),
          );
        }

        final stats = controller.stockStats.value;
        if (stats == null) {
          return SizedBox.shrink();
        }

        return ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          children: [
            _buildStatCard(
              'Last Month\nadded stock',
              stats.lastMonthStock.toString(),
              Icons.calendar_month,
              Color(0xFF8B5CF6),
              width: 140, // Fixed width for consistent card sizes
            ),
            SizedBox(width: 12),
            _buildStatCard(
              'Today Added\nstock',
              stats.todayStock.toString(),
              Icons.today,
              Color(0xFF10B981),
              width: 140,
              onTap:
                  () => showStockItemsDialog(
                    context,
                    stats,
                    StockWhenAdded.today,
                  ),
            ),
            SizedBox(width: 12),
            _buildStatCard(
              'This Month\nadded stock',
              stats.thisMonthStock.toString(),
              Icons.date_range,
              Color(0xFF3B82F6),
              width: 140,
              onTap:
                  () => showStockItemsDialog(
                    context,
                    stats,
                    StockWhenAdded.thisMonth,
                  ),
            ),
            SizedBox(width: 12),
            _buildStatCard(
              'Total available\nStock',
              stats.totalStocks.toString(),
              Icons.inventory_2,
              Color(0xFF1E293B),
              width: 140,
            ),
            SizedBox(width: 12),
            _buildStatCard(
              'View This Month\nonline Added Stock',
              'Tap to View',
              Icons.arrow_forward_ios,
              Color(0xFF059669),
              width: 140,
              onTap: () => controller.navigateToThisMonthStock(),
            ),
            SizedBox(width: 16), // Extra padding at the end
          ],
        );
      }),
    );
  }

  // Updated _buildStatCard method to support fixed width
  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color, {
    void Function()? onTap,
    double width = 140, // Default width parameter
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(
        12,
      ), // Add border radius for better touch feedback
      child: Container(
        width: width,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          // Add subtle border for tappable cards
          border:
              onTap != null
                  ? Border.all(color: color.withValues(alpha: 0.2), width: 1)
                  : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            SizedBox(height: 8),
            if (value.isNotEmpty) ...[
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            // Add subtle tap indicator for interactive cards
            if (onTap != null) ...[
              SizedBox(height: 4),
              Container(
                width: 20,
                height: 2,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _showFilterBottomSheet(context),
              icon: Icon(Icons.filter_list, size: 18),
              label: Obx(() {
                String filterText = 'Filter & Sort';
                List<String> activeFilters = [];

                if (controller.selectedCompany.value != 'All') {
                  activeFilters.add(controller.selectedCompany.value);
                }

                if (controller.timePeriodType.value == 'Month/Year') {
                  activeFilters.add(
                    '${controller.getMonthName(controller.selectedMonth.value)} ${controller.selectedYear.value}',
                  );
                } else if (controller.timePeriodType.value == 'Custom Date' &&
                    controller.startDate.value != null &&
                    controller.endDate.value != null) {
                  activeFilters.add('Custom Range');
                }

                if (activeFilters.isNotEmpty) {
                  filterText = activeFilters.join(' • ');
                }

                return Text(
                  filterText,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                );
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E293B),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ),
          SizedBox(width: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: IconButton(
              onPressed: () => controller.refreshBills(),
              icon: Obx(
                () =>
                    controller.isLoading.value
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Color(0xFF1E293B),
                          ),
                        )
                        : Icon(Icons.refresh, color: Color(0xFF1E293B)),
              ),
              tooltip: 'Refresh',
            ),
          ),
        ],
      ),
    );
  }

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
                    backgroundColor: Colors.grey.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Company and Time Period Row
            Row(
              children: [
                Expanded(
                  child: Obx(
                    () => _buildStyledDropdown(
                      labelText: 'Vendors',
                      hintText: 'Select Vendor',
                      value:
                          controller.selectedCompany.value == 'All'
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
                    () => _buildStyledDropdown(
                      labelText: 'Time Period',
                      hintText: 'Select Period',
                      value: controller.timePeriodType.value,
                      items: controller.timePeriodOptions,
                      onChanged: controller.onTimePeriodTypeChanged,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Date Selection based on Time Period Type
            Obx(() {
              if (controller.timePeriodType.value == 'Month/Year') {
                return _buildMonthYearSelection();
              } else {
                return _buildCustomDateSelection(context);
              }
            }),

            SizedBox(height: 16),

            // Sort Option
            Obx(
              () => _buildStyledDropdown(
                labelText: 'Sort By',
                hintText: 'Select Sort Field',
                value: controller.sortBy.value,
                items: controller.sortOptions,
                onChanged:
                    (value) => controller.onSortChanged(value ?? 'billId'),
                suffixIcon: Icon(
                  controller.sortDir.value == 'asc'
                      ? Icons.arrow_upward
                      : Icons.arrow_downward,
                  size: 16,
                  color: Color(0xFF1E293B),
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
                    onPressed: () => Get.back(),
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

            SizedBox(height: MediaQuery.of(Get.context!).viewInsets.bottom),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _resetFilters() {
    controller.selectedCompany.value = 'All';
    controller.timePeriodType.value = 'Month/Year';
    controller.selectedMonth.value = DateTime.now().month;
    controller.selectedYear.value = DateTime.now().year;
    controller.startDate.value = null;
    controller.endDate.value = null;
    controller.startDateController.clear();
    controller.endDateController.clear();
    controller.sortBy.value = 'billId';
    controller.sortDir.value = 'desc';
    controller.loadBills(refresh: true);
    Get.back();
  }

  Widget _buildMonthYearSelection() {
    return Row(
      children: [
        Expanded(
          child: Obx(
            () => _buildStyledDropdown(
              labelText: 'Month',
              hintText: 'Select Month',
              value: controller.getMonthName(controller.selectedMonth.value),
              items: List.generate(
                12,
                (index) => controller.getMonthName(index + 1),
              ),
              onChanged: (value) {
                if (value != null) {
                  final monthIndex =
                      List.generate(
                        12,
                        (index) => controller.getMonthName(index + 1),
                      ).indexOf(value) +
                      1;
                  controller.onMonthChanged(monthIndex);
                }
              },
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Obx(
            () => _buildStyledDropdown(
              labelText: 'Year',
              hintText: 'Select Year',
              value: controller.selectedYear.value.toString(),
              items:
                  List.generate(
                    6,
                    (index) => (2020 + index).toString(),
                  ).reversed.toList(),
              onChanged:
                  (value) =>
                      controller.onYearChanged(int.tryParse(value ?? '')),
            ),
          ),
        ),
      ],
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
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF1E293B),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      if (isStartDate) {
        controller.onStartDateChanged(picked);
      } else {
        controller.onEndDateChanged(picked);
      }
    }
  }

  Widget _buildStyledDropdown({
    required String labelText,
    required String hintText,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
    bool enabled = true,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(
            color: Color(0xFF374151),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: enabled ? Colors.white : Colors.grey.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            isExpanded: true,
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: suffixIcon,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            hint: Text(
              hintText,
              style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            ),
            style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            items:
                enabled
                    ? items.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList()
                    : [],
            onChanged: enabled ? onChanged : null,
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget _buildBillsGrid() {
    return Obx(() {
      if (controller.error.value.isNotEmpty && controller.bills.isEmpty) {
        return _buildErrorState();
      }

      if (controller.isLoading.value && controller.bills.isEmpty) {
        return _buildLoadingState();
      }

      if (controller.bills.isEmpty) {
        return _buildEmptyState();
      }

      return RefreshIndicator(
        onRefresh: controller.refreshBills,
        color: Color(0xFF1E293B),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemCount:
                controller.bills.length +
                (controller.isLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.bills.length) {
                return _buildLoadingMoreIndicator();
              }

              final bill = controller.bills[index];
              return _buildBillCard(bill);
            },
          ),
        ),
      );
    });
  }

  Widget _buildBillCard(Bill bill) {
    return GestureDetector(
      onTap: () => controller.navigateToBillDetails(bill),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              spreadRadius: 0,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: controller.getStatusColor(bill).withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with company and status
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    controller
                        .getCompanyColor(bill.companyName)
                        .withValues(alpha: 0.1),
                    controller
                        .getCompanyColor(bill.companyName)
                        .withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: controller.getCompanyColor(bill.companyName),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      controller.getCompanyIcon(bill.companyName),
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          bill.companyName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: controller.getCompanyColor(bill.companyName),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '#${bill.billId}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusBadge(bill),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        SizedBox(width: 4),
                        Text(
                          bill.formattedDate,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),

                    // Items preview
                    if (bill.items.isNotEmpty) ...[
                      Text(
                        'Items (${bill.totalItems})',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 4),
                      ...bill.items
                          .take(2)
                          .map(
                            (item) => Padding(
                              padding: EdgeInsets.only(bottom: 2),
                              child: Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: controller.getCompanyColor(
                                        item.company,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      '${item.model} (${item.ramRomDisplay})',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[700],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                      if (bill.items.length > 2)
                        Text(
                          '+${bill.items.length - 2} more',
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],

                    Spacer(),

                    // Amount section
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.currency_rupee,
                                size: 12,
                                color: Colors.grey[600],
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Amount',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Spacer(),
                              Text(
                                bill.formattedAmount,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                            ],
                          ),
                          if (bill.dues > 0) ...[
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.warning,
                                  size: 10,
                                  color: Colors.orange,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Dues',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  bill.formattedDues,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(Bill bill) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: controller.getStatusColor(bill),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(controller.getStatusIcon(bill), size: 8, color: Colors.white),
          SizedBox(width: 2),
          Text(
            bill.isPaid ? 'Paid' : 'Pending',
            style: TextStyle(
              fontSize: 8,
              color: Colors.white,
              fontWeight: FontWeight.w600,
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
          CircularProgressIndicator(color: Color(0xFF1E293B), strokeWidth: 2),
          SizedBox(height: 16),
          Text(
            'Loading bills...',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
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
          Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'No bills found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your filters',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => controller.loadBills(refresh: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E293B),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Refresh'),
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
          Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
          SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Obx(
              () => Text(
                controller.error.value,
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => controller.loadBills(refresh: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1E293B),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Color(0xFF1E293B),
                strokeWidth: 2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Loading more...',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  //floating button
  Widget buildFloatingActionButtons() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      backgroundColor: const Color(0xFF6C5CE7),
      foregroundColor: Colors.white,
      elevation: 8,
      shape: const CircleBorder(),
      children: [
        buildSpeedDialChild(
          label: 'View Purchased Item',
          backgroundColor: const Color(0xFF51CF66),
          icon: Icons.inventory_2,
          onTap: () => Get.toNamed(AppRoutes.stockList),
        ),
        buildSpeedDialChild(
          label: 'Online added Products',
          backgroundColor: const Color(0xFF00CEC9),
          icon: Icons.add,
          onTap: () => Get.toNamed(AppRoutes.onlineAddedProducts),
        ),
        buildSpeedDialChild(
          label: 'Add New Stock',
          backgroundColor: const Color(0xFF00CEC9),
          icon: Icons.add,
          onTap: () => Get.toNamed(AppRoutes.addNewStock),
        ),
      ],
    );
  }
}
