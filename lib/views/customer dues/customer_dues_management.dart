import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/bottom_navigation_screen.dart';
import 'package:smartbecho/controllers/customer%20dues%20controllers/customer_dues_controller.dart';
import 'package:smartbecho/models/customer%20dues%20management/all_customer_dues_model.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/common_date_feild.dart';
import 'package:smartbecho/utils/custom_appbar.dart';
import 'package:smartbecho/utils/show_network_image.dart';
import 'package:smartbecho/views/customer%20dues/components/customer_dues_details.dart';

class CustomerDuesManagementScreen extends StatefulWidget {
  @override
  _CustomerDuesManagementScreenState createState() =>
      _CustomerDuesManagementScreenState();
}

class _CustomerDuesManagementScreenState
    extends State<CustomerDuesManagementScreen>
    with SingleTickerProviderStateMixin {
  final CustomerDuesController controller = Get.find<CustomerDuesController>();
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScroll);

    // Listen to tab changes
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        controller.onTabChanged(_tabController.index == 0 ? 'dues' : 'paid');
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      controller.loadMoreDues();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BuildAppBar(
        title: "Dues Management",
        onPressed: () {
          final bottomNavController = Get.find<BottomNavigationController>();
          bottomNavController.setIndex(0);
        },
        actionItem: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            onPressed: controller.showAnalyticsModal,
            icon: Icon(Icons.analytics_outlined),
          ),
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // _buildCustomAppBar(),
            _buildSummaryCards(),
            _buildSearchAndFilters(),
            _buildTabs(),
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildCustomAppBar() {
    return buildCustomAppBar(
      "Dues Management",
      isdark: true,
      onPressed: () {
        final bottomNavController = Get.find<BottomNavigationController>();
        bottomNavController.setIndex(0);
      },
      actionItem: IconButton(
        onPressed: controller.showAnalyticsModal,
        icon: Icon(Icons.analytics_outlined),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Obx(() {
        if (controller.isSummaryDataLoading.value == true) {
          return _buildSummaryCardsShimmer();
        }

        final summary = controller.summaryData.value!;

        return ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 16),
          children: [
            _buildSummaryCard(
              'Total Dues\nGiven',
              '₹${summary.totalGiven}',
              Icons.account_balance_wallet_outlined,
              AppColors.primaryLight,
            ),
            _buildSummaryCard(
              'Total\nCollected',
              '₹${summary.totalCollected}',
              Icons.check_circle_outline,
              Color(0xFF51CF66),
            ),
            _buildSummaryCard(
              'Total\nRemaining',
              '₹${summary.totalRemaining}',
              Icons.error_outline,
              Color(0xFFFF6B6B),
            ),
            _buildSummaryCard(
              'This Month\nCollected',
              '₹${summary.thisMonthCollection}',
              Icons.calendar_today_outlined,
              Color(0xFF4ECDC4),
            ),
            _buildSummaryCard(
              'Tap to see',
              'Today\'s\nRetrieval',
              Icons.people_outline,
              Color(0xFFFF9500),
              onTap: () => Get.toNamed(AppRoutes.todaysRetrievalDues),
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
    Color color, {
    void Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: EdgeInsets.only(right: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.08),
              spreadRadius: 0,
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 2),
              Text(
                title,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                  height: 1.2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.primaryLight,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
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
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.withValues(alpha: 0.2),
                      ),
                    ),
                    child: TextField(
                      onChanged: controller.onSearchChanged,
                      decoration: InputDecoration(
                        hintText: 'Search by name, ID, or customer ID...',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          size: 20,
                          color: Colors.grey[500],
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                // Filter Button
                Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primaryLight.withValues(alpha: 0.3),
                    ),
                  ),
                  child: IconButton(
                    onPressed: () => _showFilterBottomSheet(context),
                    icon: Icon(
                      Icons.tune,
                      size: 20,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ),
              ],
            ),
            // SizedBox(height: 12),
            // Quick Filter buttons
            // Row(
            //   children: [
            //     Expanded(
            //       child: _buildFilterButton(
            //         'Reset',
            //         Icons.refresh,
            //         onPressed: controller.resetFilters,
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(
    String text,
    IconData icon, {
    VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: Colors.grey[600]),
            SizedBox(width: 4),
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        final duesCount = controller.allDues.length;
        final paidCount = controller.paidDues.length;

        return TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.primaryLight,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[600],
          labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 18),
                  SizedBox(width: 4),
                  Text('Dues ($duesCount)'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 18),
                  SizedBox(width: 4),
                  Text('Paid ($paidCount)'),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTabContent() {
    return RefreshIndicator(
      onRefresh: controller.refreshData,
      child: TabBarView(
        controller: _tabController,
        children: [_buildDuesTab(), _buildPaidTab()],
      ),
    );
  }

  Widget _buildDuesTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingIndicator();
      }

      final duesCustomers = controller.allDues;

      if (duesCustomers.isEmpty) {
        return _buildEmptyState(
          'No dues found',
          'All customers have paid their dues',
        );
      }

      return SingleChildScrollView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildCustomerGrid(duesCustomers, isDuesSection: true),
            _buildLoadMoreIndicator(),
            SizedBox(height: 80), // Space for FAB
          ],
        ),
      );
    });
  }

  Widget _buildPaidTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingIndicator();
      }

      final paidCustomers = controller.paidDues;

      if (paidCustomers.isEmpty) {
        return _buildEmptyState(
          'No paid customers',
          'Customers who have paid will appear here',
        );
      }

      return SingleChildScrollView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            _buildCustomerGrid(paidCustomers, isDuesSection: false),
            _buildLoadMoreIndicator(),
            SizedBox(height: 80), // Space for FAB
          ],
        ),
      );
    });
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: AppColors.primaryLight,
              strokeWidth: 3,
            ),
            SizedBox(height: 16),
            Text(
              'Loading dues...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerGrid(
    List<CustomerDue> customers, {
    required bool isDuesSection,
  }) {
    return Container(
      margin: EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          return _buildCustomerCard(customer, isDuesSection: isDuesSection);
        },
      ),
    );
  }

  Widget _buildCustomerCard(
    CustomerDue customer, {
    required bool isDuesSection,
  }) {
    // Determine status color based on remainingDue
    Color statusColor =
        customer.remainingDue <= 0 ? Colors.green : AppColors.errorLight;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 15,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar and status
          Container(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey[200],
                  child:
                      customer.profileUrl != null
                          ? cachedImage(customer.profileUrl!)
                          : Icon(Icons.person, color: Colors.grey[600]),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name ?? "",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'ID: ${customer.id}',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    customer.statusText,
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Amount details
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAmountRow(
                    'Total Given Dues:',
                    customer.totalDue,
                    Colors.black87,
                  ),
                  SizedBox(height: 4),
                  _buildAmountRow('Paid:', customer.totalPaid, Colors.green),
                  SizedBox(height: 4),
                  _buildAmountRow(
                    'Remaining:',
                    customer.remainingDue,
                    customer.remainingDue <= 0
                        ? Colors.green
                        : AppColors.errorLight,
                    isHighlight: true,
                  ),
                  SizedBox(height: 8),

                  // Progress bar (only for dues section)
                  if (isDuesSection && customer.totalDue > 0) ...[
                    LinearProgressIndicator(
                      value: customer.paymentProgress / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      minHeight: 3,
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${customer.paymentProgress.toStringAsFixed(1)}% paid',
                      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Action buttons
          Container(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'View',
                    Icons.visibility_outlined,
                    Colors.blue,
                    onPressed: () => controller.viewCustomerDetails(customer),
                  ),
                ),
                SizedBox(width: 8),
                isDuesSection
                    ? Expanded(
                      child: _buildActionButton(
                        'Notify',
                        Icons.notifications_outlined,
                        Colors.orange,
                        onPressed:
                            () => controller.notifyCustomer(
                              customer.customerId,
                              customer.name ?? "",
                            ),
                      ),
                    )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(
    String label,
    double amount,
    Color color, {
    bool isHighlight = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          '₹${amount}',
          style: TextStyle(
            fontSize: isHighlight ? 13 : 12,
            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color, {
    VoidCallback? onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    return Obx(() {
      if (controller.isLoadingMore.value) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                CircularProgressIndicator(
                  color: AppColors.primaryLight,
                  strokeWidth: 2,
                ),
                SizedBox(height: 8),
                Text(
                  'Loading more...',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        );
      }
      return SizedBox.shrink();
    });
  }

  Widget _buildEmptyState([String? title, String? subtitle]) {
    return Container(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long_outlined, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            title ?? 'No customer dues found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle ?? 'Create your first due entry to get started',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: controller.createDueEntry,
      backgroundColor: AppColors.primaryLight,
      label: Text(
        'Add Due',
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
      icon: Icon(Icons.add, color: Colors.white),
    );
  }

  // Filter Bottom Sheet
  void _showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      SafeArea(
        child: Container(
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

              // Time Period Row
              Obx(
                () => _buildStyledDropdown(
                  labelText: 'Time Period',
                  hintText: 'Select Period',
                  value: controller.timePeriodType.value,
                  items: controller.timePeriodOptions,
                  onChanged: controller.onTimePeriodTypeChanged,
                ),
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
                      (value) =>
                          controller.onSortChanged(value ?? 'creationDate'),
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
                        foregroundColor: AppColors.primaryLight,
                        side: BorderSide(color: AppColors.primaryLight),
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
                        backgroundColor: AppColors.primaryLight,
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
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _resetFilters() {
    controller.resetFilters();
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
              value:
                  controller.selectedMonth.value != null
                      ? controller.getMonthName(controller.selectedMonth.value!)
                      : null,
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
              value: controller.selectedYear.value?.toString(),
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
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
          ),
          child: DropdownButtonFormField<String>(
            value: value,
            hint: Text(
              hintText,
              style: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
              suffixIcon: suffixIcon,
            ),
            style: const TextStyle(
              color: Color(0xFF374151),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            items:
                items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
            onChanged: onChanged,
            icon:
                suffixIcon == null
                    ? Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF))
                    : SizedBox.shrink(),
          ),
        ),
      ],
    );
  }

  // String _formatAmount(double amount) {
  //   if (amount >= 100000) {
  //     return '${(amount / 100000).toStringAsFixed(1)}L';
  //   } else if (amount >= 1000) {
  //     return '${(amount / 1000).toStringAsFixed(1)}K';
  //   } else {
  //     return amount.toStringAsFixed(0);
  //   }
  // }
}
