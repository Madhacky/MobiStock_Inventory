import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/customer%20dues%20controllers/customer_dues_controller.dart';
import 'package:smartbecho/models/customer%20dues%20management/all_customer_dues_model.dart';
<<<<<<< HEAD
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:smartbecho/utils/common_month_year_dropdown.dart';
=======
import 'package:smartbecho/routes/app_routes.dart';
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
import 'package:smartbecho/utils/custom_appbar.dart';
import 'package:smartbecho/views/customer%20dues/components/customer_dues_details.dart';

class CustomerDuesManagementScreen extends StatefulWidget {
  @override
  _CustomerDuesManagementScreenState createState() => _CustomerDuesManagementScreenState();
}

class _CustomerDuesManagementScreenState extends State<CustomerDuesManagementScreen> 
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
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      controller.loadMoreDues();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.grey50,
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomAppBar(),
            _buildSummaryCards(),
            _buildSearchAndFilters(),
            _buildTabs(),
            Expanded(
              child: _buildTabContent(),
            ),
          ],
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
        icon: Icon(Icons.analytics_outlined),
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
              'This Month\n₹${_formatAmount(summary.thisMonthCollection)}',
              '${summary.totalCustomers} Customers',
              Icons.calendar_today_outlined,
              Color(0xFF4ECDC4),
            ),
            _buildSummaryCard(
              'Today\'s\nRetrieval',
              '${controller.paidCustomersCount} Customers',
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
<<<<<<< HEAD
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
=======
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
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
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
<<<<<<< HEAD
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
=======
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
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
<<<<<<< HEAD
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
=======
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Search Bar
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: TextField(
                onChanged: controller.onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search by name, ID, or customer ID...',
                  hintStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20,
                    color: Colors.grey[500],
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            SizedBox(height: 12),
            // Filter buttons
            Row(
              children: [
                Expanded(
                  child: _buildFilterButton(
                    'Sort by Date',
                    Icons.sort,
                    onPressed: () => _showSortOptions(),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _buildFilterButton(
                    'Reset',
                    Icons.refresh,
                    onPressed: controller.resetFilters,
                  ),
                ),
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String text, IconData icon, {VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
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
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Obx(() {
        final duesCount = controller.allDues.where((due) => due.remainingDue > 0).length;
        final paidCount = controller.allDues.where((due) => due.remainingDue <= 0).length;

        return TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Color(0xFF6C5CE7),
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey[600],
          labelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
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
        children: [
          _buildDuesTab(),
          _buildPaidTab(),
        ],
      ),
    );
  }

<<<<<<< HEAD
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
=======
  Widget _buildDuesTab() {
    return Obx(() {
      if (controller.isLoading.value) {
        return _buildLoadingIndicator();
      }

      final duesCustomers = controller.allDues.where((due) => due.remainingDue > 0).toList();

      if (duesCustomers.isEmpty) {
        return _buildEmptyState('No dues found', 'All customers have paid their dues');
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

      final paidCustomers = controller.allDues.where((due) => due.remainingDue <= 0).toList();

      if (paidCustomers.isEmpty) {
        return _buildEmptyState('No paid customers', 'Customers who have paid will appear here');
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
              color: Color(0xFF6C5CE7),
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
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
      ),
    );
  }

  Widget _buildCustomerGrid(List<CustomerDue> customers, {required bool isDuesSection}) {
    return Container(
      margin: EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          return _buildCustomerCard(customer, isDuesSection: isDuesSection);
        },
      ),
    );
  }

  Widget _buildCustomerCard(CustomerDue customer, {required bool isDuesSection}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
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
                  // backgroundImage: customer.profileUrl != null 
                  //     ? NetworkImage(customer.profileUrl!) 
                  //     : null,
                  child: Icon(Icons.person, color: Colors.grey[600]),
                  
                  //  customer.profileUrl == null
                  //     ? Icon(Icons.person, color: Colors.grey[600])
                  //     : null,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'ID: ${customer.customerId}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDuesSection 
                        ? Colors.red.withOpacity(0.1) 
                        : Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    customer.statusText,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: isDuesSection ? Colors.red : Colors.green,
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
                  _buildAmountRow('Total Due:', customer.totalDue, Colors.black87),
                  SizedBox(height: 4),
                  _buildAmountRow('Paid:', customer.totalPaid, Colors.green),
                  SizedBox(height: 4),
                  _buildAmountRow(
                    'Remaining:', 
                    customer.remainingDue, 
                    isDuesSection ? Colors.red : Colors.green,
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
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
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
                Expanded(
                  child: _buildActionButton(
                    'Notify',
                    Icons.notifications_outlined,
                    Colors.orange,
                    onPressed: () => controller.notifyCustomer(
                      customer.customerId, 
                      customer.name,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountRow(String label, double amount, Color color, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
<<<<<<< HEAD
        Text(label, style: AppStyles.custom(size: 9, color: AppTheme.grey600)),
        Spacer(),
        Text(
          value,
          style: AppStyles.custom(
            size: 10,
            weight: FontWeight.bold,
=======
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: isHighlight ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          '₹${_formatAmount(amount)}',
          style: TextStyle(
            fontSize: isHighlight ? 13 : 12,
            fontWeight: isHighlight ? FontWeight.w700 : FontWeight.w600,
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
            color: color,
          ),
        ),
      ],
    );
  }

<<<<<<< HEAD
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
=======
  Widget _buildActionButton(String label, IconData icon, Color color, {VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
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
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
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
                  color: Color(0xFF6C5CE7),
                  strokeWidth: 2,
                ),
                SizedBox(height: 8),
                Text(
                  'Loading more...',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
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
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
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
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: controller.createDueEntry,
      backgroundColor: Color(0xFF6C5CE7),
      label: Text(
        'Add Due',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      icon: Icon(Icons.add, color: Colors.white),
    );
  }

  void _showSortOptions() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Sort Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 20),
            _buildSortOption('Latest First', 'creationDate,desc'),
            _buildSortOption('Oldest First', 'creationDate,asc'),
            _buildSortOption('Highest Amount', 'totalDue,desc'),
            _buildSortOption('Lowest Amount', 'totalDue,asc'),
            _buildSortOption('Name A-Z', 'name,asc'),
            _buildSortOption('Name Z-A', 'name,desc'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String title, String sortValue) {
    return Obx(() {
      final isSelected = controller.selectedSort.value == sortValue;
      return InkWell(
        onTap: () {
          controller.onSortChanged(sortValue);
          Get.back();
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF6C5CE7).withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Color(0xFF6C5CE7) : Colors.grey.withOpacity(0.2),
            ),
          ),
          child: Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? Color(0xFF6C5CE7) : Colors.black87,
                ),
              ),
              Spacer(),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Color(0xFF6C5CE7),
                  size: 20,
                ),
            ],
          ),
        ),
      );
    });
  }

  String _formatAmount(double amount) {
    if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }
<<<<<<< HEAD

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
=======
}
>>>>>>> f22fa2fa092f8d46ad80c2c3e4ec5206279ac628
