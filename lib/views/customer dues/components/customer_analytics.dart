import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/customer%20dues%20controllers/customer_dues_controller.dart';
import 'package:smartbecho/models/customer%20dues%20management/monthly_dues_analytics_model.dart';
import 'package:smartbecho/utils/app_colors.dart';
import 'package:smartbecho/utils/app_styles.dart';
import 'package:smartbecho/utils/generic_charts.dart';

class CustomerDuesAnalyticsModal extends StatelessWidget {
  const CustomerDuesAnalyticsModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomerDuesController controller =
        Get.find<CustomerDuesController>();
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Container(
      height: screenSize.height * 0.85,
      decoration: const BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: AppTheme.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.grey200!)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: AppTheme.blue600,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Dues Analytics',
                  style: AppStyles.custom(
                    size: 20,
                    weight: FontWeight.bold,
                    color: AppTheme.black87,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                  splashRadius: 20,
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: Obx(() {
              if (controller.isAnalyticsLoading.value) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Loading analytics...',
                        style: AppStyles.custom(size: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              if (controller.analyticsData.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bar_chart_outlined,
                        size: 64,
                        color: AppTheme.grey400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No analytics data available',
                        style: AppStyles.custom(
                          size: 16,
                          color: AppTheme.grey600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: controller.fetchMonthlyAnalytics,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Cards
                    _buildSummaryCards(controller),

                    const SizedBox(height: 24),

                    // Chart
                    GenericDoubleBarChart(
                      title: 'Monthly Dues vs Collections',
                      payload: controller.remainingData,
                      secondaryPayload: controller.collectedData,
                      primaryLabel: 'Remaining Dues',
                      secondaryLabel: 'Collected',
                      primaryBarColor: AppTheme.red400,
                      secondaryBarColor: AppTheme.green500,
                      screenWidth: screenSize.width,
                      isSmallScreen: isSmallScreen,
                      chartHeight: 300,
                      dataType: ChartDataType.revenue,
                      showTotals: true,
                    ),

                    const SizedBox(height: 24),

                    // Monthly Details
                    _buildMonthlyDetails(controller),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(CustomerDuesController controller) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total Collected',
            '₹${_formatAmount(controller.totalCollected)}',
            AppTheme.primaryGreen,
            Icons.account_balance_wallet,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Total Remaining',
            '₹${_formatAmount(controller.totalRemaining)}',
            AppTheme.primaryRed,
            Icons.pending_actions,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: AppStyles.custom(
                    size: 12,
                    color: color.withOpacity(0.8),
                    weight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppStyles.custom(
              size: 18,
              weight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyDetails(CustomerDuesController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Breakdown',
          style: AppStyles.custom(
            size: 18,
            weight: FontWeight.bold,
            color: AppTheme.black87,
          ),
        ),
        const SizedBox(height: 16),
        ...controller.analyticsData.map((data) => _buildMonthlyCard(data)),
      ],
    );
  }

  Widget _buildMonthlyCard(MonthlyDuesSummary data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.grey200!),
        boxShadow: [
          BoxShadow(
            color: AppTheme.greyOpacity01,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                data.month,
                style: AppStyles.custom(
                  size: 16,
                  weight: FontWeight.bold,
                  color: AppTheme.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(
                    data.collectedPercentage,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${data.collectedPercentage.toStringAsFixed(0)}% Collected',
                  style: AppStyles.custom(
                    size: 12,
                    weight: FontWeight.w500,
                    color: _getStatusColor(data.collectedPercentage),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Collected',
                      style: AppStyles.custom(
                        size: 12,
                        color: AppTheme.grey600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${_formatAmount(data.collected)}',
                      style: AppStyles.custom(
                        size: 16,
                        weight: FontWeight.bold,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remaining',
                      style: AppStyles.custom(
                        size: 12,
                        color: AppTheme.grey600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${_formatAmount(data.remaining)}',
                      style: AppStyles.custom(
                        size: 16,
                        weight: FontWeight.bold,
                        color: AppTheme.primaryRed,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar
          LinearProgressIndicator(
            value: data.collectedPercentage / 100,
            backgroundColor: AppTheme.grey200,
            valueColor: AlwaysStoppedAnimation<Color>(
              _getStatusColor(data.collectedPercentage),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(double percentage) {
    if (percentage >= 80) return AppTheme.primaryGreen;
    if (percentage >= 50) return AppTheme.primaryOrange;
    return AppTheme.primaryRed;
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return "${(amount / 1000000).toStringAsFixed(1)}M";
    } else if (amount >= 1000) {
      return "${(amount / 1000).toStringAsFixed(1)}K";
    }
    return amount.toStringAsFixed(0);
  }
}
