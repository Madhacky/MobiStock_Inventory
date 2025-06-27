// File: views/dashboard/inventory_dashboard.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/auth%20controllers/auth_controller.dart';
import 'package:smartbecho/controllers/dashboard_controller.dart';
import 'package:smartbecho/controllers/user_prefs_controller.dart';
import 'package:smartbecho/models/dashboard_models/sales_summary_model.dart';
import 'package:smartbecho/routes/app_routes.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:smartbecho/utils/generic_charts.dart';
import 'package:smartbecho/views/dashboard/charts/switchable_chart.dart';
import 'package:smartbecho/views/dashboard/widgets/dashboard_shimmers.dart';
import 'package:smartbecho/views/dashboard/widgets/drawer.dart';
import 'package:smartbecho/views/dashboard/widgets/error_cards.dart';
import 'package:smartbecho/views/dashboard/widgets/user_pref_dailog.dart';

class InventoryDashboard extends StatefulWidget {
  @override
  State<InventoryDashboard> createState() => _InventoryDashboardState();
}

class _InventoryDashboardState extends State<InventoryDashboard> {
  final DashboardController controller = Get.find<DashboardController>();

  final AuthController authController = Get.find<AuthController>();
  final UserPrefsController userPrefsController =
      Get.find<UserPrefsController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        drawer: ModernAppDrawer(),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: AnimatedBuilder(
            animation: controller.animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: controller.fadeAnimation,
                child: SlideTransition(
                  position: controller.slideAnimation,
                  child: Column(
                    children: [
                      _buildHeader(),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: controller.refreshDashboardData,
                          backgroundColor: Colors.white,
                          color: Color(0xFF6C5CE7),
                          child: SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(
                              horizontal: controller.screenWidth * 0.04,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: controller.screenHeight * 0.02,
                                ),
                                _buildSearchBar(),
                                SizedBox(
                                  height: controller.screenHeight * 0.02,
                                ),
                                _buildTopStatsGrid(),

                                SizedBox(
                                  height: controller.screenHeight * 0.03,
                                ),
                                _buildSummaryCardsSection(),
                                SizedBox(
                                  height: controller.screenHeight * 0.03,
                                ),
                                _buildInsightsCharts(),

                                SizedBox(
                                  height: controller.screenHeight * 0.03,
                                ),
                                _buildQuickActionsSection(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        floatingActionButton: _buildFloatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(controller.screenWidth * 0.05),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Builder(
            builder:
                (context) => _buildHeaderButton(
                  Icons.menu_rounded,
                  onTap: () => Scaffold.of(context).openDrawer(),
                ),
          ),
          SizedBox(width: 16),
          Expanded(child: Image.asset('assets/applogo.png')),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeaderButton(
                Icons.filter_alt_sharp,
                onTap:
                    () => context.showViewPreferencesBottomSheet(
                      userPrefsController,
                    ),
              ),
              SizedBox(width: 8),

              _buildHeaderButton(
                Icons.person_rounded,
                onTap: () => Get.toNamed(AppRoutes.profile),
              ),
              SizedBox(width: 8),
              _buildHeaderButton(
                Icons.logout,
                onTap: () => authController.logout(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton(IconData icon, {void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.all(controller.isSmallScreen ? 8 : 10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey[300]!, width: 1),
        ),
        child: Icon(
          icon,
          color: Colors.grey[700],
          size: controller.isSmallScreen ? 16 : 18,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: TextField(
        onChanged: controller.updateSearchQuery,
        style: AppStyles.custom(
          color: Colors.black87,
          size: controller.isSmallScreen ? 14 : 16,
          weight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText:
              controller.isSmallScreen
                  ? 'Search products...'
                  : 'Search products, EMI records, sales...',
          hintStyle: AppStyles.custom(
            color: Colors.grey[500],
            size: controller.isSmallScreen ? 14 : 16,
            weight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search_outlined,
            color: Colors.grey[500],
            size: controller.isSmallScreen ? 20 : 22,
          ),
          suffixIcon: Icon(
            Icons.filter_list_outlined,
            color: Colors.grey[500],
            size: controller.isSmallScreen ? 20 : 22,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: controller.isSmallScreen ? 14 : 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTopStatsGrid() {
    return Column(
      children: [
        Obx(
          () =>
              controller.isTodaysSalesCardLoading.value
                  ? TodaysSalesStatsShimmer(itemCount: 3)
                  : controller.hasTodaysSalesCardError.value
                  ? buildErrorCard(
                    controller.todaysSalesCarderrorMessage,
                    controller.screenWidth,
                    controller.screenHeight,
                    controller.isSmallScreen,
                  )
                  : userPrefsController.isTopStatGridView.value
                  ? _buildTopStatsGridView()
                  : _buildTopStatsListView(),
        ),
      ],
    );
  }

  // Grid view widget
  Widget _buildTopStatsGridView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: controller.isSmallScreen ? 1 : 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 10,
        childAspectRatio: controller.isSmallScreen ? 2.5 : 2,
      ),
      itemCount: controller.topStats.length,
      itemBuilder:
          (context, index) => _buildTopStatCard(controller.topStats[index]),
    );
  }

  // List view widget
  Widget _buildTopStatsListView() {
    return ListView.separated(
      separatorBuilder: (context, index) => SizedBox(height: 10),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: controller.topStats.length,
      itemBuilder:
          (context, index) => _buildTopStatCard(controller.topStats[index]),
    );
  }

  Widget _buildTopStatCard(StatItem stat) {
    return Container(
      padding: EdgeInsets.all(controller.screenWidth * 0.04),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: stat.colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: stat.colors[0].withOpacity(0.25),
            spreadRadius: 0,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(controller.isSmallScreen ? 8 : 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              stat.icon,
              color: Colors.white,
              size: controller.isSmallScreen ? 20 : 24,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  stat.title,
                  style: AppStyles.custom(
                    size: controller.isSmallScreen ? 10 : 12,
                    color: Colors.white.withOpacity(0.9),
                    weight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  stat.value,
                  style: AppStyles.custom(
                    size: controller.isSmallScreen ? 20 : 24,
                    weight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Quick Actions',
            style: AppStyles.custom(
              size: controller.isSmallScreen ? 18 : 20,
              weight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(height: 16),
        _buildQuickActionsGrid(),
      ],
    );
  }

  Widget _buildQuickActionsGrid() {
    return Obx(
      () => GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: controller.isSmallScreen ? 2 : 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: controller.isSmallScreen ? 1.6 : 1.8,
        ),
        itemCount: controller.quickActions.length,
        itemBuilder:
            (context, index) =>
                _buildQuickActionCard(controller.quickActions[index]),
      ),
    );
  }

  Widget _buildQuickActionCard(QuickActionButton action) {
    return InkWell(
      onTap: () => controller.handleQuickAction(action.title),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: EdgeInsets.all(controller.screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey[200]!, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(controller.isSmallScreen ? 8 : 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: action.colors),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                action.icon,
                color: Colors.white,
                size: controller.isSmallScreen ? 16 : 18,
              ),
            ),
            SizedBox(height: 5),
            Flexible(
              child: Text(
                action.title,
                textAlign: TextAlign.center,
                style: AppStyles.custom(
                  color: Colors.black87,
                  size: controller.isSmallScreen ? 10 : 12,
                  weight: FontWeight.w600,
                ),
                maxLines: controller.isSmallScreen ? 2 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCardsSection() {
    return Column(
      children: [
        // Sales Summary - Full Width
        Obx(
          () =>
              controller.isSalesSummaryLoading.value
                  ? buildSalesSummaryShimmer(context, controller)
                  : controller.hasSalesSummaryError.value
                  ? buildErrorCard(
                    controller.errorMessage,
                    controller.screenWidth,
                    controller.screenHeight,
                    controller.isSmallScreen,
                  )
                  : _buildSummaryCard(
                    title: 'Sales Summary',
                    child: _buildSalesSummaryContent(),
                  ),
        ),

        SizedBox(height: 16),

        Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return Obx(() {
                  bool shouldUseGridView =
                      userPrefsController.isInventorySummaryGridView.value &&
                      constraints.maxWidth >= 360;

                  if (!shouldUseGridView) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          controller.isStockSummaryLoading.value
                              ? buildSalesSummaryShimmer(context, controller)
                              : controller.hasStockSummaryError.value
                              ? buildErrorCard(
                                controller.stockSummaryerrorMessage,
                                controller.screenWidth,
                                controller.screenHeight,
                                controller.isSmallScreen,
                              )
                              : _buildSummaryCard(
                                title: 'Stock Summary',
                                child: _buildStockSummaryContent(),
                              ),
                          SizedBox(height: 16),
                          _buildSummaryCard(
                            title: 'EMI Summary',
                            child: _buildEMISummaryContent(),
                          ),
                        ],
                      ),
                    );
                  } else {
                    // Grid View (Side by side)
                    return SingleChildScrollView(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child:
                                controller.isStockSummaryLoading.value
                                    ? buildSalesSummaryShimmer(
                                      context,
                                      controller,
                                    )
                                    : controller.hasStockSummaryError.value
                                    ? buildErrorCard(
                                      controller.stockSummaryerrorMessage,
                                      controller.screenWidth,
                                      controller.screenHeight,
                                      controller.isSmallScreen,
                                    )
                                    : _buildSummaryCard(
                                      title: 'Stock Summary',
                                      child: _buildStockSummaryContent(),
                                    ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: _buildSummaryCard(
                              title: 'EMI Summary',
                              child: _buildEMISummaryContent(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({required String title, required Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      padding: EdgeInsets.all(controller.screenWidth * 0.05),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.blue.shade50.withOpacity(0.3)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blue.shade100.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.2),
            blurRadius: 20,
            offset: Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 10,
            offset: Offset(0, -2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.cyan.shade300],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.custom(
                    size: controller.isSmallScreen ? 16 : 18,
                    weight: FontWeight.w700,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildSalesSummaryContent() {
    return Obx(
      () => Column(
        children: [
          // Main metrics with modern cards
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  'Total Sales',
                  controller.salesSummary!.value.totalSales,
                  Icons.trending_up_rounded,
                  Colors.purpleAccent.shade400,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  'Transactions',
                  '${controller.salesSummary!.value.totalTransactions}',
                  Icons.receipt_long_rounded,
                  Colors.blue.shade400,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          _buildMetricCard(
            'Smartphones Sold',
            '${controller.salesSummary!.value.smartphonesSold}',
            Icons.smartphone_rounded,
            Colors.purple.shade400,
            isFullWidth: true,
          ),
          SizedBox(height: 20),

          // Payment breakdown section
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50.withOpacity(0.7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.payment_rounded,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Payment Methods',
                      style: AppStyles.custom(
                        size: controller.isSmallScreen ? 13 : 14,
                        weight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                ...controller.salesSummary!.value.paymentBreakdown.entries
                    .take(controller.isSmallScreen ? 3 : 4)
                    .map((entry) => _buildPaymentItem(entry.key, entry.value)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockSummaryContent() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryItem(
            'Total Stock',
            controller.stockSummary.value.totalStock,
          ),
          SizedBox(height: 8),
          Text(
            'Company-Wise Stock',
            style: AppStyles.custom(
              size: controller.isSmallScreen ? 11 : 12,
              weight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4),
          ...controller.stockSummary.value.companyStock.entries
              .take(controller.isSmallScreen ? 2 : 3)
              .map(
                (entry) => _buildSummaryItem(entry.key, '${entry.value} units'),
              ),
          SizedBox(height: 8),
          Text(
            'Low Stock Alerts',
            style: AppStyles.custom(
              size: controller.isSmallScreen ? 11 : 12,
              weight: FontWeight.w600,
              color: Colors.red[600],
            ),
          ),
          SizedBox(height: 4),
          ...controller.stockSummary.value.lowStockAlerts
              .take(controller.isSmallScreen ? 2 : 3)
              .map((alert) => _buildAlertItem(alert)),
        ],
      ),
    );
  }

  Widget _buildEMISummaryContent() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryItem(
            'Total EMI Due',
            controller.emiSummary.value.totalEMIDue,
          ),
          _buildSummaryItem(
            'Total Phones on EMI',
            '${controller.emiSummary.value.phonesSoldOnEMI}',
          ),
          _buildSummaryItem(
            'Pending Payments',
            controller.emiSummary.value.pendingPayments,
          ),
          SizedBox(height: 8),
          Text(
            'Phones Sold on EMI',
            style: AppStyles.custom(
              size: controller.isSmallScreen ? 11 : 12,
              weight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 4),
          ...controller.emiSummary.value.emiPhones.entries
              .take(controller.isSmallScreen ? 2 : 3)
              .map((entry) => _buildSummaryItem(entry.key, entry.value)),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: AppStyles.custom(
                size: controller.isSmallScreen ? 10 : 11,
                color: Colors.grey[600],
                weight: FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: AppStyles.custom(
                size: controller.isSmallScreen ? 10 : 11,
                color: Colors.black87,
                weight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem(String method, PaymentDetail detail) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              '$method:',
              style: AppStyles.custom(
                size: controller.isSmallScreen ? 10 : 11,
                color: Colors.grey[600],
                weight: FontWeight.normal,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Text(
              '${detail.amount} (${detail.transactions})',
              style: AppStyles.custom(
                size: controller.isSmallScreen ? 10 : 11,
                color: Colors.black87,
                weight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(String alert) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Colors.red[600],
            size: controller.isSmallScreen ? 10 : 12,
          ),
          SizedBox(width: 4),
          Expanded(
            child: Text(
              alert,
              style: AppStyles.custom(
                size: controller.isSmallScreen ? 10 : 11,
                color: Colors.red[600],
                weight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6C5CE7).withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () => controller.handleQuickAction('Add Product'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Icon(
          Icons.add_rounded,
          color: Colors.white,
          size: controller.isSmallScreen ? 24 : 28,
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String label,
    String value,
    IconData icon,
    Color accentColor, {
    bool isFullWidth = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: accentColor.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.1),
            blurRadius: 12,
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
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: accentColor),
              ),
              if (!isFullWidth) Spacer(),
              if (isFullWidth) SizedBox(width: 12),
              if (isFullWidth)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: AppStyles.custom(
                          size: controller.isSmallScreen ? 11 : 12,
                          color: Colors.grey.shade600,
                          weight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        value,
                        style: AppStyles.custom(
                          size: controller.isSmallScreen ? 16 : 18,
                          color: Colors.grey.shade800,
                          weight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (!isFullWidth) ...[
            SizedBox(height: 12),
            Text(
              label,
              style: AppStyles.custom(
                size: controller.isSmallScreen ? 11 : 12,
                color: Colors.grey.shade600,
                weight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: AppStyles.custom(
                size: controller.isSmallScreen ? 16 : 18,
                color: Colors.grey.shade800,
                weight: FontWeight.w700,
              ),
            ),
          ],
        ],
      ),
    );
  }

  //build charts
  Widget _buildInsightsCharts() {
    return Column(
      children: [
        // Monthly Revenue Chart with loading/error handling
        Obx(
          () =>
              controller.isMonthlyRevenueChartLoading.value
                  ? GenericBarChartShimmer(title: "Monthly Revenue Performance")
                  : controller.hasMonthlyRevenueChartError.value
                  ? buildErrorCard(
                    controller.monthlyRevenueCharterrorMessage,
                    controller.screenWidth,
                    controller.screenHeight,
                    controller.isSmallScreen,
                  )
                  : SwitchableChartWidget(
                    payload: controller.monthlyRevenueChartPayload,
                    title: "Monthly Revenue Performance",
                    screenWidth: controller.screenWidth,
                    screenHeight: controller.screenHeight,
                    isSmallScreen: controller.isSmallScreen,
                    initialChartType: "barchart", // Start with bar chart
                    chartDataType: ChartDataType.revenue,
                  ),
        ),

        // Top-Selling Models Chart
        Obx(
          () =>
              controller.isTopSellingModelChartLoading.value
                  ? GenericBarChartShimmer(title: "Top-Selling Models")
                  : controller.hasisTopSellingModelChartError.value
                  ? buildErrorCard(
                    controller.topSellingModelCharterrorMessage,
                    controller.screenWidth,
                    controller.screenHeight,
                    controller.isSmallScreen,
                  )
                  : SwitchableChartWidget(
                    payload: controller.topSellingModelChartPayload,
                    title: "Top-Selling Models",
                    screenWidth: controller.screenWidth,
                    screenHeight: controller.screenHeight,
                    isSmallScreen: controller.isSmallScreen,
                    initialChartType: "piechart", // Start with pie chart
                    customColors: [
                      const Color(0xFF2196F3), // Blue for iPhone
                      const Color(0xFFE91E63), // Pink for Realme
                      const Color(0xFFFF9800), // Orange for Samsung
                    ],
                    chartDataType: ChartDataType.quantity,
                  ),
        ),

        //monthly emi dues
        Obx(
          () =>
              controller.isMonthlyEmiDuesChartLoading.value
                  ? GenericBarChartShimmer(title: "EMI dues per month")
                  : controller.hasmonthlyEmiDuesChartError.value
                  ? buildErrorCard(
                    controller.monthlyEmiDuesCharterrorMessage,
                    controller.screenWidth,
                    controller.screenHeight,
                    controller.isSmallScreen,
                  )
                  : SwitchableChartWidget(
                    payload: controller.monthlyEmiDuesChartPayload,
                    title: "EMI dues per month",
                    screenWidth: controller.screenWidth,
                    screenHeight: controller.screenHeight,
                    isSmallScreen: controller.isSmallScreen,
                    initialChartType: "piechart", // Start with pie chart
                    customColors: [
                      const Color(0xFF2196F3), // Blue for iPhone
                      const Color(0xFFE91E63), // Pink for Realme
                      const Color(0xFFFF9800), // Orange for Samsung
                    ],
                    chartDataType: ChartDataType.revenue,
                  ),
        ),
      ],
    );
  }
}
