import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smartbecho/controllers/bill%20history%20controllers/bill_analytics_controller.dart';
import 'package:smartbecho/controllers/bill%20history%20controllers/bill_history_controller.dart';
import 'package:smartbecho/models/bill%20history/monthly_purchase_chart_reponse_model.dart';
import 'package:smartbecho/utils/common_date_feild.dart';
import 'package:smartbecho/utils/custom_dropdown.dart';
import 'package:smartbecho/utils/generic_charts.dart';

class BillAnalyticsScreen extends StatelessWidget {
  const BillAnalyticsScreen({Key? key}) : super(key: key);

  void _showFilterBottomSheet(BuildContext context, BillAnalyticsController controller,BillHistoryController billHistoryController) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
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
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Row(
              children: [
                Icon(
                  Icons.filter_list,
                  color: Colors.blue[600],
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
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

            const SizedBox(height: 20),

            // Company and Time Period Row
            Row(
              children: [
                Expanded(
                  child: Obx(() => buildStyledDropdown(
                    labelText: 'Company',
                    hintText: 'Select Company',
                    value: controller.selectedCompany.value.isEmpty || controller.selectedCompany.value == 'All Companies'
                        ? null 
                        : controller.selectedCompany.value,
                    items: billHistoryController.companyOptions,
                    onChanged: controller.onCompanyChanged,
                  )),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() => buildStyledDropdown(
                    labelText: 'Time Period',
                    hintText: 'Select Period',
                    value: controller.timePeriodType.value,
                    items: const ['Month/Year', 'Custom Date'],
                    onChanged: controller.onTimePeriodTypeChanged,
                  )),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Date Selection based on Time Period Type
            Obx(() {
              if (controller.timePeriodType.value == 'Month/Year') {
                return _buildMonthYearSelection(controller);
              } else {
                return _buildCustomDateSelection(context, controller);
              }
            }),

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.clearFilters();
                      Get.back();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      side: BorderSide(color: Colors.grey[400]!),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Clear'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.applyFilters();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),

            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildMonthYearSelection(BillAnalyticsController controller) {
    return Row(
      children: [
        Expanded(
          child: Obx(() => buildStyledDropdown(
            labelText: 'Month',
            hintText: 'Select Month',
            value: controller.selectedMonth.value,
            items: controller.availableMonths,
            onChanged: controller.onMonthChanged,
          )),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(() => buildStyledDropdown(
            labelText: 'Year',
            hintText: 'Select Year',
            value: controller.selectedYear.value,
            items: controller.availableYears,
            onChanged: controller.onYearChanged,
          )),
        ),
      ],
    );
  }

  Widget _buildCustomDateSelection(BuildContext context, BillAnalyticsController controller) {
    return Row(
      children: [
        Expanded(
          child: buildDateField(
            labelText: 'Start Date',
            controller: controller.startDateController,
            onTap: () => _selectDate(context, controller, true),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: buildDateField(
            labelText: 'End Date',
            controller: controller.endDateController,
            onTap: () => _selectDate(context, controller, false),
          ),
        ),
      ],
    );
  }

  
  Future<void> _selectDate(BuildContext context, BillAnalyticsController controller, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF3B82F6),
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

 

  @override
  Widget build(BuildContext context) {
    final BillAnalyticsController controller = Get.put(BillAnalyticsController());
    final BillHistoryController billHistoryController =Get.find<BillHistoryController>();
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Monthly Purchase & Payment Summary',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            onPressed: () => _showFilterBottomSheet(context, controller,billHistoryController),
            icon: const Icon(Icons.filter_list, color: Colors.black87),
            tooltip: 'Filter',
          ),
          IconButton(
            onPressed: controller.refreshData,
            icon: const Icon(Icons.refresh, color: Colors.black87),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isAnalyticsLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'Loading analytics...',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        if (controller.hasError.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load analytics',
                  style: TextStyle(fontSize: 16, color: Colors.red[300]),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: controller.refreshData,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                  ),
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
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No analytics data available',
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                TextButton.icon(
                  onPressed: controller.refreshData,
                  icon: const Icon(Icons.refresh, color: Colors.blue),
                  label: const Text('Refresh', style: TextStyle(color: Colors.blue)),
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
              _buildSummaryCards(controller, isSmallScreen),

              const SizedBox(height: 24),

              // Chart Section
              GenericDoubleBarChart(
                title: 'Monthly Purchase vs Payment',
                payload: controller.purchaseData,
                secondaryPayload: controller.paidData,
                primaryLabel: 'Purchase Amount',
                secondaryLabel: 'Paid Amount',
                primaryBarColor:Colors.green[500] ,
                secondaryBarColor: Colors.red[400],
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
    );
  }

  Widget _buildSummaryCards(BillAnalyticsController controller, bool isSmallScreen) {
    return Obx(() => GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 1 : 3,
      childAspectRatio: isSmallScreen ? 3 : 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildSummaryCard(
          'Total Purchase',
          '₹${_formatAmount(controller.totalPurchaseAmount)}',
          Icons.shopping_cart,
          Colors.blue,
        ),
        _buildSummaryCard(
          'Total Paid',
          '₹${_formatAmount(controller.totalPaidAmount)}',
          Icons.payment,
          Colors.green,
        ),
        _buildSummaryCard(
          'Outstanding',
          '₹${_formatAmount(controller.totalOutstanding)}',
          Icons.account_balance_wallet,
          Colors.orange,
        ),
      ],
    ));
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyDetails(BillAnalyticsController controller) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Monthly Breakdown',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        ...controller.analyticsData.map((data) => _buildMonthlyCard(data)),
      ],
    ));
  }

  Widget _buildMonthlyCard(BillAnalyticsModel data) {
    final paymentPercentage = data.totalPurchase > 0 
        ? (data.totalPaid / data.totalPurchase * 100).clamp(0, 100)
        : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.1),
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(paymentPercentage.toDouble()).withValues(alpha:0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${paymentPercentage.toStringAsFixed(0)}% Paid',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _getStatusColor(paymentPercentage.toDouble()),
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
                      'Purchase',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${_formatAmount(data.totalPurchase)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
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
                      'Paid',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${_formatAmount(data.totalPaid)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
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
                      'Outstanding',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${_formatAmount(data.totalPurchase - data.totalPaid)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
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
            value: paymentPercentage / 100,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor(paymentPercentage.toDouble())),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)}Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }
}