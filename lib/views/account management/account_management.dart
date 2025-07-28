import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/account%20management%20controller/account_management_controller.dart';
import 'package:smartbecho/models/account%20management%20models/account_summary_model.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/utils/custom_appbar.dart';
import 'package:smartbecho/views/account%20management/components/commision%20received/commission_received.dart';
import 'package:smartbecho/views/account%20management/components/emi%20settlement/emi_settlement.dart';
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
      actionItem: IconButton(
        onPressed: controller.refreshData,
        icon: Icon(Icons.refresh, color: Colors.black87),
      ),
    );
  }

  Widget _buildAnimatedTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
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
        margin: EdgeInsets.only(right: 8),
        child: GestureDetector(
          onTap: () => controller.onTabChanged(item.id),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(
              horizontal: isActive ? 20 : 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isActive ? item.color : Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: isActive ? item.color : Colors.grey.withOpacity(0.3),
                width: 1.5,
              ),
              boxShadow:
                  isActive
                      ? [
                        BoxShadow(
                          color: item.color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ]
                      : [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
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
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: isActive ? 8 : 0,
                  child: SizedBox(width: isActive ? 8 : 0),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: isActive ? null : 0,
                  child:
                      isActive
                          ? Text(
                            item.label,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                          : SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildTabContent() {
    return Container(
      margin: EdgeInsets.all(16),
      child: Obx(() {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 400),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return SlideTransition(
              position: animation.drive(
                Tween(begin: Offset(1.0, 0.0), end: Offset.zero),
              ),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          child: _buildSelectedTabContent(),
        );
      }),
    );
  }

  Widget _buildSelectedTabContent() {
    if (controller.isLoading.value) {
      return Container(
        key: ValueKey('loading'),
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6C5CE7),
            strokeWidth: 3,
          ),
        ),
      );
    }

    switch (controller.selectedTab.value) {
      case 'account-summary':
        return Container(
          key: ValueKey('account-summary'),
          child: _buildAccountSummaryContent(),
        );
      case 'pay-bill':
        return Container(key: ValueKey('pay-bill'), child: PayBillsPage());
      case 'withdraw':
        return Container(
          key: ValueKey('withdraw'),
          child: WithdrawHistoryPage(),
        );
      case 'commission':
        return Container(
          key: ValueKey('commission'),
          child: CommissionReceivedPage(),
        );
      case 'history':
        return Container(key: ValueKey('history'), child: History());
      case 'emi-settlement':
        return Container(
          key: ValueKey('emi-settlement'),
          child: EmiSettlementPage(),
        );
      default:
        return Container(
          key: ValueKey('default'),
          child: _buildAccountSummaryContent(),
        );
    }
  }

  Widget _buildAccountSummaryContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle('Account Summary Dashboard'),
          SizedBox(height: 16),
          _buildAccountSummaryCards(),
          SizedBox(height: 24),
          _buildMetricsGrid(),
          SizedBox(height: 24),
          _buildChartsSection(),
        ],
      ),
    );
  }

  Widget _buildAccountSummaryCards() {
    return Container(
      height: 130,
      child: Obx(() {
        if (controller.isLoading.value) {
          return _buildSummaryCardsShimmer();
        }

        if (controller.accountData.value == null) {
          return Center(
            child: Text(
              'No data available',
              style: TextStyle(color: Colors.grey[600]),
            ),
          );
        }

        final data = controller.accountData.value!;

        return ListView(
          scrollDirection: Axis.horizontal,
          children: [
            _buildSummaryCard(
              'Opening\nBalance',
              '₹${controller.formatAmount(data.openingBalance)}',
              Icons.account_balance_wallet_outlined,
              Color(0xFF6C5CE7),
            ),
            _buildSummaryCard(
              'In-Counter\nCash',
              '₹${controller.formatAmount(data.inCounterCash)}',
              Icons.payments_outlined,
              Color(0xFF51CF66),
            ),
            _buildSummaryCard(
              'In-Account\nBalance',
              '₹${controller.formatAmount(data.inAccountBalance)}',
              Icons.account_balance_outlined,
              Color(0xFF4ECDC4),
            ),
            _buildSummaryCard(
              'Total\nSales',
              '₹${controller.formatAmount(data.totalSales)}',
              Icons.shopping_cart_outlined,
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
            child: Icon(icon, color: color, size: 20),
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
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCardsShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: 4,
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
              color: Color(0xFF6C5CE7),
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricsGrid() {
    final data = controller.accountData.value;
    if (data == null) return SizedBox.shrink();

    final metrics = [
      {
        'title': 'Total Paid Bills',
        'value': data.totalPaidBills,
        'icon': Icons.receipt_outlined,
        'color': Color(0xFFFF6B6B),
      },
      {
        'title': 'Total Commission',
        'value': data.totalCommission,
        'icon': Icons.monetization_on_outlined,
        'color': Color(0xFF51CF66),
      },
      {
        'title': 'Net Balance',
        'value': data.netBalance,
        'icon': Icons.savings_outlined,
        'color': Color(0xFF4ECDC4),
      },
      {
        'title': 'Closing Balance',
        'value': data.closingBalance,
        'icon': Icons.account_balance_outlined,
        'color': Color(0xFF6C5CE7),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final metric = metrics[index];
        return _buildMetricCard(
          metric['title'] as String,
          metric['value'] as double,
          metric['icon'] as IconData,
          metric['color'] as Color,
        );
      },
    );
  }

  Widget _buildMetricCard(
    String title,
    double value,
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
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          Spacer(),
          Text(
            '₹${controller.formatAmount(value)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildChartsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Text(
            'Financial Overview',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Container(
            height: 200,
            child: Center(
              child: Text(
                'Chart visualization will be implemented here',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
          ),
        ],
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
