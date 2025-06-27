import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/account%20management%20controller/account_management_controller.dart';
import 'package:smartbecho/models/account%20management%20models/account_summary_model.dart';
import 'package:smartbecho/services/app_config.dart';
import 'package:smartbecho/utils/custom_appbar.dart';
import 'package:smartbecho/views/account%20management/components/commision.dart';
import 'package:smartbecho/views/account%20management/components/history.dart';
import 'package:smartbecho/views/account%20management/components/paybill.dart';
import 'package:smartbecho/views/account%20management/components/withdraw.dart';

class AccountManagementScreen extends StatelessWidget {
  final AccountManagementController controller = Get.put(AccountManagementController());

  final List<NavItemModel> navItems = [
    NavItemModel(
      id: 'account-summary',
      label: 'Summary',
      icon: Icons.account_balance_wallet_outlined,
      activeIcon: Icons.account_balance_wallet,
      color: Color(0xFF6C5CE7),
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
      label: 'Commission',
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long,
      color: Color(0xFF4ECDC4),
    ),
    NavItemModel(
      id: 'history',
      label: 'History',
      icon: Icons.history_outlined,
      activeIcon: Icons.history,
      color: Color(0xFFFF6B6B),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            _buildCustomAppBar(),
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildAccountSummaryCards(),
                    _buildMainContent(),
                    SizedBox(height: 80), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildAnimatedBottomNavBar(),
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

  Widget _buildAccountSummaryCards() {
    return Container(
      height: 120,
      margin: EdgeInsets.symmetric(vertical: 8),
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
          padding: EdgeInsets.symmetric(horizontal: 16),
          children: [
            _buildSummaryCard(
              'Opening\nBalance',
              '₹${controller.formatAmount(data.openingBalance)}',
              Icons.account_balance_wallet_outlined,
              Color(0xFF6C5CE7),
            ),
            _buildSummaryCard(
              'Counter\nCash',
              '₹${controller.formatAmount(data.inCounterCash)}',
              Icons.payments_outlined,
              Color(0xFF51CF66),
            ),
            _buildSummaryCard(
              'Account\nBalance',
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
            _buildSummaryCard(
              'Net\nBalance',
              '₹${controller.formatAmount(data.netBalance)}',
              Icons.savings_outlined,
              Color(0xFF6C5CE7),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
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
            maxLines: 1,
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
              color: Color(0xFF6C5CE7),
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainContent() {
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
      child: Obx(() => _buildSelectedTabContent()),
    );
  }

  Widget _buildSelectedTabContent() {
    if (controller.isLoading.value) {
      return Container(
        height: 400,
        child: Center(
          child: CircularProgressIndicator(color: Color(0xFF6C5CE7)),
        ),
      );
    }

    switch (controller.selectedTab.value) {
      case 'account-summary':
        return _buildAccountSummaryContent();
      case 'pay-bill':
        return Paybill();
      case 'withdraw':
        return Withdraw();
      case 'commission':
        return Commision();
      case 'history':
        return History();
      default:
        return _buildAccountSummaryContent();
    }
  }

  Widget _buildAccountSummaryContent() {
    if (controller.accountData.value == null) {
      return Container(
        height: 400,
        child: Center(
          child: Text('No account data available'),
        ),
      );
    }

    return AnimatedOpacity(
      opacity: controller.isAnimating.value ? 0.5 : 1.0,
      duration: Duration(milliseconds: 300),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account Summary Dashboard',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            _buildMetricsGrid(),
            SizedBox(height: 16),
            _buildChartsAndPromotions(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    final data = controller.accountData.value!;
    
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
        'title': 'Closing Balance',
        'value': data.closingBalance,
        'icon': Icons.savings_outlined,
        'color': Color(0xFF6C5CE7),
      },
      {
        'title': 'Cash Percentage',
        'value': data.cashPercentage,
        'icon': Icons.pie_chart,
        'color': Color(0xFF4ECDC4),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
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

  Widget _buildMetricCard(String title, double value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
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
            child: Icon(icon, color: color, size: 16),
          ),
          Spacer(),
          Text(
            title == 'Cash Percentage' 
              ? '${value.toInt()}%' 
              : '₹${controller.formatAmount(value)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildChartsAndPromotions() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 1, child: _buildCashVsAccountChart()),
        SizedBox(width: 12),
        Expanded(flex: 1, child: _buildPromotionsSection()),
      ],
    );
  }

  Widget _buildCashVsAccountChart() {
    final data = controller.accountData.value!;
    
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cash vs Account',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12),
          Container(
            height: 100,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: data.cashPercentage / 100,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF51CF66)),
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(
                      value: data.accountPercentage / 100,
                      strokeWidth: 8,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
                    ),
                  ),
                  Text(
                    '${data.cashPercentage.toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildLegendItem('Cash', Color(0xFF51CF66)),
              _buildLegendItem('Account', Color(0xFF4ECDC4)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPromotionsSection() {
    final promotions = [
      {
        'title': 'EMI Offers',
        'description': '0% EMI available',
        'color': Color(0xFF6C5CE7),
      },
      {
        'title': 'Recharge Deals',
        'description': '2% extra cashback',
        'color': Color(0xFF4ECDC4),
      },
      {
        'title': 'Premium Plan',
        'description': 'Upgrade now',
        'color': Color(0xFFFF9500),
      },
    ];

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          ...promotions.map((promo) => _buildPromotionCard(
            promo['title'] as String,
            promo['description'] as String,
            promo['color'] as Color,
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildPromotionCard(String title, String description, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 6),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 9,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 10, color: color),
        ],
      ),
    );
  }

 
 


  Widget _buildAnimatedBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: AppConfig.screenHeight*0.09,
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: navItems.map((item) => _buildBottomNavItem(item)).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem(NavItemModel item) {
    return Obx(() {
      final isActive = controller.selectedTab.value == item.id;
      
      return Expanded(
        child: GestureDetector(
          onTap: () => controller.onTabChanged(item.id),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? item.color.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.all(isActive ? 4 : 2),
                  child: Icon(
                    isActive ? item.activeIcon : item.icon,
                    color: isActive ? item.color : Colors.grey[600],
                    size: isActive ? 20 : 18,
                  ),
                ),
                SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: isActive ? 11 : 10,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive ? item.color : Colors.grey[600],
                  ),
                  child: Text(
                    item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
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