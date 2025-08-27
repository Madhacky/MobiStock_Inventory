import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/account%20management%20controller/account_management_controller.dart';
import 'package:smartbecho/models/account%20management%20models/account_summary_model.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/utils/custom_appbar.dart';
import 'package:smartbecho/utils/generic_charts.dart';
import 'package:smartbecho/views/account%20management/components/commision%20received/commission_received.dart';
import 'package:smartbecho/views/account%20management/components/emi%20settlement/emi_settlement.dart';
import 'package:smartbecho/views/account%20management/components/gst%20ledger/gst_ledger_page.dart';
import 'package:smartbecho/views/account%20management/components/history.dart';
import 'package:smartbecho/views/account%20management/components/paybill/paybill.dart';
import 'package:smartbecho/views/account%20management/components/withdraw/withdraw.dart';
import 'package:smartbecho/views/account%20management/widgets/header_widget.dart';

class AccountManagementScreen extends StatelessWidget {
  final AccountManagementController controller =
      Get.find<AccountManagementController>();

  final List<NavItemModel> navItems = [
    NavItemModel(
      id: 'account-summary',
      label: 'Account Summary',
      icon: Icons.account_balance_wallet_outlined,
      activeIcon: Icons.account_balance_wallet,
      color: Color(0xFF6C5CE7),
    ),
    NavItemModel(
      id: 'history',
      label: 'View History',
      icon: Icons.history_outlined,
      activeIcon: Icons.history,
      color: Color(0xFFFF6B6B),
    ),
    NavItemModel(
      id: 'pay-bill',
      label: 'Pay Bill',
      icon: Icons.payment_outlined,
      activeIcon: Icons.payment,
      color: Color(0xFF51CF66),
    ),
    NavItemModel(
      id: 'withdraw',
      label: 'Withdraw',
      icon: Icons.arrow_downward_outlined,
      activeIcon: Icons.arrow_downward,
      color: Color(0xFFFF9500),
    ),
    NavItemModel(
      id: 'commission',
      label: 'Commission Received',
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
      color: Color(0xFF4ECDC4),
    ),
    NavItemModel(
      id: 'emi-settlement',
      label: 'EMI Settlements',
      icon: Icons.credit_card_outlined,
      activeIcon: Icons.credit_card,
      color: Color(0xFF9C27B0),
    ),
        NavItemModel(
      id: 'gst-ledger',
      label: 'GST Ledger',
      icon: Icons.file_copy,
      activeIcon: Icons.file_copy,
      color: Color.fromARGB(255, 231, 195, 154),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomAppBar(),
            _buildAnimatedTabBar(),
            Expanded(child: _buildTabContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomAppBar() {
    return buildCustomAppBar(
      "Account Management",
      isdark: true,
      actionItem: Obx(
        () => IconButton(
          onPressed: controller.isLoading.value ? null : controller.refreshData,
          icon:
              controller.isLoading.value
                  ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                    ),
                  )
                  : Icon(Icons.refresh, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildAnimatedTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        child: Row(
          children: navItems.map((item) => _buildAnimatedTab(item)).toList(),
        ),
      ),
    );
  }

  Widget _buildAnimatedTab(NavItemModel item) {
    return Obx(() {
      final isActive = controller.selectedTab.value == item.id;

      return AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(right: 12),
        child: GestureDetector(
          onTap: () => controller.onTabChanged(item.id),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(
              horizontal: isActive ? 20 : 16,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: isActive ? item.color : Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color:
                    isActive ? item.color : Colors.grey.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow:
                  isActive
                      ? [
                        BoxShadow(
                          color: item.color.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ]
                      : [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  child: Icon(
                    isActive ? item.activeIcon : item.icon,
                    color: isActive ? Colors.white : Colors.grey[700],
                    size: 18,
                  ),
                ),
                if (isActive) ...[
                  SizedBox(width: 8),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    child: Text(
                      item.label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTabContent() {
    return Obx(() {
      return AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: Offset(0.1, 0.0), end: Offset.zero),
            ),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: _buildSelectedTabContent(),
      );
    });
  }

  Widget _buildSelectedTabContent() {
    switch (controller.selectedTab.value) {
      case 'account-summary':
        return Container(
          key: ValueKey('account-summary'),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _buildAccountSummaryContent(),
        );
      case 'pay-bill':
        return Container(
          key: ValueKey('pay-bill'),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: PayBillsPage(),
        );
      case 'withdraw':
        return Container(
          key: ValueKey('withdraw'),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: WithdrawHistoryPage(),
        );
      case 'commission':
        return Container(
          key: ValueKey('commission'),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: CommissionReceivedPage(),
        );
      case 'history':
        return Container(
          key: ValueKey('history'),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: History(),
        );
      case 'emi-settlement':
        return Container(
          key: ValueKey('emi-settlement'),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: EmiSettlementPage(),
        );
      case 'gst-ledger':
        return Container(
          key: ValueKey('gst-ledger'),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: GstLedgerHistoryPage(),
        );
      default:
        return Container(
          key: ValueKey('default'),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: _buildAccountSummaryContent(),
        );
    }
  }

  Widget _buildAccountSummaryContent() {
    return Obx(() {
      if (controller.isLoading.value &&
          controller.accountDashboardData.value == null) {
        return _buildFullPageLoader();
      }

      if (controller.hasError.value &&
          controller.accountDashboardData.value == null) {
        return _buildErrorState();
      }

      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            buildSectionTitle('Account Summary Dashboard'),
            SizedBox(height: 20),
            _buildAccountSummaryCards(),
            SizedBox(height: 24),
            _buildMetricsGrid(),
            SizedBox(height: 24),
            _buildChartsSection(),
            SizedBox(height: 16), // Bottom padding
          ],
        ),
      );
    });
  }

  Widget _buildFullPageLoader() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF6C5CE7), strokeWidth: 3),
          SizedBox(height: 16),
          Text(
            'Loading account data...',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
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
            'Failed to load account summary',
            style: TextStyle(
              color: Colors.red,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            'Please check your connection and try again',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: controller.refreshData,
            icon: Icon(Icons.refresh),
            label: Text('Retry'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF6C5CE7),
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

  Widget _buildAccountSummaryCards() {
    return Container(
      height: 140,
      child: Obx(() {
        if (controller.isLoading.value &&
            controller.accountDashboardData.value == null) {
          return _buildSummaryCardsShimmer();
        }

        if (controller.hasError.value &&
            controller.accountDashboardData.value == null) {
          return _buildSummaryCardsError();
        }

        return ListView(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 4),
          children: [
            _buildSummaryCard(
              "Today's Opening\nCash",
              controller.formatAmount(controller.openingBalance),
              Icons.account_balance_wallet_outlined,
              Color(0xFF6C5CE7),
            ),
            _buildSummaryCard(
              "Today's Closing\nCash",
              controller.formatAmount(controller.closingBalance),
              Icons.payments_outlined,
              Color(0xFF51CF66),
            ),
            _buildSummaryCard(
              "Today's Sales",
              controller.formatAmount(controller.totalSale),
              Icons.shopping_cart_outlined,
              Color(0xFFFF9500),
            ),
            _buildSummaryCard(
              "Today's EMI Collected",
              controller.formatAmount(controller.emiReceivedToday),
              Icons.account_balance_outlined,
              Color(0xFF4ECDC4),
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
      width: 150,
      margin: EdgeInsets.symmetric(horizontal: 8),
      padding: EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(height: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCardsShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 4),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          width: 150,
          margin: EdgeInsets.symmetric(horizontal: 8),
          padding: EdgeInsets.all(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShimmerBox(32, 32, 8),
              SizedBox(height: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildShimmerBox(80, 18, 4),
                    SizedBox(height: 8),
                    _buildShimmerBox(100, 12, 4),
                    SizedBox(height: 4),
                    _buildShimmerBox(60, 12, 4),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCardsError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red[300], size: 32),
          SizedBox(height: 8),
          Text(
            'Failed to load summary cards',
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerBox(double width, double height, double borderRadius) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: LinearProgressIndicator(
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[100]!),
        ),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return Obx(() {
      if (controller.isLoading.value &&
          controller.accountDashboardData.value == null) {
        return _buildMetricsShimmer();
      }

      if (controller.hasError.value &&
          controller.accountDashboardData.value == null) {
        return _buildMetricsError();
      }

      final data = controller.accountDashboardData.value;
      if (data == null) return SizedBox.shrink();

      final metrics = [
        {
          'title': 'Due Payments Collected',
          'value': controller.formatAmount(controller.duesRecovered),
          'icon': Icons.receipt_outlined,
          'color': Color(0xFFFF6B6B),
        },
        {
          'title': "Today's Bills Paid",
          'value': controller.formatAmount(controller.payBills),
          'icon': Icons.monetization_on_outlined,
          'color': Color(0xFF51CF66),
        },
        {
          'title': "Today's Withdrawals",
          'value': controller.formatAmount(controller.withdrawals),
          'icon': Icons.savings_outlined,
          'color': Color(0xFF4ECDC4),
        },
        {
          'title': 'Total Commission',
          'value': controller.formatAmount(controller.commissionReceived),
          'icon': Icons.account_balance_outlined,
          'color': Color(0xFF6C5CE7),
        },
      ];

      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        itemCount: metrics.length,
        itemBuilder: (context, index) {
          final metric = metrics[index];
          return _buildMetricCard(
            metric['title'] as String,
            metric['value'] as String,
            metric['icon'] as IconData,
            metric['color'] as Color,
          );
        },
      );
    });
  }

  Widget _buildMetricsShimmer() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.08),
                spreadRadius: 0,
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildShimmerBox(30, 30, 6),
              Spacer(),
              _buildShimmerBox(60, 16, 4),
              SizedBox(height: 4),
              _buildShimmerBox(80, 11, 4),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetricsError() {
    return Center(
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.red[300], size: 32),
          SizedBox(height: 8),
          Text(
            'Failed to load metrics',
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
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
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Obx(() {
      if (controller.isLoading.value &&
          controller.accountDashboardData.value == null) {
        return _buildChartShimmer();
      }

      if (controller.hasError.value &&
          controller.accountDashboardData.value == null) {
        return _buildChartError();
      }

      if (controller.creditByAccount.isEmpty) {
        return _buildNoDataState();
      }

      return GenericDoubleBarChart(
        title: 'Cash vs Account Balance',
        payload: controller.creditByAccount,
        secondaryPayload: controller.creditByAccount,
        primaryLabel: 'Cash Amount',
        secondaryLabel: 'Account Balance',
        primaryBarColor: Colors.green[500],
        secondaryBarColor: Colors.red[400],
        screenWidth: controller.screenWidth,
        isSmallScreen: controller.isSmallScreen,
        chartHeight: 300,
        dataType: ChartDataType.revenue,
        showTotals: true,
      );
    });
  }

  Widget _buildChartShimmer() {
    return Container(
      height: 300,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildShimmerBox(200, 20, 4),
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF6C5CE7),
                strokeWidth: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartError() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, color: Colors.red[300], size: 48),
            SizedBox(height: 12),
            Text(
              'Failed to load financial overview',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoDataState() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart_outlined, color: Colors.grey[400], size: 48),
            SizedBox(height: 12),
            Text(
              'No financial data available',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            SizedBox(height: 4),
            Text(
              'Data will appear here once available',
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class NavItemModel {
  final String id;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Color color;

  NavItemModel({
    required this.id,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.color,
  });
}
