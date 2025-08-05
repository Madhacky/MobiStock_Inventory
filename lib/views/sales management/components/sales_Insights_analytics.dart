import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:smartbecho/controllers/sales%20hisrory%20controllers/sales_Insights_analytics_controller.dart';
import 'package:smartbecho/utils/common_month_year_dropdown.dart';
import 'package:smartbecho/utils/custom_appbar.dart';
import 'package:smartbecho/utils/generic_charts.dart';
import 'package:smartbecho/views/dashboard/charts/switchable_chart.dart';
import 'package:smartbecho/views/dashboard/widgets/dashboard_shimmers.dart';

class SalesInsightsAnalytics extends GetView<SalesInsightsAnalyticsController> {
  const SalesInsightsAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SalesInsightsAnalyticsController>();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                buildCustomAppBar("Stock  History Analytics", isdark: true),
                _buildTabs(),
                Obx(() {
                  switch (controller.selectedTab.value) {
                    case 'Revenue Trends':
                      return _revenueTrends();
                    case 'Product Analysis':
                      return _productAnalysis();
                    case 'Payment Methods':
                      return _paymentMethods();
                    default:
                      return _revenueTrends();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _companyDropDown({
    required void Function(String?)? onChanged,
    required List<String> items,
    required String? value, // ADD THIS
  }) {
    return Container(
      height: 44,
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: DropdownButtonFormField<String>(
        value: value, // ✅ This line ensures reactive UI update
        items:
            items
                .map(
                  (company) => DropdownMenuItem(
                    value: company,
                    child: Text(
                      company,
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ),
                )
                .toList(),
        hint: Text(
          'Select Company',
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
        ),
        icon: Icon(Icons.keyboard_arrow_down, size: 20),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Obx(
        () => Row(
          children: [
            _buildTabButton(
              'Revenue Trends',
              'Revenue Trends',
              Icons.dashboard,
            ),
            _buildTabButton(
              'Product Analysis',
              'Product Analysis',
              Icons.history,
            ),
            _buildTabButton(
              'Payment Methods',
              'Payment Methods',
              Icons.insights,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(String tabValue, String label, IconData icon) {
    bool isSelected = controller.selectedTab.value == tabValue;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.onTabChanged(tabValue),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFF6C5CE7) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey[600],
                size: 16,
              ),
              SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterOptionsCard({Widget? child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Filter Options',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Column(children: [child!]),
        ],
      ),
    );
  }

  Widget _revenueTrends() {
    return Column(
      children: [
        _filterOptionsCard(
          child: Obx(() {
            return YearDropdown(
              selectedYear: controller.selectedInsightRevenueYear.value,
              onYearChanged: (year) {
                controller.selectedInsightRevenueYear.value = year;
                controller.fetchSalesInsightAnalyticsData(
                  
                  year: controller.selectedInsightRevenueYear.value,
                );
              },
            );
          }),
        ),
        GenericLineChart(
          title: 'Sales Insights Analytics',
          payload: controller.salesInsightAnalyticsRevenueChartPayload,
          screenWidth: controller.screenWidth,
          isSmallScreen: controller.isSmallScreen,
          dataType: ChartLineDataType.revenue,
          chartHeight: 400,
        ),

        // LayoutBuilder(
        //           builder: (context, constraints) {
        //             final screenWidth = constraints.maxWidth;
        //             final isSmallScreen = screenWidth < 600;

        //         return Obx(
        //   () =>
        //       customerAnalyticsController
        //               .isMonthlyRepeatCustomerChartLoading
        //               .value
        //           ? GenericBarChartShimmer(
        //             title: "Monthly Repeat Customers",
        //           )
        //           : GenericLineChart(
        //             title: 'Monthly Repeat Customers',
        //             payload:
        //                 customerAnalyticsController
        //                     .monthlyRepeatCustomerPayload,
        //             screenWidth: screenWidth,
        //             isSmallScreen: isSmallScreen,
        //             dataType: ChartLineDataType.users,
        //             chartHeight: 400,
        //           ),
        // );
        //   },
        // ),
      ],
    );
  }

  Widget _productAnalysis() => Column(
    children: [
      //     Obx(
      //   () =>
      //       controller.isMonthlyRevenueChartLoading.value
      //           ? GenericBarChartShimmer(title: "Monthly Revenue Performance")
      //           : controller.hasMonthlyRevenueChartError.value
      //           ? buildErrorCard(
      //             controller.monthlyRevenueCharterrorMessage,
      //             controller.screenWidth,
      //             controller.screenHeight,
      //             controller.isSmallScreen,
      //           )
      //           :  SwitchableChartWidget(
      //             payload: {},
      //             title: "Monthly Revenue Performance",
      //             screenWidth: controller.screenWidth,
      //             screenHeight: controller.screenHeight,
      //             isSmallScreen: controller.isSmallScreen,
      //             initialChartType: "barchart", // Start with bar chart
      //             chartDataType: ChartDataType.revenue,
      //           ),
      // ),

      // // Top-Selling Models Chart
      // Obx(
      //   () =>
      //       controller.isTopSellingModelChartLoading.value
      //           ? GenericBarChartShimmer(title: "Top-Selling Models")
      //           : controller.hasisTopSellingModelChartError.value
      //           ? buildErrorCard(
      //             controller.topSellingModelCharterrorMessage,
      //             controller.screenWidth,
      //             controller.screenHeight,
      //             controller.isSmallScreen,
      //           )
      //           : SwitchableChartWidget(
      //             payload: {
      //               'iPhone': 1500,
      //               'Realme': 1200,
      //               'Samsung': 900,
      //             },
      //             title: "Top-Selling Models",
      //             screenWidth: controller.screenWidth,
      //             screenHeight: controller.screenHeight,
      //             isSmallScreen: controller.isSmallScreen,
      //             initialChartType: "piechart", // Start with pie chart
      //             customColors: [
      //               const Color(0xFF2196F3), // Blue for iPhone
      //               const Color(0xFFE91E63), // Pink for Realme
      //               const Color(0xFFFF9800), // Orange for Samsung
      //             ],
      //             chartDataType: ChartDataType.quantity,
      //           ),
      // ),

      //selectedInsightBrandDistribution
      _filterOptionsCard(
        child: Column(
          children: [
            MonthYearDropdown(
              selectedMonth:
                  controller.selectedInsightBrandDistributionMonth.value,
              selectedYear:
                  controller.selectedInsightBrandDistributionYear.value,
              onMonthChanged: (month) {
                controller.selectedInsightBrandDistributionMonth.value = month;
                controller.fetchSalesInsightAnalyticsBrandDistribution(
                  month: controller.selectedInsightBrandDistributionMonth.value,
                  year: controller.selectedInsightBrandDistributionYear.value,
                );
              },
              onYearChanged: (year) {
                controller.selectedInsightBrandDistributionYear.value = year;
                controller.fetchSalesInsightAnalyticsBrandDistribution(
                  month: controller.selectedInsightBrandDistributionMonth.value,
                  year: controller.selectedInsightBrandDistributionYear.value,
                );
              },
            ),
            SizedBox(height: 16),
            Obx(() {
              return _companyDropDown(
                onChanged: (company) {
                  controller.selectedInsightBrandDistributionCompany.value =
                      company;
                  debugPrint(
                    "Selected Company: ${controller.selectedInsightBrandDistributionCompany.value}",
                  );
                  controller.fetchSalesInsightAnalyticsBrandDistribution(
                    month:
                        controller.selectedInsightBrandDistributionMonth.value,
                    year: controller.selectedInsightBrandDistributionYear.value,
                    company:
                        controller
                            .selectedInsightBrandDistributionCompany
                            .value,
                  );
                },
                items: controller.companyDropDownList,
                value:
                    controller
                        .selectedInsightBrandDistributionCompany
                        .value, // ✅ required
              );
            }),
          ],
        ),
      ),
      SwitchableChartWidget(
        payload: controller.salesInsightAnalyticsBrandDistributionAmounts,
        title: "Brand Distribution",
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

      // Top Selling Models Chart
      _filterOptionsCard(
        child: MonthYearDropdown(
          selectedMonth: controller.selectedInsightTopSellingModelsMonth.value,
          selectedYear: controller.selectedInsightTopSellingModelsYear.value,
          onMonthChanged: (month) {
            controller.selectedInsightTopSellingModelsMonth.value = month;
            controller.fetchSalesInsightAnalyticsTopSellingModels(
              month: controller.selectedInsightTopSellingModelsMonth.value,
              year: controller.selectedInsightTopSellingModelsYear.value,
            );
          },
          onYearChanged: (year) {
            controller.selectedInsightTopSellingModelsYear.value = year;
            controller.fetchSalesInsightAnalyticsTopSellingModels(
              month: controller.selectedInsightTopSellingModelsMonth.value,
              year: controller.selectedInsightTopSellingModelsYear.value,
            );
          },
        ),
      ),

      SwitchableChartWidget(
        payload: controller.salesInsightAnalyticsTopSellingModelsAmounts,
        title: "Top Selling Models",
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
    ],
  );

  // Payment Methods Chart
  Widget _paymentMethods() => Column(
    children: [
      _filterOptionsCard(
        child: MonthYearDropdown(
          selectedMonth: controller.selectedInsightPaymentMethodsMonth.value,
          selectedYear: controller.selectedInsightPaymentMethodsYear.value,
          onMonthChanged: (month) {
            controller.selectedInsightPaymentMethodsMonth.value = month;
            controller.fetchSalesInsightAnalyticsPaymentMethods(
              month: controller.selectedInsightPaymentMethodsMonth.value,
              year: controller.selectedInsightPaymentMethodsYear.value,
            );
          },
          onYearChanged: (year) {
            controller.selectedInsightPaymentMethodsYear.value = year;
            controller.fetchSalesInsightAnalyticsPaymentMethods(
              month: controller.selectedInsightPaymentMethodsMonth.value,
              year: controller.selectedInsightPaymentMethodsYear.value,
            );
          },
        ),
      ),
      Obx(() {
        if (controller
            .salesInsightAnalyticsPaymentMethodsChartPayload
            .isNotEmpty) {
          return Text(
            'no data available',
            style: TextStyle(fontSize: 16, color: Colors.green),
          );
        } else if (controller
            .isSalesInsightAnalyticsPaymentMethodsLoading
            .value) {
          return GenericBarChartShimmer(title: "Monthly Repeat Customers");
        }
        return SwitchableChartWidget(
          payload: controller.salesInsightAnalyticsPaymentMethodsChartPayload,
          title: "Payment Method Distribution",
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
        );
      }),

      SwitchableChartWidget(
        payload: controller.salesInsightAnalyticsPaymentMethodsChartPayload,
        title: "Payment Method Distribution",
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
    ],
  );
}
