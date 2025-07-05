import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/customer%20dues%20controllers/customer_dues_controller.dart';
import 'package:smartbecho/models/customer%20dues%20management/all_customer_dues_model.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:smartbecho/utils/common_month_year_dropdown.dart';
import 'package:smartbecho/utils/custom_appbar.dart';
import 'package:smartbecho/utils/enhanced_image_picker.dart';
import 'package:smartbecho/views/customer%20dues/components/customer_dues_details.dart';

class CustomerDuesManagementScreen extends StatelessWidget {
  final CustomerDuesController controller = Get.find<CustomerDuesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey50,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              _buildCustomAppBar(),
              _buildSummaryCards(),

              _buildSearchAndFilters(),
              _buildTabsAndContent(),
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildCustomAppBar() {
    return buildCustomAppBar(
      "Customer Dues Management",
      isdark: true,
      actionItem: IconButton(
        onPressed: controller.showAnalyticsModal,
        icon: Icon(Icons.analytics),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Obx(() {
        if (controller.summaryData.value == null) {
          return _buildSummaryCardsShimmer();
        }

        final summary = controller.summaryData.value!;

        return ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          children: [
            _buildSummaryCard(
              'Total Dues\nGiven',
              '₹${_formatAmount(summary.totalGiven)}',
              Icons.account_balance_wallet_outlined,
              Color(0xFF6C5CE7),
            ),
            _buildSummaryCard(
              'Total\nCollected',
              '₹${_formatAmount(summary.totalCollected)}',
              Icons.check_circle_outline,
              Color(0xFF51CF66),
            ),
            _buildSummaryCard(
              'Total\nRemaining',
              '₹${_formatAmount(summary.totalRemaining)}',
              Icons.error_outline,
              Color(0xFFFF6B6B),
            ),
            _buildSummaryCard(
              'This Month ₹${_formatAmount(summary.thisMonthCollection)}',
              '${controller.duesCustomersCount}\nCustomers',
              Icons.calendar_today_outlined,
              Color(0xFF4ECDC4),
            ),
            _buildSummaryCard(
              'Today\'s Retrieval',
              '${controller.paidCustomersCount}\nCustomers',
              Icons.people_outline,
              Color(0xFFFF9500),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 140,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity08,
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: AppStyles.custom(
              size: 14,
              weight: FontWeight.bold,
              color: AppTheme.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: AppTheme.grey600,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCardsShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          width: 140,
          margin: EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: AppTheme.backgroundLight,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: CircularProgressIndicator(
              color: Color(0xFF6C5CE7),
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity08,
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.grey50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.greyOpacity02),
              ),
              child: TextField(
                onChanged: controller.onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search by name or ID...',
                  hintStyle: AppStyles.custom(
                    size: 14,
                    color: AppTheme.grey500,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20,
                    color: Color(0xFF6C5CE7),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            SizedBox(height: 12),

            // Filter Toggle Row
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    // onTap: controller.toggleFiltersExpanded,
                    child: Container(
                      height: 44,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.grey50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.greyOpacity02),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.tune, size: 18, color: Color(0xFF6C5CE7)),
                          SizedBox(width: 8),
                          Text(
                            'Filters',
                            style: AppStyles.custom(
                              size: 14,
                              color: AppTheme.grey700,
                            ),
                          ),
                          Spacer(),
                          Obx(
                            () => AnimatedRotation(
                              turns:
                                  controller.isFiltersExpanded.value ? 0.5 : 0,
                              duration: Duration(milliseconds: 200),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 20,
                                color: AppTheme.grey600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Container(
                  height: 44,
                  child: ElevatedButton.icon(
                    onPressed: controller.exportDues,
                    icon: Icon(Icons.download_outlined, size: 16),
                    label: Text('Export', style: AppStyles.custom(size: 14)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.grey50,
                      foregroundColor: AppTheme.grey600,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: AppTheme.greyOpacity02),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Expandable Filters Section
            Obx(
              () => AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: controller.isFiltersExpanded.value ? null : 0,
                child:
                    controller.isFiltersExpanded.value
                        ? Column(
                          children: [
                            SizedBox(height: 16),
                            Divider(color: AppTheme.greyOpacity02),
                            SizedBox(height: 16),

                            // Month and Year Dropdowns
                            Obx(
                              () => MonthYearDropdown(
                                selectedMonth: controller.selectedMonth.value,
                                selectedYear: controller.selectedYear.value,
                                onMonthChanged: controller.onMonthChanged,
                                onYearChanged: controller.onYearChanged,
                                showAllOption: true,
                              ),
                            ),

                            SizedBox(height: 16),

                            // Sort Dropdown
                            Container(
                              height: 44,
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              decoration: BoxDecoration(
                                color: AppTheme.grey50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppTheme.greyOpacity02,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: Obx(
                                  () => DropdownButton<String>(
                                    value: controller.selectedSort.value,
                                    items: [
                                      DropdownMenuItem(
                                        value: 'date_desc',
                                        child: Text(
                                          'Latest First',
                                          style: AppStyles.custom(size: 14),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'date_asc',
                                        child: Text(
                                          'Oldest First',
                                          style: AppStyles.custom(size: 14),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'amount_desc',
                                        child: Text(
                                          'Highest Amount',
                                          style: AppStyles.custom(size: 14),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'amount_asc',
                                        child: Text(
                                          'Lowest Amount',
                                          style: AppStyles.custom(size: 14),
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      if (value != null) {
                                        controller.onSortChanged(value);
                                      }
                                    },
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      size: 20,
                                    ),
                                    isExpanded: true,
                                    hint: Text(
                                      'Sort by',
                                      style: AppStyles.custom(size: 14),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: 12),

                            // Reset Filters Button
                            SizedBox(
                              width: double.infinity,
                              height: 36,
                              child: TextButton(
                                onPressed: controller.resetFilters,
                                child: Text(
                                  'Reset Filters',
                                  style: AppStyles.custom(
                                    size: 13,
                                    color: Color(0xFF6C5CE7),
                                    weight: FontWeight.w500,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(
                                    0xFF6C5CE7,
                                  ).withOpacity(0.1),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                        : SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabsAndContent() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity08,
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tabs
          Container(
            padding: EdgeInsets.all(16),

            child: Column(
              children: [
                Row(
                  children: [
                    Obx(
                      () => _buildTab(
                        'Dues Customers',
                        '${controller.duesCustomersCount}',
                        'dues',
                      ),
                    ),
                    SizedBox(width: 8),
                    Obx(
                      () => _buildTab(
                        'Paid Customers',
                        '${controller.paidCustomersCount}',
                        'paid',
                      ),
                    ),
                    IconButton(
                      onPressed: () => controller.refreshData(),
                      icon: Icon(Icons.refresh, color: AppTheme.backgroundDark),
                    ),
                  ],
                ),
                // SizedBox(height: 12),
                // SizedBox(
                //   width: double.infinity,
                //   child: ElevatedButton.icon(
                //     onPressed: controller.createDueEntry,
                //     icon: Icon(Icons.add, size: 16, color: AppTheme.backgroundLight),
                //     label: Text(
                //       'Create Due Entry',
                //       style: AppStyles.custom(size: 14, color: AppTheme.backgroundLight),
                //     ),
                //     style: ElevatedButton.styleFrom(
                //       backgroundColor: Color(0xFF6C5CE7),
                //       padding: EdgeInsets.symmetric(vertical: 12),
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          // Content
          Obx(() => _buildDuesList()),
        ],
      ),
    );
  }

  Widget _buildTab(String title, String count, String tabValue) {
    final isSelected = controller.selectedTab.value == tabValue;
    return Expanded(
      child: InkWell(
        onTap: () => controller.onTabChanged(tabValue),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF6C5CE7) : AppTheme.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$title ($count)',
            style: AppStyles.custom(
              size: 14,
              weight: FontWeight.w600,
              color: isSelected ? AppTheme.backgroundLight : AppTheme.grey700,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildDuesList() {
    if (controller.isLoading.value) {
      return Container(
        height: 400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF6C5CE7)),
              SizedBox(height: 16),
              Text(
                'Loading dues...',
                style: AppStyles.custom(color: AppTheme.grey600),
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
              Icon(Icons.error_outline, size: 48, color: AppTheme.red300),
              SizedBox(height: 16),
              Text(
                'Failed to load dues',
                style: AppStyles.custom(size: 16, color: AppTheme.grey700),
              ),
              SizedBox(height: 8),
              Text(
                controller.errorMessage.value,
                style: AppStyles.custom(size: 12, color: AppTheme.grey500),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.refreshData,
                child: Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6C5CE7),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (controller.filteredDues.isEmpty) {
      return Container(
        height: 400,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_balance_wallet_outlined,
                size: 64,
                color: AppTheme.grey300,
              ),
              SizedBox(height: 16),
              Text(
                'No dues found',
                style: AppStyles.custom(size: 18, color: AppTheme.grey600),
              ),
              SizedBox(height: 8),
              Text(
                'Try adjusting your search criteria',
                style: AppStyles.custom(size: 14, color: AppTheme.grey500),
              ),
            ],
          ),
        ),
      );
    }

    // Grid View - 2 cards per row
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72, // Adjust based on card height needs
      ),
      itemCount: controller.filteredDues.length,
      itemBuilder: (context, index) {
        final due = controller.filteredDues[index];
        return _buildCompactDueCard(due);
      },
    );
  }

  Widget _buildCompactDueCard(CustomerDue due) {
    return GestureDetector(
      onTap: () => _navigateToDueDetails(due),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.greyOpacity01),
          boxShadow: [
            BoxShadow(
              color: AppTheme.greyOpacity05,
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with avatar and status
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Color(0xFF6C5CE7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        _getInitials(due.customerName),
                        style: AppStyles.custom(
                          color: AppTheme.backgroundLight,
                          weight: FontWeight.bold,
                          size: 12,
                        ),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color:
                          due.remainingDue > 0
                              ? AppTheme.red50
                              : AppTheme.green50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color:
                            due.remainingDue > 0
                                ? AppTheme.red200
                                : AppTheme.green200,
                      ),
                    ),
                    child: Text(
                      due.remainingDue > 0 ? 'PENDING' : 'PAID',
                      style: AppStyles.custom(
                        size: 8,
                        weight: FontWeight.bold,
                        color:
                            due.remainingDue > 0
                                ? AppTheme.red700
                                : AppTheme.green700,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Customer name
              Text(
                due.customerName,
                style: AppStyles.custom(
                  size: 14,
                  weight: FontWeight.bold,
                  color: AppTheme.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              SizedBox(height: 4),

              // ID and Date
              Text(
                'ID: #${due.id}',
                style: AppStyles.custom(size: 10, color: AppTheme.grey600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              Text(
                'Date: ${_formatDate(DateTime.parse(due.creationDate))}',
                style: AppStyles.custom(size: 10, color: AppTheme.grey600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              Spacer(),

              // Due amounts section
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                decoration: BoxDecoration(
                  color: AppTheme.grey50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildCompactDueDetail(
                      'Total',
                      '₹${_formatAmount(due.totalDue)}',
                      AppTheme.primaryBlue,
                    ),
                    SizedBox(height: 4),
                    _buildCompactDueDetail(
                      'Paid',
                      '₹${_formatAmount(due.totalPaid)}',
                      AppTheme.primaryGreen,
                    ),
                    SizedBox(height: 4),
                    _buildCompactDueDetail(
                      'Remaining',
                      '₹${_formatAmount(due.remainingDue)}',
                      AppTheme.primaryRed,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 8),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 28,
                      child: ElevatedButton(
                        onPressed:
                            () => controller.callCustomer(due.customerId),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF51CF66).withOpacity(0.1),
                          foregroundColor: Color(0xFF51CF66),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Icon(Icons.call, size: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 6),
                  if (due.remainingDue > 0)
                    Expanded(
                      child: Container(
                        height: 28,
                        child: ElevatedButton(
                          onPressed: () => _showAddPaymentDialog(due),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6C5CE7).withOpacity(0.1),
                            foregroundColor: Color(0xFF6C5CE7),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          child: Icon(Icons.payment, size: 12),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompactDueDetail(String label, String value, Color color) {
    return Row(
      children: [
        Text(label, style: AppStyles.custom(size: 9, color: AppTheme.grey600)),
        Spacer(),
        Text(
          value,
          style: AppStyles.custom(
            size: 10,
            weight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: controller.createDueEntry,
      backgroundColor: Color(0xFF6C5CE7),
      icon: Icon(Icons.add, color: AppTheme.backgroundLight),
      label: Text(
        'Add Due',
        style: AppStyles.custom(
          color: AppTheme.backgroundLight,
          weight: FontWeight.w600,
        ),
      ),
    );
  }

  // Navigation to details page
  void _navigateToDueDetails(CustomerDue due) {
    Get.to(() => CustomerDueDetailsScreen(due: due));
  }

  // Helper methods
  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getInitials(String name) {
    List<String> parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.length == 1) {
      return parts[0].length >= 2
          ? parts[0].substring(0, 2).toUpperCase()
          : parts[0][0].toUpperCase();
    }
    return 'UN';
  }

  void _showAddPaymentDialog(CustomerDue due) {
    TextEditingController amountController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Add Payment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: ${due.customerName}'),
            SizedBox(height: 8),
            Text('Remaining Due: ₹${due.remainingDue.toStringAsFixed(2)}'),
            SizedBox(height: 16),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Payment Amount',
                border: OutlineInputBorder(),
                prefixText: '₹',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              double amount = double.tryParse(amountController.text) ?? 0;
              if (amount > 0) {
                controller.addPartialPayment(due.id, amount);
                Get.back();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF6C5CE7)),
            child: Text(
              'Add Payment',
              style: AppStyles.custom(color: AppTheme.backgroundLight),
            ),
          ),
        ],
      ),
    );
  }
}
